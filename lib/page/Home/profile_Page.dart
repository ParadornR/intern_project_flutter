// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uu_alpha/page/Login/login_Page.dart';
import 'package:uu_alpha/page/Profile/contrac_Page.dart';
import 'package:uu_alpha/page/Profile/family_Page.dart';
import 'package:uu_alpha/page/Profile/faq_Page.dart';
import 'package:uu_alpha/page/Profile/showProfile_Page.dart';
import 'package:uu_alpha/page/Profile/term_Page.dart';
import 'package:uu_alpha/provider/providerModel.dart';

import 'package:uu_alpha/styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  List<Map> dataU = [
    {
      'iconData': Icons.groups,
      'nameIcon': 'profile_page.family'.tr(),
      'nextPage': const FamilyPage(),
    },
    {
      'iconData': Icons.contacts,
      'nameIcon': 'profile_page.contact'.tr(),
      'nextPage': const contracPage(),
    },
    {
      'iconData': Icons.quiz,
      'nameIcon': 'profile_page.question'.tr(),
      'nextPage': const faqPage(),
    },
    {
      'iconData': Icons.gavel,
      'nameIcon': 'profile_page.Terms_Conditions'.tr(),
      'nextPage': const TermPage(),
    },
    {
      'iconData': Icons.logout,
      'nameIcon': 'profile_page.log_out'.tr(),
      'nextPage': const LoginPage(),
    },
  ];

  Widget box(IconData iconName, String name) {
    return Row(
      children: [
        Icon(
          iconName,
          color: ColorStyles.purple_500, // Set the color for the icon
        ),
        const SizedBox(width: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _filterStatus() {
    final List<String> status = [
      'TH',
      'EN',
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          context.read<ProviderModel>().selectedLang ?? 'TH',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        items: status
            .map((String status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: context.read<ProviderModel>().selectedLang,
        onChanged: (String? value) {
          if (value != null) {
            context.read<ProviderModel>().onItemTapped(0);
            context.read<ProviderModel>().selectedLang = value;
            log('[value]: ${context.read<ProviderModel>().selectedLang}');

            log('[value]: ${context.read<ProviderModel>().selectedLang?.toLowerCase()}');
            if (context.read<ProviderModel>().selectedLang == 'TH') {
              setState(() {
                context.setLocale(const Locale('th'));
                context.read<ProviderModel>().setDataLanguage('TH');
              });
            }
            if (context.read<ProviderModel>().selectedLang == 'EN') {
              setState(() {
                context.setLocale(const Locale('en'));
                context.read<ProviderModel>().setDataLanguage('EN');
              });
            }
          }
        },
        buttonStyleData: ButtonStyleData(
          // padding: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: ColorStyles.grey_200,
            ),
            color: ColorStyles.backgroundColor,
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Symbols.arrow_drop_down,
            size: 0,
            weight: 800,
          ),
          openMenuIcon: Icon(
            Symbols.arrow_drop_up,
            size: 0,
            weight: 800,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.transparent,
          iconDisabledColor: Colors.transparent,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: ColorStyles.backgroundColor,
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40,
          // padding: const EdgeInsets.only(left: 14, right: 14),
          selectedMenuItemBuilder: (BuildContext context, Widget child) {
            return Container(
              color: ColorStyles.purple_200,
              child: child,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Expanded(flex: 4, child: SizedBox()),
            Expanded(flex: 1, child: _filterStatus()),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: ColorStyles.backgroundColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _imageProfileSection(),
            _nameProfileSection(),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShowProfilePage()),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: const Color(0xFFEFD9F6),
                  boxShadow: const [BoxShadowStyles.largeBoxButtom],
                ),
                child: Text(
                  'profile_page.view_profile'.tr(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataU.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    log('ProfilePage() pushReplacement=> ${dataU[index]['nextPage']}()');
                    index == dataU.length - 1
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  // Your code here
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: AlertDialog(
                                    titlePadding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 24),
                                    title: Center(
                                      child: Text(
                                        'profile_page.confirm_log_out'.tr(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                    actionsPadding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 24),
                                    actions: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 24,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: ColorStyles.grey_200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  boxShadow: const [
                                                    BoxShadowStyles
                                                        .largeBoxButtom
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'profile_page.bt_Cancel'
                                                        .tr(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                              flex: 1, child: SizedBox()),
                                          Expanded(
                                            flex: 3,
                                            child: GestureDetector(
                                              onTap: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                await prefs.setBool(
                                                    'isLoggedIn',
                                                    false); // เก็บข้อมูลการเข้าสู่ระบบ
                                                await prefs.setString(
                                                    'PhoneNumber', '');
                                                context
                                                    .read<ProviderModel>()
                                                    .onItemTapped(0);
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginPage()),
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                                // Navigator.pushReplacement(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           const LoginPage()),
                                                // );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 24,
                                                  vertical: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: ColorStyles.purple_500,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  boxShadow: const [
                                                    BoxShadowStyles
                                                        .largeBoxButtom
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'profile_page.bt_Confirm'
                                                        .tr(),
                                                    style: const TextStyle(
                                                      color: ColorStyles
                                                          .purple_800,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => dataU[index]['nextPage'],
                            ),
                          );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    margin: const EdgeInsets.only(top: 0.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [BoxShadowStyles.largeBoxButtom],
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
                    ),
                    child: box(
                      dataU[index]['iconData'],
                      dataU[index]['nameIcon'],
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  "Version ${_packageInfo.version}",
                  style: const TextStyle(
                    color: ColorStyles.grey_500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseFirestore firebase = FirebaseFirestore.instance;
  Future<void> createReservation(
    String phoneNumber,
    String firstname,
    String lastname,
    DateTime birthday,
    String gender,
  ) async {
    firebase
        .collection("User")
        .doc(phoneNumber)
        .collection("information")
        .doc("Account")
        .set({
      'th_Firstname': firstname,
      'th_Lastname': lastname,
      'en_Firstname': '',
      'en_Lastname': '',
      'nickname': '',
      'birthday': birthday,
      'gender': gender,
      'phone': '088-888-8888',
      'image_Profile': null,
    }).then((_) {
      log("collection created");
    }).catchError((_) {
      log("an error occured");
    });
  }

  Widget _imageProfileSection() {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Consumer(
            builder:
                (BuildContext context, ProviderModel value, Widget? child) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                width: 120,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorStyles.purple_500,
                    width: 5,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  shape: BoxShape.circle,
                ),
                child: value.selectFamPatient == 0
                    ? value.dataAccount['image_Profile'] == null ||
                            value.dataAccount['image_Profile'] == ""
                        ? const Text(
                            'dataAccount?',
                            style: TextStyle(color: Colors.white),
                          )
                        : Image.network(
                            '${value.dataAccount['image_Profile']}',
                            fit: BoxFit.cover,
                          )
                    : value.dataListFamily[value.selectFamPatient - 1]
                                    ['image_Profile'] ==
                                null ||
                            value.dataListFamily[value.selectFamPatient - 1]
                                    ['image_Profile'] ==
                                ""
                        ? const Text(
                            'dataAccount?',
                            style: TextStyle(color: Colors.white),
                          )
                        : Image.network(
                            '${value.dataListFamily[value.selectFamPatient - 1]['image_Profile']}',
                            fit: BoxFit.cover,
                          ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _nameProfileSection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Consumer(builder:
            (BuildContext context, ProviderModel value, Widget? child) {
          if (context.read<ProviderModel>().selectFamPatient == 0) {
            return Column(
              children: [
                Text(
                  '${value.dataAccount['th_Firstname']} ${value.dataAccount['th_Lastname']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${value.dataAccount['phone']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Text(
                  '${value.dataListFamily[value.selectFamPatient - 1]['th_Firstname']} ${value.dataListFamily[value.selectFamPatient - 1]['th_Lastname']}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text('${value.dataAccount['phone']}',
                    style: const TextStyle(
                      color: Colors.transparent,
                      fontSize: 16,
                    )),
              ],
            );
          }
        }),
      ],
    );
  }
}
