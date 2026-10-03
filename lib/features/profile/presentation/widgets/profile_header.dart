import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String address;
  final String? profileImage;
  final String? avatarId;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.address,
    this.profileImage,
    this.avatarId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProfileImage(profileImage: profileImage, avatarId: avatarId),
        const SizedBox(height: 12),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xff202020),
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'عميل لدينا',
          style: TextStyle(
            color: Color(0xff999999),
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 14,
              color: Color(0xffB60F1A),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                address.trim().isEmpty ? 'لم يتم إضافة عنوان' : address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xff888888),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileImage extends StatelessWidget {
  final String? profileImage;
  final String? avatarId;

  const _ProfileImage({this.profileImage, this.avatarId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffB60F1A), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffB60F1A).withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(child: _buildImage()),
    );
  }

  Widget _buildImage() {
    if (profileImage != null && profileImage!.trim().isNotEmpty) {
      return Image.network(
        profileImage!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _defaultAvatar(),
      );
    }

    // avatarId جاهز للاستخدام لاحقًا لو أضفنا مجموعة Avatars.
    return _defaultAvatar();
  }

  Widget _defaultAvatar() {
    return Container(
      color: const Color(0xffF4F4F4),
      child: const Icon(
        Icons.person_rounded,
        size: 50,
        color: Color(0xffAAAAAA),
      ),
    );
  }
}
