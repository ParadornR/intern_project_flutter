// ignore_for_file: file_names, non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uu_alpha/page/Profile/editProfile_Page.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';

class ShowProfilePage extends StatefulWidget {
  const ShowProfilePage({
    super.key,
  });

  @override
  State<ShowProfilePage> createState() => _ShowProfilePageState();
}

class _ShowProfilePageState extends State<ShowProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
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
                  'show_profile.title_bar'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            context.read<ProviderModel>().selectFamPatient == 0
                ? Expanded(
                    flex: 2,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfilePage()),
                        );
                      },
                      child: Text('show_profile.edit'.tr(),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: ColorStyles.purple_800,
                            fontSize: 14,
                          )),
                    ),
                  )
                : const Expanded(
                    child: SizedBox(),
                  ),
          ],
        ),
        backgroundColor: ColorStyles.backgroundColor,
      ),
      body: Stack(
        children: [
          _backGroundSection(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _imageProfileSection(),
                  const SizedBox(height: 16),
                  _infomationSection(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _backGroundSection() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Stack(
            children: [
              Container(
                color: ColorStyles.purple_200,
              ),
            ],
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

  Widget _imageProfileSection() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Consumer(
        builder: (BuildContext context, ProviderModel value, Widget? child) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            width: 120,
            height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 5,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              shape: BoxShape.circle,
            ),
            child: value.selectFamPatient == 0
                ? value.dataAccount['image_Profile'] == null ||
                        value.dataAccount['image_Profile'] == ""
                    ? const Center(
                        child: Text(
                          'No image',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Image.network(
                        '${value.dataAccount['image_Profile']}',
                        fit: BoxFit.cover,
                      )
                : value.dataListFamily[value.selectFamPatient - 1]
                                ['image_Profile'] ==
                            null ||
                        value.dataListFamily[value.selectFamPatient - 1]
                                ['image_Profile'] ==
                            ""
                    ? const Text(
                        'dataAccount?',
                        style: TextStyle(color: Colors.white),
                      )
                    : Image.network(
                        '${value.dataListFamily[value.selectFamPatient - 1]['image_Profile']}',
                        fit: BoxFit.cover,
                      ),
          );
        },
      ),
    );
  }

  Widget _infomationSection() {
    return Consumer(
      builder: (BuildContext context, ProviderModel value, Widget? child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.selectFamPatient == 0
              ? value.dataAccount.length - 2
              : context
                      .read<ProviderModel>()
                      .dataListFamily[value.selectFamPatient - 1]
                      .length -
                  1,
          itemBuilder: (BuildContext context, int index) {
            final List<dynamic> FromProfile = [
              [
                'show_profile.name'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['th_Firstname'] : value.dataListFamily[value.selectFamPatient - 1]['th_Firstname']}'
              ],
              [
                'show_profile.sername'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['th_Lastname'] : value.dataListFamily[value.selectFamPatient - 1]['th_Lastname']}'
              ],
              [
                'show_profile.first_name'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['en_Firstname'] : value.dataListFamily[value.selectFamPatient - 1]['en_Firstname']}'
              ],
              [
                'show_profile.last_name'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['en_Lastname'] : value.dataListFamily[value.selectFamPatient - 1]['en_Lastname']}'
              ],
              [
                'show_profile.nickname'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['nickname'] : value.dataListFamily[value.selectFamPatient - 1]['nickname']}'
              ],
              [
                'show_profile.birthday'.tr(),
                (value.selectFamPatient == 0
                    ? (value.showDateMonthYearABB(
                        value.showTimestamp(value.dataAccount['birthday'])))
                    : (value.showDateMonthYearABB(value.showTimestamp(
                        value.dataListFamily[value.selectFamPatient - 1]
                            ['birthday']))))
              ],
              [
                'show_profile.gender'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['gender'] : value.dataListFamily[value.selectFamPatient - 1]['gender']}',
              ],
              [
                'show_profile.age'.tr(),
                (value.selectFamPatient == 0
                    ? value.showAge(
                        value.showTimestamp(value.dataAccount['birthday']))
                    : value.showAge(value.showTimestamp(
                        value.dataListFamily[value.selectFamPatient - 1]
                            ['birthday'])))
              ],
              [
                'show_profile.human_no'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['HN_ID'] : value.dataListFamily[value.selectFamPatient - 1]['HN_ID']}',
              ],
              [
                'show_profile.phone'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['phone'] : value.dataListFamily[value.selectFamPatient - 1]['phone']}',
              ],
              [
                'show_profile.group_blood'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['groupBlood'] : value.dataListFamily[value.selectFamPatient - 1]['groupBlood']}',
              ],
              [
                'show_profile.religion'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['religion'] : value.dataListFamily[value.selectFamPatient - 1]['religion']}'
              ],
              [
                'show_profile.nationality'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['nationality'] : value.dataListFamily[value.selectFamPatient - 1]['nationality']}'
              ],
              [
                'show_profile.customer_type'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['customerType'] : value.dataListFamily[value.selectFamPatient - 1]['customerType']}'
              ],
              [
                'show_profile.phright_treatmentone'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['rightToTreatment'] : value.dataListFamily[value.selectFamPatient - 1]['rightToTreatment']}'
              ],
              [
                'show_profile.drugAllergy_allergicReaction'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['drugAllergy_AllergicReaction'] : value.dataListFamily[value.selectFamPatient - 1]['drugAllergy_AllergicReaction']}'
              ],
              [
                'show_profile.firstTimeComing'.tr(),
                (value.selectFamPatient == 0
                    ? ""
                    : value.showDateMonthYearABB(value.showTimestamp(
                        value.dataListFamily[value.selectFamPatient - 1]
                            ['FirstTimeComing'])))
              ],
              [
                'show_profile.comeWith'.tr(),
                '${value.selectFamPatient == 0 ? value.dataAccount['comeWith'] : value.dataListFamily[value.selectFamPatient - 1]['comeWith']}'
              ],
            ];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              margin: const EdgeInsets.only(top: 0.25),
              decoration: BoxDecoration(
                boxShadow: const [BoxShadowStyles.largeBoxButtom],
                color: Colors.white,
                borderRadius: index == 0 // ถ้าเป็นรายการแรก
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      )
                    : value.selectFamPatient == 0
                        ? (index ==
                                context
                                        .read<ProviderModel>()
                                        .dataAccount
                                        .length -
                                    3)
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )
                            : BorderRadius.circular(0) // รายการกลาง
                        : (index ==
                                context
                                        .read<ProviderModel>()
                                        .dataListFamily[context
                                                .read<ProviderModel>()
                                                .selectFamPatient -
                                            1]
                                        .length -
                                    2)
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )
                            : BorderRadius.circular(0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${FromProfile[index][0]}',
                    style: const TextStyle(
                      color: ColorStyles.grey_200,
                      fontSize: 16,
                      fontFamily: 'Kanit',
                    ),
                  ),
                  // Text(
                  //   '${[index]}',
                  //   style: const TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 16,
                  //     fontFamily: 'Kanit',
                  //   ),
                  // ),
                  FromProfile[index][1] == null || FromProfile[index][1] == ""
                      ? Text(
                          '${FromProfile[index][0]}',
                          style: const TextStyle(
                            color: ColorStyles.grey_200,
                            fontSize: 16,
                            fontFamily: 'Kanit',
                          ),
                        )
                      : Text(
                          '${FromProfile[index][1]}',
                          style: TextStyle(
                            color: (index == 7 || index == 15)
                                ? Colors.red
                                : Colors.black,
                            fontSize: 16,
                            fontFamily: 'Kanit',
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
