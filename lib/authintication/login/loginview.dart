import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sufra_app/authintication/register/registerView.dart';
import 'package:sufra_app/core/common/filledButton.dart';
import 'package:sufra_app/core/common/textfild.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
        child: Column(
          children: [
            Text(
              "تسجيل الدخول",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Gap(10),
            Text(
              "أضف التفاصيل الخاصة بك لتسجيل الدخول",
              style: TextStyle(fontSize: 20),
            ),
            Spacer(),
            TextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              decoration: textField.copyWith(hintText: "بريدك الإلكتروني"),
            ),
            Gap(20),
            TextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: textField.copyWith(hintText: "كلمة المرور "),
            ),

            Gap(20),

            CustomFilledbutton(
              text: "تسجيل الدخول",
              onPressed: () {},
              color: const Color.fromARGB(255, 136, 8, 8),
            ),

            TextButton(
              onPressed: () {},
              child: Text(
                "هل نسيت كلمة المرور الخاصة بك؟ انقر هنا",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[800],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Gap(40),
            Text(
              "أو تسجيل الدخول باستخدام",
              style: TextStyle(fontSize: 20, color: Colors.grey[800]),
            ),
            Gap(20),
            CustomFilledbutton(
              text: "تسجيل الدخول باستخدام فيسبوك",
              onPressed: () {},
              color: Color(0xff367FC0),
              child: Icon(Icons.facebook, size: 40, color: Colors.white),
            ),
            Gap(20),
            CustomFilledbutton(
              text: "تسجيل الدخول باستخدام جوجل",
              onPressed: () {},
              color: Color(0xffCA9744),
              child: Icon(
                Icons.g_mobiledata_outlined,
                size: 70,
                color: Colors.white,
              ),
            ),

            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (context) => RegisterView()),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: "ليس لديك حساب؟ ",
                  style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                  children: [
                    TextSpan(
                    mouseCursor: SystemMouseCursors.resizeRight,
                      text: "تسجيل ",
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 136, 8, 8),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
