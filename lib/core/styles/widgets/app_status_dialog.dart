import 'package:flutter/material.dart';

class AppStatusDialog {
  static Future<void> showSuccess(
    BuildContext context, {
    String title = 'تم بنجاح',
    required String message,
    String buttonText = 'حسناً',
    VoidCallback? onPressed,
  }) {
    return _show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      icon: Icons.check_rounded,
      iconColor: Colors.green,
      onPressed: onPressed,
    );
  }

  static Future<void> showError(
    BuildContext context, {
    String title = 'حدث خطأ',
    required String message,
    String buttonText = 'حاول مجددًا',
    VoidCallback? onPressed,
  }) {
    return _show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      icon: Icons.close_rounded,
      iconColor: Colors.red,
      onPressed: onPressed,
    );
  }

  static Future<void> showWarning(
    BuildContext context, {
    String title = 'تنبيه',
    required String message,
    String buttonText = 'حسناً',
    VoidCallback? onPressed,
  }) {
    return _show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      onPressed: onPressed,
    );
  }

  static Future<void> _show(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonText,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor.withValues(alpha: 0.12),
                  ),
                  child: Icon(icon, size: 42, color: iconColor),
                ),

                const SizedBox(height: 20),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();

                      onPressed?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB60F1A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
