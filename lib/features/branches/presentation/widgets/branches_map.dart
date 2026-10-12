import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sufra_app/features/branches/domain/entities/branch_entity.dart';

class BranchesMap extends StatefulWidget {
  const BranchesMap({super.key, required this.branches});

  final List<BranchEntity> branches;

  @override
  State<BranchesMap> createState() => _BranchesMapState();
}

class _BranchesMapState extends State<BranchesMap> {
  static const _red = Color(0xffB60F1A);

  final MapController _controller = MapController();
  LatLng? _myLocation;
  BranchEntity? _selected;
  bool _locating = false;

  List<BranchEntity> get _mappedBranches => widget.branches.where((b) {
    final lat = b.latitude;
    final lon = b.longitude;
    return lat != null &&
        lon != null &&
        lat.isFinite &&
        lon.isFinite &&
        lat >= -90 &&
        lat <= 90 &&
        lon >= -180 &&
        lon <= 180;
  }).toList();

  LatLng _point(BranchEntity b) => LatLng(b.latitude!, b.longitude!);

  double? _distance(BranchEntity b) {
    if (_myLocation == null) return null;
    return Geolocator.distanceBetween(
          _myLocation!.latitude,
          _myLocation!.longitude,
          b.latitude!,
          b.longitude!,
        ) /
        1000;
  }

  String _distanceText(double km) =>
      km < 1 ? '${(km * 1000).round()} م' : '${km.toStringAsFixed(1)} كم';

  Future<void> _findNearest() async {
    if (_mappedBranches.isEmpty || _locating) return;

    setState(() => _locating = true);

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('خدمة الموقع غير مفعلة على الجهاز');
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('يلزم السماح للتطبيق باستخدام الموقع');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      if (!mounted) return;

      final current = LatLng(position.latitude, position.longitude);

      final sorted = [..._mappedBranches]
        ..sort((a, b) {
          final da = Geolocator.distanceBetween(
            current.latitude,
            current.longitude,
            a.latitude!,
            a.longitude!,
          );
          final db = Geolocator.distanceBetween(
            current.latitude,
            current.longitude,
            b.latitude!,
            b.longitude!,
          );
          return da.compareTo(db);
        });

      setState(() {
        _myLocation = current;
        _selected = sorted.first;
      });

      _controller.move(_point(sorted.first), 14);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تعذر تحديد أقرب فرع: $error')));
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _directions(BranchEntity branch) async {
    final lat = branch.latitude!;
    final lon = branch.longitude!;
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=$lat,$lon',
    );

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('تعذر فتح تطبيق الخرائط');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تعذر فتح الاتجاهات')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final branches = _mappedBranches;

    if (branches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('خريطة الفروع ستظهر بعد إضافة مواقع الفروع.'),
      );
    }

    final selected = branches.any((b) => b.id == _selected?.id)
        ? branches.firstWhere((b) => b.id == _selected!.id)
        : branches.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'مواقع فروعنا',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            FilledButton.icon(
              onPressed: _locating ? null : _findNearest,
              icon: _locating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.my_location, size: 18),
              label: const Text('أقرب فرع لي'),
              style: FilledButton.styleFrom(backgroundColor: _red),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 290,
            child: FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: _point(branches.first),
                initialZoom: 11,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'sufra_app',
                ),
                MarkerLayer(
                  markers: [
                    for (final branch in branches)
                      Marker(
                        point: _point(branch),
                        width: 48,
                        height: 48,
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = branch),
                          child: Icon(
                            Icons.location_on,
                            color: selected.id == branch.id
                                ? _red
                                : Colors.deepOrange,
                            size: selected.id == branch.id ? 43 : 35,
                          ),
                        ),
                      ),
                    if (_myLocation != null)
                      Marker(
                        point: _myLocation!,
                        width: 30,
                        height: 30,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 26,
                        ),
                      ),
                  ],
                ),
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution('OpenStreetMap contributors'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xffF8F8F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selected.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(selected.address),
              if (_distance(selected) case final km?) ...[
                const SizedBox(height: 6),
                Text(
                  'المسافة التقريبية: ${_distanceText(km)}',
                  style: const TextStyle(
                    color: _red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _directions(selected),
                icon: const Icon(Icons.directions),
                label: const Text('الاتجاهات'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
