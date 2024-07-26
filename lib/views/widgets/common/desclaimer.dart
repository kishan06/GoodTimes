import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../screens/subscription/open_website.dart';

showDesclaimer(context) {
    void _launchWebsiteForiOS() async {
      final Uri url = Uri.parse('https://apps.apple.com/in/story/id1614232807');
      if (Platform.isIOS) {
        // Open in Safari on iOS
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // For other platforms, use the default behavior
        await launchUrl(url);
      }
    }

    return showBarModalBottomSheet(
      expand: false,
      context: context,
      barrierColor: const Color(0xff000000).withOpacity(0.9),
      backgroundColor: const Color(0xff1C1C1C),
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 25.0, right: 25, top: 30, bottom: 5),
          child: Column(
            children: [
              const Text(
                'You\'re about to leave the app and go to an external website. You will no longer be transacting with Apple.',
                style: TextStyle(
                  fontSize: 24,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Any accounts or purchases made outside of this app will be managed by the developer "GoodTimesApp". Your App Store account, stored payment method, and related features, such as subscription management and refund request, will not be available. Apple is not responsible for the privacy or security of transactions made with this developer',
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryColor,
                ),
              ),
              const Spacer(
                flex: 4,
              ),
              // OutlinedButton(onPressed: onPressed, child: child)
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                margin: const EdgeInsets.symmetric(vertical: 3.0),
                child: SizedBox.expand(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        width: 1,
                        color: kPrimaryColor,
                        style: BorderStyle.solid,
                      ),
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                ),
                    ),
                    onPressed: () {
                      _launchWebsiteForiOS();
                      Get.back();
                    },
                    child: const Text(
                      'Learn More',
                      style: TextStyle(
                          color:kPrimaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MyElevatedButton(
                text: 'Continue',
                onPressed: () {
                  Get.back();
                  Get.to(() => const WebViewExample());
                },
              ),
              const SizedBox(height: 20),
              myElevatedButtonOutline(
                  text: 'Cancel',
                  onPressed: () {
                    Get.back();
                  }),
              const Spacer(flex: 1),
            ],
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
    );
  }