// ignore_for_file: unused_import, deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uu_alpha/api/Firebase_Notifications.dart';
import 'package:uu_alpha/page/History/checkStatus_Page..dart';
import 'package:uu_alpha/page/Home/home_Control.dart';
import 'package:uu_alpha/page/Login/login_Page.dart';
import 'package:uu_alpha/page/Profile/editProfile_Page.dart';
import 'package:uu_alpha/page/Onboarding/onboarding_Page.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';
import 'provider/provien.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// function to lisen to background changes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyBNoh0JLhEk3M48ZmF2ELLJurOU8woZtAc", // paste your api key here
      appId:
          "1:999136610796:android:7bf3903306eec3931b98c9", //paste your app id here
      messagingSenderId: "999136610796", //paste your messagingSenderId here
      projectId: "uuprojectalpha", //paste your project id here
    ),
  );
  PushNotifications().notifications();

  // Splash Screen
  FlutterNativeSplash.removeAfter(initialization);
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'), // English
        Locale('th'), // Thai
      ],
      // startLocale: const Locale('en', 'EN'),
      startLocale: const Locale('th'),
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ProviderModel>(create: (_) => ProviderModel()),
        ],
        child: ChangeNotifierProvider(
          create: (context) => ProviderModel(),
          child: const MyApp(),
        ),
      ),
    ),
  );
}

