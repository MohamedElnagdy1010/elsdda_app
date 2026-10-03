import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final String? value;
  final IconData icon;
  final TextInputType keyboardType;
  final bool enabled;
  final bool readOnly;

  const ProfileField.editable({
    super.key,
    required this.title,
    required TextEditingController this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
  }) : value = null,
       readOnly = false;

  const ProfileField.readOnly({
    super.key,
    required this.title,
    required String this.value,
    required this.icon,
  }) : controller = null,
       keyboardType = TextInputType.text,
       enabled = false,
       readOnly = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xff555555),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 7),
        if (readOnly) _buildReadOnly() else _buildEditable(),
      ],
    );
  }

  Widget _buildEditable() {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: const TextStyle(
        color: Color(0xff202020),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xff888888)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: _border(),
        enabledBorder: _border(),
        disabledBorder: _border(color: const Color(0xffEEEEEE)),
        focusedBorder: _border(color: const Color(0xffB60F1A), width: 1.4),
      ),
    );
  }

  Widget _buildReadOnly() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 54),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xffEEEEEE)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, size: 20, color: const Color(0xff999999)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value ?? '',
              textAlign: TextAlign.right,
              textDirection: TextDirection.ltr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xff666666),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: Color(0xffAAAAAA),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border({
    Color color = const Color(0xffEEEEEE),
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
