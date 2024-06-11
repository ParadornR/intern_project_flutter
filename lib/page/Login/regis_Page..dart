// ignore_for_file: avoid_print, non_constant_identifier_names, file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uu_alpha/page/Home/home_Control.dart';
import 'package:uu_alpha/styles.dart';

class RegisPage extends StatefulWidget {
  final String? phoneNumberController;
  const RegisPage({
    super.key,
    required this.phoneNumberController,
  });
  @override
  State<RegisPage> createState() => _RegisPageState();
}

enum SingingCharacter { male, famale }

class _RegisPageState extends State<RegisPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController FirstNameController = TextEditingController();
  TextEditingController LastNameController = TextEditingController();
  TextEditingController dateInputController = TextEditingController();
  DateTime? pickedDate;
  final _formKey = GlobalKey<FormState>();
  SingingCharacter? _character;
  late String _gender;
  String errorMessage = ''; // Add this line
  String errorFirstName = ''; // Add this line
  String errorLastName = ''; // Add this line
  String errorDate = ''; // Add this line
  DateTime now = DateTime.now();
  String phoneNo = '';

  @override
  void initState() {
    super.initState();
    phoneNo = widget.phoneNumberController.toString();
  }

  // Future<void> createCollection(
  // ) async {
  //   firebase
  //       .collection("User")
  //       .doc(context.read<ProviderModel>().getIdValue())
  //       .collection("family")
  //       .set({
  //   ใช้เพิ่มข้อมูลครอบครัว
  //   }).then((_) {
  //     print("collection created");
  //   }).catchError((_) {
  //     print("an error occured");
  //   });
  // }

  // ใช้เพิ่มข้อมูลบัญชี ด้วยเบอร์โทร
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  Future<void> createAccount(
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
      'phone': phoneNumber,
      'image_Profile': null,
    }).then((_) {
      log("collection created");
    }).catchError((_) {
      log("an error occured");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.only(top: 64),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 212,
                    height: 90,
                    child: Center(
                      child: Image.network(
                          'https://media.discordapp.net/attachments/747447611987984404/1181860434974887956/Group_2_2.png?ex=6582984d&is=6570234d&hm=44cfd0eabd0672290d6aa21b35fea8f16c196072ec9fcb2ef7c97672f840debd&=&format=webp&quality=lossless&width=810&height=355'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: const Text(
                      'regis.description',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ).tr(),
                  ),
                  const SizedBox(height: 32),
                  _Form(),
                  Container(
                    height: 16,
                    margin: const EdgeInsets.only(top: 8, bottom: 10),
                    child: Text(
                      errorMessage,
                      style: errorMessage == 'กรุณารอสักครู่'
                          ? TextStyles.textVisible
                          : const TextStyle(
                              color: ColorStyles.red,
                              fontSize: 12,
                            ),
                    ),
                  ),
                  _Button(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget nameField(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const Text(
          ' *',
          style: TextStyle(
            color: ColorStyles.red,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _Form() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: nameField('regis.name'.tr())),
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                controller: FirstNameController,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Zก-๏เแโใไ]'),
                  ),
                ],
                decoration: InputDecoration(
                  hintText: 'regis.name'.tr(),
                  errorStyle: const TextStyle(height: 0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: errorFirstName == 'ไม่ถูกต้อง'
                          ? Colors.red
                          : Colors.black,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: errorFirstName == 'ไม่ถูกต้อง'
                          ? Colors.red
                          : errorFirstName == 'ถูกต้อง'
                              ? Colors.black
                              : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.length < 4) {
                    setState(() {
                      errorFirstName = 'ไม่ถูกต้อง';
                    });
                  } else {
                    setState(() {
                      errorFirstName = 'ถูกต้อง';
                      _CheckForm();
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: nameField('regis.surname'.tr())),
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                controller: LastNameController,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zก-๏เแโใไ]'))
                ],
                decoration: InputDecoration(
                  hintText: 'regis.surname'.tr(),
                  errorStyle: const TextStyle(height: 0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: errorLastName == 'ไม่ถูกต้อง'
                          ? Colors.red
                          : Colors.black,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: errorLastName == 'ไม่ถูกต้อง'
                          ? Colors.red
                          : errorLastName == 'ถูกต้อง'
                              ? Colors.black
                              : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.length < 4) {
                    setState(() {
                      errorLastName = 'ไม่ถูกต้อง';
                    });
                  } else {
                    setState(() {
                      errorLastName = 'ถูกต้อง';
                      _CheckForm();
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: nameField('regis.date'.tr())),
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'regis.date'.tr(),
                  suffixIcon: const Icon(Icons.calendar_month),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color:
                          errorDate == 'ไม่ถูกต้อง' ? Colors.red : Colors.black,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: errorDate == 'ไม่ถูกต้อง'
                          ? Colors.red
                          : errorDate == 'ถูกต้อง'
                              ? Colors.black
                              : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                ),
                controller: dateInputController,
                readOnly: true,
                onTap: () async {
                  pickedDate = await showDatePicker(
                    context: context,
                    initialDate: now,
                    // currentDate: now.subtract(Duration(days: 1)),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    // locale: const Locale('th', 'TH'), // Specify Thai locale
                    helpText: 'regis.date'.tr(),
                    cancelText: 'regis.date_cancel'.tr(), //สำหรับปุ่มยกเลิก
                    confirmText: 'regis.date_confirm'.tr(), //สำหรับปุ่มยืนยัน
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ), // สไตล์ของตัวอักษร
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    28.0), // ปรับเปลี่ยนรูปร่างตามความต้องการ
                              ),
                            ),
                          ),
                          textTheme: const TextTheme(
                            bodyLarge: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            bodySmall: TextStyle(
                              color: ColorStyles.grey_500,
                              fontSize: 16,
                            ),
                            titleMedium: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            labelLarge: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    // Convert to Thai Buddhist date
                    now = pickedDate!;
                    DateTime thaiBuddhistDate =
                        convertToThaiBuddhistDate(pickedDate!);
                    // Format the date
                    var formattedDate = DateFormat('dd MMMM yyyy', 'th')
                        .format(thaiBuddhistDate);
                    dateInputController.text = formattedDate;
                    // ตรวจสอบว่าถูกต้องหรือไม่
                    setState(() {
                      errorDate = 'ถูกต้อง';
                      _CheckForm();
                    });
                  } else {
                    // ไม่ได้ระบุวันที่
                    setState(() {
                      errorDate = 'ไม่ถูกต้อง';
                    });
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: nameField('regis.gender'.tr())),
        Row(
          children: [
            RadioTheme(
              data: RadioThemeData(
                fillColor:
                    MaterialStateColor.resolveWith((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.black; // Color when selected
                  }
                  return Colors.black; // Color when not selected
                }),
              ),
              child: Row(
                children: [
                  Radio<SingingCharacter>(
                    value: SingingCharacter.male,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                        _gender = 'regis.male'.tr();
                        log('$_character');
                        _CheckForm();
                      });
                    },
                  ),
                  const Text('regis.male',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )).tr()
                ],
              ),
            ),
            const SizedBox(width: 40),
            RadioTheme(
              data: RadioThemeData(
                fillColor:
                    MaterialStateColor.resolveWith((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.black; // Color when selected
                  }
                  return Colors.black; // Color when not selected
                }),
              ),
              child: Row(
                children: [
                  Radio<SingingCharacter>(
                    value: SingingCharacter.famale,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                        _gender = 'regis.female'.tr();
                        log('$_character');
                        _CheckForm();
                      });
                    },
                  ),
                  const Text('regis.female',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )).tr(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _CheckForm() {
    if (errorFirstName == 'ถูกต้อง' &&
        errorLastName == 'ถูกต้อง' &&
        errorDate == 'ถูกต้อง' &&
        _character != null) {
      setState(() {
        errorMessage = 'กรุณารอสักครู่';
      });
    }
  }

  Widget _Button() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          if (FirstNameController.text.isEmpty ||
              LastNameController.text.isEmpty ||
              dateInputController.text.isEmpty) {
            setState(() {
              errorMessage = 'regis.personal_information_error'.tr();
            });
          } else if (_character == null) {
            setState(() {
              errorMessage = 'regis.gender_identification_error'.tr();
              log(errorMessage);
            });
          } else if (errorFirstName == 'ถูกต้อง' &&
              errorLastName == 'ถูกต้อง' &&
              errorDate == 'ถูกต้อง' &&
              _character != null) {
            setState(() {
              errorMessage = 'กรุณารอสักครู่';
              log(errorMessage);
            });
            print('Go to => OtpRequest');
            //ส่งบันทึก
            log('ส่งบันทึก: ${FirstNameController.text},${LastNameController.text},$pickedDate,$_gender');
            createAccount(
              phoneNo,
              FirstNameController.text,
              LastNameController.text,
              pickedDate!,
              _gender,
            );
            log('RegisPage() pushReplacement=> homeControl()');

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true); // เก็บข้อมูลการเข้าสู่ระบบ
            await prefs.setString(
                'PhoneNumber', phoneNo); // เก็บข้อมูลการเข้าสู่ระบบ
            log('${prefs.getString('PhoneNumber')}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const homeControl()),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: ColorStyles.purple_500,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadowStyles.largeBoxButtom],
          ),
          child: const Center(
            child: Text(
              'ยืนยัน',
              style: TextStyle(
                color: ColorStyles.purple_800,
                fontSize: 22,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ),
    );
  }

  DateTime convertToThaiBuddhistDate(DateTime gregorianDate) {
    // Thai Buddhist year offset
    const thaiBuddhistYearOffset = 543;

    // Add the offset to the year
    int thaiBuddhistYear = gregorianDate.year + thaiBuddhistYearOffset;

    // Create a new DateTime with the adjusted year
    DateTime thaiBuddhistDate =
        DateTime(thaiBuddhistYear, gregorianDate.month, gregorianDate.day);

    return thaiBuddhistDate;
  }
}
