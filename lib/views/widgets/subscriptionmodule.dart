import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/constant.dart';
import '../../utils/temp.dart';
import '../screens/subscription/open_website.dart';
import 'common/button.dart';
import 'common/desclaimer.dart';
import 'signout.dart';

Subscriptionmodule(BuildContext context, String usertype, {String email = ""}) {
  if (usertype == "event_user") {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 0.90,
                padding: const EdgeInsets.only(
                    top: 10, left: 30, right: 10, bottom: 20),
                decoration: const BoxDecoration(color: kTextgreyDark),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.close_sharp,
                            size: 20,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 10),
                      child: Text(
                        'You are just one step away, to explore all the events',
                        style: paragraphStyle.copyWith(
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: MyElevatedButton(
                          onPressed: () {
                            redirectsubscribe(context);
                          },
                          text: 'Join Us'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: TextButton(
                          onPressed: () {
                            GetStorage().write(TempData.SubscriptionSkip, true);
                            GetStorage().write(TempData.StoreUserId, email);

                            Get.back();
                          },
                          child: Text(
                            "Skip",
                            style:
                                paragraphStyle.copyWith(color: kPrimaryColor),
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  } else {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 50, right: 50, bottom: 40),
      width: double.infinity,
      decoration: BoxDecoration(color: kTextWhite.withOpacity(0.3)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You are just one step away, to explore all the events',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          MyElevatedButton(
              onPressed: () {
                redirectsubscribe(context);
              },
              text: 'Join Us'),
          TextButton(
              onPressed: () {
                signOutAccount(context);
              },
              child: Text(
                "Sign Out",
                style: paragraphStyle.copyWith(color: kPrimaryColor),
              ))
        ],
      ),
    );
  }
}

Future<void> redirectsubscribe(BuildContext context) async {
  if (Platform.isIOS) {
    // Open in Safari on iOS
    showDesclaimer(context);
  } else {
    Get.to(() => const WebViewExample());
  }
}

PreferenceWarning(BuildContext context,Function()? onTap) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: AlertDialog(
          surfaceTintColor: Color(0xFFFFFFFF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          insetPadding: const EdgeInsets.symmetric(vertical: 8),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              "Once you proceed with the selected preferences, you won't be able to edit them later without a subscription. Are you sure you want to continue?",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: const Color(0xff54595F),
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: const Color(0xff000000),
                ),
              ),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTap: onTap,
              child: const Text(
                "Yes",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: kPrimaryColor,
                ),
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      );
    },
  );
}