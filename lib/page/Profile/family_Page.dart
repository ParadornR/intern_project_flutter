// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:uu_alpha/provider/providerModel.dart';
import 'package:uu_alpha/styles.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'family_Page.title_bar'.tr(),
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
      body: context.read<ProviderModel>().dataListFamily.isNotEmpty
          ? Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Wrap(
                spacing: 0,
                runSpacing: 0,
                children: List.generate(
                  context.read<ProviderModel>().dataListFamily.length + 1,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        context
                            .read<ProviderModel>()
                            .changeSelectedFamPatient(index);

                        log('selectedFamily: ${context.read<ProviderModel>().selectFamPatient}');
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.18,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 2,
                          color:
                              context.read<ProviderModel>().selectFamPatient ==
                                      index
                                  ? ColorStyles.purple_500
                                  : Colors.transparent,
                        ),
                      ),
                      child: Consumer(
                        builder: (BuildContext context, ProviderModel value,
                            Widget? child) {
                          return Column(
                            children: [
                              // value.dataListFamily[index - 1]['image_Profile']
                              index == 0
                                  ? value.dataAccount['image_Profile'] ==
                                              null ||
                                          value.dataAccount['image_Profile'] ==
                                              ""
                                      ? const CircleAvatar(
                                          radius: 38,
                                        )
                                      : CircleAvatar(
                                          radius: 38,
                                          backgroundImage: NetworkImage(
                                            '${value.dataAccount['image_Profile']}',
                                          ),
                                        )
                                  : value.dataListFamily[index - 1]
                                                  ['image_Profile'] ==
                                              null ||
                                          value.dataListFamily[index - 1]
                                                  ['image_Profile'] ==
                                              ""
                                      ? const CircleAvatar(
                                          radius: 38,
                                        )
                                      : CircleAvatar(
                                          radius: 38,
                                          backgroundImage: NetworkImage(
                                            '${value.dataListFamily[index - 1]['image_Profile']}',
                                          ),
                                        ),
                              const SizedBox(height: 8),
                              Text(
                                '${index == 0 ? value.dataAccount['th_Firstname'] : value.dataListFamily[index - 1]['th_Firstname']}  ${index == 0 ? value.dataAccount['th_Lastname'] : value.dataListFamily[index - 1]['th_Lastname']} ',
                                overflow: TextOverflow.ellipsis,
                              ),
                              index == 0
                                  ? Text(
                                      '${value.dataAccount['phone']}',
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Symbols.group,
                    size: 48,
                    weight: 400,
                    color: ColorStyles.grey_500,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'ไม่มีFamily',
                    style: TextStyle(
                      color: ColorStyles.grey_500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
