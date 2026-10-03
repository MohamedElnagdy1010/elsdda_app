import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sufra_app/features/branches/domain/entities/branch_entity.dart';
import 'package:sufra_app/features/branches/presentation/cubit/branches/branches_cubit.dart';
import 'package:sufra_app/features/branches/presentation/cubit/branches/branches_state.dart';

class BranchesSection extends StatelessWidget {
  const BranchesSection({super.key});

  static const Color _primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesCubit, BranchesState>(
      builder: (context, state) {
        if (state is BranchesLoading || state is BranchesInitial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: CircularProgressIndicator(color: _primaryColor),
            ),
          );
        }

        if (state is BranchesFailure) {
          return _buildError(context, state.message);
        }

        if (state is BranchesLoaded) {
          if (state.branches.isEmpty) {
            return _buildEmpty();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'فروعنا',
                style: TextStyle(
                  color: _primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'تواصل معنا من خلال أقرب فرع لك',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              ...state.branches.map(
                (branch) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _BranchCard(branch: branch),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: _primaryColor, size: 35),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              context.read<BranchesCubit>().getBranches();
            },
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(Icons.store_outlined, size: 38, color: Colors.grey),
          SizedBox(height: 8),
          Text('لا توجد فروع متاحة حاليًا', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final BranchEntity branch;

  const _BranchCard({required this.branch});

  static const Color _primaryColor = Color(0xffB60F1A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8F8F8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storefront_outlined, color: _primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  branch.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.grey,
                size: 21,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  branch.address,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ],
          ),

          if (branch.phone.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone_outlined, color: Colors.grey, size: 21),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    branch.phone,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          Row(
            children: [
              if (branch.phone.isNotEmpty)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _makePhoneCall(context, branch.phone);
                    },
                    icon: const Icon(Icons.phone, size: 19),
                    label: const Text('اتصال'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryColor,
                      side: const BorderSide(color: _primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

              if (branch.phone.isNotEmpty && branch.whatsapp.isNotEmpty)
                const SizedBox(width: 10),

              if (branch.whatsapp.isNotEmpty)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _openWhatsApp(context, branch.whatsapp);
                    },
                    icon: const Icon(Icons.chat_outlined, size: 19),
                    label: const Text('واتساب'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(BuildContext context, String phone) async {
    final normalizedPhone = phone.replaceAll(RegExp(r'[\s-]'), '');

    final uri = Uri(scheme: 'tel', path: normalizedPhone);

    final launched = await launchUrl(uri);

    if (!launched && context.mounted) {
      _showLaunchError(context, 'تعذر فتح تطبيق الاتصال');
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phone) async {
    final normalizedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    final uri = Uri.parse('https://wa.me/$normalizedPhone');

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched && context.mounted) {
      _showLaunchError(context, 'تعذر فتح واتساب');
    }
  }

  void _showLaunchError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message, textAlign: TextAlign.right)),
      );
  }
}
