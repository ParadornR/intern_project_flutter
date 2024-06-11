// ignore_for_file: prefer_const_constructors, file_names, avoid_print, camel_case_types

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:uu_alpha/page/Booking/booking_Calender.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool needfilter = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      context
          .read<ProviderModel>()
          .filterDocData(context.read<ProviderModel>().textFiler.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: needfilter
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            needfilter = false;
                          });
                        },
                        icon: const Icon(Icons.chevron_left),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Text(
                          'booking_page.select_service',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ).tr(),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'booking_page.find_doctor',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ).tr(),
                  ],
                ),
          backgroundColor: ColorStyles.backgroundColor,
        ),
        body: needfilter ? _selectService() : _showDoctorServicen(),
        backgroundColor: ColorStyles.backgroundColor,
      ),
    );
  }

  Widget _selectService() {
    return Consumer<ProviderModel>(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(
                    value.serviceOptions.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          value.textFiler.text =
                              value.serviceOptions[index]['name_service'];
                          value.selectedfilterIndex = index;
                          needfilter = false;
                          value.filterDocData(value.textFiler.text);
                        });
                        log('${value.filteredDocData.length}');
                        log('at GestureDetector text.textFiler.text: ${value.textFiler.text}');

                        // log('index: $index');
                        // log('selectedfilterIndex: $selectedfilterIndex');
                      },
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: value.selectedfilterIndex == index
                              ? ColorStyles.purple_200
                              : Colors.white,
                          border: Border.all(
                            color: ColorStyles.grey_500,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.network(
                                  value.serviceOptions[index]['image_service']),
                            ),
                            SizedBox(height: 8),
                            Text(
                              value.getServiceText(
                                  value.serviceOptions[index]['name_service']),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _showDoctorServicen() {
    return Column(
      children: [
        _textField(),
        SizedBox(height: 10),
        Expanded(
          flex: 8,
          child: context.read<ProviderModel>().filteredDocData.isEmpty
              ? _notFound()
              : _founded(),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _textField() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: value.textFiler,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              decoration: TextDecoration.none,
              decorationThickness: 0,
            ),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'booking_page.field_hint'.tr(),
              hintStyle: TextStyle(
                color: ColorStyles.grey_500,
                fontSize: 16,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.black,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              prefixIcon: Icon(
                Symbols.search,
                size: 24,
                weight: 800,
                color: ColorStyles.purple_500,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    needfilter = true;
                  });
                  log('at IconButton text.textFiler.text: ${value.textFiler.text}');
                },
                icon: Icon(
                  Symbols.filter_alt,
                  size: 24,
                  weight: 800,
                  color: ColorStyles.purple_500,
                ),
              ),
            ),
            onChanged: (doc) {
              if (value.textFiler.text.isEmpty) {
                setState(() {
                  value.selectedfilterIndex = -1;
                });
              }
              log('doc:$doc');
              setState(() {
                value.filterDocData(value.textFiler.text);
              });
              log('${value.filteredDocData.length}');
            },
          ),
        );
      },
    );
  }

  Widget _notFound() {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Symbols.content_paste_search,
            size: 48,
            weight: 800,
            color: ColorStyles.grey_200,
          ),
          SizedBox(height: 8),
          Text(
            'booking_page.notFound'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'booking_page.description'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorStyles.grey_500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _founded() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return ListView.builder(
          physics: ClampingScrollPhysics(),
          itemCount: value.filteredDocData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                log("[docID]: ${value.filteredDocData[index]['docID']}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingCalendarPage(
                      nameDocSelect: value.filteredDocData[index]['docID'],
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadowStyles.largeBoxButtom],
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 68,
                      height: 68,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          value.filteredDocData[index]['imageDoc'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${value.filteredDocData[index]['prefixDoc']} ${value.filteredDocData[index]['nameDoc']}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            children: List.generate(
                              value.filteredDocData[index]['skillsDoc'].length,
                              (indexSkill) => Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 2.5, vertical: 3),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: ColorStyles.purple_200,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                    value.getServiceText(
                                        value.filteredDocData[index]
                                            ['skillsDoc'][indexSkill]),
                                    textAlign: TextAlign.center,
                                    style: TextStyles.textB_12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
