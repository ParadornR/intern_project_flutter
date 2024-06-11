// ignore_for_file: file_names

import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uu_alpha/page/Booking/booking_Result.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';

final today = DateUtils.dateOnly(DateTime.now());

class BookingCalendarPage extends StatefulWidget {
  final String nameDocSelect;
  const BookingCalendarPage({
    Key? key,
    required this.nameDocSelect,
  }) : super(key: key);

  @override
  State<BookingCalendarPage> createState() => _BookingCalendarPageState();
}

class _BookingCalendarPageState extends State<BookingCalendarPage> {
  int selectedButtonZonetime = -1;
  int selectedButtonService = -1;
  late String selectedService;

  int slotTime = 14;
  List<Map> zonetime = [
    {'timeZone': '9:00', 'status': false},
    {'timeZone': '9:30', 'status': true},
    {'timeZone': '10:00', 'status': true},
    {'timeZone': '10:30', 'status': false},
    {'timeZone': '11:00', 'status': true},
    {'timeZone': '11:30', 'status': false},
    {'timeZone': '12:00', 'status': false},
    {'timeZone': '12:30', 'status': false},
    {'timeZone': '13:00', 'status': true},
    {'timeZone': '13:30', 'status': true},
    {'timeZone': '14:00', 'status': false},
    {'timeZone': '14:30', 'status': true},
    {'timeZone': '15:00', 'status': true},
    {'timeZone': '15:30', 'status': false},
    {'timeZone': '16:00', 'status': true},
    {'timeZone': '16:30', 'status': false},
    {'timeZone': '17:00', 'status': true},
    {'timeZone': '17:30', 'status': true},
    {'timeZone': '18:00', 'status': true},
    {'timeZone': '18:30', 'status': true},
    {'timeZone': '19:00', 'status': true},
    {'timeZone': '19:30', 'status': false},
  ];
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];

  late int indexdoc;
  late int i;

  bool isSelectable(DateTime day) {
    // ตรวจสอบว่าวันที่ในรายการ dayOff ว่าวันไหนบ้างที่ไม่สามารถกดได้
    return !context.read<ProviderModel>().dayOff.contains(day);
  }

  DateTime timeBackPressed = DateTime.now();
  @override
  void initState() {
    super.initState();
    log(widget.nameDocSelect);
    indexdoc = context
        .read<ProviderModel>()
        .dataListDoctor
        .indexWhere((element) => element['docID'] == widget.nameDocSelect);
    log('indexdoc: $indexdoc');
  }

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: ColorStyles.purple_500,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      currentDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 31)),
      // weekdayLabels: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
      weekdayLabelTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
      lastMonthIcon: const Icon(Icons.navigate_before, color: Colors.black),
      nextMonthIcon: const Icon(Icons.navigate_next, color: Colors.black),
      firstDayOfWeek: 0,
      controlsHeight: 50,
      selectedDayTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      controlsTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      dayTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      disabledDayTextStyle: const TextStyle(
        color: ColorStyles.grey_500,
        fontSize: 16,
      ),
      selectableDayPredicate: isSelectable,
    );
    return Scaffold(
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
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  'booking_calendar.appbar_title'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              _showInfomationDocdor(),
              // _familySelection(),
              _serviceSelection(),
              _dateCalenderSeletion(config),
              _timeSeletion(),
              _confirmSeletion(config),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showInfomationDocdor() {
    return Consumer<ProviderModel>(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Row(
          children: [
            Container(
              width: 62,
              height: 57.81,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(
                      "${value.dataListDoctor[indexdoc]['imageDoc']}"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              value.dataListDoctor[indexdoc]['prefixDoc'] +
                  value.dataListDoctor[indexdoc]['nameDoc'] +
                  ' (${value.dataListDoctor[indexdoc]['nickName']})',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            )
          ],
        );
      },
    );
  }

  // Widget _familySelection() {
  //   return Consumer(
  //     builder: (BuildContext context, ProviderModel value, Widget? child) {
  //       return context.read<ProviderModel>().haveFam
  //           ? Column(
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(vertical: 10),
  //                   alignment: Alignment.centerLeft,
  //                   child: const Text(
  //                     'กรุณาเลือกคนไข้',
  //                     style: TextStyle(
  //   fontSize: 16,
  //   color: Colors.black,
  // ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 90,
  //                   child: ListView.builder(
  //                     scrollDirection: Axis.horizontal,
  //                     physics:
  //                         const PageScrollPhysics(), // สำหรับการสลับระหว่างรายการแต่ละรายการ
  //                     itemCount: context
  //                         .read<ProviderModel>()
  //                         .familyData
  //                         .length, // จำนวนรายการ
  //                     itemBuilder: (BuildContext context, int index) {
  //                       return GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             value.selectFamPatient = index;
  //                           });
  //                         },
  //                         child: Container(
  //                           margin: const EdgeInsets.symmetric(horizontal: 4),
  //                           padding: const EdgeInsets.all(8.0),
  //                           decoration: BoxDecoration(
  //                             border: Border.all(
  //                               width: 1,
  //                               color: value.selectFamPatient == index
  //                                   ? ColorStyles.purple_500
  //                                   : Colors.transparent,
  //                             ),
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Container(
  //                                 width: 48,
  //                                 height: 48,
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(50),
  //                                   color: ColorStyles.grey_500,
  //                                 ),
  //                                 child: const Center(
  //                                   child: Text(
  //                                     'image',
  //                                     style: TextStyle(
  //   fontSize: 14,
  //   color: Colors.black,
  // ),,
  //                                   ),
  //                                 ),
  //                               ),
  //                               Text(
  //                                 '${context.read<ProviderModel>().familyData[index]['th_FirstNamePatient']}',
  //                                 style: const TextStyle(
  //   fontSize: 12,
  //   color: Colors.black,
  // ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 )
  //               ],
  //             )
  //           : const SizedBox();
  //     },
  //   );
  // }

  Widget _serviceSelection() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'booking_calendar.select_service'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 16.0,
                runSpacing: 8.0,
                children: List.generate(
                  value.dataListDoctor[indexdoc]['skillsDoc'].length,
                  (indexSkill) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedButtonService = indexSkill;
                        selectedService = value.dataListDoctor[indexdoc]
                            ['skillsDoc'][indexSkill];
                      });
                      log('selectedService $selectedService');
                      log('indexSkill $indexSkill');
                      log('selectedButtonService $selectedButtonService');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selectedButtonService == indexSkill
                            ? ColorStyles.purple_500
                            : Colors.white,
                        border: Border.all(color: ColorStyles.purple_500),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [BoxShadowStyles.smallBoxButtom],
                      ),
                      child: Text(
                        value.getServiceText(value.dataListDoctor[indexdoc]
                            ['skillsDoc'][indexSkill]),
                        textAlign: TextAlign.center,
                        style: selectedButtonService == indexSkill
                            ? const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              )
                            : const TextStyle(
                                color: ColorStyles.purple_500,
                                fontSize: 14,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _dateCalenderSeletion(CalendarDatePicker2Config config) {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    'booking_calendar.select_date'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: const Color(0xFFFFFFFF),
              ),
              child: CalendarDatePicker2(
                  config: config,
                  value: _singleDatePickerValueWithDefaultValue,
                  onValueChanged: (dates) {
                    setState(() {
                      _singleDatePickerValueWithDefaultValue = dates;
                      log('$_singleDatePickerValueWithDefaultValue');
                      selectedButtonZonetime = -1;
                    });
                  }),
            ),
          ],
        );
      },
    );
  }

  Widget timeBox(
    String timeZone,
    int index,
    bool colorStatus,
  ) {
    return GestureDetector(
      onTap: () {
        if (colorStatus) {
          selectedButtonZonetime = index;
          log('timeZone: $timeZone , index:$index ,selectedButtonZonetime: $selectedButtonZonetime');
          setState(() {});
        }
      },
      child: Container(
        width: 80,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: !colorStatus
                ? ColorStyles.grey_100
                : selectedButtonZonetime == index
                    ? ColorStyles.purple_500
                    : ColorStyles.purple_500,
            width: 2.0,
          ),
          color: !colorStatus
              ? Colors.transparent
              : selectedButtonZonetime == index
                  ? ColorStyles.purple_500
                  : Colors.white,
          boxShadow: !colorStatus
              ? [const BoxShadow(color: Colors.transparent)]
              : [BoxShadowStyles.smallBoxButtom],
        ),
        child: Center(
          child: Text(
            timeZone,
            style: !colorStatus
                ? const TextStyle(
                    color: ColorStyles.grey_100,
                    fontSize: 16,
                  )
                : selectedButtonZonetime == index
                    ? const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      )
                    : const TextStyle(
                        color: ColorStyles.purple_500,
                        fontSize: 16,
                      ),
          ),
        ),
      ),
    );
  }

  Widget _timeSeletion() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'booking_calendar.select_time'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                isWeekend(_singleDatePickerValueWithDefaultValue[0]!)
                    ? zonetime.length
                    : zonetime.length - slotTime,
                (index) => isWeekend(_singleDatePickerValueWithDefaultValue[0]!)
                    ? timeBox(
                        zonetime[index]['timeZone'],
                        index,
                        zonetime[index]['status'],
                      )
                    : timeBox(
                        zonetime[index + slotTime]['timeZone'],
                        index + slotTime,
                        zonetime[index + slotTime]['status'],
                      ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                      radius: 8, backgroundColor: ColorStyles.purple_500),
                  const SizedBox(width: 8),
                  Text(
                    'booking_calendar.free_time'.tr(),
                    style: TextStyles.textB_11,
                  ),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                      radius: 8, backgroundColor: ColorStyles.grey_500),
                  const SizedBox(width: 8),
                  Text(
                    'booking_calendar.busy_time'.tr(),
                    style: TextStyles.textB_11,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  FirebaseFirestore firebase = FirebaseFirestore.instance;
  Future<void> createReserve(
    String phoneNumber,
    String id,
    DateTime date,
    String prefix,
    String doctor,
    String imageDoc,
    String service,
    String patient,
    String imagepatient,
  ) async {
    firebase
        .collection("User")
        .doc(phoneNumber)
        .collection("information")
        .doc("Account")
        .collection("Reservation")
        .add({
      'idReserve': id,
      'datetimeReserve': date,
      // datetimeOldReserve
      'prefixDoc': prefix,
      'docReserve': doctor,
      'docImage': imageDoc,
      'selectservices': service,
      'patientReserve': patient,
      'patientImage': imagepatient,
      'phoneReserve': phoneNumber,
      'statusReserve': 'รอชำระเงิน',
    }).then((_) {
      log("collection created");
    }).catchError((_) {
      log("an error occured");
    });
  }

  Widget _confirmSeletion(CalendarDatePicker2Config config) {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: GestureDetector(
            onTap: () {
              if (selectedButtonZonetime != -1 && selectedButtonService != -1) {
                //ข้อมูลวันที่ รูปแบบข้อความ
                String pointSelected = '${_getValueText(
                  config.calendarType,
                  _singleDatePickerValueWithDefaultValue,
                )} ${zonetime[selectedButtonZonetime]['timeZone']}';

                log('pointSelected: $pointSelected');
                // แปลง String เป็น DateTime
                // ใช้ DateFormat เพื่อกำหนดรูปแบบของ String ที่ต้องการแปลง
                DateFormat inputFormat = DateFormat('dd-MM-yyyy HH:mm');
                DateTime dateTime = inputFormat.parse(pointSelected);
                log('dateTime: $dateTime');

                firebase
                    .collection("User")
                    .doc(value.phoneNumber)
                    .collection("information")
                    .doc("Account")
                    .collection("Reservation")
                    .orderBy("idReserve", descending: true)
                    .limit(1)
                    .get()
                    .then((QuerySnapshot querySnapshot) async {
                  if (querySnapshot.docs.isNotEmpty) {
                    // หาชุดข้อมูลสุดท้าย
                    Map<String, dynamic> latestDocumentData =
                        querySnapshot.docs.first.data() as Map<String, dynamic>;
                    log("[latestDocumentData['idReserve']]: ${latestDocumentData['idReserve']}");
                    // ดึงข่อมูล id ชุดข้อมูลสุดท้าย มาใส่ใน stringNumber
                    context.read<ProviderModel>().stringNumber =
                        latestDocumentData['idReserve'];
                    // เพิ่มค่า stringNumber ขึ้น 1
                    context.read<ProviderModel>().incrementNumber(
                        context.read<ProviderModel>().stringNumber);
                    // บันทึกการจอง
                    createReserve(
                      value.phoneNumber,
                      value.stringNumber,
                      dateTime,
                      value.dataListDoctor[indexdoc]['prefixDoc'],
                      value.dataListDoctor[indexdoc]['nameDoc'],
                      value.dataListDoctor[indexdoc]['imageDoc'],
                      selectedService,
                      (value.selectFamPatient == 0)
                          ? "${value.dataAccount['th_Firstname']} ${value.dataAccount['th_Lastname']}"
                          : "${value.dataListFamily[value.selectFamPatient - 1]['th_Firstname']} ${value.dataListFamily[value.selectFamPatient - 1]['th_Lastname']}",
                      (value.selectFamPatient == 0)
                          ? "${value.dataAccount['image_Profile']}"
                          : "${value.dataListFamily[value.selectFamPatient - 1]['image_Profile']}",
                    );
                    // อัปเดตข้อมูล
                    value.loadDataListReservation(value.phoneNumber);

                    // jump
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingResult(),
                      ),
                    );
                  } else {
                    log("[firebase][dataListReservation]: No documents found");
                    context.read<ProviderModel>().incrementNumber(
                        context.read<ProviderModel>().stringNumber);
                    createReserve(
                      value.phoneNumber,
                      value.stringNumber,
                      dateTime,
                      value.dataListDoctor[indexdoc]['prefixDoc'],
                      value.dataListDoctor[indexdoc]['nameDoc'],
                      value.dataListDoctor[indexdoc]['imageDoc'],
                      selectedService,
                      (value.selectFamPatient == 0)
                          ? "${value.dataAccount['th_Firstname']} ${value.dataAccount['th_Lastname']}"
                          : "${value.dataListFamily[value.selectFamPatient - 1]['th_Firstname']} ${value.dataListFamily[value.selectFamPatient - 1]['th_Lastname']}",
                      (value.selectFamPatient == 0)
                          ? "${value.dataAccount['image_Profile']}"
                          : "${value.dataListFamily[value.selectFamPatient - 1]['image_Profile']}",
                    );
                    // อัปเดตข้อมูล
                    value.loadDataListReservation(value.phoneNumber);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingResult(),
                      ),
                    );
                  }
                }).catchError((error) {
                  log("An error occurred: $error");
                });
              } else {
                Fluttertoast.showToast(
                  msg: "toast.alert_booking".tr(),
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color.fromARGB(158, 158, 158, 158),
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                log('selectedButtonZonetime = -1 \nselectedButtonService = -1');
              }
              // log('IdReserve: $formattedNumber');
              // log('DateReserve: ${DateFormat('d MMMM yyyy', 'th_TH').format(dateTime)} ');
              // log('TimeReserve: ${zonetime[selectedButtonZonetime]['timeZone']}');
              // log('DocReserve: ${value.docData[1]['nameDoc']}');
              // log('PatientReserve: ${value.ProfileData['th_NamePatient']}');
              // log('PhoneReserve: ${value.ProfileData['phonePatient']}');
              // log('StatusReserve: รอชำระเงิน');
              // log('TokenReserve: 2');
              // log('${value.dataReserve.length}');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: ColorStyles.purple_500,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadowStyles.largeBoxButtom],
              ),
              child: Center(
                child: Text(
                  'booking_calendar.bt_Confirm'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool isWeekend(DateTime dateTime) {
    return dateTime.weekday == DateTime.saturday ||
        dateTime.weekday == DateTime.sunday;
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueDateTime = values.isNotEmpty ? values[0] : null;

    if (valueDateTime != null) {
      // แปลง DateTime เป็น String ในรูปแบบ "dd-MM-yyyy"
      var formattedDate = DateFormat('dd-MM-yyyy').format(valueDateTime);
      // log(formattedDate);
      return formattedDate;
    } else {
      return ''; // หรือค่าเริ่มต้นที่คุณต้องการสำหรับกรณีที่ values ว่างเปล่า
    }
  }
}
