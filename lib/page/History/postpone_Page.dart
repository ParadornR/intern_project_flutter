// ignore_for_file: file_names

import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:uu_alpha/page/Booking/booking_Result.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';

// final today = DateUtils.dateOnly(DateTime.now());

class PostponePage extends StatefulWidget {
  const PostponePage({
    Key? key,
  }) : super(key: key);

  @override
  State<PostponePage> createState() => _PostponePageState();
}

class _PostponePageState extends State<PostponePage> {
  int selectedButtonZonetime = -1;
  int selectedButtonService = -1;
  late String selectedService;
  bool normalDay = false;
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    fontFamily: 'Kanit',
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

  late int indexDataReserve;
  late int indexDocData;

  DateTime timeBackPressed = DateTime.now();
  @override
  void initState() {
    super.initState();
    log(
      "${context.read<ProviderModel>().idReserveReservation}",
    );
    indexDocData = context.read<ProviderModel>().dataListDoctor.indexWhere(
        (element) =>
            element['nameDoc'] ==
            context.read<ProviderModel>().idReserveReservation!['docReserve']);
    log('indexdoc: $indexDocData');
    // indexDataReserve = context
    //     .read<ProviderModel>()
    //     .dataReserve
    //     .indexWhere((element) => element['idReserve'] == widget.idReserve);
    // log('indexDataReserve: $indexDataReserve');

    // indexDocData = context.read<ProviderModel>().docData.indexWhere((element) =>
    //     element['nameDoc'] ==
    //     context.read<ProviderModel>().dataReserve[indexDataReserve]
    //         ['docReserve']);
    // log('indexDocData: $indexDocData');
  }

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2Config(
      selectedDayHighlightColor: ColorStyles.purple_500,

      firstDate: DateTime.now().add(const Duration(days: 1)),
      currentDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 31)),

      weekdayLabels: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
      weekdayLabelTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      lastMonthIcon: const Icon(Icons.navigate_before, color: Colors.black),
      nextMonthIcon: const Icon(Icons.navigate_next, color: Colors.black),

      firstDayOfWeek: 0,
      controlsHeight: 50,

      selectedDayTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
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

      // selectableDayPredicate: (day) {
      //   // // ไม่ให้เลือกวันปัจจุบัน
      //   // if (DateUtils.isSameDay(day, today)) {
      //   //   return false;
      //   // }
      //   // // ไม่ให้เลือกวันที่ กำหนด
      //   // if (day.day == 31) {
      //   //   return false;
      //   // }
      //   // return true;
      // },
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
                  'postpone_calendar.appbar_title'.tr(),
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
                      "${value.dataListDoctor[indexDocData]['imageDoc']}"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              value.dataListDoctor[indexDocData]['prefixDoc'] +
                  value.dataListDoctor[indexDocData]['nameDoc'] +
                  '(${value.dataListDoctor[indexDocData]['nickName']})',
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
                    'postpone_calendar.select_date'.tr(),
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
                    'postpone_calendar.select_time'.tr(),
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
                    'postpone_calendar.free_time'.tr(),
                    style: TextStyles.textB_11,
                  ),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                      radius: 8, backgroundColor: ColorStyles.grey_500),
                  const SizedBox(width: 8),
                  Text(
                    'postpone_calendar.busy_time'.tr(),
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

  Widget _confirmSeletion(CalendarDatePicker2Config config) {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: GestureDetector(
            onTap: () {
              if (selectedButtonZonetime != -1) {
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return showPostponeDialog(dateTime);
                  },
                );
              } else {
                log('selectedButtonZonetime = -1');
              }
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
                  'postpone_calendar.bt_postpone'.tr(),
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

  // เลื่อนการจอง
  FirebaseFirestore firebase = FirebaseFirestore.instance;
  // มีtoken
  void updateDatetimeReservation(
    String Number,
    String idReserve,
    DateTime newDateTime,
    DateTime oldDateTime,
    int token,
  ) {
    token -= 1;
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
                'datetimeReserve': newDateTime,
                'oldDatetimeReserve': oldDateTime,
                'tokenReserve': token,
              }, SetOptions(merge: true))
              .then((value) => log("Data update DateTime successfully"))
              .catchError((error) => log("Failed to add data: $error"));
        }
      } else {
        log("No documents found ");
      }
    }).catchError((error) {
      log("An error occurred: $error");
    });
  }

  // ไม่มี token
  void updateDatetimeReservationNotoken(
    String Number,
    String idReserve,
    DateTime newDateTime,
    DateTime oldDateTime,
  ) {
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
                'statusReserve': 'รอชำระเงิน',
                'datetimeReserve': newDateTime,
                'oldDatetimeReserve': oldDateTime,
              }, SetOptions(merge: true))
              .then((value) => log("Data update DateTime successfully"))
              .catchError((error) => log("Failed to add data: $error"));
        }
      } else {
        log("No documents found ");
      }
    }).catchError((error) {
      log("An error occurred: $error");
    });
  }

  Widget showPostponeDialog(DateTime dateTime) {
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
                  Symbols.event_upcoming,
                  size: 48,
                  weight: 800,
                  color: ColorStyles.purple_500,
                ),
                const SizedBox(height: 8),
                const Text(
                  'เลื่อนนัดหมาย',
                  style: TextStyle(
                    color: ColorStyles.purple_500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value.showDateMonthYear(value.showTimestamp(
                      value.idReserveReservation!['datetimeReserve'])),
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
                      value.showTime(value.showTimestamp(
                          value.idReserveReservation!['datetimeReserve'])),
                      style: const TextStyle(
                        color: ColorStyles.grey_500,
                        fontSize: 12,
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
                  value.showDateMonthYear(dateTime),
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
                      value.showTime(dateTime),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'postpone_calendar.alert_postpone.description_1'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${value.idReserveReservation!['tokenReserve']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorStyles.purple_600,
                      ),
                    ),
                    Text(
                      'postpone_calendar.alert_postpone.description_2'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  child: Text(
                    'postpone_calendar.alert_postpone.Warning'.tr(),
                    style: const TextStyle(
                      color: ColorStyles.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  value.idReserveReservation!['tokenReserve'] != 0
                      ? Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              // log(value.phoneNumber);
                              // log(value.stringNumber);
                              // log("$dateTime");
                              // log("${value.idReserveReservation!['datetimeReserve']}");
                              updateDatetimeReservation(
                                value.phoneNumber,
                                value.stringNumber,
                                dateTime,
                                value.showTimestamp(value
                                    .idReserveReservation!['datetimeReserve']),
                                value.idReserveReservation!['tokenReserve'],
                              );
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: ColorStyles.purple_500,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadowStyles.largeBoxButtom
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'postpone_calendar.alert_postpone.postpone'
                                      .tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              updateDatetimeReservationNotoken(
                                value.phoneNumber,
                                value.stringNumber,
                                dateTime,
                                value.showTimestamp(value
                                    .idReserveReservation!['datetimeReserve']),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BookingResult()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: ColorStyles.purple_500,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadowStyles.largeBoxButtom
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'postpone_calendar.alert_postpone.payment'
                                      .tr(),
                                  style: const TextStyle(
                                    color: ColorStyles.purple_800,
                                    fontSize: 14,
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
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Center(
                          child: Text(
                            'postpone_calendar.alert_postpone.return'.tr(),
                            style: const TextStyle(
                              color: ColorStyles.grey_500,
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
