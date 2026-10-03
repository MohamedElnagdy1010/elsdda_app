import 'package:flutter/material.dart';

class ProfileSaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const ProfileSaveButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffB60F1A),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(
            0xffB60F1A,
          ).withValues(alpha: 0.55),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: Colors.white,
                ),
              )
            : const Text(
                'حفظ التغييرات',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
      ),
    );
  }
}
