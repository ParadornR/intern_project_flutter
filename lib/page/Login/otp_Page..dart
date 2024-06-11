// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, file_names, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uu_alpha/page/Home/home_Control.dart';
import 'package:uu_alpha/page/Login/login_Page.dart';
import 'package:uu_alpha/page/Login/regis_Page..dart';
import 'package:uu_alpha/styles.dart';

class OtpRequest extends StatefulWidget {
  final String? verificationCode;
  final String? phoneNumberController;
  const OtpRequest(
      {super.key,
      required this.phoneNumberController,
      required this.verificationCode});
  @override
  State<OtpRequest> createState() => _OtpRequestState();
}

class _OtpRequestState extends State<OtpRequest> {
  String errorMessage = ''; // Add this line
  TextEditingController otpNumber = TextEditingController();
  String phoneNo = '';
  String verificationCode = '';
  @override
  void initState() {
    super.initState();
    phoneNo = widget.phoneNumberController.toString();
    verificationCode = widget.verificationCode!;
    startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  bool newUser = true;

  bool error = true;
  String textError = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  var _isLoading = false;

  Future<void> verifyOTP(String otp) async {
    log('otp:$otp');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationCode, smsCode: otp);
    try {
      await _auth.signInWithCredential(credential).then(
        (user) {
          error = false;
          textError = '';
          setState(() => _isLoading = false);
          log(phoneNo);
          firebase
              .collection("User")
              .doc(phoneNo)
              .collection('information')
              .get()
              .then((QuerySnapshot querySnapshot) async {
            // ตรวจสอบว่ามีเอกสารหรือไม่
            // เงื่อนไขตรวจบัญชี
            if (querySnapshot.docs.isNotEmpty) {
              // ดึงข้อมูลจากคอลเล็กชัน "information"
              var data = querySnapshot.docs.first.data();
              log("[firebase]: Data from 'information' collection: $data");
              log('OtpRequest() pushReplacement=> homeControl()');

              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool(
                  'isLoggedIn', true); // เก็บข้อมูลการเข้าสู่ระบบ
              await prefs.setString('PhoneNumber', phoneNo);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => homeControl(),
                ),
              );
            } else {
              log("[firebase]: No documents found in 'information' collection");
              log('OtpRequest() pushReplacement=> RegisPage()');
              // Navigator.of(context).popAndPushNamed('/home', arguments: {});
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisPage(
                    phoneNumberController: phoneNo,
                  ),
                ),
              );
            }
          }).catchError((error) {
            log("An error occurred: $error");
          });
        },
      );
    } catch (e) {
      log('$e');
      setState(() {
        try {
          textError = e.toString().replaceAll(RegExp(r'\[.*?\]'), '');
          setState(() {
            _isLoading = false;
            errorMessage = 'รหัสยืนยันจาก SMS/TOTP ไม่ถูกต้อง';
          });
          log('[TextError1]: $textError');
        } catch (e) {
          // setState(() => errorMessage = 'รหัสยืนยันจาก SMS/TOTP ไม่ถูกต้อง');
          textError = "The verification code from SMS/TOTP is invalid";
          log('[TextError2]: $textError');
        }
        error = true;
      });
    }
  }

  int _countdown = 180; // Set the initial countdown time (in seconds) 3 min
  late Timer _timer;
  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        log('_countdown:$_countdown');
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer.cancel(); // Stop the timer when countdown reaches 0
        }
      });
    });
  }

  void resetCountdown() {
    setState(() {
      _countdown = 180; // Reset the countdown time
    });
    startCountdown(); // Restart the countdown
  }

  @override
  Widget build(BuildContext context) {
    log(widget.verificationCode.toString());
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorStyles.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    log('OtpRequest() <=pushReplacement LoginPage()');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: Text(
                    'otp.appbar_title',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ).tr(),
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
          padding: EdgeInsets.symmetric(horizontal: 8),
          margin: EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 8),
          child: Column(
            children: <Widget>[
              detail(),
              inputOTP(),
              // Container(
              //   margin: const EdgeInsetsDirectional.symmetric(
              //     horizontal: 10,
              //     vertical: 5,
              //   ),
              //   child: Text(
              //     errorMessage,
              //     style: TextStyle(
              //       color: errorMessage == 'กรุณารอสักครู่'
              //           ? Colors.grey
              //           : Colors.red,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
              enterOTP(),
              againOTP(),
              // Text(
              //   _countdown > 0
              //       ? 'กรุณาใส่รหัส OTP ในเวลา $_countdown วินาที'
              //       : "หมดเวลายืนยันแล้ว",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: Colors.grey,
              //     fontSize: 16,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detail() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            textAlign: TextAlign.center,
            'otp.description',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ).tr(),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          margin: const EdgeInsetsDirectional.only(
            top: 36,
            bottom: 24,
          ),
          child: Text(
            phoneNo,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget inputOTP() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Pinput(
        controller: otpNumber,
        length: 6,
        defaultPinTheme: PinTheme(
          width: 55,
          height: 55,
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.transparent),
          ),
        ),
        focusedPinTheme: PinTheme(
          width: 55,
          height: 55,
          textStyle: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.transparent),
          ),
        ),
      ),
    );
  }

  Widget enterOTP() {
    return GestureDetector(
      onTap: () {
        // เงื่อนไขหมดเวลา OTP
        if (_countdown > 0) {
          log('กดยืนยัน');
          setState(() => _isLoading = true);
          errorMessage = 'กรุณารอสักครู่';
          log('กำลังยืนยัน OTP');
          verifyOTP(otpNumber.text.toString());
        } else {
          log('หมดเวลายืนยัน ขอรหัส OTP');
        }
      },
      child: Container(
        height: 60,
        margin: EdgeInsetsDirectional.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: ColorStyles.purple_500,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? Container(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : Text(
                    'otp.bt_Confirm',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorStyles.purple_800,
                      fontSize: 16,
                    ),
                  ).tr(),
          ],
        ),
      ),
    );
  }

  Future otp(String phoneNum) async {
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
      },
      codeSent: (String verificationId, int? resendToken) {
        log('[codeSent] : $verificationId , $resendToken');
        verificationCode = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('[codeAutoRetrievalTimeout] : $verificationId');
      },
    );
  }

  Widget againOTP() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () async {
          log('ขอรหัส OTP อีกครั้ง');
          log(phoneNo); //088-888-8888
          String modifiedNumber = phoneNo.replaceFirst('0', '');
          modifiedNumber = modifiedNumber.replaceAll('-', ' ');
          log(modifiedNumber); // 88 888 8888
          resetCountdown();
          //  Fn ขอรหัส OTP อีกครั้ง
          await otp(modifiedNumber);
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        enableFeedback: false,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'otp.bt_Request',
            style: TextStyle(
              color: ColorStyles.grey_500,
              fontSize: 14,
            ),
          ).tr(),
        ),
      ),
    );
  }
}
