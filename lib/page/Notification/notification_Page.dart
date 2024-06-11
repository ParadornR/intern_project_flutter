// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';

class notification extends StatefulWidget {
  const notification({
    Key? key,
  }) : super(key: key);

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  bool deleteNoti = true;
  bool needDelete = true;

  Widget boxNoti(int index) {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  value.notiData[index]['isActive'] =
                      !value.notiData[index]['isActive'];
                });
              },
              child: deleteNoti
                  ? const SizedBox()
                  : value.notiData[index]['isActive']
                      ? Container(
                          width: 24,
                          height: 24,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFD79FE8),
                            shape: OvalBorder(
                              side: BorderSide(
                                  width: 1, color: Color(0xFFD79FE8)),
                            ),
                          ),
                        )
                      : Container(
                          width: 24,
                          height: 24,
                          decoration: const ShapeDecoration(
                            color: ColorStyles.backgroundColor,
                            shape: OvalBorder(
                              side: BorderSide(
                                  width: 1, color: ColorStyles.grey_500),
                            ),
                          ),
                        ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadowStyles.largeBoxButtom],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/uuprojectalpha.appspot.com/o/asset%2Ficon.png?alt=media&token=17234d33-75fe-4408-8934-828e5af0d360'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'หมายเลขการจอง : ${value.notiData[index]['idReserve']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            value.notiData[index]['statusUpdate'],
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
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: deleteNoti
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                    ),
                  ),
                  const Center(
                    child: Text(
                      'แจ้งเตือน',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        deleteNoti = false;
                      });
                    },
                    icon: const Icon(
                      size: 24,
                      Symbols.delete,
                      weight: 800,
                    ),
                  ),
                ],
              )
            : Consumer(
                builder:
                    (BuildContext context, ProviderModel value, Widget? child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          for (var notification in value.notiData) {
                            notification['isActive'] = false;
                          }

                          setState(() {
                            deleteNoti = true;
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                      const Center(
                        child: Text(
                          'ลบรายการแจ้งเตือน',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            for (var notification in value.notiData) {
                              notification['isActive'] = true;
                            }
                          });
                        },
                        child: const Text(
                          'เลือกทั้งหมด',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
        backgroundColor: ColorStyles.backgroundColor,
      ),
      body: Consumer<ProviderModel>(
        builder: (BuildContext context, ProviderModel value, Widget? child) {
          return value.notiData.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 48,
                        color: ColorStyles.grey_500,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'ไม่มีแจ้งเตือน',
                        style: TextStyle(
                          color: ColorStyles.grey_500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 9,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.notiData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {
                                  // LocalNotifications.showScheduleNotification(
                                  //   title: value.notiData[index]
                                  //       ['statusUpdate'],
                                  //   body:
                                  //       'หมายเลขการจอง : ${value.notiData[index]['idReserve']}',
                                  //   payload: 'payload',
                                  // );
                                },
                                child: boxNoti(index));
                          },
                        ),
                      ),
                      deleteNoti
                          ? const SizedBox()
                          : Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pop(); // Your code here
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: AlertDialog(
                                              title: const Text(
                                                'ลบการแจ้งเตือน',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              content: const Text(
                                                'เมื่อลบแจ้งเตือนแล้วจะไม่สามารถ \nเรียกคืนข้อมูลได้อีก\nต้องการลบรายการแจ้งเตือนทั้งหมดหรือไม่',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              actions: [
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        value
                                                            .removeActiveItems();
                                                        Navigator.of(context)
                                                            .pop(); // Your code here
                                                        setState(() {
                                                          deleteNoti = true;
                                                        });
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16,
                                                                vertical: 16),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ColorStyles
                                                              .pink_200,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          boxShadow: const [
                                                            BoxShadowStyles
                                                                .smallBoxButtom
                                                          ],
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'ลบ',
                                                            style: TextStyles
                                                                .textB_16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 20),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16,
                                                                vertical: 16),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ColorStyles
                                                              .grey_200,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          boxShadow: const [
                                                            BoxShadowStyles
                                                                .smallBoxButtom
                                                          ],
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'ยกเลิก',
                                                            style: TextStyles
                                                                .textB_16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: ColorStyles.pink_200,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: const [
                                        BoxShadowStyles.largeBoxButtom
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'ลบแจ้งเตือน',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                );
        },
      ),
      backgroundColor: ColorStyles.backgroundColor,
    );
  }
}
