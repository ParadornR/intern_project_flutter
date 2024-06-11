// ignore_for_file: file_names, , unused_field, camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_import

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uu_alpha/page/Home/home_Control.dart';
import 'package:uu_alpha/page/Login/regis_Page..dart';
import 'package:uu_alpha/styles.dart';

class TermPage extends StatefulWidget {
  const TermPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TermPage> createState() => _TermPageState();
}

class _TermPageState extends State<TermPage> {
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
                  'Term_Page.title_bar'.tr(),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [BoxShadowStyles.largeBoxButtom],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
    );
  }
}
