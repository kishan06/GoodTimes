// ignore_for_file: prefer_const_constructors, library_prefixes

import 'dart:convert';
import 'dart:developer';
import 'dart:io' as IO;
import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:good_times/data/repository/services/get_event_services.dart';
import 'package:good_times/data/repository/services/social_share.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/event_manager/edit_event.dart/edit_event.dart';
import 'package:good_times/views/screens/event_manager/edit_event.dart/edit_event_title.dart';
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
import 'Widget/sharemodule.dart';

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
  EventsModel? eventsmodeldata;
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: WillPopScope(
        onWillPop: () async {
          // Navigate to the HomeMain screen and remove all previous routes
          if (isSaved) {
            clearAllTempData();
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeMain.routeName,
              (route) => true,
            );
          } else {
            Get.back();
          }
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
                  if (isSaved) {
                    clearAllTempData();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      HomeMain.routeName,
                      (route) => true,
                    );
                  } else {
                    Get.back();
                  }
                },
                icon: Icon(Icons.arrow_back),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    if (isSaved) {
                      if (eventsmodeldata != null) {
                        Get.to(
                          () => EditEventTitile(eventData: eventsmodeldata!),
                        );
                      }

                      // Get.to(
                      //                                     () => EditEventTitile(eventData: data),
                      //                                   );
                    } else {
                      Navigator.pop(context);
                    }
                  },
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
                    child: MyElevatedButton(
                      onPressed: () async {
                        if (isSaved) {
                          onSaveBottomsheet(context,
                              eventid: eventmodelobj!.last.id + 1);
                        } else {
                          if (!waiting) {
                            log("check entry type ${TempData.eventEntryType}");
                            showWaitingDialoge(
                                context: context, loading: waiting);
                            setState(() {
                              waiting = true;
                            });
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
                                .then((value) async {
                              if (value.responseStatus ==
                                  ResponseStatus.success) {
                                var response = await GetEventServices()
                                    .getEventDetails(context,
                                        getEventId: eventmodelobj!.last.id + 1);

                                log("responses store in model --- >  $response");
                                eventsmodeldata = response;
                                setState(() {
                                  waiting = false;
                                  Get.back();
                                  isSaved = true; // Update the saved status
                                });
                                Fluttertoast.showToast(
                                    msg: "Your event has been saved");
                                // clearAllTempData();
                                // Navigator.pop(context);
                                Future.delayed(Duration(milliseconds: 400), () {
                                  onSaveBottomsheet(context,
                                      eventid: eventmodelobj!.last.id + 1);
                                });
                              } else if (value.responseStatus ==
                                  ResponseStatus.failed) {
                                setState(() {
                                  waiting = false;
                                });
                                Navigator.pop(context);
                              }
                            });
                          }
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
}
