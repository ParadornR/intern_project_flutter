// ignore_for_file: file_names, camel_case_types

import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uu_alpha/page/History/checkStatus_Page..dart';
import 'package:uu_alpha/page/Notification/notification_Page.dart';
import 'package:uu_alpha/provider/providerModel.dart';

import 'package:uu_alpha/styles.dart';

class homePage extends StatefulWidget {
  const homePage({
    Key? key,
  }) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _currentIndex = 0;
  late String service;
  int selectFam = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 108,
              child: Center(
                child: Image.network(
                  fit: BoxFit.cover,
                  'https://firebasestorage.googleapis.com/v0/b/uuprojectalpha.appspot.com/o/asset%2Flogo2.png?alt=media&token=4cdd0a79-b85f-4418-b81d-d5ee579145ee',
                ),
              ),
            ),
            Consumer(
              builder:
                  (BuildContext context, ProviderModel value, Widget? child) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const notification()),
                    );
                  },
                  child: Stack(
                    children: [
                      const Icon(
                        size: 24,
                        Symbols.notifications,
                        weight: 800,
                      ),
                      value.notiData.isEmpty
                          ? const SizedBox()
                          : Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: const BoxDecoration(
                                  color: ColorStyles.purple_500,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    "${value.notiData.length}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        backgroundColor: ColorStyles.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCarouselSlider(),
            _buildServiceGridView(),
            _buildFamilySection(),
            _buildAppointmentList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return value.dataBanner.isNotEmpty
            ? Column(
                children: [
                  Container(
                    height: 150,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    // margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: CarouselSlider.builder(
                      itemCount: value.dataBanner.length,
                      options: CarouselOptions(
                        height: 150,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  '${value.dataBanner[index]['backImage']}'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  AnimatedSmoothIndicator(
                    activeIndex: _currentIndex,
                    count: value.dataBanner.length,
                    effect: const ExpandingDotsEffect(
                      spacing: 8,
                      dotWidth: 8,
                      dotHeight: 8,
                      dotColor: ColorStyles.grey_100,
                      activeDotColor: ColorStyles.purple_500,
                    ),
                  ),
                ],
              )
            : SizedBox();
      },
    );
  }

  Widget _buildServiceGridView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 210,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 8.0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        itemCount: context.read<ProviderModel>().serviceOptions.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.read<ProviderModel>().selectedfilterIndex = index;
              log('${context.read<ProviderModel>().serviceOptions[index]['name_service']}');
              context.read<ProviderModel>().textFiler.text = context
                  .read<ProviderModel>()
                  .serviceOptions[index]['name_service'];
              log('homePage() => BookingPage()');
              context.read<ProviderModel>().onItemTapped(1);
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 1.0,
                      color: ColorStyles.purple_500,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    context.read<ProviderModel>().serviceOptions[index]
                        ['image_service'],
                    width: 40,
                    height: 40,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.read<ProviderModel>().getServiceText(
                        context.read<ProviderModel>().serviceOptions[index]
                            ['name_service'],
                      ),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFamilySection() {
    // เงื่อนไข เมื่อบัญชี มีข้อมูลครอบครัว
    if (context.read<ProviderModel>().dataListFamily.isEmpty) {
      return const SizedBox();
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: const Text(
                  'home_page.family',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ).tr(),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics:
                  const PageScrollPhysics(), // สำหรับการสลับระหว่างรายการแต่ละรายการ
              itemCount: context.read<ProviderModel>().dataListFamily.length +
                  1, // จำนวนรายการ
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        context.read<ProviderModel>().selectFamPatient = index;
                        log('selectFamPatient: ${context.read<ProviderModel>().selectFamPatient}');
                        log('[dataAccount]: ${context.read<ProviderModel>().dataAccount["th_Firstname"]}');
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 88,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          width: 3,
                          color:
                              context.read<ProviderModel>().selectFamPatient ==
                                      index
                                  ? ColorStyles.purple_500
                                  : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                              '${context.read<ProviderModel>().dataAccount['image_Profile']}',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${context.read<ProviderModel>().dataAccount["th_Firstname"]}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        context.read<ProviderModel>().selectFamPatient = index;
                        log('selectFamPatient: ${context.read<ProviderModel>().selectFamPatient}');
                        log('[dataListFamily]: ${context.read<ProviderModel>().dataListFamily[index - 1]["th_Firstname"]}');
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 88,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          width: 3,
                          color:
                              context.read<ProviderModel>().selectFamPatient ==
                                      index
                                  ? ColorStyles.purple_500
                                  : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(
                              '${context.read<ProviderModel>().dataListFamily[index - 1]['image_Profile']}',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${context.read<ProviderModel>().dataListFamily[index - 1]["th_Firstname"]}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      );
    }
  }

  Widget notFound() {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [BoxShadowStyles.largeBoxButtom],
      ),
      child: Center(
        child: const Text(
          'home_page.notFound',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ).tr(),
      ),
    );
  }

  Widget _buildAppointmentList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: const Text(
                  'home_page.appointment_list',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ).tr(),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () {
                    log('ทั้งหมด');
                    log('homePage() => BookingPage()');
                    context.read<ProviderModel>().onItemTapped(2);
                  },
                  child: const Text(
                    'home_page.view_all',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ).tr(),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Consumer<ProviderModel>(
            builder:
                (BuildContext context, ProviderModel value, Widget? child) {
              if (value.dataListReservation.isNotEmpty) {
                value.loadDataListReservation(value.phoneNumber);
                // จัดหมวดหมู่
                Map<String, List<Map<String, dynamic>>> groupedData =
                    groupDataByService(value.dataListReservation);

                if (context.read<ProviderModel>().selectFamPatient != 0) {
                  groupedData.forEach((key, value) {
                    // กรองข้อมูลที่มี key patientReserve เป็น "นวลสุข ลัลลา"
                    groupedData[key] = value
                        .where((element) =>
                            element['patientReserve'] ==
                            "${context.read<ProviderModel>().dataListFamily[context.read<ProviderModel>().selectFamPatient - 1]['th_Firstname']} ${context.read<ProviderModel>().dataListFamily[context.read<ProviderModel>().selectFamPatient - 1]['th_Lastname']}")
                        .toList();
                  });
                }
                List<String> keysToRemove = [];
                groupedData.forEach((key, value) {
                  if (value.isEmpty) {
                    keysToRemove.add(key);
                  }
                });

                for (var key in keysToRemove) {
                  groupedData.remove(key);
                }
                // log('[groupedData]:$groupedData');
                if (groupedData.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: groupedData.length,
                    itemBuilder: (BuildContext context, int index) {
                      // แสดงรายการในหมวดหมู่
                      String serviceKey = groupedData.keys.elementAt(index);
                      List<Map<String, dynamic>> serviceData =
                          groupedData[serviceKey]!;
                      serviceData = serviceData
                          .where(
                            (data) =>
                                data['statusReserve'] == 'อนุมัติ' ||
                                data['statusReserve'] == 'ยืนยันเข้าคลินิก' ||
                                data['statusReserve'] == 'รอตรวจสอบ' ||
                                data['statusReserve'] == 'รอชำระเงิน' ||
                                data['statusReserve'] == 'นัดหมายหมอ',
                          )
                          .toList();

                      // จัดเรียงวันแลเวลา
                      serviceData.sort((a, b) =>
                          a['datetimeReserve'].compareTo(b['datetimeReserve']));

                      // ถ้าไม่มีข้อมูลในกลุ่มนี้ ก็ไม่แสดง ExpansionPanelList
                      if (serviceData.isEmpty) {
                        return const SizedBox();
                      } else {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: RoundedExpansionTile(
                            dense: true,
                            trailing: const Icon(
                              Symbols.expand_more,
                              size: 24,
                              weight: 800,
                            ),
                            rotateTrailing: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            title: Text(
                              '${value.getServiceText(serviceKey)} (${serviceData.length})',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            tileColor: ColorStyles.purple_200,
                            childrenPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            children: serviceData
                                .map(
                                  (data) => GestureDetector(
                                    onTap: () {
                                      context
                                          .read<ProviderModel>()
                                          .stringNumber = data['idReserve'];
                                      context
                                          .read<ProviderModel>()
                                          .findResult();
                                      // log('data:$indexId');
                                      log('homePage() push=> CheckStatus()');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CheckStatus(),
                                        ),
                                      );
                                    },
                                    child: cardStyles(data),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return notFound();
                }
              } else {
                return notFound();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget cardStyles(data) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [BoxShadowStyles.largeBoxButtom],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              color: Provider.of<ProviderModel>(context, listen: false)
                  .getStatusColor200(data['statusReserve']),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${'card.reservation_no'.tr()} ${data['idReserve']}',
                  style: const TextStyle(
                    color: ColorStyles.grey_500,
                    fontSize: 11,
                  ),
                ),
                Text(
                  context
                      .read<ProviderModel>()
                      .getStatusCardText(data['statusReserve']),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                              image: NetworkImage("${data['docImage']}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['prefixDoc'] + data['docReserve'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
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
                          Text(
                            context.read<ProviderModel>().showDateMonthYear(
                                context
                                    .read<ProviderModel>()
                                    .showTimestamp(data['datetimeReserve'])),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.schedule),
                          const SizedBox(width: 8),
                          Text(
                            context.read<ProviderModel>().showTime(context
                                .read<ProviderModel>()
                                .showTimestamp(data['datetimeReserve'])),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage("${data['patientImage']}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['patientReserve'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                data['phoneReserve'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
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
  }

  Map<String, List<Map<String, dynamic>>> groupDataByService(
      List<Map<dynamic, dynamic>> dataList) {
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var data in dataList) {
      String serviceKey = data['selectservices'];
      groupedData.putIfAbsent(serviceKey, () => []);
      groupedData[serviceKey]!.add(Map<String, dynamic>.from(data));
    }
    return groupedData;
  }
}
