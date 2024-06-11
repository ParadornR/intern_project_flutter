// ignore_for_file: file_names, , unused_field, camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uu_alpha/page/Home/home_Control.dart';
import 'package:uu_alpha/page/Login/login_Page.dart';
import 'package:uu_alpha/page/Login/regis_Page..dart';
import 'package:uu_alpha/page/Onboarding/intro_Page.dart';
import 'package:uu_alpha/styles.dart';

class TermIntroPage extends StatefulWidget {
  const TermIntroPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TermIntroPage> createState() => _TermIntroPageState();
}

class _TermIntroPageState extends State<TermIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  log('IntroPage() <=pushReplacement TermIntroPage()');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const IntroPage()),
                  );
                },
                icon: const Icon(Icons.chevron_left),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  'intro_term.appbar_title',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ).tr(),
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
        backgroundColor: ColorStyles.backgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                // ดึงจากหลังบ้าน HTML
                child: Text(
                  'Lorem ipsum dolor sit amet consectetur. Pellentesque nulla faucibus egestas massa gravida quis. Risus ornare suspendisse tellus proin ut enim nunc dignissim. Vel porttitor varius iaculis donec sed nulla pretium scelerisque. Aliquet volutpat vivamus duis vitae pulvinar sollicitudin Lorem ipsum dolor sit amet consectetur. Pellentesque nulla faucibus egestas massa gravida quis. Risus ornare suspendisse tellus proin ut enim nunc dignissim. Vel porttitor varius iaculis donec sed nulla pretium scelerisque. Aliquet volutpat vivamus duis vitae pulvinar sollicitudin. Lorem ipsum dolor sit amet consectetur. Pellentesque nulla faucibus egestas massa gravida quis. Risus ornare suspendisse tellus proin ut enim nunc dignissim. Vel porttitor varius iaculis donec sed nulla pretium scelerisque. Aliquet volutpat vivamus duis vitae pulvinar sollicitudin. Lorem ipsum dolor sit amet consectetur. Pellentesque nulla faucibus egestas massa gravida quis. Risus ornare suspendisse tellus proin ut enim nunc dignissim. Vel porttitor varius iaculis donec sed nulla pretium scelerisque. Aliquet volutpat vivamus duis vitae pulvinar sollicitudin. Lorem ipsum dolor sit amet consectetur. Pellentesque nulla faucibus egestas massa gravida quis. Risus ornare suspendisse tellus proin ut enim nunc dignissim. Vel porttitor varius iaculis donec sed nulla pretium scelerisque. Aliquet volutpat vivamus duis vitae pulvinar sollicitudin..',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () async {
                log('ยอมรับข้อตกลงและเงื่อนไข');
                log('TermIntroPage() pushReplacement=> LoginPage()');
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool(
                    'isFirstTime', false); // ตั้งค่าให้ไม่ใช่ครั้งแรก
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  color: ColorStyles.purple_500,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [BoxShadowStyles.largeBoxButtom],
                ),
                child: Center(
                  child: Text(
                    'intro_term.bt_Confirm',
                    style: TextStyle(
                      color: ColorStyles.purple_800,
                      fontSize: 16,
                    ),
                  ).tr(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
