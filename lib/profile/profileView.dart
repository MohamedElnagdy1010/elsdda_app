import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "معلوماتي",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: SvgPicture.asset(
            "assets/home/svgs/shopping-cart.svg",
            width: 20,
            height: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),

          child: Column(
            children: [
              // Profile Image
              Container(
                width: 95,
                height: 95,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffB60F1A),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(3),

                child: ClipOval(
                  child: Image.asset(
                    "assets/profile/profile.png",
                    fit: BoxFit.cover,

                    // مؤقت لحد ما تضيف الصورة
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.person,
                          size: 55,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "محمد أحمد",
                style: TextStyle(
                  color: Color(0xffB60F1A),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                "عميل لدينا",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "المملكة العربية السعودية",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              _profileField(
                title: "الاسم",
                value: "أحمد محمد المصري",
              ),

              const SizedBox(height: 13),

              _profileField(
                title: "البريد الإلكتروني",
                value: "ahmed_3@gmail.com",
              ),

              const SizedBox(height: 13),

              _profileField(
                title: "رقم الهاتف",
                value: "774303713",
              ),

              const SizedBox(height: 13),

              _profileField(
                title: "العنوان",
                value: "المملكة - الرياض",
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC8101E),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  child: const Text(
                    "حفظ",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileField({
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      height: 50,

      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),

      decoration: BoxDecoration(
        color: const Color(0xffF4F4F4),
        borderRadius: BorderRadius.circular(25),
      ),

      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Text(
            "$title :",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}