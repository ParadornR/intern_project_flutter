// ignore_for_file: must_be_immutable, file_names, prefer_initializing_formals, invalid_use_of_visible_for_testing_member, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:uu_alpha/page/Booking/booking_Result.dart';
import 'package:uu_alpha/page/History/postpone_Page.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';

class CheckStatus extends StatefulWidget {
  const CheckStatus({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckStatus> createState() => _CheckStatusState();
}

class _CheckStatusState extends State<CheckStatus> {
  Map payload = {};
  // เงื่อนไขในการกด ยืนยันเข้าคลินิก true
  bool canConfirm = true;
  // เงื่อนไขในการกด เลื่อนนัดหมาย false
  bool canPostpone = true;

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments;
    if (data is RemoteMessage) {
      payload = data.data;
      log('[payload][RemoteMessage]:$payload');
      context.read<ProviderModel>().stringNumber = payload['id'];
      context.read<ProviderModel>().findResult();
    }
    if (data is NotificationResponse) {
      payload = jsonDecode(data.payload!);
      log('[payload][NotificationResponse]:$payload');
      context.read<ProviderModel>().stringNumber = payload['id'];
      context.read<ProviderModel>().findResult();
    }

    // log('${context.read<ProviderModel>().idReserveReservation['statusReserve']}');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          _backgroundSection(),
          SingleChildScrollView(
            child: Column(
              children: [
                Consumer(
                  builder: (BuildContext context, ProviderModel value,
                      Widget? child) {
                    context.read<ProviderModel>().loadDataListReservation(
                        context.read<ProviderModel>().phoneNumber);
                    context.read<ProviderModel>().findResult();
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      margin:
                          const EdgeInsets.only(top: 150, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadowStyles.largeBoxButtom],
                      ),
                      child: Column(
                        children: [
                          _detailSection(),
                          _buttonConfirmSection(),
                          _buttonPostponeSection(),
                          _buttonCancelSection(),
                          _buttonPaymentSection(),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _backgroundSection() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Consumer(
            builder:
                (BuildContext context, ProviderModel value, Widget? child) {
              return Container(
                color: value.getStatusColor100(
                  value.idReserveReservation!['statusReserve'],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(top: 24),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)),
                        child: Icon(
                          value.getStatusIcon(
                              value.idReserveReservation!['statusReserve']),
                          size: 40,
                          color: value.getStatusColor500(
                              value.idReserveReservation!['statusReserve']),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value.getStatusText(
                          value.idReserveReservation!['statusReserve']),
                      style: TextStyle(
                        color: value.getStatusColor800(
                            value.idReserveReservation!['statusReserve']),
                        fontSize: 18,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ],
                ),
              );
            },
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

  Widget _detailSection() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'in_card.reservation_no'.tr()} ',
                  style: const TextStyle(
                    color: ColorStyles.grey_500,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${value.idReserveReservation!['idReserve']}',
                  style: const TextStyle(
                    color: ColorStyles.grey_500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DottedDashedLine(
              height: 0,
              width: MediaQuery.of(context).size.width,
              axis: Axis.horizontal,
              dashColor: ColorStyles.grey_500,
            ),
            const SizedBox(height: 16),
            value.idReserveReservation!['statusReserve'] != 'ยกเลิก' &&
                    value.idReserveReservation!['oldDatetimeReserve'] != null
                ? Column(
                    children: [
                      Text(
                        value.showDateMonthYear(value.showTimestamp(
                            value.idReserveReservation!['oldDatetimeReserve'])),
                        style: const TextStyle(
                          color: ColorStyles.grey_500,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Symbols.schedule,
                            size: 17.5,
                            weight: 800,
                            color: ColorStyles.grey_500,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            value.showTime(value.showTimestamp(value
                                .idReserveReservation!['oldDatetimeReserve'])),
                            style: const TextStyle(
                              color: ColorStyles.grey_500,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Symbols.south,
                        size: 40,
                        weight: 800,
                        color: Colors.black,
                      ),
                      Text(
                        value.showDateMonthYear(value.showTimestamp(
                            value.idReserveReservation!['datetimeReserve'])),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Symbols.schedule,
                            size: 17.5,
                            weight: 800,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${value.showTime(value.showTimestamp(value.idReserveReservation!['datetimeReserve']))} น.',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        value.showDateMonthYear(value.showTimestamp(
                            value.idReserveReservation!['datetimeReserve'])),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Symbols.schedule,
                            size: 18,
                            weight: 800,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${value.showTime(value.showTimestamp(value.idReserveReservation!['datetimeReserve']))} น.',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                        image: NetworkImage(
                            "${value.idReserveReservation!['docImage']}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${value.idReserveReservation!['prefixDoc'] + value.idReserveReservation!['docReserve']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ColorStyles.purple_200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                            value.idReserveReservation!['selectservices'],
                            style: TextStyles.textB_12),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buttonConfirmSection() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return //  ปุ่ม ยืนยันเข้าคลินิก
            value.idReserveReservation!['statusReserve'] == 'อนุมัติ' ||
                    value.idReserveReservation!['statusReserve'] == 'เลื่อน' ||
                    value.idReserveReservation!['statusReserve'] == 'นัดหมายหมอ'
                ? Column(
                    children: [
                      canConfirm
                          // ปุ่ม อับเดทสถานะเป็น 'ยืนยัน' เข้าคลินิก
                          ? GestureDetector(
                              onTap: () {
                                log('ปุ่ม อับเดทสถานะเป็น ยืนยัน เข้าคลินิก');
                                log('${value.idReserveReservation}');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return showConfirmDialog();
                                  },
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: ColorStyles.purple_500,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: ColorStyles.purple_500, width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    'in_card.bt_confirm'.tr(),
                                    style: const TextStyle(
                                      color: ColorStyles.purple_800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: ColorStyles.purple_200,
                                        width: 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'in_card.bt_confirm'.tr(),
                                      style: const TextStyle(
                                        color: ColorStyles.purple_100,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    'in_card.bt_confirm_description'.tr(),
                                    style: const TextStyle(
                                      color: ColorStyles.grey_500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  )
                : const SizedBox();
      },
    );
  }

  Widget _buttonPostponeSection() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return // ปุ่ม เลื่อนนัดหมาย
            value.idReserveReservation!['statusReserve'] == 'อนุมัติ' ||
                    value.idReserveReservation!['statusReserve'] ==
                        'ยืนยันเข้าคลินิก' ||
                    value.idReserveReservation!['statusReserve'] == 'เลื่อน' ||
                    value.idReserveReservation!['statusReserve'] == 'นัดหมายหมอ'
                ? canPostpone
                    // เข้าสู่การ เลื่อน และอัปเดทข้อมูล
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              log('เข้าสู่การ เลื่อน และอัปเดทข้อมูล');
                              log('${value.idReserveReservation}');
                              log('CheckStatus() pushReplacement=> PostponePage()');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PostponePage(),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: ColorStyles.purple_500, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  'in_card.bt_postpone'.tr(),
                                  style: const TextStyle(
                                    color: ColorStyles.purple_500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          value.idReserveReservation!['statusReserve'] ==
                                  'ยืนยันเข้าคลินิก'
                              ? Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    'in_card.can_postpone_description'.tr(),
                                    style: const TextStyle(
                                      color: ColorStyles.grey_500,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    : value.idReserveReservation!['statusReserve'] ==
                            'ยืนยันเข้าคลินิก'
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'in_card.postpone_description'.tr(),
                              style: const TextStyle(
                                color: ColorStyles.red,
                                fontSize: 22,
                              ),
                            ),
                          )
                        : const SizedBox()
                : const SizedBox();
      },
    );
  }

  Widget _buttonCancelSection() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return // ปุ่ม ยกเลิกนัดหมาย
            value.idReserveReservation!['statusReserve'] == 'อนุมัติ' ||
                    value.idReserveReservation!['statusReserve'] ==
                        'ยืนยันเข้าคลินิก' ||
                    value.idReserveReservation!['statusReserve'] == 'เลื่อน' ||
                    value.idReserveReservation!['statusReserve'] ==
                        'รอตรวจสอบ' ||
                    value.idReserveReservation!['statusReserve'] == 'นัดหมายหมอ'
                ? GestureDetector(
                    onTap: () {
                      log('ปุ่ม ยกเลิกนัดหมาย');
                      log('${value.idReserveReservation}');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return showCancelDialog();
                        },
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border:
                            Border.all(color: ColorStyles.purple_500, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          'in_card.bt_cancel'.tr(),
                          style: const TextStyle(
                            color: ColorStyles.purple_500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox();
      },
    );
  }

  Widget _buttonPaymentSection() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return // ปุ่ม ชำระเงิน
            value.idReserveReservation!['statusReserve'] == 'รอชำระเงิน'
                ? GestureDetector(
                    onTap: () {
                      log('ปุ่ม ชำระเงิน');
                      log('CheckStatus() pushReplacement=> BookingResult()');
                      // ดึงข่อมูล id ชุดข้อมูลสุดท้าย มาใส่ใน stringNumber

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingResult(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: ColorStyles.purple_500,
                        borderRadius: BorderRadius.circular(50),
                        border:
                            Border.all(color: ColorStyles.purple_500, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          'in_card.bt_payment'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox();
      },
    );
  }

  Widget showConfirmDialog() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: AlertDialog(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'in_card.alert_confirm.tile'.tr(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        log('ยันยัน');
                        log('[value.idReserveReservation]${value.idReserveReservation}');
                        // เปลี่ยนสถานะ เป็น ยกเลิก
                        context.read<ProviderModel>().updateStatusReservation(
                            context.read<ProviderModel>().phoneNumber,
                            context
                                .read<ProviderModel>()
                                .idReserveReservation?['idReserve'],
                            "ยืนยันเข้าคลินิก");
                        // อัปเดตข้อมูล
                        context.read<ProviderModel>().loadDataListReservation(
                            context.read<ProviderModel>().phoneNumber);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: ColorStyles.purple_300,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BoxShadowStyles.smallBoxButtom],
                        ),
                        child: Center(
                          child: Text(
                            'in_card.alert_confirm.confirm'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        log('กลับ');
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: ColorStyles.grey_100,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BoxShadowStyles.smallBoxButtom],
                        ),
                        child: Center(
                          child: Text(
                            'in_card.alert_confirm.return'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
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
        );
      },
    );
  }

  Widget showCancelDialog() {
    TextEditingController textCancel = TextEditingController();
    final ValueNotifier<bool> canClickNotifier = ValueNotifier<bool>(false);
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: AlertDialog(
            contentPadding: const EdgeInsets.only(top: 16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Symbols.cancel,
                  size: 48,
                  weight: 800,
                  color: ColorStyles.red,
                ),
                const SizedBox(height: 8),
                Text(
                  'in_card.alert_cancel.tile'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: ColorStyles.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value.showDateMonthYear(value.showTimestamp(
                      value.idReserveReservation!['datetimeReserve'])),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Symbols.schedule,
                      size: 17.5,
                      weight: 800,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      value.showTime(value.showTimestamp(
                          value.idReserveReservation!['datetimeReserve'])),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                Text(
                  value.idReserveReservation!['selectservices'],
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'in_card.alert_cancel.description'.tr(),
                        style: const TextStyle(
                          color: ColorStyles.grey_500,
                          fontSize: 12,
                        ),
                      ),
                      TextFormField(
                        controller: textCancel,
                        onChanged: (text) {
                          if (text.isEmpty) {
                            canClickNotifier.value = false;
                          } else {
                            canClickNotifier.value = true;
                          }
                        },
                        autocorrect: false,
                        enableSuggestions: false,
                        style: const TextStyle(
                          color: ColorStyles.grey_500,
                          fontSize: 12,
                          fontFamily: 'Kanit',
                        ),
                        decoration: InputDecoration(
                          hintText: 'in_card.alert_cancel.hintText'.tr(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                              color: ColorStyles.grey_500,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'in_card.alert_cancel.Warning'.tr(),
                          style: const TextStyle(
                            color: ColorStyles.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            actions: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        if (canClickNotifier.value) {
                          log('ยกเลิกนัดหมาย');
                          log('[value.idReserveReservation]${value.idReserveReservation}');
                          // เปลี่ยนสถานะ เป็น ยกเลิก
                          context.read<ProviderModel>().updateStatusReservation(
                              context.read<ProviderModel>().phoneNumber,
                              context
                                  .read<ProviderModel>()
                                  .idReserveReservation?['idReserve'],
                              "ยกเลิก");
                          // อัปเดตข้อมูล
                          context.read<ProviderModel>().loadDataListReservation(
                              context.read<ProviderModel>().phoneNumber);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: const [BoxShadowStyles.largeBoxButtom],
                          color: canClickNotifier.value
                              ? ColorStyles.purple_500
                              : ColorStyles.grey_100,
                        ),
                        child: Center(
                          child: Text(
                            'in_card.alert_cancel.confirm'.tr(),
                            style: const TextStyle(
                              color: ColorStyles.grey_800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Center(
                          child: Text(
                            'in_card.alert_cancel.return'.tr(),
                            style: const TextStyle(
                              color: ColorStyles.purple_800,
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
        );
      },
    );
  }
}
