// ignore_for_file: file_names, camel_case_types

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:uu_alpha/page/History/checkStatus_Page..dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String? selectedStatus = 'สถานะทั้งหมด';
  String? selectedService = 'บริการทั้งหมด';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'history_page.appbar_title'.tr(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: ColorStyles.backgroundColor,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Row(
              children: [
                Expanded(flex: 2, child: _filterStatus()),
                const SizedBox(width: 8),
                Expanded(flex: 2, child: _filterService()),
                const Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  _showResultFilter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardStyles(int index) {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: const [BoxShadowStyles.largeBoxButtom],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: value.getStatusColor200(
                      value.dataListReservation[index]['statusReserve']),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'card.reservation_no'.tr()} ${value.dataListReservation[index]['idReserve']}',
                      style: TextStyles.textB_11,
                    ),
                    Text(
                      context.read<ProviderModel>().getStatusCardText(
                          value.dataListReservation[index]['statusReserve']),
                      style: TextStyles.textB_11,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "${value.dataListReservation[index]['docImage']}"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            value.dataListReservation[index]['prefixDoc'] +
                                value.dataListReservation[index]['docReserve'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  value.showDateMonthYear(value.showTimestamp(
                                      value.dataListReservation[index]
                                          ['datetimeReserve'])),
                                  style: TextStyles.textB_18,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.schedule),
                              const SizedBox(width: 8),
                              Text(
                                '${value.showTime(value.showTimestamp(value.dataListReservation[index]['datetimeReserve']))} น.',
                                style: TextStyles.textB_18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Center(
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "${value.dataListReservation[index]['patientImage']}"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value.dataListReservation[index]
                                        ['patientReserve'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    value.dataListReservation[index]
                                        ['phoneReserve'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterStatus() {
    final List<String> status = [
      'สถานะทั้งหมด',
      'อนุมัติ',
      'ยืนยันเข้าคลินิก',
      'รอตรวจสอบ',
      'ยกเลิก',
      'รอชำระเงิน',
      'สำเร็จ',
      'นัดหมายหมอ',
    ];
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Text(
          'สถานะทั้งหมด',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        items: status
            .map((String status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    context.read<ProviderModel>().getStatusCardText(status),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedStatus,
        onChanged: (String? value) {
          setState(() {
            selectedStatus = value;
            log('$selectedStatus');
          });
        },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: ColorStyles.grey_200,
            ),
            color: ColorStyles.backgroundColor,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Symbols.arrow_drop_down,
            size: 24,
            weight: 800,
          ),
          openMenuIcon: Icon(
            Symbols.arrow_drop_up,
            size: 24,
            weight: 800,
          ),
          iconSize: 14,
          iconEnabledColor: ColorStyles.purple_500,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: ColorStyles.backgroundColor,
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40,
          padding: const EdgeInsets.only(left: 14, right: 14),
          selectedMenuItemBuilder: (BuildContext context, Widget child) {
            return Container(
              color: ColorStyles.purple_200,
              child: child,
            );
          },
        ),
      ),
    );
  }

  Widget _filterService() {
    final List<String> service = [
      'บริการทั้งหมด',
      'ตรวจฟัน',
      'ขูดหินปูน',
      'ถอนฟัน',
      'รากฟัน',
      'อุดฟัน',
      'ผ่าฟันคุด',
      'ครอบฟัน',
      'จัดฟัน',
      'หลุมร่องฟัน',
      'รีเทนเนอร์',
      'ฟอกสีฟัน',
      'X-ray ฟัน',
    ];
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Text(
          'สถานะทั้งหมด',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        items: service
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    context.read<ProviderModel>().getServiceText(item),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedService,
        onChanged: (String? value) {
          setState(() {
            selectedService = value;
            log('$selectedService');
          });
        },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: ColorStyles.grey_200,
            ),
            color: ColorStyles.backgroundColor,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Symbols.arrow_drop_down,
            size: 24,
            weight: 800,
          ),
          openMenuIcon: Icon(
            Symbols.arrow_drop_up,
            size: 24,
            weight: 800,
          ),
          iconSize: 14,
          iconEnabledColor: ColorStyles.purple_500,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: ColorStyles.backgroundColor,
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40,
          padding: const EdgeInsets.only(left: 14, right: 14),
          selectedMenuItemBuilder: (BuildContext context, Widget child) {
            return Container(
              color: ColorStyles.purple_200,
              child: child,
            );
          },
        ),
      ),
    );
  }

  Widget _showResultFilter() {
    return Consumer<ProviderModel>(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        if (value.dataListReservation.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.dataListReservation.length,
            itemBuilder: (BuildContext context, int index) {
              if ((selectedStatus == 'สถานะทั้งหมด' &&
                      selectedService == 'บริการทั้งหมด') ||
                  (value.dataListReservation[index]['selectservices'] ==
                          selectedService &&
                      value.dataListReservation[index]['statusReserve'] ==
                          selectedStatus) ||
                  (value.dataListReservation[index]['selectservices'] ==
                          selectedService &&
                      selectedStatus == 'สถานะทั้งหมด') ||
                  (value.dataListReservation[index]['statusReserve'] ==
                          selectedStatus &&
                      selectedService == 'บริการทั้งหมด')) {
                return GestureDetector(
                  onTap: () {
                    context.read<ProviderModel>().stringNumber =
                        value.dataListReservation[index]['idReserve'];
                    context.read<ProviderModel>().findResult();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckStatus(),
                      ),
                    );
                  },
                  child: cardStyles(index),
                );
              } else {
                return const SizedBox();
              }
            },
          );
        } else {
          return Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: const [BoxShadowStyles.largeBoxButtom],
            ),
            child: Center(
              child: Text(
                'booking_calendar.notFound'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
