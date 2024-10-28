// ignore_for_file: prefer_const_constructors, library_prefixes
import 'dart:developer';
import 'dart:io' as IO;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/data/repository/services/event_manager.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/event_manager/create-event/Widget/sharemodule.dart';
import 'package:good_times/views/screens/event_manager/edit_event.dart/edit_event.dart';
import 'package:good_times/views/screens/event_manager/home.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/events_model.dart';
import '../../../../data/models/profile.dart';
import '../../../../data/repository/services/create_event.dart';
import '../../../../data/repository/services/profile.dart';
import '../../../../utils/loading.dart';
import '../../../../utils/temp.dart';
import '../../../../view-models/evevnt_filter_controller.dart';
import '../../../../view-models/global_controller.dart';
import '../../../widgets/common/parent_widget.dart';

class EditedEventPreview extends StatefulWidget {
  static const String routeName = "editedEventPreview";
  final EventsModel eventData;
  bool draftpage = false;
  EditedEventPreview(
      {super.key, required this.eventData, this.draftpage = false});

  @override
  State<EditedEventPreview> createState() => _CreatedEventPreviewState();
}

class _CreatedEventPreviewState extends State<EditedEventPreview> {
  GlobalController globalController = Get.find();
  bool waiting = false;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    // log("times start date ${TempData.editEvetStartDate} end date ${TempData.editEvetEndDate}");
    // final  eventData = ModalRoute.of(context)!.settings.arguments;
    logger.e("Logger images ${TempData.editEventPhotos}");
    return parentWidgetWithConnectivtyChecker(
      child: WillPopScope(
        onWillPop: () async {
          // Navigate to the HomeMain screen and remove all previous routes
          // clearAllTempData();
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
        child: Scaffold(
          appBar: AppBar(
            title: Text('Preview', style: labelStyle.copyWith(fontSize: 20)),
            iconTheme: IconThemeData(color: kPrimaryColor),
            automaticallyImplyLeading: false, // Disable the default back button
            leading: IconButton(
              onPressed: () {
                // clearAllTempData();
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
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.edit_outlined)),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (globalController.thumbImgType.value == ImgTypes.network.index)
                    ? Image.network(
                        globalController.thumbImgPath.value,
                        width: double.infinity,
                        height: 342,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        IO.File(globalController.thumbImgPath.value),
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
                        '${DateFormat('EEEE MMM dd, yyyy').format(TempData.editEvetStartDate)}     ${TempData.editEvetStartTime.format(context)}',
                        style: paragraphStyle,
                      ),
                      SizedBox(height: 8),
                      Text(
                        TempData.editEvetTitle,
                        style: headingStyle.copyWith(fontSize: 24),
                      ),
                      SizedBox(height: 13),
                      Text('Location',
                          style:
                              labelStyle.copyWith(fontWeight: FontWeight.w500)),
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
                              child: Text(TempData.editEvetAddress,
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
                                  "${getTimeDifference(TempData.editEvetStartTime, TempData.editEvetEndTime)}",
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
                              child: Text(TempData.editeventEntryType,
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
                          style:
                              labelStyle.copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: 5),
                      Text(TempData.editEvetDescription, style: paragraphStyle),
                      SizedBox(height: 15),
                      Text('Key Guest',
                          style:
                              labelStyle.copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: 5),
                      Text(TempData.editeventKeyGuest, style: paragraphStyle),
                      if (widget.draftpage)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          ],
                        ),
                      Text('Tags',
                          style:
                              labelStyle.copyWith(fontWeight: FontWeight.w500)),
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
                              itemCount: TempData.editEventTags.length,
                              itemBuilder: (context, index) => Text(
                                  "#${TempData.editEventTags[index]}",
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
                              // Text(
                              //   'Lorem ipsum dolor sit amet, consectetur\nadipiscie Ut et massa mi. Aliquam',
                              //   style: paragraphStyle.copyWith(
                              //     fontSize: 14,
                              //     color: Color(0xff8C8C8C),
                              //   ),
                              //   textAlign: TextAlign.center,
                              // )
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
                      //  loader: waiting
                      //             ? const CircularProgressIndicator()
                      //             : const SizedBox(),
                      onPressed: () {
                        if (isSaved) {
                          print("//");
                          onSaveBottomsheet(context,
                              eventid: widget.eventData.id,
                              eventData: widget.eventData,
                              editpath: true);
                        } else {
                          if (!waiting) {
                            showWaitingDialoge(
                                context: context, loading: waiting);
                            setState(() {
                              waiting = true;
                            });
                            CreateEventService()
                                .editEventServices(
                              context,
                              eventId: widget.eventData.id,
                              title: TempData.editEvetTitle,
                              ageGroup: TempData.editageGroup,
                              description: TempData.editEvetDescription,
                              startDate: TempData.editEvetStartDate,
                              category: TempData.editcategoryID,
                              enteryFee: TempData.editeventEntryCost,
                              guest: TempData.editeventKeyGuest,
                              fromTime: TempData.editEvetStartTime,
                              endDate: TempData.editEvetEndDate,
                              toTime: TempData.editEvetEndTime,
                              entryType: TempData.editeventEntryType,
                              venue: TempData.editselectVenuId,
                              venueCapacity: TempData.editeventCapcity,
                              draft: false,
                              thumbnailImg: globalController
                                          .eventThumbnailImgPath.value ==
                                      ''
                                  ? widget.eventData.thumbnail
                                  : globalController
                                      .eventThumbnailImgPath.value,
                              images: tempImgs,
                              tags: TempData.editEventTags,
                            )
                                .then((value) {
                              if (value.responseStatus ==
                                  ResponseStatus.success) {
                                setState(() {
                                  waiting = false;
                                  Get.back();
                                  isSaved = true; // Update the saved status
                                });
                                onSaveBottomsheet(context,
                                    eventid: widget.eventData.id,
                                    eventData: widget.eventData,
                                    editpath: true);
                                Fluttertoast.showToast(
                                    msg: "Your event has been saved");

                                // clearAllTempData();
                              }
                              if (value.responseStatus ==
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
                      text: isSaved ? 'Share' : 'Save'),
                ),
                SizedBox(height: 30),
              ],
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
