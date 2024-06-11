// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uu_alpha/styles.dart';

class ProviderModel extends ChangeNotifier {
  // ภาษา
  String? selectedLang;
  void getDataLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('language');
    log("[getDataLanguage][value]: $value");
    selectedLang = value;
  }

  void setDataLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
    String? value = prefs.getString('language');
    log("[setDataLanguage][value]: $value");
    selectedLang = value;
  }

  // ใช้เก็บเบอร์
  late String phoneNumber = ''; //088-888-8888

  // Firebase ข้อมูล
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  Map<String, dynamic> dataAccount = {};
  void loadDataAccount(String Number) {
    firebase
        .collection("User")
        .doc(Number)
        .collection("information")
        .doc("Account")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      // ตรวจสอบว่ามีเอกสารหรือไม่
      if (documentSnapshot.exists) {
        // เลือกแสดงข้อมูลจากเอกสารที่มี index เป็น 0 (หรือตามที่คุณต้องการ)
        dataAccount.clear();
        dataAccount = documentSnapshot.data() as Map<String, dynamic>;
        log("[firebase][dataAccount]: $dataAccount");
        notifyListeners();
      } else {
        log("[firebase][dataAccount]: No documents found");
      }
    }).catchError((error) {
      log("An error occurred: $error");
    });
  }

  List<Map<String, dynamic>> dataListFamily = [];
  void loadDataListFamily(String Number) {
    firebase
        .collection("User")
        .doc(Number)
        .collection("information")
        .doc("Account")
        .collection("Family")
        .get()
        .then((QuerySnapshot querySnapshot) {
      // ตรวจสอบว่ามีเอกสารหรือไม่
      if (querySnapshot.docs.isNotEmpty) {
        // เลือกแสดงข้อมูลจากเอกสารที่มี index เป็น 0 (หรือตามที่คุณต้องการ)
        dataListFamily.clear();
        dataListFamily = querySnapshot.docs
            .map((document) => (document.data() ?? {}) as Map<String, dynamic>)
            .toList();
        notifyListeners();
        // log("[firebase][dataListFamily]: $dataListFamily");
      } else {
        log("[firebase][dataListFamily]: No documents found");
      }
    }).catchError((error) {
      log("An error occurred: $error");
    });
  }

  List<Map<String, dynamic>> dataListDoctor = [];
  void loadDataListDoctor() {
    firebase.collection("doctor").get().then((QuerySnapshot querySnapshot) {
      // ตรวจสอบว่ามีเอกสารหรือไม่
      if (querySnapshot.docs.isNotEmpty) {
        // เลือกแสดงข้อมูลจากเอกสารที่มี index เป็น 0 (หรือตามที่คุณต้องการ)
        dataListDoctor.clear();
        dataListDoctor = querySnapshot.docs
            .map((document) => (document.data() ?? {}) as Map<String, dynamic>)
            .toList();
        notifyListeners();
        // log("[firebase][dataListDoctor]: $dataListDoctor");
      } else {
        log("[firebase][dataListDoctor]: No documents found");
      }
    }).catchError((error) {
      log("An error occurred: $error");
    });
  }

  List<Map<String, dynamic>> dataListReservation = [];
  void loadDataListReservation(String Number) {
    firebase
        .collection("User")
        .doc(Number)
        .collection("information")
        .doc("Account")
        .collection("Reservation")
        .orderBy("idReserve", descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      // ตรวจสอบว่ามีเอกสารหรือไม่

      if (querySnapshot.docs.isNotEmpty) {
        // เลือกแสดงข้อมูลจากเอกสารที่มี index เป็น 0 (หรือตามที่คุณต้องการ)
        dataListReservation = [];
        dataListReservation = querySnapshot.docs
            .map((document) => (document.data() ?? {}) as Map<String, dynamic>)
            .toList();
        // log("[firebase][dataListReservation]: $dataListReservation");
        notifyListeners();
      } else {
        log("[firebase][dataListReservation]: No documents found");
      }
    }).catchError((error) {
      log("An error occurred: $error");
    });
  }

  List<Map<String, dynamic>> serviceOptions = [];
  void loadDataListserviceOptions() {
    firebase.collection("data").get().then((QuerySnapshot querySnapshot) {
      // ตรวจสอบว่ามีเอกสารหรือไม่
      if (querySnapshot.docs.isNotEmpty) {
        // เลือกแสดงข้อมูลจากเอกสารที่มี index เป็น 0 (หรือตามที่คุณต้องการ)
        serviceOptions = [];
        serviceOptions = querySnapshot.docs
            .map((document) => (document.data() ?? {}) as Map<String, dynamic>)
            .toList();
        log("[firebase][serviceOptions]: $serviceOptions");
        notifyListeners();
      } else {
        log("[firebase][serviceOptions]: No documents found");
      }
    }).catchError((error) {
      log("An error occurred: $error");
    });
  }
  //ใช้เก็บ รายการที่ให้บริการ
  // final List<Map> serviceOptions = [
  //   // ตรวจฟัน
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159666801414144/fd2c74197d10d7d4.png?ex=65cc716f&is=65b9fc6f&hm=4725415cb35683381179490d75830787fbff657b5d70c56caf640d76a8565fa9&=&format=webp&quality=lossless&width=640&height=640',
  //     'name_service': 'ตรวจฟัน',
  //   },
  //   // ขูดหินปูน
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159665925075034/961517ab43f99ab6.png?ex=65cc716f&is=65b9fc6f&hm=ac23c7729e7061b93062e3fc5c1f29660ccfe9d6f848a0fc2d3c94aceb9dd00a&=&format=webp&quality=lossless&width=625&height=640',
  //     'name_service': 'ขูดหินปูน',
  //   },
  //   // ถอนฟัน
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159667170508880/32cee57568d86a04.png?ex=65cc716f&is=65b9fc6f&hm=e723a0295450f39e11b1f33af8c911558c6812fa69e98dc548b075e52b8f8665&=&format=webp&quality=lossless&width=655&height=640',
  //     'name_service': 'ถอนฟัน',
  //   },
  //   // รากฟัน
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159665174302750/8393a8631a435900.png?ex=65cc716f&is=65b9fc6f&hm=472af001f0ffcf7c7fdc45c23b0cd05843ab5769e43694ba1eebeaa1ca5cab38&=&format=webp&quality=lossless&width=640&height=640',
  //     'name_service': 'รากฟัน',
  //   },
  //   // อุดฟัน
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159672258474004/77095f3bbda8bbe5.png?ex=65cc7170&is=65b9fc70&hm=efeb5be9b5e3b43011760973e783350d339f4053f1e2f856b13c1c9308518a26&=&format=webp&quality=lossless&width=640&height=640',
  //     'name_service': 'อุดฟัน',
  //   },
  //   // ครอบฟัน
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159666193506304/8a44e732a14afa08.png?ex=65cc716f&is=65b9fc6f&hm=d68e2db01d7869f1a1cabdbd3d648778ec3d87db1f6b4724ee7dc4048baed3fd&=&format=webp&quality=lossless&width=625&height=640',
  //     'name_service': 'ครอบฟัน',
  //   },
  //   // ผ่าฟันคุด
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159667506061352/962269fbb7bfde2e.png?ex=65cc716f&is=65b9fc6f&hm=0f3430ffab0c36629c507091220e5592d5c1a0d3dad97341f4db0fb950aa4d8c&=&format=webp&quality=lossless&width=640&height=640',
  //     'name_service': 'ผ่าฟันคุด',
  //   },
  //   // จัดฟัน
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159666491297792/b057736e523894aa.png?ex=65cc716f&is=65b9fc6f&hm=1d90a043f2c4201d4d82fbe5b8c8a7b71c067656d3650f4e6a5ac33e450a256b&=&format=webp&quality=lossless&width=640&height=640',
  //     'name_service': 'จัดฟัน',
  //   },
  //   // หลุมร่องฟัน
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159671943905280/6379ad84dc884c00.png?ex=65cc7170&is=65b9fc70&hm=f8dfc2d188a50e3feeed15d576af43378848ccbf142271c1e16236880837bed5&=&format=webp&quality=lossless&width=640&height=640',
  //     'name_service': 'หลุมร่องฟัน',
  //   },
  //   // รีเทนเนอร์
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159665425956864/f7eae8dfb8a39ead.png?ex=65cc716f&is=65b9fc6f&hm=be96f0a75d71f931ce6e43fb934beb62747e5e4f2f570971f146d9c68e44da49&=&format=webp&quality=lossless&width=655&height=640',
  //     'name_service': 'รีเทนเนอร์',
  //   },
  //   // ฟอกสีฟัน
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159667783159808/faa70736429bb90e.png?ex=65cc716f&is=65b9fc6f&hm=84e51db2ba8ed515e484f7f3b3116cc3ff322aead5b4b19ad629271ff0cb08f6&=&format=webp&quality=lossless&width=625&height=640',
  //     'name_service': 'ฟอกสีฟัน',
  //   },
  //   // X-ray ฟัน
  //   {
  //     'image_service':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1202159665681793024/x.png?ex=65cc716f&is=65b9fc6f&hm=719926b6be05a8e1b7497288325b7e23e1b29ae8853a84b5c071c8f23389f335&=&format=webp&quality=lossless&width=640&height=640',
  //     'name_service': 'X-ray ฟัน',
  //   },
  // ];

  List<Map<String, dynamic>> dataBanner = [];
  void loadDataListBanner() {
    firebase.collection("banner").get().then((QuerySnapshot querySnapshot) {
      // ตรวจสอบว่ามีเอกสารหรือไม่
      if (querySnapshot.docs.isNotEmpty) {
        // เลือกแสดงข้อมูลจากเอกสารที่มี index เป็น 0 (หรือตามที่คุณต้องการ)
        dataBanner = [];
        dataBanner = querySnapshot.docs
            .map((document) => (document.data() ?? {}) as Map<String, dynamic>)
            .toList();
        log("[firebase][dataBanner]: $dataBanner");
        notifyListeners();
      } else {
        log("[firebase][dataBanner]: No documents found");
      }
    }).catchError((error) {
      log("An error occurred: $error");
    });
  }

  // //banner
  // final List<Map> dataBanner = [
  //   {
  //     'backImage':
  //         'https://media.discordapp.net/attachments/747447611987984404/1181891230171410543/ban2.png?ex=6582b4fb&is=65703ffb&hm=b94f31a6d4d1ccecbdb24eb225f095d5c8ead91ecc64bc65fb219101c9b30fa8&=&format=webp&quality=lossless&width=810&height=253'
  //   },
  //   {
  //     'backImage':
  //         'https://media.discordapp.net/attachments/747447611987984404/1181891230473404437/ban1.png?ex=6582b4fb&is=65703ffb&hm=e1cacd332f34f582a07bb74e66bb84cf846eab27c3d609e00e0e9db4b25ccc9f&=&format=webp&quality=lossless&width=810&height=253',
  //   },
  //   {
  //     'backImage':
  //         'https://media.discordapp.net/attachments/747447611987984404/1181891230171410543/ban2.png?ex=6582b4fb&is=65703ffb&hm=b94f31a6d4d1ccecbdb24eb225f095d5c8ead91ecc64bc65fb219101c9b30fa8&=&format=webp&quality=lossless&width=810&height=253'
  //   },
  //   {
  //     'backImage':
  //         'https://media.discordapp.net/attachments/747447611987984404/1181891230473404437/ban1.png?ex=6582b4fb&is=65703ffb&hm=e1cacd332f34f582a07bb74e66bb84cf846eab27c3d609e00e0e9db4b25ccc9f&=&format=webp&quality=lossless&width=810&height=253',
  //   },
  // ];
  // ส่งหลักฐานการโอน ชำระเงิน
  void updateDataReservation(String Number, String idReserve, String image) {
    firebase
        .collection("User")
        .doc(Number)
        .collection("information")
        .doc("Account")
        .collection("Reservation")
        .where("idReserve", isEqualTo: idReserve) // เปลี่ยนเป็นคำสั่ง where
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          firebase
              .collection("User")
              .doc(Number)
              .collection("information")
              .doc("Account")
              .collection("Reservation")
              .doc(doc.id) // ใช้ doc.id ที่ได้จาก query ไปเป็น idReserve
              .set({
                'PictureEevidence': image,
                'statusReserve': 'รอตรวจสอบ',
                'tokenReserve': 2,
              }, SetOptions(merge: true))
              .then((value) => log("Data  update image successfully"))
              .catchError((error) => log("Failed to add data: $error"));
          notifyListeners();
        }
      } else {
        log("No documents found with idReserve: 000000021");
      }
    }).catchError((error) {
      log("An error occurred: $error");
    });
  }

  // อัปเดดสถานะ ยืนยันเข้าคลินิก ยกเลิก
  void updateStatusReservation(String Number, String idReserve, String status) {
    firebase
        .collection("User")
        .doc(Number)
        .collection("information")
        .doc("Account")
        .collection("Reservation")
        .where("idReserve", isEqualTo: idReserve) // เปลี่ยนเป็นคำสั่ง where
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          firebase
              .collection("User")
              .doc(Number)
              .collection("information")
              .doc("Account")
              .collection("Reservation")
              .doc(doc.id) // ใช้ doc.id ที่ได้จาก query ไปเป็น idReserve
              .set({'statusReserve': status}, SetOptions(merge: true))
              .then((value) => log("Data  update status successfully"))
              .catchError((error) => log("Failed to add data: $error"));
          notifyListeners();
        }
      } else {
        log("No documents found with idReserve: 000000021");
      }
    }).catchError((error) {
      log("An error occurred: $error");
    });
  }

  // homecontrol
  int currentIndex = 0;
  late PageController pageController =
      PageController(initialPage: currentIndex);
  void onItemTapped(int index) {
    log('_onItemTapped:$index');
    currentIndex = index;
    pageController.animateToPage(
      index,
      // ignore: prefer_const_constructors
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  // ใช้เก็บ tag ที่เราเลือก
  late int selectedfilterIndex = -1;
  // ใช้เก็บ id ล่าสุด เอาไปสร้าง id การจองต่อไป
  String stringNumber = '0000000000';
  // สร้าง id booking
  String incrementNumber(String numberString) {
    // แปลงข้อความเป็นตัวเลขแบบ int
    int number = int.parse(numberString);

    // เพิ่มค่าของตัวเลข
    number++;

    // แปลงตัวเลขกลับเป็นข้อความแบบ string
    String incrementedNumberString = number.toString().padLeft(9, '0');
    log('[stringNumber][NewID]: $incrementedNumberString');
    return stringNumber = incrementedNumberString;
  }

  // หน้า result
  Map<String, dynamic>? idReserveReservation;
  // หาข้อมูลที่ตรงกับ id ที่กำหนด
  void findResult() {
    final List<Map<String, dynamic>> allReservations = dataListReservation;

    final selectedReservations = allReservations
        .where((reservation) => reservation['idReserve'] == stringNumber)
        .toList();

    if (selectedReservations.isNotEmpty) {
      idReserveReservation = selectedReservations.first;
    } else {
      idReserveReservation = null;
    }
    log('[findResult][idReserveReservation]: $idReserveReservation');
  }

  // void filterCardData(String keyword) {
  //   filteredDocData = docData.where((doc) {
  //     final String lowerCaseKeyword = keyword.toLowerCase();
  //     return doc['statusReserve'].toLowerCase().contains(lowerCaseKeyword) ||
  //         doc['nameDoc'].toLowerCase().contains(lowerCaseKeyword) ||
  //         doc['skillsDoc'].any((skill) =>
  //             skill.toString().toLowerCase().contains(lowerCaseKeyword));
  //   }).toList();
  // }
  // int findIndexByIdReserve(String targetId) {
  //   return dataReserve.indexWhere((data) => data['idReserve'] == targetId);
  // }

  // ใช้เก็บ ข้อมูลรายการจอง
  // final List<Map> dataReserve = [
  //   // /*-1 อนุมัติ*/
  //   // {
  //   //   'idReserve': 'xxxxxx000',
  //   //   'datetimeReserve': '',
  //   //   'datetimeOldReserve': '',
  //   //   'prefixDoc': 'นายแพทย์',
  //   //   'docReserve': 'สุขใจ มีโชค',
  //   //   'selectservices': 'ผ่าฟันคุด',
  //   //   'patientReserve': 'นวลสุข หหหห',
  //   //   'phoneReserve': '088-888-8888',
  //   //   'statusReserve': 'อนุมัติ',
  //   //   'tokenReserve': 2,
  //   // },
  //   // /*0 สำเร็จ*/ {
  //   //   'idReserve': 'xxxxxx000',
  //   //   'datetimeReserve': '',
  //   //   'prefixDoc': 'นายแพทย์',
  //   //   'docReserve': 'สุขใจ มีโชค',
  //   //   'selectservices': 'ตรวจฟัน',
  //   //   'patientReserve': 'นวลสุข หหหห',
  //   //   'phoneReserve': '088-888-888',
  //   //   'statusReserve': 'สำเร็จ',
  //   //   'tokenReserve': 2,
  //   // },
  //   // /*1 ยกเลิก*/ {
  //   //   'idReserve': 'xxxxxx111',
  //   //   'datetimeReserve': '',
  //   //   'prefixDoc': 'นายแพทย์',
  //   //   'docReserve': 'สุขใจ มีโชค',
  //   //   'selectservices': 'ผ่าฟันคุด',
  //   //   'patientReserve': 'นวลสุข กกกก',
  //   //   'phoneReserve': '088-888-888',
  //   //   'statusReserve': 'ยกเลิก',
  //   //   'tokenReserve': 2,
  //   // },
  //   // /*2 เลื่อน*/ {
  //   //   'idReserve': 'xxxxxx222',
  //   //   'datetimeReserve': '',
  //   //   'prefixDoc': 'นายแพทย์',
  //   //   'docReserve': 'สุขใจ มีโชค',
  //   //   'selectservices': ' ',
  //   //   'patientReserve': 'นวลสุข ฟฟฟฟ',
  //   //   'phoneReserve': '088-888-888',
  //   //   'statusReserve': 'เลื่อน',
  //   //   'tokenReserve': 1,
  //   // },
  //   // /*3 รอตรวจสอบ*/ {
  //   //   'idReserve': 'xxxxxx333',
  //   //   'datetimeReserve': '',
  //   //   'prefixDoc': 'นายแพทย์',
  //   //   'docReserve': 'สุขใจ มีโชค',
  //   //   'selectservices': 'จัดฟัน',
  //   //   'patientReserve': 'นวลสุข ไไไไ',
  //   //   'phoneReserve': '088-888-888',
  //   //   'statusReserve': 'รอตรวจสอบ',
  //   //   'tokenReserve': 2,
  //   // },
  //   // /*4 รอชำระเงิน*/ {
  //   //   'idReserve': 'xxxxxx444',
  //   //   'datetimeReserve': '',
  //   //   'prefixDoc': 'นายแพทย์',
  //   //   'docReserve': 'มีโชค สุขใจ',
  //   //   'selectservices': 'จัดฟัน',
  //   //   'patientReserve': 'นวล พพพพพ',
  //   //   'phoneReserve': '088-888-888',
  //   //   'statusReserve': 'รอชำระเงิน',
  //   //   'tokenReserve': 2,
  //   // },
  // ];

  //แสดงวันที่ เดือน ไม่แสดง พ.ศ.
  String showDateMonthYear(DateTime date) {
    // แสดงแบบ วัน ที่ เดือน พ.ศ
    // กำหนดรูปแบบวันที่
    String day = DateFormat('d', 'th_TH').format(date);

    // กำหนดรูปแบบเดือน
    String month = DateFormat('MMMM', 'th_TH').format(date);

    // กำหนดรูปแบบปี และ พ.ศ.
    // String year = DateFormat('y', 'th_TH').format(date);
    String buddhistEra = (date.year + 543).toString(); // คำนวณ พ.ศ.

    // สร้างสตริงแบบที่ต้องการ
    String formattedDate = '$day $month $buddhistEra';

    return formattedDate;
  }

  //แสดงวันที่ เดือนแบบย่อ ไม่แสดง พ.ศ.
  String showDateMonthYearABB(DateTime date) {
    // แสดงแบบ วัน ที่ เดือน พ.ศ
    // กำหนดรูปแบบวันที่
    String day = DateFormat('d', 'th_TH').format(date);

    // กำหนดรูปแบบเดือน
    String month = DateFormat('MMM', 'th_TH').format(date);

    // กำหนดรูปแบบปี และ พ.ศ.
    // String year = DateFormat('y', 'th_TH').format(date);
    String buddhistEra = (date.year + 543).toString(); // คำนวณ พ.ศ.

    // สร้างสตริงแบบที่ต้องการ
    String formattedDate = '$day $month $buddhistEra';

    return formattedDate;
  }

  //แสดงวัน วันที่ เดือน ไม่แสดง พ.ศ.
  String showDateMonthYearWDY(DateTime date) {
    // แสดงแบบ วัน ที่ เดือน พ.ศ
    // กำหนดรูปแบบวัน
    String dayOfWeek = DateFormat('EEEE', 'th_TH').format(date);

    // กำหนดรูปแบบวันที่
    String day = DateFormat('d', 'th_TH').format(date);

    // กำหนดรูปแบบเดือน
    String month = DateFormat('MMMM', 'th_TH').format(date);

    // กำหนดรูปแบบปี และ พ.ศ.
    // String year = DateFormat('y', 'th_TH').format(date);
    String buddhistEra = (date.year + 543).toString(); // คำนวณ พ.ศ.

    // สร้างสตริงแบบที่ต้องการ
    String formattedDate = '$dayOfWeek ที่ $day $month $buddhistEra';

    return formattedDate;
  }

  //แสดงเวลา 24.00 น.
  String showTime(DateTime time) {
    // แปลง DateTime เป็นสตริง ส่วนของเวลา
    String formattedtime = DateFormat('HH:mm น.').format(time);
    return formattedtime;
  }

  //ใช้เก็บ ข้อมูลหมอ
  // final List<Map> docData = [
  //   {
  //     'imageDoc':
  //         'https://i.pinimg.com/564x/13/7e/57/137e57e5d5a40634d8506fbc6bc7ffbe.jpg',
  //     'prefixDoc': 'นายแพทย์ ',
  //     'nickName': 'หมอสุข',
  //     'nameDoc': 'สุขใจ มีโชค',
  //     'skillsDoc': [
  //       'ถอนฟัน',
  //       'ครอบฟัน',
  //       'ผ่าฟันคุด',
  //       'จัดฟัน',
  //       'เคลือบหลุมร่องฟัน'
  //     ],
  //   },
  //   {
  //     'imageDoc':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1193767261396287602/2c423b7579a9a4aaf4aa6c1600ae0ecc.png?ex=65ade966&is=659b7466&hm=e8426426f5da226d1eda996471380cb44a14c6844c1e28ec8d2ff86f082322f0&=&format=webp&quality=lossless',
  //     'prefixDoc': 'แพทย์หญิง ',
  //     'nickName': 'H',
  //     'nameDoc': 'แสนดี มีชัย',
  //     'skillsDoc': ['ถอนฟัน', 'เคลือบหลุมร่องฟัน', 'ครอบฟัน', 'หลุมร่องฟัน'],
  //   },
  //   {
  //     'imageDoc':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1193767261123649586/65f5f1519b81c94d60e19bb69ab6c93c.png?ex=65ade966&is=659b7466&hm=7af4ccb9bf6647cd2067594d9c7a255cc02d58ae27d29032392a949f83335bb6&=&format=webp&quality=lossless',
  //     'prefixDoc': 'นายแพทย์ ',
  //     'nickName': 'G',
  //     'nameDoc': 'วินนา เจริญ',
  //     'skillsDoc': ['ถอนฟัน', 'ครอบฟัน', 'รีเทนเนอร์'],
  //   },
  //   {
  //     'imageDoc':
  //         'https://media.discordapp.net/attachments/1185071591726530652/1193767261660512346/7c7608dd7c78d114d4efcdb599b9ee2d.png?ex=65ade966&is=659b7466&hm=59b6979c5dfea1f84365f18963f7c7ffcc611627a82667dcea223b7b0951e351&=&format=webp&quality=lossless',
  //     'prefixDoc': 'แพทย์หญิง ',
  //     'nickName': 'V',
  //     'nameDoc': 'รัตนา วรรณ',
  //     'skillsDoc': [
  //       'ถอนฟัน',
  //       'อุดฟัน',
  //       'ครอบฟัน',
  //       'X-ray ฟัน',
  //     ],
  //   },
  // ];
  TextEditingController textFiler = TextEditingController();
  List<Map> filteredDocData = [];
  //ใช้หรองหา ข้อมูลหมอ
  void filterDocData(String keyword) {
    keyword = keyword.trim();
    filteredDocData = dataListDoctor.where((doc) {
      final String lowerCaseKeyword = keyword.toLowerCase();
      return doc['prefixDoc'].toLowerCase().contains(lowerCaseKeyword) ||
          doc['nameDoc'].toLowerCase().contains(lowerCaseKeyword) ||
          doc['skillsDoc'].any((skill) =>
              skill.toString().toLowerCase().contains(lowerCaseKeyword));
    }).toList();
  }

  //ใช้ index ของข้อมูลหมอ
  // int findDoc(String name) {
  //   return docData.indexWhere((map) => map['nameDoc'] == name);
  // }

  // แสดงอายุปัจจุบัน
  String showAge(DateTime birthDate) {
    // รับวันปัจจุบัน
    DateTime currentDate = DateTime.now();

    // คำนวนอายุโดยใช้ Duration
    Duration ageDifference = currentDate.difference(birthDate);

    // แสดงผลลัพธ์เป็นตัวแปร DateTime
    DateTime age = DateTime(1, 1, 1).add(ageDifference);

    return "${age.year - 1} yr (${age.month - 1}m ${age.day - 1}d)";
  }

  // แปลง Timestamp เป็น DateTime
  DateTime showTimestamp(Timestamp timestamp) {
    // ข้อมูล birthday
    Timestamp birthdayTimestamp = timestamp;

    DateTime birthdayDateTime = birthdayTimestamp.toDate();
    return birthdayDateTime;
    // showDateMonthYearABB(birthdayDateTime);
  }

  // หรือในกรณีที่มีการเปลี่ยนแปลงข้อมูลในตำแหน่งที่เฉพาะเจาะจง
  // bool haveFam = true;
  int selectFamPatient = 0;
  void changeSelectedFamPatient(int newIndex) {
    selectFamPatient = newIndex;
    notifyListeners();
  }

  //ใช้เก็บ รายการที่ให้บริการ
  // List<Map<String, dynamic>> familyData = [
  //   {
  //     'th_Firstname': 'ภราดร',
  //     'th_Lastname': 'รินฤทธิ์',
  //     'en_Firstname': '',
  //     'en_Lastname': '',
  //     'nickname': '',
  //     'birthday': DateTime(2001, 06, 15),
  //     'gender': 'ชาย',
  //     'phone': '077-777-7777',
  //     'image_Profile': null,
  //   },
  //   {
  //     'th_Firstname': 'นวลสุข',
  //     'th_Lastname': 'ลัลลา',
  //     'en_Firstname': '',
  //     'en_Lastname': '',
  //     'nickname': 'นวล',
  //     'birthday': DateTime(2001, 06, 15),
  //     'gender': 'หญิง',
  //     'age': '',
  //     'HN_ID': '1501234567890',
  //     'phone': '0973562285',
  //     'groupBlood': 'O',
  //     'religion': 'พุทธ',
  //     'nationality': 'ไทย',
  //     'customerType': 'ลูกค้าทั่วไป',
  //     'rightToTreatment': '-',
  //     'drugAllergy_AllergicReaction': 'ไม่มี',
  //     'FirstTimeComing': DateTime(2021, 03, 11),
  //     'comeWith': 'นวลสุข',
  //     'image_Profile': null,
  //   },
  //   {
  //     'th_Firstname': 'ไม่นวลสุข',
  //     'th_Lastname': 'ลัลลา',
  //     'en_Firstname': '',
  //     'en_Lastname': '',
  //     'nickname': 'นวล',
  //     'birthday': DateTime(2004, 07, 27),
  //     'gender': 'หญิง',
  //     'age': '',
  //     'HN_ID': '1501234567890',
  //     'phone': '0973562285',
  //     'groupBlood': 'O',
  //     'religion': 'พุทธ',
  //     'nationality': 'ไทย',
  //     'customerType': 'ลูกค้าทั่วไป',
  //     'rightToTreatment': '-',
  //     'drugAllergy_AllergicReaction': 'ไม่มี',
  //     'FirstTimeComing': DateTime(2023, 03, 11),
  //     'comeWith': 'นวลสุข',
  //     'image_Profile': null,
  //   },
  //   {
  //     'th_Firstname': 'ไม่สุขนวล',
  //     'th_Lastname': 'ลัลลา',
  //     'en_Firstname': '',
  //     'en_Lastname': '',
  //     'nickname': 'นวล',
  //     'birthday': DateTime(2006, 11, 09),
  //     'gender': 'หญิง',
  //     'age': '',
  //     'HN_ID': '1501234567890',
  //     'phone': '0973562285',
  //     'groupBlood': 'O',
  //     'religion': 'พุทธ',
  //     'nationality': 'ไทย',
  //     'customerType': 'ลูกค้าทั่วไป',
  //     'rightToTreatment': '-',
  //     'drugAllergy_AllergicReaction': 'ไม่มี',
  //     'FirstTimeComing': DateTime(2021, 07, 04),
  //     'comeWith': 'นวลสุข',
  //     'image_Profile': null,
  //   },
  //   {
  //     'th_Firstname': 'นวลไม่สุข',
  //     'th_Lastname': 'ลัลลา',
  //     'en_Firstname': '',
  //     'en_Lastname': '',
  //     'nickname': 'นวล',
  //     'birthday': DateTime(2011, 03, 05),
  //     'gender': 'หญิง',
  //     'age': '',
  //     'HN_ID': '1501234567890',
  //     'phone': '0973562285',
  //     'groupBlood': 'O',
  //     'religion': 'พุทธ',
  //     'nationality': 'ไทย',
  //     'customerType': 'ลูกค้าทั่วไป',
  //     'rightToTreatment': '-',
  //     'drugAllergy_AllergicReaction': 'ไม่มี',
  //     'FirstTimeComing': DateTime(2023, 03, 11),
  //     'comeWith': 'นวลสุข',
  //     'image_Profile': null,
  //   },
  // ];

  //ใช้เก็บ ข้อมูลรากการแจ้งเตือน dummy
  final List<Map> notiData = [
    {
      'idReserve': '000002',
      'statusUpdate': 'ได้ผ่านการตรวจสอบแล้ว',
      'isActive': false,
    },
    {
      'idReserve': '000001',
      'statusUpdate': 'ได้ผ่านการตรวจสอบแล้ว',
      'isActive': false,
    },
    {
      'idReserve': '000001',
      'statusUpdate': 'เลื่อนสำเร็จ',
      'isActive': false,
    },
    {
      'idReserve': '000001',
      'statusUpdate': 'ยกเลิกสำเร็จ',
      'isActive': false,
    },
    {
      'idReserve': '000001',
      'statusUpdate': 'จองนัดหมายสำเร็จ',
      'isActive': false,
    },
  ];
  void removeActiveItems() {
    notiData.removeWhere((item) => item['isActive'] == true);
    notifyListeners(); // แจ้งเตือนให้ Consumer ทราบว่าข้อมูลถูกเปลี่ยนแปลง
  }

  // _backgroundSection
  Color getStatusColor100(String status) {
    switch (status) {
      case 'อนุมัติ':
        return ColorStyles.green_100;
      case 'ยืนยันเข้าคลินิก':
        return ColorStyles.purple_100;
      case 'รอตรวจสอบ':
        return ColorStyles.yellow_100;
      case 'ยกเลิก':
        return ColorStyles.pink_100;
      case 'รอชำระเงิน':
        return ColorStyles.orange_100;
      case 'สำเร็จ':
        return ColorStyles.green_100;
      case 'นัดหมายหมอ':
        return ColorStyles.blue_100;
      default:
        return Colors.red;
    }
  }

  // cardStyles
  Color getStatusColor200(String status) {
    switch (status) {
      case 'อนุมัติ':
        return ColorStyles.green_200;
      case 'ยืนยันเข้าคลินิก':
        return ColorStyles.purple_200;
      case 'รอตรวจสอบ':
        return ColorStyles.yellow_200;
      case 'ยกเลิก':
        return ColorStyles.pink_200;
      case 'รอชำระเงิน':
        return ColorStyles.orange_200;
      case 'สำเร็จ':
        return ColorStyles.green_200;
      case 'นัดหมายหมอ':
        return ColorStyles.blue_200;
      default:
        return Colors.red;
    }
  }

  // Icon
  Color getStatusColor500(String status) {
    switch (status) {
      case 'อนุมัติ':
        return ColorStyles.green_500;
      case 'ยืนยันเข้าคลินิก':
        return ColorStyles.purple_500;
      case 'รอตรวจสอบ':
        return ColorStyles.yellow_500;
      case 'ยกเลิก':
        return ColorStyles.pink_500;
      case 'รอชำระเงิน':
        return ColorStyles.orange_500;
      case 'สำเร็จ':
        return ColorStyles.green_500;
      case 'นัดหมายหมอ':
        return ColorStyles.blue_500;
      default:
        return Colors.red;
    }
  }

  // text
  Color getStatusColor800(String status) {
    switch (status) {
      case 'อนุมัติ':
        return ColorStyles.green_800;
      case 'ยืนยันเข้าคลินิก':
        return ColorStyles.purple_800;
      case 'รอตรวจสอบ':
        return ColorStyles.yellow_800;
      case 'ยกเลิก':
        return ColorStyles.pink_800;
      case 'รอชำระเงิน':
        return ColorStyles.orange_800;
      case 'สำเร็จ':
        return ColorStyles.green_800;
      case 'นัดหมายหมอ':
        return ColorStyles.blue_800;
      default:
        return Colors.red;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'อนุมัติ':
        return Symbols.fact_check;
      case 'ยืนยันเข้าคลินิก':
        return Symbols.check_circle;
      case 'รอตรวจสอบ':
        return Symbols.calendar_clock;
      case 'ยกเลิก':
        return Symbols.event_busy;
      case 'รอชำระเงิน':
        return Symbols.local_atm;
      case 'สำเร็จ':
        return Symbols.event_available;
      case 'นัดหมายหมอ':
        return Symbols.stethoscope;
      default:
        return Symbols.error;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'อนุมัติ':
        return 'in_card.in_approve'.tr();
      case 'ยืนยันเข้าคลินิก':
        return 'in_card.in_confirm'.tr();
      case 'รอตรวจสอบ':
        return 'in_card.in_waiting_check'.tr();
      case 'ยกเลิก':
        return 'in_card.in_cancel'.tr();
      case 'รอชำระเงิน':
        return 'in_card.in_waiting_payment'.tr();
      case 'สำเร็จ':
        return 'in_card.in_succeed'.tr();
      case 'นัดหมายหมอ':
        return 'in_card.in_appoint'.tr();
      default:
        return 'error';
    }
  }

  String getStatusCardText(String status) {
    switch (status) {
      case 'สถานะทั้งหมด':
        return 'card.all'.tr();
      case 'อนุมัติ':
        return 'card.approve'.tr();
      case 'ยืนยันเข้าคลินิก':
        return 'card.confirm'.tr();
      case 'รอตรวจสอบ':
        return 'card.waiting_check'.tr();
      case 'ยกเลิก':
        return 'card.cancel'.tr();
      case 'รอชำระเงิน':
        return 'card.waiting_payment'.tr();
      case 'สำเร็จ':
        return 'card.succeed'.tr();
      case 'นัดหมายหมอ':
        return 'card.appoint'.tr();
      default:
        return 'error';
    }
  }

  String getServiceText(String status) {
    switch (status) {
      case 'บริการทั้งหมด':
        return 'home_page.service.all'.tr();
      case 'ตรวจฟัน':
        return 'home_page.service.check_teeth'.tr();
      case 'ขูดหินปูน':
        return 'home_page.service.scrape_tartar'.tr();
      case 'ถอนฟัน':
        return 'home_page.service.tooth_extraction'.tr();
      case 'รากฟัน':
        return 'home_page.service.root'.tr();
      case 'อุดฟัน':
        return 'home_page.service.dental_filling'.tr();
      case 'ผ่าฟันคุด':
        return 'home_page.service.wisdom_tooth_removal'.tr();
      case 'ครอบฟัน':
        return 'home_page.service.crown'.tr();
      case 'จัดฟัน':
        return 'home_page.service.orthodontics'.tr();
      case 'เคลือบหลุมร่องฟัน':
        return 'home_page.service.grooves'.tr();
      case 'รีเทนเนอร์':
        return 'home_page.service.retainer'.tr();
      case 'ฟอกสีฟัน':
        return 'home_page.service.whitening'.tr();
      case 'X-ray ฟัน':
        return 'home_page.service.dental_X-ray'.tr();
      default:
        return 'error';
    }
  }

  //ใช้เก็บ ข้อมูลรากการวันที่ปืดให้บริการ dummy
  List dayOff = [
    DateTime(2024, 01, 25),
    DateTime(2024, 01, 28),
    DateTime(2024, 01, 1),
    DateTime(2024, 02, 3),
    DateTime(2024, 02, 7),
    DateTime(2024, 02, 11),
    DateTime(2024, 02, 16),
    DateTime(2024, 02, 24),
  ];
}
