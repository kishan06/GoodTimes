// ignore_for_file: prefer_const_constructors, library_prefixes

import 'dart:convert';
import 'dart:developer';
import 'dart:io' as IO;
import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:good_times/data/models/Organisation_model.dart';
import 'package:good_times/data/models/events_model.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/data/repository/services/event_manager.dart';
import 'package:good_times/data/repository/services/social_share.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/profile.dart';
import '../../../../data/repository/services/create_event.dart';
import '../../../../data/repository/services/profile.dart';
import '../../../../utils/loading.dart';
import '../../../../utils/temp.dart';
import '../../../../view-models/evevnt_filter_controller.dart';
import '../../../../view-models/global_controller.dart';
import '../../../widgets/common/parent_widget.dart';

class CreatedEventPreview extends StatefulWidget {
  static const String routeName = "createdEventPreview";
  const CreatedEventPreview({super.key});

  @override
  State<CreatedEventPreview> createState() => _CreatedEventPreviewState();
}

class _CreatedEventPreviewState extends State<CreatedEventPreview> {
  GlobalController globalController = Get.find();
  bool waiting = false;
  bool isSaved = false;

  RxBool sharecheck = false.obs;

  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: WillPopScope(
        onWillPop: () async {
          // Navigate to the HomeMain screen and remove all previous routes
          clearAllTempData();
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeMain.routeName,
            (route) => true,
          );
          return true; // Prevent the default pop behavior
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Preview', style: labelStyle.copyWith(fontSize: 20)),
              iconTheme: IconThemeData(color: kPrimaryColor),
              automaticallyImplyLeading:
                  false, // Disable the default back button
              leading: IconButton(
                onPressed: () {
                  clearAllTempData();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    HomeMain.routeName,
                    (route) => true,
                  );
                },
                icon: Icon(Icons.arrow_back),
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.edit_outlined),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.file(
                    IO.File(globalController.eventThumbnailImgPath.value),
                    width: double.infinity,
                    height: 342,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12),
                        Text(
                          '${DateFormat('EEEE MMM dd, yyyy').format(TempData.evetStartDate)}     ${TempData.evetStartTime.format(context)}',
                          style: paragraphStyle,
                        ),
                        SizedBox(height: 8),
                        Text(
                          TempData.evetTitle,
                          style: headingStyle.copyWith(fontSize: 24),
                        ),
                        SizedBox(height: 13),
                        Text('Location',
                            style: labelStyle.copyWith(
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: kPrimaryColor,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text(TempData.evetAddress,
                                    style: paragraphStyle))
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              size: 20,
                              color: kPrimaryColor,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text(
                                    "${double.parse(getTimeDifference(TempData.evetStartTime, TempData.evetEndTime).toStringAsFixed(2))}",
                                    style: paragraphStyle))
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/event/euro.svg',
                              width: 20,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: Text(TempData.eventEntryType,
                                    style: paragraphStyle))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: scaffoldPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About this event',
                            style: labelStyle.copyWith(
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 5),
                        Text(TempData.evetDescription, style: paragraphStyle),
                        SizedBox(height: 15),
                        Text('Key Guest',
                            style: labelStyle.copyWith(
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 5),
                        Text(TempData.eventKeyGuest, style: paragraphStyle),
                        SizedBox(height: 15),
                        Text('Coupon Code',
                            style: labelStyle.copyWith(
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 5),
                        Text(TempData.couponCode, style: paragraphStyle),
                        SizedBox(height: 15),
                        Text('Coupon Code Descriptions',
                            style: labelStyle.copyWith(
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 5),
                        Text(TempData.couponCodeDescription,
                            style: paragraphStyle),
                        SizedBox(height: 15),
                        Text('Tags',
                            style: labelStyle.copyWith(
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 5),
                        SizedBox(
                            height: 20,
                            child: ListView.separated(
                                separatorBuilder: (context, index) => Text(
                                      ", ",
                                      style: paragraphStyle,
                                    ),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: TempData.eventTags.length,
                                itemBuilder: (context, index) => Text(
                                    "#${TempData.eventTags[index]}",
                                    style: paragraphStyle))),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  FutureBuilder(
                    future: ProfileService().getProfileDetails(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        ProfileModel userData = snapshot.data!.data;
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: scaffoldPadding),
                          child: Center(
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: userData.profilePhoto == ''
                                      ? Image.asset('assets/images/avatar.jpg',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover)
                                      : Image.network(userData.profilePhoto,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Organized By',
                                  style: paragraphStyle.copyWith(
                                    fontSize: 12,
                                    color: Color(0xff8C8C8C),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "${userData.firstName} ${userData.lastName}",
                                  style: paragraphStyle.copyWith(
                                      fontSize: 18,
                                      color: Color(0xffE3E3E3),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 2),
                              ],
                            ),
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                    child:

                        // MyElevatedButton(
                        //     //  loader: waiting
                        //     //           ? const CircularProgressIndicator()
                        //     //           : const SizedBox(),
                        //     onPressed: () {
                        //       log("check entry type ${TempData.eventEntryType}");
                        //       //   onSaveBottomsheet();

                        //       // showWaitingDialoge(context: context, loading: waiting);
                        //       // setState(() {
                        //       //   waiting = true;
                        //       // });
                        //       CreateEventService()
                        //           .createEventServices(context,
                        //               title: TempData.evetTitle,
                        //               ageGroup: TempData.ageGroup,
                        //               description: TempData.evetDescription,
                        //               startDate: TempData.evetStartDate,
                        //               category: TempData.category,
                        //               enteryFee: TempData.eventEntryCost,
                        //               guest: TempData.eventKeyGuest,
                        //               fromTime: TempData.evetStartTime,
                        //               endDate: TempData.evetEndDate,
                        //               toTime: TempData.evetEndTime,
                        //               entryType: TempData.eventEntryType,
                        //               venue: TempData.selectVenu,
                        //               venueCapacity: TempData.eventCapcity,
                        //               tags: TempData.eventTags,
                        //               couponCodeController: TempData.couponCode,
                        //               couponDescriptionController:
                        //                   TempData.couponCodeDescription,
                        //               draft: false,
                        //               thumbnailImg: globalController
                        //                   .eventThumbnailImgPath.value,
                        //               images: globalController.eventPhotosmgPath)
                        //           .then((value) {
                        //         if (value.responseStatus == ResponseStatus.success) {
                        //           setState(() {
                        //             waiting = false;
                        //           });
                        //           // clearAllTempData();
                        //           // Navigator.pop(context);

                        //           // Navigator.pushNamedAndRemoveUntil(
                        //           //   context,
                        //           //   HomeMain.routeName,
                        //           //   (route) => true,
                        //           // );
                        //           onSaveBottomsheet();
                        //         }
                        //         if (value.responseStatus == ResponseStatus.failed) {
                        //           setState(() {
                        //             waiting = false;
                        //           });
                        //           Navigator.pop(context);
                        //         }
                        //       });
                        //     },
                        //     text: 'Save'),

                        MyElevatedButton(
                      onPressed: () {
                        if (isSaved) {
                          Fluttertoast.showToast(
                            msg: "Your event has been saved already",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          onSaveBottomsheet();
                        } else {
                          log("check entry type ${TempData.eventEntryType}");

                          CreateEventService()
                              .createEventServices(
                            context,
                            title: TempData.evetTitle,
                            ageGroup: TempData.ageGroup,
                            description: TempData.evetDescription,
                            startDate: TempData.evetStartDate,
                            category: TempData.category,
                            enteryFee: TempData.eventEntryCost,
                            guest: TempData.eventKeyGuest,
                            fromTime: TempData.evetStartTime,
                            endDate: TempData.evetEndDate,
                            toTime: TempData.evetEndTime,
                            entryType: TempData.eventEntryType,
                            venue: TempData.selectVenu,
                            venueCapacity: TempData.eventCapcity,
                            tags: TempData.eventTags,
                            couponCodeController: TempData.couponCode,
                            couponDescriptionController:
                                TempData.couponCodeDescription,
                            draft: false,
                            thumbnailImg:
                                globalController.eventThumbnailImgPath.value,
                            images: globalController.eventPhotosmgPath,
                          )
                              .then((value) {
                            setState(() {
                              waiting = false;
                            });

                            if (value.responseStatus ==
                                ResponseStatus.success) {
                              setState(() {
                                isSaved = true; // Update the saved status
                              });
                              // clearAllTempData();
                              // Navigator.pop(context);
                              onSaveBottomsheet();
                            } else if (value.responseStatus ==
                                ResponseStatus.failed) {
                              setState(() {
                                waiting = false;
                              });
                              Navigator.pop(context);
                            }
                          });
                        }
                      },
                      text: isSaved ? 'Share' : 'Save',
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                    child: myElevatedButtonOutline(
                      // loader: waiting
                      //           ? const CircularProgressIndicator()
                      //           : const SizedBox(),
                      onPressed: () {
                        showWaitingDialoge(context: context, loading: waiting);
                        setState(() {
                          waiting = true;
                        });
                        CreateEventService()
                            .createEventServices(context,
                                title: TempData.evetTitle,
                                ageGroup: TempData.ageGroup,
                                description: TempData.evetDescription,
                                startDate: TempData.evetStartDate,
                                category: TempData.category,
                                enteryFee: TempData.eventEntryCost,
                                guest: TempData.eventKeyGuest,
                                fromTime: TempData.evetStartTime,
                                endDate: TempData.evetEndDate,
                                toTime: TempData.evetEndTime,
                                entryType: TempData.eventEntryType,
                                venue: TempData.selectVenu,
                                venueCapacity: TempData.eventCapcity,
                                couponCodeController: TempData.couponCode,
                                couponDescriptionController:
                                    TempData.couponCodeDescription,
                                draft: true,
                                tags: TempData.eventTags,
                                thumbnailImg: globalController
                                    .eventThumbnailImgPath.value,
                                images: globalController.eventPhotosmgPath)
                            .then((value) {
                          if (value.responseStatus == ResponseStatus.success) {
                            setState(() {
                              waiting = false;
                            });
                            clearAllTempData();
                            Navigator.pop(context);

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeMain.routeName,
                              (route) => true,
                            );
                          }
                          if (value.responseStatus == ResponseStatus.failed) {
                            setState(() {
                              waiting = false;
                            });
                            Navigator.pop(context);
                          }
                        });
                      },
                      text: 'Save as draft',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  clearAllTempData() {
    TempData.eventCapcity = '';
    TempData.ageGroup = '';
    TempData.category = '';
    TempData.selectVenu = '';
    TempData.eventEntryType = '';
    TempData.eventEntryCost = '';
    TempData.eventKeyGuest = '';
    globalController.eventPhotosmgPath.clear();
    globalController.eventThumbnailImgPath.value = '';
  }

  void onSaveBottomsheet() {
    Get.bottomSheet(isScrollControlled: true, BottomSheetContent());
  }
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
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

  @override
  Widget build(BuildContext context) {
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
                  Image.asset(
                    "assets/images/x.png",
                    height: 24,
                    width: 24,
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
            // Image.file(
            //   IO.File(globalController.eventThumbnailImgPath.value),
            //   width: 325,
            //   height: 139,
            //   fit: BoxFit.cover,
            // ),

            // Container(
            //     height: 1, width: double.infinity, color: Color(0xFF424242)),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Obx(() {
            //       return Transform.scale(
            //         scale: 1,
            //         child: Checkbox(
            //           side: BorderSide(color: Color(0xFFE8C98B)),
            //           value: sharecheck.value,
            //           activeColor: Color(0xFFFFFFFF),
            //           // shape: BeveledRectangleBorder(
            //           //     side: BorderSide(color: Colors.white)),
            //           checkColor: Color(0xFFE8C98B),
            //           onChanged: (bool? value) {
            //             sharecheck.value = value!;
            //           },
            //         ),
            //       );
            //     }),
            //     Text("Share on Good TImes social media",
            //         style: TextStyle(
            //           fontSize: 12,
            //           fontWeight: FontWeight.w400,
            //           fontFamily: 'Poppins',
            //           color: Color(0xFFE8C98B),
            //         )),
            //   ],
            // ),
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
                              log("Event Id ---->>> ${eventmodelobj!.last.id + 1}");
                              showWaitingDialoge(
                                  context: context, loading: waiting);
                              setState(() {
                                waiting = true;
                              });
                              SocialShareService()
                                  .socialShare(context,
                                      eventid: eventmodelobj!.last.id + 1,
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
                              log("Event Id ---->>> ${eventmodelobj!.last.id + 1}");
                              showWaitingDialoge(
                                  context: context, loading: waiting);
                              setState(() {
                                waiting = true;
                              });
                              SocialShareService()
                                  .socialShare(context,
                                      eventid: eventmodelobj!.last.id + 1,
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
                                      eventid: eventmodelobj!.last.id + 1,
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
                                      eventid: eventmodelobj!.last.id + 1,
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
  }
}

void onShareBottomsheet() {
  bool instagramcheck = false;
  bool facebookcheck = false;
  bool twittercheck = false;

  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: const Color(0xFF252527),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: StatefulBuilder(
          // Added to make setState available
          builder: (context, setState) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "Share thumbnail",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Color(0xFFD0D0D0),
                      ),
                    ),
                    Spacer(),
                    Image.asset(
                      "assets/images/x.png",
                      height: 24,
                      width: 24,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(height: 1, width: double.infinity, color: Colors.white),
              SizedBox(height: 20),
              Image.file(
                IO.File(globalController.eventThumbnailImgPath.value),
                width: 325,
                height: 139,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Container(
                height: 1,
                width: double.infinity,
                color: Color(0xFF424242),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialMediaIcon(
                    context: context,
                    imagePath: "assets/images/skill-icons_instagram.png",
                    isSelected: instagramcheck,
                    onTap: () {
                      setState(() {
                        instagramcheck = !instagramcheck;
                        facebookcheck = false;
                        twittercheck = false;
                      });
                    },
                  ),
                  SizedBox(width: 15),
                  _buildSocialMediaIcon(
                    context: context,
                    imagePath: "assets/images/logos_facebook.png",
                    isSelected: facebookcheck,
                    onTap: () {
                      setState(() {
                        instagramcheck = false;
                        facebookcheck = !facebookcheck;
                        twittercheck = false;
                      });
                    },
                  ),
                  SizedBox(width: 15),
                  _buildSocialMediaIcon(
                    context: context,
                    imagePath: "assets/images/ant-design_x-outlined.png",
                    isSelected: twittercheck,
                    onTap: () {
                      setState(() {
                        instagramcheck = false;
                        facebookcheck = false;
                        twittercheck = !twittercheck;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                  height: 1, width: double.infinity, color: Color(0xFF424242)),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MyElevatedButton(
                  onPressed: () {
                    if (instagramcheck) () {};
                    if (facebookcheck) () {};
                    if (twittercheck) () {};
                  },
                  text: 'Share',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildSocialMediaIcon({
  required BuildContext context,
  required String imagePath,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Stack(
    children: [
      InkWell(
        onTap: onTap,
        child: Image.asset(
          imagePath,
          height: 48,
          width: 48,
        ),
      ),
      if (isSelected)
        Positioned(
          top: 0,
          right: 0,
          child: Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
    ],
  );
}
