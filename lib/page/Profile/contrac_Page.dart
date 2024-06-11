// ignore_for_file: file_names, non_constant_identifier_names, unused_field, camel_case_types, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:uu_alpha/page/Login/regis_Page..dart';
import 'package:uu_alpha/styles.dart';

class contracPage extends StatefulWidget {
  const contracPage({
    Key? key,
  }) : super(key: key);

  @override
  State<contracPage> createState() => _contracPageState();
}

class _contracPageState extends State<contracPage> {
  TextEditingController ThFirstNameController = TextEditingController();
  TextEditingController ThLastNameController = TextEditingController();
  TextEditingController EnFirstNameController = TextEditingController();
  TextEditingController EnLastNameController = TextEditingController();
  TextEditingController NickNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  SingingCharacter? _character;

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
                  log('ProfilePage() <=pushReplacement contracPage()');
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  'contrac_Page.title_bar'.tr(),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  color: Colors.amber,
                  child: Center(
                    child: Image.network(
                        fit: BoxFit.cover,
                        'https://media.discordapp.net/attachments/1189203452136538124/1202513541525938226/image.png?ex=65e96a81&is=65d6f581&hm=ab3276071b262cd801df78d25762898768549160eaad5ec9958303034d647df0&=&format=webp&quality=lossless&width=652&height=437'),
                  ),
                ),
                Text(
                  'contrac_Page.link_location'.tr(),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                    decorationThickness: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  detail(
                    Symbols.location_on_rounded,
                    'ที่อยู่ : 91/2 หมู่ที่ 22 ต.รอบเวียง \nอ.เมืองเชียงราย จ.เชียงราย 57000',
                  ),
                  detail(
                    Icons.drafts_outlined,
                    'uukiddent.cei@gmail.com',
                  ),
                  detail(
                    FontAwesomeIcons.facebook,
                    'UU Kiddent dental clinic : ทำฟันเด็ก จัดฟัน \nเชียงราย โดยทันตแพทย์เฉพาะทาง',
                  ),
                  detail(
                    FontAwesomeIcons.line,
                    'uukiddent',
                  ),
                  detail(
                    Icons.call_outlined,
                    '090 893 3363',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detail(IconData iconName, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Icon(
            iconName,
            weight: 800,
            size: 24,
            color: ColorStyles.purple_500,
          ),
          SizedBox(width: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
