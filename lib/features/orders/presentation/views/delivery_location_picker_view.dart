import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class DeliveryLocationPickerView extends StatefulWidget {
  const DeliveryLocationPickerView({super.key, this.initialLocation});

  final LatLng? initialLocation;

  @override
  State<DeliveryLocationPickerView> createState() =>
      _DeliveryLocationPickerViewState();
}

class _DeliveryLocationPickerViewState
    extends State<DeliveryLocationPickerView> {
  static const Color _primaryColor = Color(0xffB60F1A);

  final MapController _mapController = MapController();

  LatLng? _selectedLocation;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  Future<void> _useCurrentLocation() async {
    if (_locating) return;

    setState(() => _locating = true);

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('يرجى تشغيل خدمة الموقع على الجهاز');
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'صلاحية الموقع مرفوضة نهائيًا. فعّلها من إعدادات الجهاز',
        );
      }

      if (permission == LocationPermission.denied) {
        throw Exception('يرجى السماح بالوصول إلى الموقع');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      if (!mounted) return;

      final location = LatLng(position.latitude, position.longitude);

      setState(() => _selectedLocation = location);
      _mapController.move(location, 16);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذر تحديد الموقع: $error',
            textAlign: TextAlign.right,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _locating = false);
      }
    }
  }

  void _confirmLocation() {
    final location = _selectedLocation;

    if (location == null) return;

    Navigator.of(context).pop(location);
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedLocation;

    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.white,
        title: const Text(
          'تحديد موقع التوصيل',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'اضغط على الخريطة لتحديد عنوان التوصيل، '
                'أو استخدم موقعك الحالي.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: selected ?? const LatLng(24.0, 45.0),
                      initialZoom: selected == null ? 5.5 : 16,
                      onTap: (tapPosition, point) {
                        setState(() => _selectedLocation = point);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'sufra_app',
                      ),
                      if (selected != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: selected,
                              width: 55,
                              height: 55,
                              child: const Icon(
                                Icons.location_on,
                                size: 48,
                                color: _primaryColor,
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
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    onPressed: _locating ? null : _useCurrentLocation,
                    icon: _locating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                    label: Text(
                      _locating
                          ? 'جارٍ تحديد موقعك...'
                          : 'استخدام موقعي الحالي',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryColor,
                      padding: const EdgeInsets.all(14),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (selected != null)
                    Text(
                      'الموقع المحدد: '
                      '${selected.latitude.toStringAsFixed(6)}, '
                      '${selected.longitude.toStringAsFixed(6)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: selected == null ? null : _confirmLocation,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'تأكيد موقع التوصيل',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
