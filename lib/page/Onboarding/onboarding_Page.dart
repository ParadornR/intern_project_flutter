// ignore_for_file: file_names, deprecated_member_use, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uu_alpha/page/Onboarding/intro_Page.dart';
import 'package:uu_alpha/styles.dart';

class OnboardingPageModel {
  final String title;
  final String description;
  final String image;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel(
      {required this.title,
      required this.description,
      required this.image,
      this.bgColor = Colors.blue,
      this.textColor = Colors.black});
}

class OnboardingPage extends StatefulWidget {
  final List<OnboardingPageModel> pages;

  const OnboardingPage({Key? key, required this.pages}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Store the currently visible page
  int _currentPage = 0;
  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                // Pageview to render each page
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    // Change current page when pageview changes
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final _item = widget.pages[idx];
                    return Column(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
                            padding: const EdgeInsets.all(40.0),
                            child: Image.network(
                              _item.image,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                _item.title,
                                style: const TextStyle(
                                  color: ColorStyles.purple_800,
                                  fontSize: 22,
                                ),
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  _item.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: ColorStyles.purple_800,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Bottom buttons
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () {
                          _pageController.animateToPage(widget.pages.length - 1,
                              curve: Curves.easeInOutCubic,
                              duration: const Duration(milliseconds: 500));
                        },
                        child: Text(
                          "onboarding.skip".tr(),
                          style: const TextStyle(
                            color: ColorStyles.purple_800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    // Current page indicator
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: widget.pages.length,
                          axisDirection: Axis.horizontal,
                          effect: const SlideEffect(
                            spacing: 8.0,
                            radius: 4.0,
                            dotWidth: 16.0,
                            dotHeight: 6.0,
                            dotColor: ColorStyles.grey_200,
                            activeDotColor: ColorStyles.purple_500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: () async {
                          if (_currentPage == widget.pages.length - 1) {
                            // This is the last page
                            log('OnboardingPage() pushReplacement=> IntroPage()');

                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const IntroPage()),
                            );
                          } else {
                            _pageController.animateToPage(_currentPage + 1,
                                curve: Curves.easeInOutCubic,
                                duration: const Duration(milliseconds: 250));
                          }
                        },
                        child: Text(
                          _currentPage == widget.pages.length - 1
                              ? "onboarding.start".tr()
                              : "onboarding.next".tr(),
                          style: const TextStyle(
                            color: ColorStyles.purple_800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
