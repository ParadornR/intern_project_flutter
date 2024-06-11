// ignore_for_file: file_names, non_constant_identifier_names, unused_field, camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uu_alpha/page/Home/home_Control.dart';
import 'package:uu_alpha/page/Login/regis_Page..dart';
import 'package:uu_alpha/styles.dart';

class faqPage extends StatefulWidget {
  const faqPage({
    Key? key,
  }) : super(key: key);

  @override
  State<faqPage> createState() => _faqPageState();
}

class _faqPageState extends State<faqPage> {
  List<Map> dataU = [
    {
      'nameIcon': 'faq_Page.how_to_1'.tr(),
    },
    {
      'nameIcon': 'faq_Page.how_to_2'.tr(),
    },
    {
      'nameIcon': 'faq_Page.how_to_3'.tr(),
    },
    {
      'nameIcon': 'faq_Page.how_to_4'.tr(),
    },
  ];

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
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  'faq_Page.title_bar'.tr(),
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dataU.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => dataU[index]['nextPage'],
                  //   ),
                  // );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  margin: const EdgeInsets.symmetric(vertical: 0.5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: index == 0 // ถ้าเป็นรายการแรก
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            )
                          : (index == dataU.length - 1) // ถ้าเป็นรายการสุดท้าย
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )
                              : BorderRadius.circular(0), // รายการกลาง
                      boxShadow: [BoxShadowStyles.largeBoxButtom]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            dataU[index]['nameIcon'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: ColorStyles.purple_500,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
