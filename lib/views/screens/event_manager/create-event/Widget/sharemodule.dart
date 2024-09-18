import 'dart:developer';
import 'dart:io';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:appinio_social_share/appinio_social_share_method_channel.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:good_times/data/repository/services/event_manager.dart';
import 'package:good_times/data/repository/services/social_share.dart';
import 'package:good_times/utils/temp.dart';

import '../../../../../data/repository/response_data.dart';
import '../../../../../utils/loading.dart';
import '../../../../../view-models/copy_clipboard.dart';
import '../../../../../view-models/global_controller.dart';

final appinioSocialShare = AppinioSocialShare();
GlobalController globalController = Get.find();
void onSaveBottomsheet(BuildContext context, {int? eventid}) {
  bool isExpanded = false;
  bool waiting = false;
  // late List<EventsModel> data;
  final appinioSocialShare = AppinioSocialShare();
  final secondObj = MethodChannelAppinioSocialShare();

  void shareToFacebook(String caption, String imagePath) async {
    CopyClipboardAndSahreController().copyToClipboard(context, caption);
    Get.snackbar("Copied to clipboard", "");

    print("$imagePath");
    if (Platform.isAndroid) {
      bool isInstalled = await DeviceApps.isAppInstalled('com.twitter.android');
      if (isInstalled) {
        try {
          await appinioSocialShare.shareToFacebook(
            text: caption,
            filePath: imagePath,
          );
        } catch (e) {
          print("Failed to share on Facebook: $e");
        }
      } else {
        Fluttertoast.showToast(msg: "Twitter app is not installed.");
      }
    }
    if (Platform.isIOS) {
      Map<String, bool> resp = await secondObj.getInstalledApps();
      print(resp['facebook_stories']);
      if (resp['facebook_stories']!) {
        try {
          secondObj.shareToFacebook(caption, [imagePath]);
        } catch (e) {
          print("Failed to share on Instagram: $e");
        }
      } else {
        Fluttertoast.showToast(msg: "Twitter app is not installed.");
      }
    }
  }

  void shareToTwitter(String caption, String imagePath) async {
    CopyClipboardAndSahreController().copyToClipboard(context, caption);
    Get.snackbar("Copied to clipboard", "");
    if (Platform.isAndroid) {
      bool isInstalled = await DeviceApps.isAppInstalled('com.twitter.android');
      if (isInstalled) {
        try {
          await appinioSocialShare.shareToTwitter(
            text: caption,
            filePath: imagePath,
          );
        } catch (e) {
          print("Failed to share on Twitter: $e");
        }
      } else {
        Fluttertoast.showToast(msg: "Twitter app is not installed.");
      }
    }
    if (Platform.isIOS) {
      Map<String, bool> resp = await secondObj.getInstalledApps();

      if (resp['twitter']!) {
        try {
          secondObj.shareToTwitter(caption, imagePath);
        } catch (e) {
          print("Failed to share on Instagram: $e");
        }
      } else {
        Fluttertoast.showToast(msg: "Twitter app is not installed.");
      }
    }
  }

  void shareToInstagram(String caption, String imagePath) async {
    CopyClipboardAndSahreController().copyToClipboard(context, caption);
    Get.snackbar("Copied to clipboard", "");

    if (Platform.isAndroid) {
      bool isInstalled =
          await DeviceApps.isAppInstalled('com.instagram.android');
      if (isInstalled) {
        try {
          await appinioSocialShare.shareToInstagram(
            text: caption,
            filePath: imagePath,
          );
        } catch (e) {
          print("Failed to share on Instagram: $e");
        }
      } else {
        Fluttertoast.showToast(msg: "Instagram app is not installed.");
      }
    }
    if (Platform.isIOS) {
      Map<String, bool> resp = await secondObj.getInstalledApps();
      print(resp['instagram']);
      if (resp['instagram']!) {
        try {
          secondObj.shareToInstagramFeed(caption, imagePath);
        } catch (e) {
          print("Failed to share on Instagram: $e");
        }
      } else {
        Fluttertoast.showToast(msg: "Twitter app is not installed.");
      }
    }
  }

  Get.bottomSheet(isScrollControlled: true,
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Color(0xFF252527),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // sizedBoxHeight(20.h),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text("Share thumbnail",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Color(0xFFD0D0D0),
                      )),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(
                      "assets/images/x.png",
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(height: 1, width: double.infinity, color: Colors.white),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Upload thumbnail on ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: Color(0xFFFFFFFF),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Good Times',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: Color(0xFFE8C98B),
                          ),
                        ),
                        TextSpan(
                          text: ' social media',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              // List<EventsModel> data;
                              // // data[0].id;
                              // var lastEventid;
                              // if (eventmodelobj != null &&
                              //     eventmodelobj!.isNotEmpty) {
                              //   // Access the last event
                              //   lastEventid = eventmodelobj!.last;

                              // }
                              showWaitingDialoge(
                                  context: context, loading: waiting);
                              setState(() {
                                waiting = true;
                              });
                              SocialShareService()
                                  .socialShare(context,
                                      eventid: eventid,
                                      // eventid: eventmodelobj!.last.id + 1,
                                      platforms: 'instagram')
                                  .then((value) {
                                if (value.responseStatus ==
                                    ResponseStatus.success) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: value.data["success_messages"][0]
                                          .toString());
                                } else if (value.responseStatus ==
                                    ResponseStatus.failed) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Image.asset(
                              "assets/images/skill-icons_instagram.png",
                              height: 51,
                              width: 51,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Instagram",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: Color(0xFFFFFFFF),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showWaitingDialoge(
                                  context: context, loading: waiting);
                              setState(() {
                                waiting = true;
                              });
                              SocialShareService()
                                  .socialShare(context,
                                      eventid: eventid, platforms: 'facebook')
                                  .then((value) {
                                if (value.responseStatus ==
                                    ResponseStatus.success) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: value.data["success_messages"][0]
                                          .toString());
                                } else if (value.responseStatus ==
                                    ResponseStatus.failed) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Image.asset(
                              "assets/images/logos_facebook.png",
                              height: 51,
                              width: 51,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Facebook",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: Color(0xFFFFFFFF),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              log("Event Id ---->>> ${eventmodelobj!.last.id + 1}");
                              showWaitingDialoge(
                                  context: context, loading: waiting);
                              setState(() {
                                waiting = true;
                              });
                              SocialShareService()
                                  .socialShare(context,
                                      eventid: eventid, platforms: 'twitter')
                                  .then((value) {
                                if (value.responseStatus ==
                                    ResponseStatus.success) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: value.data["success_messages"][0]
                                          .toString());
                                } else if (value.responseStatus ==
                                    ResponseStatus.failed) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Image.asset(
                              "assets/images/ant-design_x-outlined.png",
                              height: 51,
                              width: 51,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "x",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: Color(0xFFFFFFFF),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              log("Event Id ---->>> ${eventmodelobj!.last.id + 1}");
                              showWaitingDialoge(
                                  context: context, loading: waiting);
                              setState(() {
                                waiting = true;
                              });
                              SocialShareService()
                                  .socialShare(context,
                                      eventid: eventid, platforms: 'all')
                                  .then((value) {
                                if (value.responseStatus ==
                                    ResponseStatus.success) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);

                                  List messagesList = [];

                                  messagesList
                                      .addAll(value.data["success_messages"]);

                                  // Add error messages if available
                                  messagesList.addAll(value.data["errors"]);

                                  // Join all messages with a newline separator
                                  String messages = messagesList.join('\n');

                                  // Delay the toast to ensure context is available
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    Fluttertoast.showToast(msg: messages);
                                  });

                                  print("message$messages");
                                } else if (value.responseStatus ==
                                    ResponseStatus.failed) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: Container(
                              height: 51,
                              width: 53,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFF434343)),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/mdi_share.png",
                                  height: 22,
                                  width: 22,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Share all",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: Color(0xFFFFFFFF),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Upload thumbnail on your social media',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              String caption =
                                  "Event Name: ${TempData.evetTitle}, Location: ${TempData.editselectVenu}, Date: ${TempData.evetStartDate} ${TempData.evetStartTime}-${TempData.evetEndDate} ${TempData.evetEndTime}, Amount: ${TempData.editeventEntryCost}";
                              shareToInstagram(caption,
                                  globalController.eventThumbnailImgPath.value);
                            },
                            child: Image.asset(
                              "assets/images/skill-icons_instagram.png",
                              height: 51,
                              width: 51,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Instagram",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: Color(0xFFFFFFFF),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              String caption =
                                  "Event Name: ${TempData.evetTitle}, Location: ${TempData.editselectVenu}, Date: ${TempData.evetStartDate} ${TempData.evetStartTime}-${TempData.evetEndDate} ${TempData.evetEndTime}, Amount: ${TempData.editeventEntryCost}";

                              shareToFacebook(caption,
                                  globalController.eventThumbnailImgPath.value);
                            },
                            child: Image.asset(
                              "assets/images/logos_facebook.png",
                              height: 51,
                              width: 51,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Facebook",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: Color(0xFFFFFFFF),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              String caption =
                                  "Event Name: ${TempData.evetTitle}, Location: ${TempData.editselectVenu}, Date: ${TempData.evetStartDate} ${TempData.evetStartTime}-${TempData.evetEndDate} ${TempData.evetEndTime}, Amount: ${TempData.editeventEntryCost}";

                              shareToTwitter(caption,
                                  globalController.eventThumbnailImgPath.value);
                            },
                            child: Image.asset(
                              "assets/images/ant-design_x-outlined.png",
                              height: 51,
                              width: 51,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "x",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: Color(0xFFFFFFFF),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: isExpanded == true ? 250 : null,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF434343)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Row(
                            crossAxisAlignment: isExpanded == true
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/alert-circle.png",
                                width: 14,
                                height: 14,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Text(
                                "Know more about the further steps...",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded!;
                                  });
                                },
                                child: isExpanded == true
                                    ? Image.asset(
                                        "assets/images/arrow-down-circle (1).png",
                                        width: 24,
                                        height: 24,
                                      )
                                    : Image.asset(
                                        "assets/images/arrow-down-circle.png",
                                        width: 24,
                                        height: 24,
                                      ),
                              )
                            ],
                          ),
                        ),
                        if (isExpanded == true)
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 0.5,
                                    width: double.infinity,
                                    color: const Color(0xFFF1D69F)
                                        .withOpacity(0.45),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: const Icon(
                                          Icons.circle,
                                          size: 6,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "With this feature, you can seamlessly upload your event thumbnail to both the Good Times social media account and the event manager's registered social media accounts. This ensures consistent branding and maximum visibility for your event across multiple platforms. Easily manage and enhance your event's online presence by synchronizing your promotional materials with just a few clicks, making it simpler than ever to engage your audience and boost event attendance.",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Poppins',
                                            color: const Color(0xFFFFFFFF)
                                                .withOpacity(0.79),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     const Icon(
                                  //       Icons.circle,
                                  //       size: 6,
                                  //       color: Color(0xFFFFFFFF),
                                  //     ),
                                  //     const SizedBox(
                                  //       width: 8,
                                  //     ),
                                  //     Text(
                                  //       "Lorem ipsum dolor sit amet, consectetur ",
                                  //       style: TextStyle(
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.w300,
                                  //         fontFamily: 'Poppins',
                                  //         color: const Color(0xFFFFFFFF)
                                  //             .withOpacity(0.79),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // const SizedBox(
                                  //   height: 8,
                                  // ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }));
}
