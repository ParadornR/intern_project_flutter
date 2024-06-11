// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

enum SingingCharacter { male, famale }

class _EditProfilePageState extends State<EditProfilePage> {
  late DateTime now;
  final TextEditingController _th_Firstname = TextEditingController();
  final TextEditingController _th_Lastname = TextEditingController();
  final TextEditingController _en_Firstname = TextEditingController();
  final TextEditingController _en_Lastname = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _date = TextEditingController();
  DateTime? pickedDate;
  SingingCharacter? _character;
  late String _gender;

  @override
  void initState() {
    super.initState();
    // พิมพ์ผลลัพธ์
    now = DateTime.now();
    _th_Firstname.text =
        '${context.read<ProviderModel>().dataAccount['th_Firstname']}';
    _th_Lastname.text =
        '${context.read<ProviderModel>().dataAccount['th_Lastname']}';
    _en_Firstname.text =
        '${context.read<ProviderModel>().dataAccount['en_Firstname']}';
    _en_Lastname.text =
        '${context.read<ProviderModel>().dataAccount['en_Lastname']}';
    _nickname.text = '${context.read<ProviderModel>().dataAccount['nickname']}';
    _date.text = context.read<ProviderModel>().showDateMonthYearABB(
          context.read<ProviderModel>().showTimestamp(
                context.read<ProviderModel>().dataAccount['birthday'],
              ),
        );
    if (context.read<ProviderModel>().dataAccount['gender'] == 'ชาย') {
      _character = SingingCharacter.male;
      _gender = 'ชาย';
    } else {
      _character = SingingCharacter.famale;
      _gender = 'หญิง';
    }
  }

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
                  'edit_profile.title_bar'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'show_profile.edit'.tr(),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.transparent,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: ColorStyles.backgroundColor,
      ),
      body: Stack(
        children: [
          _backGroundSection(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _imageProfileSection(),
                  const SizedBox(height: 16),
                  _editFormSection(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _backGroundSection() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              Container(
                color: ColorStyles.purple_200,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            child: Container(
              color: ColorStyles.backgroundColor,
            ),
          ),
        )
      ],
    );
  }

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late FilePickerResult result;
  late String path;
  dynamic file; // File
  late Reference ref;

  Future<void> selectFile() async {
    result = (await FilePicker.platform.pickFiles())!;
    // ignore: unnecessary_null_comparison
    if (result == null) return;

    setState(
      () {
        pickedFile = result.files.first;
        log('====================\n$pickedFile\n====================');
      },
    );
    path = 'files/${pickedFile!.name}';
    file = File(pickedFile!.path!);
    ref = FirebaseStorage.instance.ref().child(path);
    log('result: $result');
    log('path: $path');
    log('file: $file');
    log('ref: $ref');
  }

  late TaskSnapshot Snapshot;
  dynamic urlPicture; //String
  Future uploadFile() async {
    uploadTask = ref.putFile(file);
    Snapshot = await uploadTask!.whenComplete(() {});
    urlPicture = await Snapshot.ref.getDownloadURL();
    log('Download Link: $urlPicture');
  }

  Widget _imageProfileSection() {
    return Stack(
      children: [
        Consumer(
          builder: (BuildContext context, ProviderModel value, Widget? child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              width: 120,
              height: 120,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 5,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                shape: BoxShape.circle,
              ),
              child: file == null
                  ? value.dataAccount['image_Profile'] == null ||
                          value.dataAccount['image_Profile'] == ""
                      ? const Center(
                          child: Text(
                            'No image',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Image.network(
                          '${value.dataAccount['image_Profile']}',
                          fit: BoxFit.cover,
                        )
                  : Image.file(
                      file,
                      fit: BoxFit.cover,
                    ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
              width: 44,
              height: 44,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: ColorStyles.purple_500,
                  width: 4,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                  onPressed: () {
                    log('edit');
                    selectFile();
                    // uploadFile();
                  },
                  icon: const Icon(Symbols.border_color))),
        ),
      ],
    );
  }

  Widget _editFormSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadowStyles.largeBoxButtom],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'edit_profile.name_from'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _th_Firstname,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Zก-๏เแโใไ]'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _th_Firstname.text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'edit_profile.name_from'.tr(),
                      hintStyle: const TextStyle(
                        color: ColorStyles.grey_500,
                        fontSize: 14,
                      ),
                      errorStyle: const TextStyle(height: 0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: _th_Firstname.text.isEmpty
                              ? ColorStyles.red
                              : Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'edit_profile.sername_from'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _th_Lastname,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Zก-๏เแโใไ]'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _th_Lastname.text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'edit_profile.sername_from'.tr(),
                      hintStyle: const TextStyle(
                        color: ColorStyles.grey_500,
                        fontSize: 14,
                      ),
                      errorStyle: const TextStyle(height: 0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: _th_Lastname.text.isEmpty
                              ? ColorStyles.red
                              : Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'edit_profile.first_name'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _en_Firstname,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Zก-๏เแโใไ]'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _en_Firstname.text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'edit_profile.first_name'.tr(),
                      hintStyle: const TextStyle(
                        color: ColorStyles.grey_500,
                        fontSize: 14,
                      ),
                      errorStyle: const TextStyle(height: 0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: _en_Firstname.text.isEmpty
                              ? ColorStyles.grey_200
                              : Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'edit_profile.last_name'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _en_Lastname,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Zก-๏เแโใไ]'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _en_Lastname.text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'edit_profile.last_name'.tr(),
                      hintStyle: const TextStyle(
                        color: ColorStyles.grey_500,
                        fontSize: 14,
                      ),
                      errorStyle: const TextStyle(height: 0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: _en_Lastname.text.isEmpty
                              ? ColorStyles.grey_200
                              : Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'edit_profile.nickname'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _nickname,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Zก-๏เแโใไ]'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _nickname.text;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'edit_profile.nickname'.tr(),
                      hintStyle: const TextStyle(
                        color: ColorStyles.grey_500,
                        fontSize: 14,
                      ),
                      errorStyle: const TextStyle(height: 0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: _nickname.text.isEmpty
                              ? ColorStyles.grey_200
                              : Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'edit_profile.birthday'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _date,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'edit_profile.birthday'.tr(),
                      hintStyle: const TextStyle(
                        color: ColorStyles.grey_500,
                        fontSize: 14,
                      ),
                      suffixIcon: const Icon(Icons.calendar_month),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: _date.text.isEmpty
                              ? ColorStyles.grey_200
                              : Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      pickedDate = await showDatePicker(
                        context: context,
                        initialDate: now,
                        // currentDate: now.subtract(Duration(days: 1)),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                        helpText: 'edit_profile.birthday'.tr(),
                        cancelText: 'edit_profile.birthday_cancel'
                            .tr(), //สำหรับปุ่มยกเลิก
                        confirmText: 'edit_profile.birthday_confirm'
                            .tr(), //สำหรับปุ่มยืนยัน
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
                        _date.text = context
                            .read<ProviderModel>()
                            .showDateMonthYearABB(pickedDate!);
                      } else {}
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'edit_profile.gender'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                RadioTheme(
                  data: RadioThemeData(
                    fillColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
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
                            log('$_character');
                            _gender = 'ชาย';
                          });
                        },
                      ),
                      Text(
                        'edit_profile.male'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                RadioTheme(
                  data: RadioThemeData(
                    fillColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
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
                            log('$_character');
                            _gender = 'หญิง';
                          });
                        },
                      ),
                      Text(
                        'edit_profile.female'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buttonSave(),
          ],
        ),
      ),
    );
  }

  FirebaseFirestore firebase = FirebaseFirestore.instance;
  Future<void> editAccount(
    String Number,
    String th_firstname,
    String th_lsatname,
    String en_firstname,
    String en_lsatname,
    String nickname,
    DateTime birthday,
    String gender,
    String image,
  ) async {
    firebase
        .collection("User")
        .doc(Number)
        .collection("information")
        .doc("Account")
        .update({
      'th_Firstname': th_firstname,
      'th_Lastname': th_lsatname,
      'en_Firstname': en_firstname,
      'en_Lastname': en_lsatname,
      'nickname': nickname,
      'birthday': birthday,
      'gender': gender,
      'image_Profile': image
    }).then((value) {
      log("Account update");
    }).catchError((error) {
      log('Failed to update user: $error');
    });
  }

  Widget _buttonSave() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return GestureDetector(
          onTap: () async {
            if (file != null) {
              await uploadFile();
            }
            if (_th_Firstname.text.isNotEmpty && _th_Lastname.text.isNotEmpty) {
              editAccount(
                context.read<ProviderModel>().dataAccount['phone'],
                _th_Firstname.text,
                _th_Lastname.text,
                _en_Firstname.text,
                _en_Lastname.text,
                _nickname.text,
                pickedDate ??
                    context.read<ProviderModel>().showTimestamp(
                        context.read<ProviderModel>().dataAccount['birthday']),
                _gender,
                file != null
                    ? urlPicture
                    : context
                        .read<ProviderModel>()
                        .dataAccount['image_Profile'],
              );
              context
                  .read<ProviderModel>()
                  .loadDataAccount(context.read<ProviderModel>().phoneNumber);
              log('ShowProfilePage() <=pushReplacement EditProfilePage()()');
              Navigator.of(context).pop();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: ColorStyles.purple_500,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [BoxShadowStyles.largeBoxButtom],
            ),
            child: Center(
              child: Text(
                'edit_profile.record'.tr(),
                style: const TextStyle(
                  color: ColorStyles.purple_800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
