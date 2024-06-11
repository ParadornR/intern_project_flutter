// ignore_for_file: file_names, camel_case_types

import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uu_alpha/styles.dart';
import 'package:uu_alpha/page/Onboarding/term_Intro.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({
    Key? key,
  }) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorStyles.backgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/uuprojectalpha.appspot.com/o/asset%2F4.png?alt=media&token=b08fa9ae-b8a7-4053-b4f1-cc45a957efb0')
                .image,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 88),
                child: Column(
                  children: [
                    Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/uuprojectalpha.appspot.com/o/asset%2Flogo2.png?alt=media&token=4cdd0a79-b85f-4418-b81d-d5ee579145ee'),
                    const SizedBox(height: 18),
                    const Text(
                      'intro.description',
                      style: TextStyle(
                        color: ColorStyles.grey_400,
                        fontSize: 18,
                      ),
                    ).tr(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  log('IntroPage() pushReplacement=> TermIntroPage()');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermIntroPage()),
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
                    child: const Text(
                      'intro.start',
                      style: TextStyle(
                        color: ColorStyles.purple_800,
                        fontSize: 16,
                      ),
                    ).tr(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