Future initialization(BuildContext? context) async {
  await Future.delayed(const Duration(milliseconds: 1000));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: ColorStyles.backgroundColor,
        useMaterial3: true,
      ),
      // FutureBuilder<bool>(
      //   future: isFristTime(), // เรียกใช้ฟังก์ชันเพื่อตรวจสอบการเข้าสู่ระบบ
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator(); // แสดง Indicator ขณะโหลดข้อมูล
      //     } else {
      //       if (snapshot.hasData && snapshot.data == true) {
      //         return LoginPage();
      //         // homeControl(
      //         //   phoneNumber: '088-888-8888',
      //         // ); // ถ้าเข้าสู่ระบบแล้ว ให้แสดงหน้าหลัก
      //       } else {
      // return OnboardingPage(
      //   pages: [
      //     OnboardingPageModel(
      //       title: 'จองนัดหมายได้ตลอดเวลา',
      //       description:
      //           'สามารถจองนัดหมอฟันได้อย่างรวดเร็ว\nไม่ต้องเสียเวลาในการเดินทางมาที่คลินิก',
      //       image:
      //           'https://media.discordapp.net/attachments/1189203452136538124/1201824494336102420/1.png?ex=65cb3948&is=65b8c448&hm=ec1b1c08ff3e71069246ec9b50af3fb510d34b1bc8ea66c662b6ea24cfe5ab55&=&format=webp&quality=lossless&width=451&height=640',
      //       bgColor: ColorStyles.backgroundColor,
      //     ),
      //     OnboardingPageModel(
      //       title: 'สะดวกสบาย ง่ายดายเพียงไม่กี่คลิก',
      //       description:
      //           'คุณสามารถจอง เลื่อน ยกเลิก\nได้ในง่ายพร้อมทั้งมีระบบการแจ้งเตือนก่อนถึงนัดหมาย',
      //       image:
      //           'https://media.discordapp.net/attachments/1189203452136538124/1201824494570962964/2.png?ex=65cb3948&is=65b8c448&hm=060a2fb9ce9067fb2add41a4ce1982bd14356e41f0efdc9cb5a0cb2e2d47a50d&=&format=webp&quality=lossless&width=488&height=640',
      //       bgColor: ColorStyles.backgroundColor,
      //     ),
      //     OnboardingPageModel(
      //       title: 'ดูแลอย่างใส่ใจ',
      //       description:
      //           'ทีมแพทย์ของเราเป็นมืออาชีพที่ให้การดูแลอย่างเป็นทางการ บริการด้วยเครื่องมือแพทย์ที่ทันสมัยได้มาตรฐาน',
      //       image:
      //           'https://cdn.discordapp.com/attachments/1185071591726530652/1202095471104106526/3.png?ex=65cc35a6&is=65b9c0a6&hm=386f01af9c2de987eee2ea06951e421f3e239f20b74af084172a80b6fefa06f2&',
      //       bgColor: ColorStyles.backgroundColor,
      //     ),
      //   ],
      // ); // ถ้ายังไม่ได้เข้าสู่ระบบ ให้แสดงหน้าเข้าสู่ระบบ
      //       }
      //     }
      //   },
      // ),
      // const homeControl(phoneNumber: '088-888-8888'),
      routes: {
        // 'testPage': (context) => const testPage(),
        '/': (context) => FutureBuilder<bool>(
              future:
                  isFirstTime(), // เรียกใช้ฟังก์ชันเพื่อตรวจสอบครั้งแรกที่ใช้งาน
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // แสดง Indicator ขณะโหลดข้อมูล
                } else {
                  if (snapshot.hasData && snapshot.data == true) {
                    return OnboardingPage(
                      pages: [
                        OnboardingPageModel(
                          title: 'onboarding.title_1'.tr(),
                          description: 'onboarding.description_1'.tr(),
                          image:
                              'https://firebasestorage.googleapis.com/v0/b/uuprojectalpha.appspot.com/o/asset%2F1.png?alt=media&token=c184717d-eeb9-4237-a2da-c70ee34bdb39',
                          bgColor: ColorStyles.backgroundColor,
                        ),
                        OnboardingPageModel(
                          title: 'onboarding.title_2'.tr(),
                          description: 'onboarding.description_2'.tr(),
                          image:
                              'https://firebasestorage.googleapis.com/v0/b/uuprojectalpha.appspot.com/o/asset%2F2.png?alt=media&token=4ced8a5e-71af-4e11-b5f8-0c08e3758a3a',
                          bgColor: ColorStyles.backgroundColor,
                        ),
                        OnboardingPageModel(
                          title: 'onboarding.title_3'.tr(),
                          description: 'onboarding.description_3'.tr(),
                          image:
                              'https://firebasestorage.googleapis.com/v0/b/uuprojectalpha.appspot.com/o/asset%2F3.png?alt=media&token=09f99240-80c3-48a3-b4b8-4e1c9b391490',
                          bgColor: ColorStyles.backgroundColor,
                        ),
                      ],
                    ); // ถ้าเป็นครั้งแรกที่ใช้งาน ให้แสดงหน้า OnboardingPage
                  } else {
                    return FutureBuilder<bool>(
                      future:
                          isLoggedIn(), // เรียกใช้ฟังก์ชันเพื่อตรวจสอบการเข้าสู่ระบบ
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // แสดง Indicator ขณะโหลดข้อมูล
                        } else {
                          if (snapshot.hasData && snapshot.data == true) {
                            return const homeControl(); // ถ้าเข้าสู่ระบบแล้ว ให้แสดงหน้าหลัก
                          } else {
                            return const LoginPage(); // ถ้ายังไม่ได้เข้าสู่ระบบ ให้แสดงหน้าเข้าสู่ระบบ
                          }
                        }
                      },
                    );
                  }
                }
              },
            ),
        // '/login': (context) => const LoginPage(),
        '/noti': (context) => const CheckStatus(),
        // '/message': (context) => const message(),
        // '/status': (context) => const NotificationStatus(),
        // '/notification': (context) => const notification(),
        // '/home': (context) => const homeControl(),
        // '/noti': (context) => const notification(),
        // '/edit': (context) => const EditProfilePage(),
      },
    );
  }

  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    log('[isFirstTime]:$isFirstTime');
    return isFirstTime;
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? true;
    final String? phoneNumber = prefs.getString('PhoneNumber');
    log('[phoneNumber]:$phoneNumber');
    log('[isLoggedIn]:$isLoggedIn');
    return isLoggedIn;
  }
}
