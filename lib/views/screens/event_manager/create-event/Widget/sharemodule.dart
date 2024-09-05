import 'dart:developer';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:good_times/data/repository/services/event_manager.dart';
import 'package:good_times/data/repository/services/social_share.dart';
import 'package:good_times/utils/temp.dart';

import '../../../../../data/repository/response_data.dart';
import '../../../../../utils/loading.dart';
import '../../../../../view-models/global_controller.dart';

final appinioSocialShare = AppinioSocialShare();
GlobalController globalController = Get.find();
void onSaveBottomsheet(BuildContext context, {int? eventid}) {
  bool isExpanded = false;
  bool waiting = false;
  // late List<EventsModel> data;
  final appinioSocialShare = AppinioSocialShare();

  void shareToFacebook(String caption, String imagePath) async {
    bool isInstalled = await DeviceApps.isAppInstalled('com.facebook.katana');
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
      Fluttertoast.showToast(msg: "Facebook app is not installed.");
    }
  }

  void shareToTwitter(String caption, String imagePath) async {
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

  void shareToInstagram(String caption, String imagePath) async {
    Clipboard.setData(
        ClipboardData(text: "$caption Caption copied to clipboard."));

    bool isInstalled = await DeviceApps.isAppInstalled('com.instagram.android');
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

  Get.bottomSheet(isScrollControlled: true,
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: const Color(0xFF252527),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // sizedBoxHeight(20.h),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text("Share thumbnail",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Color(0xFFD0D0D0),
                      )),
                  Spacer(),
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
            SizedBox(
              height: 20,
            ),
            Container(height: 1, width: double.infinity, color: Colors.white),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Upload thumbnail on ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: Color(0xFFFFFFFF),
                      ),
                      children: const <TextSpan>[
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
                  SizedBox(
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
                          SizedBox(
                            height: 8,
                          ),
                          Text(
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
                      SizedBox(
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
                                    eventid: eventid,
                                      platforms: 'facebook')
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
                          SizedBox(
                            height: 8,
                          ),
                          Text(
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
                      SizedBox(
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
                                      eventid: eventid,
                                      platforms: 'twitter')
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
                          SizedBox(
                            height: 8,
                          ),
                          Text(
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
                      SizedBox(
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
                                    eventid: eventid,
                                      platforms: 'all')
                                  .then((value) {
                                if (value.responseStatus ==
                                    ResponseStatus.success) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                  // if (value.data["success_messages"] != null &&
                                  //     value.data["success_messages"] is List) {
                                  //   String messages = value
                                  //       .data["success_messages"]
                                  //       .where((message) => message != null)
                                  //       .map((message) => message.toString())
                                  //       .join('\n');

                                  //   Fluttertoast.showToast(msg: messages);
                                  // }

                                  List messagesList = [];

                                  messagesList
                                      .addAll(value.data["success_messages"]);

                                  // Add error messages if available
                                  messagesList.addAll(value.data["errors"]);

                                  // Join all messages with a newline separator
                                  String messages = messagesList.join('\n');

                                  // Delay the toast to ensure context is available
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
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
                                  color: Color(0xFF434343)),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/mdi_share.png",
                                  height: 22,
                                  width: 22,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
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
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Upload thumbnail on your social media',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              shareToInstagram(TempData.evetTitle,
                                  globalController.eventThumbnailImgPath.value);
                            },
                            child: Image.asset(
                              "assets/images/skill-icons_instagram.png",
                              height: 51,
                              width: 51,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
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
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              shareToFacebook(TempData.evetTitle,
                                  globalController.eventThumbnailImgPath.value);
                            },
                            child: Image.asset(
                              "assets/images/logos_facebook.png",
                              height: 51,
                              width: 51,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
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
                      SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              shareToTwitter(TempData.evetTitle,
                                  globalController.eventThumbnailImgPath.value);
                            },
                            child: Image.asset(
                              "assets/images/ant-design_x-outlined.png",
                              height: 51,
                              width: 51,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
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
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: isExpanded == true ? 220 : null,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF434343)),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
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
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Know more about the further steps...",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                              Spacer(),
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
                                    color: Color(0xFFF1D69F).withOpacity(0.45),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 6,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Lorem ipsum dolor sit amet, consectetur ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Poppins',
                                          color: Color(0xFFFFFFFF)
                                              .withOpacity(0.79),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 6,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Lorem ipsum dolor sit amet, consectetur ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Poppins',
                                          color: Color(0xFFFFFFFF)
                                              .withOpacity(0.79),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 6,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Lorem ipsum dolor sit amet, consectetur ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Poppins',
                                          color: Color(0xFFFFFFFF)
                                              .withOpacity(0.79),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 6,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Lorem ipsum dolor sit amet, consectetur ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Poppins',
                                          color: Color(0xFFFFFFFF)
                                              .withOpacity(0.79),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
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
