// ignore_for_file: prefer_const_constructors, file_names, avoid_print, camel_case_types, use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uu_alpha/page/Home/booking_Page.dart';
import 'package:uu_alpha/page/Home/history_Page.dart';
import 'package:uu_alpha/page/Home/home_Page.dart';
import 'package:uu_alpha/page/Home/profile_Page.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';

class homeControl extends StatefulWidget {
  const homeControl({
    super.key,
  });
  @override
  State<homeControl> createState() => _homeControlState();
}

class _homeControlState extends State<homeControl> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    String phoneNumber = await getPhoneNumber();
    setState(() {
      context.read<ProviderModel>().currentIndex;
      context.read<ProviderModel>().phoneNumber = phoneNumber;
    });
    log('[phoneNumber][final]: $phoneNumber');

    context.read<ProviderModel>().loadDataAccount(phoneNumber);
    context.read<ProviderModel>().loadDataListFamily(phoneNumber);
    context.read<ProviderModel>().loadDataListDoctor();
    context.read<ProviderModel>().loadDataListReservation(phoneNumber);
    context.read<ProviderModel>().loadDataListserviceOptions();
    context.read<ProviderModel>().loadDataListBanner();
    context.read<ProviderModel>().getDataLanguage();
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNumber = prefs.getString('PhoneNumber') ?? '';
    log('[phoneNumber][get]: $phoneNumber');
    return phoneNumber;
  }
  // void initState() {
  //   super.initState();
  //   context.read<ProviderModel>().phoneNumber = getPhoneNumber() as String;
  //   log('[phoneNumber][final]: ${context.read<ProviderModel>().phoneNumber}');
  //   context
  //       .read<ProviderModel>()
  //       .loadDataAccount(context.read<ProviderModel>().phoneNumber);
  //   context
  //       .read<ProviderModel>()
  //       .loadDataListFamily(context.read<ProviderModel>().phoneNumber);
  //   context.read<ProviderModel>().loadDataListDoctor();
  //   context
  //       .read<ProviderModel>()
  //       .loadDataListReservation(context.read<ProviderModel>().phoneNumber);
  // }

  // Future<String> getPhoneNumber() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String phoneNumber = prefs.getString('PhoneNumber') ?? '';
  //   log('[phoneNumber][get]: $phoneNumber');
  //   return phoneNumber;
  // }
  bool isBackPressed = false;
  final _pageOptions = [
    homePage(),
    BookingPage(),
    HistoryPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return WillPopScope(
          onWillPop: () async {
            // ทำสิ่งที่คุณต้องการเมื่อกดปุ่ม back ที่นี่
            // ตัวอย่างเช่น:
            if (value.currentIndex != 0) {
              value.onItemTapped(0);
              return false; // ไม่ออกจากหน้านี้
            } else {
              if (isBackPressed) {
                return true; // ออกจากแอพ
              } else {
                setState(() {
                  isBackPressed = true;
                });
                Fluttertoast.showToast(
                  msg: "toast.need_exit".tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color.fromARGB(158, 158, 158, 158),
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                return false; // ไม่ออกจากหน้านี้
              }
            }
          },
          child: Scaffold(
            body: PageView(
              controller: context.watch<ProviderModel>().pageController,
              physics: NeverScrollableScrollPhysics(),
              children: _pageOptions,
            ),
            bottomNavigationBar: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Symbols.home,
                      size: 24,
                      weight: 800,
                    ),
                    label: ('mainHome.Home').tr(),
                    // ('home_control.Home'.tr()),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Symbols.calendar_add_on,
                      size: 24,
                      weight: 800,
                    ),
                    label: ('mainHome.Booking').tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Symbols.history,
                      size: 24,
                      weight: 800,
                    ),
                    label: ('mainHome.History').tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Symbols.account_circle,
                      size: 24,
                      weight: 800,
                    ),
                    label: ('mainHome.Profile').tr(),
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                enableFeedback: false,
                backgroundColor: Colors.white,
                selectedItemColor: ColorStyles.purple_500,
                unselectedItemColor: ColorStyles.grey_500,
                selectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                currentIndex: value.currentIndex,
                onTap: (index) {
                  value.onItemTapped(index);
                  setState(() {
                    isBackPressed = false;
                  });
                }),
          ),
        );
      },
    );
  }
}
