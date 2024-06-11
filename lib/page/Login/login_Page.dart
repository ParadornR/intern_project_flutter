// ignore_for_file: unnecessary_null_comparison, prefer_is_empty, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, non_constant_identifier_names, unused_import, avoid_unnecessary_containers, file_names

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uu_alpha/page/Login/otp_Page..dart';
import 'package:uu_alpha/styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  String errorMessage = '';
  var _isLoading = false;

  Future Otp(String phoneNum) async {
    phoneNum = '+66 $phoneNum';
    log('phoneNum: $phoneNum');
    await FirebaseAuth.instance.verifyPhoneNumber(
      // phoneNumber: '+66 88 888 8888',
      // phoneNumber: '+66 97 356 2285',
      phoneNumber: phoneNum,
      verificationCompleted: (PhoneAuthCredential credential) {
        log('[verificationCompleted]: $credential');
      },
      verificationFailed: (FirebaseAuthException e) {
        log('[verificationFailed]: $e');
        setState(() {
          _isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        log('[codeSent] : $verificationId , $resendToken');
        setState(() {
          _isLoading = false;
          errorMessage = '';
        });
        log('LoginPage() pushReplacement=> OtpRequest()');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpRequest(
              phoneNumberController: phoneController.text,
              verificationCode: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('[codeAutoRetrievalTimeout] : $verificationId');
        setState(() {
          _isLoading = false;
          errorMessage = 'ลองอีกครั้ง';
        });
      },
    );
  }

  bool isBackPressed = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ทำสิ่งที่คุณต้องการเมื่อกดปุ่ม back ที่นี่
        // ตัวอย่างเช่น:
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
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                top: 54,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 232,
                    height: 110,
                    child: Center(
                      child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/uuprojectalpha.appspot.com/o/asset%2FGroup_2_2.png?alt=media&token=ec194789-2fce-4c4d-a9a0-e5b95de37abd'),
                    ),
                  ),
                  SizedBox(height: 120),
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'log_in.description',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ).tr(),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: phoneController,
                    onChanged: (value) {
                      String? validationMessage = validatePhoneNumber(value);
                      log('validationMessage : $validationMessage');
                      if (validationMessage == 'ถูกต้องครบถ้วน') {
                        setState(() {
                          errorMessage = 'ถูกต้องครบถ้วน';
                        });
                      } else {
                        setState(() {
                          errorMessage = '';
                        });
                      }
                    },
                    style: TextStyle(
                      color: errorMessage == 'ไม่ถูกต้องครบถ้วน'
                          ? Colors.red
                          : errorMessage == 'ถูกต้องครบถ้วน'
                              ? Colors.purple
                              : Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      MaskedTextInputFormatter(
                        mask: 'xxx-xxx-xxxx',
                        separator: '-',
                      ),
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '08x-xxx-xxxx',
                      hintStyle: TextStyle(
                        color: ColorStyles.grey_500,
                        fontSize: 16,
                      ),
                      contentPadding: EdgeInsets.only(
                          left: 16, top: 18, right: 0, bottom: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: errorMessage == 'ไม่ถูกต้องครบถ้วน'
                              ? Colors.red
                              : errorMessage == 'ถูกต้องครบถ้วน'
                                  ? Colors.purple
                                  : Colors.black,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: errorMessage == 'ไม่ถูกต้องครบถ้วน'
                              ? Colors.red
                              : errorMessage == 'ถูกต้องครบถ้วน'
                                  ? Colors.purple
                                  : Colors.black,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: errorMessage == 'ไม่ถูกต้องครบถ้วน'
                              ? Colors.red
                              : errorMessage == 'ถูกต้องครบถ้วน'
                                  ? Colors.purple
                                  : Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      // กำหนด helperText เป็นค่าว่าง
                      helperText: '',
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      String phoneNumber = phoneController.text;
                      String? validationMessage =
                          validatePhoneNumber(phoneNumber);
                      log('validationMessage : $validationMessage');
                      // if (validationMessage == null) {
                      //   setState(() {
                      //     _isLoading = true;
                      //     errorMessage = 'ถูกต้องครบถ้วน';
                      //   });
                      //   String modifiedNumber = phoneNumber.replaceFirst('0', '');
                      //   log(modifiedNumber);
                      //   print('Go to => OtpRequest');
                      //   await Otp(modifiedNumber);
                      // } else {
                      //   setState(() {
                      //     errorMessage = validationMessage;
                      //   });
                      // }
                      if (validationMessage == 'ถูกต้องครบถ้วน') {
                        setState(() {
                          _isLoading = true;
                          errorMessage = 'ถูกต้องครบถ้วน';
                        });
                        String modifiedNumber =
                            phoneNumber.replaceFirst('0', '');
                        modifiedNumber = modifiedNumber.replaceAll('-', ' ');

                        log(modifiedNumber);
                        print('Go to => OtpRequest');
                        await Otp(modifiedNumber);
                      } else {
                        setState(() {
                          errorMessage = 'ไม่ถูกต้องครบถ้วน';
                        });
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: ColorStyles.purple_500,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [BoxShadowStyles.largeBoxButtom],
                      ),
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : Container(
                                child: Text(
                                  'log_in.bt_Confirm',
                                  style: TextStyle(
                                    color: ColorStyles.purple_800,
                                    fontSize: 16,
                                  ),
                                ).tr(),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validatePhoneNumber(String? phoneNumber) {
    phoneNumber = phoneNumber?.replaceAll('-', '');
    log('phoneNumber: $phoneNumber');
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'ไม่ถูกต้องครบถ้วน';
    } else if (phoneNumber.length != 10) {
      return 'ไม่ถูกต้องครบถ้วน';
    } else if (phoneNumber[0] != '0') {
      return 'ไม่ถูกต้องครบถ้วน';
    } else {
      return 'ถูกต้องครบถ้วน'; // Validation passed
    }
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // ตรวจสอบว่าค่าใหม่ของข้อความมีเลข 0 ที่ตำแหน่งแรกหรือไม่
    if (newValue.text.isNotEmpty && newValue.text[0] != '0') {
      // ถ้าไม่ใช่เลข 0 ให้กลับไปยังค่าเดิม
      return oldValue;
    }

    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
