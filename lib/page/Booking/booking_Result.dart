// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';

final today = DateUtils.dateOnly(DateTime.now());

class BookingResult extends StatefulWidget {
  const BookingResult({
    Key? key,
  }) : super(key: key);

  @override
  State<BookingResult> createState() => _BookingResultState();
}

class _BookingResultState extends State<BookingResult> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: IconButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),
        backgroundColor: ColorStyles.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Consumer(
          builder: (BuildContext context, ProviderModel value, Widget? childd) {
            context.read<ProviderModel>().findResult();
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [BoxShadowStyles.largeBoxButtom],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      children: [
                        _SummarySection(),
                        _QRCodeSection(),
                      ],
                    ),
                  ),
                  _PaymentSection(),
                  _showDialogResultBooking()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _SummarySection() {
    context.read<ProviderModel>().findResult();
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  'booking_result.appbar_title'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Symbols.calendar_clock,
                  size: 20,
                  weight: 800,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value.showDateMonthYearWDY(value.showTimestamp(
                        value.idReserveReservation!['datetimeReserve'])),
                    style: TextStyles.textB_18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Symbols.calendar_clock,
                  size: 20,
                  weight: 800,
                ),
                const SizedBox(width: 8),
                Text(
                  '${'booking_result.time'.tr()} ${value.showTime(value.showTimestamp(value.idReserveReservation?['datetimeReserve']))}',
                  style: TextStyles.textB_18,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${'booking_result.doctor'.tr()}   ${value.idReserveReservation!['docReserve']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${'booking_result.patient'.tr()}  ${value.idReserveReservation!['patientReserve']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '${'booking_result.reservation'.tr()}  #${value.idReserveReservation!['idReserve']}',
                style: const TextStyle(
                  color: ColorStyles.grey_500,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DottedDashedLine(
              height: 0,
              width: MediaQuery.of(context).size.width,
              axis: Axis.horizontal,
              dashColor: ColorStyles.grey_500,
            ),
          ],
        );
      },
    );
  }

  Widget _QRCodeSection() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/image/QrCode.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'booking_result.company_name'.tr(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'booking_result.total_payment'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 24),
                Text(
                  'booking_result.number_total_payment'.tr(),
                  style: const TextStyle(
                    color: ColorStyles.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'booking_result.scheduled_payment_time'.tr(),
              style: const TextStyle(
                color: ColorStyles.red,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'booking_result.proof_payment'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                noImage
                    ? Text(
                        'booking_result.proof_payment_description'.tr(),
                        style: const TextStyle(
                          color: ColorStyles.red,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.clip,
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late FilePickerResult result;
  late String path;
  dynamic file; // File
  late Reference ref;

  late bool noImage = false;

  Future<void> selectFile() async {
    result = (await FilePicker.platform.pickFiles())!;
    // ignore: unnecessary_null_comparison
    if (result == null) return;

    setState(
      () {
        pickedFile = result.files.first;
        log('====================\n$pickedFile\n====================');
        noImage = false;
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
    // ignore: use_build_context_synchronously
    context.read<ProviderModel>().updateDataReservation(
          // ignore: use_build_context_synchronously
          context.read<ProviderModel>().phoneNumber,
          // ignore: use_build_context_synchronously
          context.read<ProviderModel>().idReserveReservation?['idReserve'],
          urlPicture,
        );
  }

  Widget _PaymentSection() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: DottedBorder(
            padding: const EdgeInsets.all(1),
            dashPattern: const [6, 3],
            borderType: BorderType.RRect, // ให้ใช้ Rounded Rectangle Border
            radius: const Radius.circular(12),
            strokeWidth: 1, // ความหนาของเส้น // ความหนาของเส้น
            child: Container(
              // padding:
              //     const EdgeInsets.symmetric(horizontal: 80, vertical: 108),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorStyles.grey_100,
              ),
              child: file != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: GestureDetector(
                        onTap: () {
                          selectFile();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 108),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF79747E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add_photo_alternate),
                              const SizedBox(width: 10),
                              Text(
                                'booking_result.choose_picture'.tr(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        file != null
            ? Positioned(
                top: -10,
                right: 10,
                child: IconButton(
                  icon: Stack(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      file = null;
                      log('message');
                    });
                  },
                  highlightColor: Colors
                      .transparent, // ตั้งค่าให้ไม่มี highlight color เมื่อกดค้าง
                  splashColor: Colors
                      .transparent, // ตั้งค่าให้ไม่มี splash color เมื่อมีการแตะ
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _showDialogResultBooking() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Column(
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                uploadFile();

                // log('ResultBooking');
                // image != null
                if (file != null) {
                  DateTime now = DateTime.now();
                  var formTime =
                      DateFormat('HH:mm:ss', 'th').format(DateTime.now());
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Your code here
                        },
                        child: Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: AlertDialog(
                            titlePadding: const EdgeInsets.all(0),
                            title: Container(
                              padding: const EdgeInsets.only(top: 16),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Icon(
                                      Icons.check_circle_outline_outlined,
                                      size: 40,
                                      color: ColorStyles.purple_500,
                                    ),
                                  ),
                                  Text(
                                    'booking_result.alert_Confirm'.tr(),
                                    style: const TextStyle(
                                      color: ColorStyles.purple_500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(0),
                            content: Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        value.showDateMonthYear(
                                            value.showTimestamp(
                                                value.idReserveReservation![
                                                    'datetimeReserve'])),
                                        style: const TextStyle(
                                          fontSize: 32,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Symbols.schedule,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            value.showTime(value.showTimestamp(
                                                value.idReserveReservation![
                                                    'datetimeReserve'])),
                                            style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        value.getServiceText(
                                            value.idReserveReservation![
                                                'selectservices']),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: DottedDashedLine(
                                      dashWidth: 5,
                                      dashSpace: 3,
                                      height: 0,
                                      width: MediaQuery.of(context).size.width,
                                      axis: Axis.horizontal,
                                      dashColor: ColorStyles.grey_500,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Symbols.calendar_clock,
                                              size: 16,
                                              color: ColorStyles.grey_500,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              context
                                                  .read<ProviderModel>()
                                                  .showDateMonthYearWDY(now),
                                              style: const TextStyle(
                                                color: ColorStyles.grey_500,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Symbols.schedule,
                                              size: 16,
                                              color: ColorStyles.grey_500,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              formTime,
                                              style: const TextStyle(
                                                color: ColorStyles.grey_500,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actionsPadding: const EdgeInsets.all(0),
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  // value.dataReserve[widget.indexResult]
                                  //     ['statusReserve'] = 'รอตรวจสอบ';
                                  context.read<ProviderModel>().onItemTapped(2);
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 16),
                                  decoration: const BoxDecoration(
                                    color: ColorStyles.purple_500,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                    boxShadow: [BoxShadowStyles.largeBoxButtom],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'booking_result.alert_bt_Confirm'.tr(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  setState(() {
                    noImage = true;
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: ColorStyles.purple_500,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadowStyles.largeBoxButtom],
                ),
                child: Center(
                  child: Text(
                    'booking_result.bt_Confirm'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
