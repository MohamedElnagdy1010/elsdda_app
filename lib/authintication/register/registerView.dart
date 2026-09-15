// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sufra_app/authintication/login/loginview.dart';

import 'package:sufra_app/common/filledButton.dart';
import 'package:sufra_app/common/textfild.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
        child: Column(
          children: [
            Text(
              "تسجيل ",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Gap(10),
            Text(
              "أضف التفاصيل الخاصة بك للتسجيل ",
              style: TextStyle(fontSize: 20),
            ),
            Spacer(),
            TextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              decoration: textField.copyWith(hintText: " الاسم "),
            ),
            Gap(20),
            TextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: textField.copyWith(hintText: "بريدك الإلكتروني"),
            ),
            Gap(20),
            TextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: textField.copyWith(hintText: " رقم الجوال "),
            ),
            Gap(20),
            TextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: textField.copyWith(hintText: " العنوان "),
            ),
            Gap(20),
            TextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: textField.copyWith(hintText: "كلمة المرور "),
            ),
            Gap(20),
            TextField(
              textAlign: TextAlign.right,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: textField.copyWith(hintText: " تأكيد كلمة المرور "),
            ),

            Spacer(),

            CustomFilledbutton(
              text: "تسجيل ",
              onPressed: () {},
              color: const Color.fromARGB(255, 136, 8, 8),
            ),

            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (context) => Loginview()),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: "هل لديك حساب بالفعل؟  ",
                  style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                  children: [
                    TextSpan(
                      mouseCursor: SystemMouseCursors.resizeRight,
                      text: "تسجيل الدخول",
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
