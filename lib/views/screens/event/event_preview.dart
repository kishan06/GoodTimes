import 'dart:developer';
import 'dart:ui';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/view-models/global_controller.dart';
import 'package:good_times/views/screens/chat/chat.dart';
import 'package:good_times/views/screens/event/wiget/slier.dart';
import 'package:good_times/views/widgets/common/bottom_sheet.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Globalconstant/constant.dart';
import '../../../Globalconstant/constantfunction.dart';
import '../../../data/models/events_model.dart';
import '../../../data/repository/services/create_chat.dart';
import '../../../data/repository/services/event_count.dart';
import '../../../data/repository/services/event_review.dart';
import '../../../data/repository/services/event_share_count.dart';
import '../../../data/repository/services/get_event_services.dart';
import '../../../utils/loading.dart';
import '../../../view-models/copy_clipboard.dart';
import '../../../view-models/deep_link_model.dart';
import '../../../view-models/evevnt_filter_controller.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';
import '../../widgets/subscriptionmodule.dart';
import '../event_manager/edit_event.dart/edit_event_title.dart';
import 'map_view.dart';

class EventPreview extends StatefulWidget {
  static const String routeName = 'eventPreview';
  const EventPreview({super.key});

  @override
  State<EventPreview> createState() => _EventPreviewState();
}

class _EventPreviewState extends State<EventPreview> {
  GlobalController globalController = Get.put(GlobalController());
  int _rating = 0; // Initial rating value
  TextEditingController feedBackController = TextEditingController();
  bool waiting = false;
  bool ratingValidation = false;
  List<String>? sliderImage;

  @override
  void initState() {
    super.initState();
    log('event id called');
    EventCountReportServices()
        .eventCountReportServices(context, id: Get.arguments[0]);
    sliderImage = [];
  }


  @override
  Widget build(BuildContext context) {
    final List<dynamic>? arg =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>?;
    int eventInnerPreview = arg![0];
    // log("eventInnerPreview ${eventInnerPreview}");
    var eventsData = arg[1];
    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
        child: FutureBuilder(
            future: GetEventServices()
                .getEventDetails(context, getEventId: eventInnerPreview),
            builder: (context, snapshot) {
              CreateEventsChatGroup()
                  .createEventsChatGroup(context, chatId: eventInnerPreview);
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something wet wronng."),
                );
              } else if (snapshot.hasData) {
                log("check events data ${snapshot.data}");
                EventsModel data = snapshot.data!;
                log("check events data ${data}");

                DateTime startDate = DateTime.parse(
                    "${data.startDate}"); //convert string date into date formate
                //!check before 48 hours edit events
                var canEdit = isDateTimeLessThanOrEqualToSubtractedDate(
                    endDate: data.startDate, startTime: data.startTime);
                String formattedTime = DateFormat('hh:mm a').format(
                    DateTime.parse('${data.startDate} ${data.startTime}'));
                sliderImage = [data.thumbnail!, ...data.images!];

                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    iconTheme: const IconThemeData(color: kPrimaryColor),
                    actions: [
                      eventsData != null
                          ? !globalController.hasActiveSubscription.value
                              ? const SizedBox()
                              : IconButton(
                                  onPressed: () {
                                    if (canEdit) {
                                      Get.to(
                                        () => EditEventTitile(eventData: data),
                                      );
                                    } else {
                                      snackBarError(context,
                                          message:
                                              'Event editing is permissible exclusively within a 48-hour window prior.');
                                    }
                                  },
                                  icon: const Icon(Icons.edit),
                                )
                          : const SizedBox(),
                      !(globalController.hasActiveSubscription.value ||
                              globalController.hasActiveGracePeriod.value)
                          ? const SizedBox()
                          : IconButton(
                              onPressed: () {
                                // Navigator.pushNamed(context, Favorites.routeName);
                                GetEventServices()
                                    .eventLike(context, eventId: data.id)
                                    .then((value) {
                                  if (value.responseStatus ==
                                      ResponseStatus.success) {
                                    setState(() {});
                                  }
                                });
                              },
                              icon: data.isLiked!
                                  ? const Icon(Icons.favorite)
                                  : const Icon(Icons.favorite_outline),
                            ),
                      !globalController.hasActiveSubscription.value
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () {
                                EasyDebounce.debounce('my-debouncer',
                                    const Duration(milliseconds: 700), () {
                                  initDeepLinkData(
                                      eventInnerPreview, 'event_id');
                                  generateLink(context).then((value) {
                                    CopyClipboardAndSahreController().shareLink(
                                        data: value,
                                        message:
                                            "Hey there! I've got something super exciting to share with you – an event you won't want to miss! Click the link to get all the juicy details! 🎉");
                                  }).then((value) {
                                    EventShareCountReportServices()
                                        .eventShareCountReportServices(context,
                                            id: Get.arguments[0]);
                                  });
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/share.png',
                                  width: 25,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                    ],
                  ),
                  body: SingleChildScrollView(
                      // reverse: true,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      thumbnailSlider(context, imageList: sliderImage),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: scaffoldPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              "${DateFormat('EEEE MMM dd, yyyy').format(startDate)} $formattedTime",
                              style: paragraphStyle,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${data.title!.capitalizeFirst}",
                              style: headingStyle.copyWith(fontSize: 24),
                            ),
                            const SizedBox(height: 13),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    globalController
                                            .hasActiveSubscription.value
                                        ? Get.to(() => ChatScreens(
                                              eventIds: eventInnerPreview,
                                            ))
                                        : snackBarError(context,
                                            message:
                                                'Please activate your account.');
                                  },
                                  child: Container(
                                    width: 166,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: kTextWhite.withOpacity(0.18),
                                      borderRadius:
                                          BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/svg/message-circle.svg'),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Join Live Chat',
                                          style: paragraphStyle.copyWith(
                                              color:
                                                  const Color(0xffC5C5C5)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Location',
                                      style: labelStyle.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                 /*    if ((globalController
                                            .hasActiveSubscription.value ||
                                        globalController
                                            .hasActiveGracePeriod.value)) */
                                      TextButton(
                                        onPressed: () async {
                                           if (!(globalController
                                            .hasActiveSubscription.value ||
                                        globalController
                                            .hasActiveGracePeriod.value)){
                                              Subscriptionmodule(context,"event_user");
                                            }else{
                                          currentmarkerIcon =
                                              await getCustomMarker(
                                                  "assets/images/themelocation.png",
                                                  60,
                                                  80);
                                          /* BitmapDescriptor
                                                  .defaultMarker; */
                                          LatLng destinationlatlng = LatLng(
                                              double.parse(data
                                                  .venu.latitude
                                                  .toString()),
                                              double.parse(data
                                                  .venu.longitude
                                                  .toString()));
                                          globaldestinationmarkers = Marker(
                                            markerId: const MarkerId(
                                                "_sourceLocation"), //google
                                            icon: currentmarkerIcon,
                                            position: destinationlatlng,
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                backgroundColor:
                                                    Colors.white,
                                                builder:
                                                    (BuildContext context) {
                                                  return Container(
                                                    width: double.infinity,
                                                    decoration: const BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(
                                                                    15.0),
                                                            topRight: Radius
                                                                .circular(
                                                                    15.0))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .all(16),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize
                                                                .min,
                                                        children: [
                                                          Text(
                                                            "${data.title!.capitalizeFirst}",
                                                            style: headingStyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        24),
                                                          ),
                                                          const SizedBox(
                                                              height: 13),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .location_on,
                                                                color:
                                                                    kPrimaryColor,
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      10),
                                                              Expanded(
                                                                  child: Text(
                                                                      "${data.venu.address}",
                                                                      style:
                                                                          paragraphStyle))
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .watch_later_outlined,
                                                                color:
                                                                    kPrimaryColor,
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      10),
                                                              Expanded(
                                                                child: Text(
                                                                    "${getTimeDifference(stringToTimeOfDay("${data.startTime}"), stringToTimeOfDay("${data.endTime}")).toStringAsFixed(1)}",
                                                                    style:
                                                                        paragraphStyle),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                          const Divider(),
                                                          const SizedBox(
                                                              height: 12),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  'About this event',
                                                                  style: labelStyle.copyWith(
                                                                      fontWeight:
                                                                          FontWeight.w500)),
                                                              const SizedBox(
                                                                  height:
                                                                      5),
                                                              Text(
                                                                  "${data.description!.capitalizeFirst}",
                                                                  style:
                                                                      paragraphStyle),
                                                              data.keyGuest ==
                                                                          ' ' ||
                                                                      data.keyGuest ==
                                                                          null
                                                                  ? const SizedBox(
                                                                      height:
                                                                          15)
                                                                  : const SizedBox(),
                                                              data.keyGuest!
                                                                      .isNotEmpty
                                                                  ? Text(
                                                                      'Key Guest',
                                                                      style:
                                                                          labelStyle.copyWith(fontWeight: FontWeight.w500))
                                                                  : const SizedBox(),
                                                              data.keyGuest!
                                                                      .isNotEmpty
                                                                  ? const SizedBox(
                                                                      height:
                                                                          5)
                                                                  : const SizedBox(),
                                                              data.keyGuest!
                                                                      .isNotEmpty
                                                                  ? Text(
                                                                      "${data.keyGuest!.capitalizeFirst}",
                                                                      style:
                                                                          paragraphStyle)
                                                                  : const SizedBox(),
                                                              data.couponCode!
                                                                      .isNotEmpty
                                                                  ? const SizedBox(
                                                                      height:
                                                                          15)
                                                                  : const SizedBox(),
                                                              const SizedBox(
                                                                  height:
                                                                      5),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 16),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                          Get.to(() => MapViews(
                                                eventLocation: LatLng(
                                                    double.parse(data
                                                        .venu.latitude
                                                        .toString()),
                                                    double.parse(data
                                                        .venu.longitude
                                                        .toString())),
                                              ));
                                          }  },
                                        child: Text(
                                          "Show Map",
                                          style: paragraphStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Text("${data.venu.address}",
                                            style: paragraphStyle))
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.watch_later_outlined,
                                      color: kPrimaryColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                          "${getTimeDifference(stringToTimeOfDay("${data.startTime}"), stringToTimeOfDay("${data.endTime}")).toStringAsFixed(1)}",
                                          style: paragraphStyle),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: scaffoldPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('About this event',
                                    style: labelStyle.copyWith(
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 5),
                                Text("${data.description!.capitalizeFirst}",
                                    style: paragraphStyle),
                                data.keyGuest == ' ' ||
                                        data.keyGuest == null
                                    ? const SizedBox(height: 15)
                                    : const SizedBox(),
                                data.keyGuest!.isNotEmpty
                                    ? Text('Key Guest',
                                        style: labelStyle.copyWith(
                                            fontWeight: FontWeight.w500))
                                    : const SizedBox(),
                                data.keyGuest!.isNotEmpty
                                    ? const SizedBox(height: 5)
                                    : const SizedBox(),
                                data.keyGuest!.isNotEmpty
                                    ? Text(
                                        "${data.keyGuest!.capitalizeFirst}",
                                        style: paragraphStyle)
                                    : const SizedBox(),
                                data.couponCode!.isNotEmpty
                                    ? const SizedBox(height: 15)
                                    : const SizedBox(),
                                data.couponCode!.isNotEmpty
                                    ? Text('Coupon Code',
                                        style: labelStyle.copyWith(
                                            fontWeight: FontWeight.w500))
                                    : const SizedBox(),
                                data.couponCode!.isNotEmpty
                                    ? const SizedBox(height: 5)
                                    : const SizedBox(),
                                data.couponCode!.isNotEmpty
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              "${data.couponCode!.capitalizeFirst}",
                                              style: paragraphStyle),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                              onTap: () {
                                                EasyDebounce.debounce(
                                                    'my-debouncer',
                                                    const Duration(
                                                        milliseconds: 500),
                                                    () {
                                                  CopyClipboardAndSahreController()
                                                      .copyToClipboard(
                                                          context,
                                                          data.couponCode);
                                                });
                                              },
                                              child: const Icon(
                                                Icons.content_copy_rounded,
                                                color: kPrimaryColor,
                                                size: 25,
                                              )),
                                        ],
                                      )
                                    : const SizedBox(),
                                data.couponCodeDescription!.isNotEmpty
                                    ? const SizedBox(height: 15)
                                    : const SizedBox(),
                                data.couponCodeDescription!.isNotEmpty
                                    ? Text('Coupon Code Descriptions',
                                        style: labelStyle.copyWith(
                                            fontWeight: FontWeight.w500))
                                    : const SizedBox(),
                                data.couponCodeDescription!.isNotEmpty
                                    ? const SizedBox(height: 5)
                                    : const SizedBox(),
                                data.couponCodeDescription!.isNotEmpty
                                    ? Text(
                                        "${data.couponCodeDescription!.capitalizeFirst}",
                                        style: paragraphStyle)
                                    : const SizedBox(),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: scaffoldPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Popularity',
                                      style: labelStyle.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _popularityModal,
                                      child: Text(
                                        'Learn More',
                                        style: paragraphStyle.copyWith(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 13),
                                Row(
                                  children: [
                                    Image.asset(
                                        'assets/images/event/blue_flame.png'),
                                    const SizedBox(width: 8),
                                    const Text('Hype’s through the roof',
                                        style: paragraphStyle),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Text('For this event?',
                                    style: labelStyle.copyWith(
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: (data.interactions == null)
                                          ? myElevatedButtonOutline(
                                              onPressed: () {
                                                globalController
                                                        .hasActiveSubscription
                                                        .value
                                                    ? GetEventServices()
                                                        .eventIntrestedAndGoing(
                                                        context,
                                                        eventId:
                                                            eventInnerPreview,
                                                        intrestedAndGoing:
                                                            'interested',
                                                      )
                                                    : snackBarError(context,
                                                        message:
                                                            'Please activate your account.');
                                                // setState(() {});
                                              },
                                              text: 'Interested')
                                          : (data.interactions != null &&
                                                  data.interactions ==
                                                      'interested')
                                              ? MyElevatedButton(
                                                  onPressed: () {
                                                    globalController
                                                            .hasActiveSubscription
                                                            .value
                                                        ? GetEventServices()
                                                            .eventIntrestedAndGoing(
                                                                context,
                                                                eventId:
                                                                    eventInnerPreview,
                                                                intrestedAndGoing:
                                                                    'interested')
                                                        : snackBarError(
                                                            context,
                                                            message:
                                                                'Please activate your account.');
                                                    setState(() {});
                                                  },
                                                  text: 'Interested')
                                              : myElevatedButtonOutline(
                                                  onPressed: () {
                                                    globalController
                                                            .hasActiveSubscription
                                                            .value
                                                        ? GetEventServices()
                                                            .eventIntrestedAndGoing(
                                                                context,
                                                                eventId:
                                                                    eventInnerPreview,
                                                                intrestedAndGoing:
                                                                    'interested')
                                                        : snackBarError(
                                                            context,
                                                            message:
                                                                'Please activate your account.');
                                                    setState(() {});
                                                  },
                                                  text: 'Interested'),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 3,
                                      child: (data.interactions == null)
                                          ? myElevatedButtonOutline(
                                              onPressed: () {
                                                globalController
                                                        .hasActiveSubscription
                                                        .value
                                                    ? GetEventServices()
                                                        .eventIntrestedAndGoing(
                                                            context,
                                                            eventId:
                                                                eventInnerPreview,
                                                            intrestedAndGoing:
                                                                'going')
                                                    : snackBarError(context,
                                                        message:
                                                            'Please activate your account.');
                                                setState(() {});
                                              },
                                              text: 'Going')
                                          : (data.interactions != null &&
                                                  data.interactions ==
                                                      'going')
                                              ? MyElevatedButton(
                                                  onPressed: () {
                                                    globalController
                                                            .hasActiveSubscription
                                                            .value
                                                        ? GetEventServices()
                                                            .eventIntrestedAndGoing(
                                                                context,
                                                                eventId:
                                                                    eventInnerPreview,
                                                                intrestedAndGoing:
                                                                    'going')
                                                        : snackBarError(
                                                            context,
                                                            message:
                                                                'Please activate your account.');
                                                    setState(() {});
                                                  },
                                                  text: 'Going')
                                              : myElevatedButtonOutline(
                                                  onPressed: () {
                                                    globalController
                                                            .hasActiveSubscription
                                                            .value
                                                        ? GetEventServices()
                                                            .eventIntrestedAndGoing(
                                                                context,
                                                                eventId:
                                                                    eventInnerPreview,
                                                                intrestedAndGoing:
                                                                    'going')
                                                        : snackBarError(
                                                            context,
                                                            message:
                                                                'Please activate your account.');
                                                    setState(() {});
                                                  },
                                                  text: 'Going'),
                                    ),
                                    const Expanded(
                                        flex: 2, child: SizedBox())
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Divider(),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: scaffoldPadding),
                            child: Column(
                              children: [
                                data.eventReview.isNotEmpty
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Reviews & Ratings',
                                              style: labelStyle.copyWith(
                                                  fontWeight:
                                                      FontWeight.w500)),
                                          GestureDetector(
                                            onTap: () {
                                              reviewList(data);
                                            },
                                            child: Text('View All',
                                                style:
                                                    paragraphStyle.copyWith(
                                                        color:
                                                            kPrimaryColor)),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                data.eventReview.isNotEmpty
                                    ? Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: kPrimaryColor,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 10),
                                          Text('5.0',
                                              style: labelStyle.copyWith(
                                                  color: kPrimaryColor,
                                                  fontWeight:
                                                      FontWeight.w500)),
                                        ],
                                      )
                                    : const SizedBox(),
                                data.eventReview.isNotEmpty
                                    ? const SizedBox(height: 10)
                                    : const SizedBox(),
                                data.eventReview.isNotEmpty
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${data.eventReview[0].reviewUserData.firstName} ${data.eventReview[0].reviewUserData.lastName}",
                                                    style: paragraphStyle),
                                                Row(
                                                  children: [
                                                    Text(
                                                      data.eventReview[0]
                                                          .reviewStar
                                                          .toString(),
                                                      style: paragraphStyle
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12),
                                                    ),
                                                    const SizedBox(
                                                        width: 5),
                                                    Row(
                                                      children:
                                                          List.generate(
                                                        5,
                                                        (index) => index <
                                                                data
                                                                    .eventReview[
                                                                        0]
                                                                    .reviewStar
                                                            ? const Icon(
                                                                Icons.star,
                                                                size: 15,
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .star_border,
                                                                size: 15,
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  data.eventReview[0]
                                                      .reviewText,
                                                  style: paragraphStyle
                                                      .copyWith(
                                                    fontSize: 14,
                                                    color: const Color(
                                                        0xff8C8C8C),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                data.eventReview.isNotEmpty
                                    ? const SizedBox(height: 30)
                                    : const SizedBox(),
                                // Padding( padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),child:
                                // ),
                                myElevatedButtonOutline(
                                  onPressed: () {
                                    globalController
                                            .hasActiveSubscription.value
                                        ? _rateThisEvent()
                                        : snackBarError(context,
                                            message:
                                                'Please activate your account.');
                                  },
                                  text: 'Help Boost the Event Rating',
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 40),
                          GestureDetector(
                            onTap: () {
                              globalController.hasActiveSubscription.value
                                  ? _viewManagerProfile(data: data)
                                  : snackBarError(context,
                                      message:
                                          'Please activate your account.');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: scaffoldPadding),
                              child: Center(
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100),
                                      child: data.venu.createdBy
                                                  .profilePhoto ==
                                              ''
                                          ? Image.asset(
                                              'assets/images/avatar.jpg',
                                              width: 67,
                                              height: 67,
                                              fit: BoxFit.cover)
                                          : Image.network(
                                              data.venu.createdBy
                                                  .profilePhoto,
                                              width: 67,
                                              height: 67,
                                              fit: BoxFit.cover),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Organized By',
                                      style: paragraphStyle.copyWith(
                                          fontSize: 12,
                                          color: const Color(0xff8C8C8C)),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${data.venu.createdBy.firstName.capitalizeFirst} ${data.venu.createdBy.lastName.capitalizeFirst}",
                                      style: paragraphStyle.copyWith(
                                          fontSize: 18,
                                          color: const Color(0xffE3E3E3),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      data.venu.createdBy.email,
                                      style: paragraphStyle.copyWith(
                                        fontSize: 14,
                                        color: const Color(0xff8C8C8C),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Click here for more info",
                                      style: paragraphStyle.copyWith(
                                          fontSize: 16,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ],
                  )),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              return Scaffold(
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: kPrimaryColor),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      ReusableSkeletonAvatar(
                        height: 340,
                        width: MediaQuery.of(context).size.width,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      const SizedBox(height: 20),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: 20,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          return ReusableSkeletonAvatar(
                            height: 25,
                            width: MediaQuery.of(context).size.width,
                            borderRadius: BorderRadius.circular(10),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  _popularityModal() {
    return modalBottomShetWidget(
      context,
      title: 'Popularity',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
        child: Column(
          children: [
            _popularity('Hype’s through the roof', 'blue'),
            _popularity('Hype’s through the stratosphere', 'orange'),
            _popularity('Hype’s off the charts', 'red'),
          ],
        ),
      ),
    );
  }

  Padding _popularity(text, icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset('assets/images/event/${icon}_flame.png'),
          const SizedBox(width: 5),
          Text(
            text,
            style: labelStyle,
          )
        ],
      ),
    );
  }

  _viewManagerProfile({data}) {
    EventsModel data1 = data;

    modalBottomShetWidget(
      context,
      title: 'Manager Profile',
      defaultHeight: MediaQuery.of(context).size.height * 0.7,
      child: StatefulBuilder(builder: (context, setStates) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: data1.venu.createdBy.profilePhoto == ''
                                  ? Image.asset('assets/images/avatar.jpg',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover)
                                  : Image.network(
                                      data1.venu.createdBy.profilePhoto,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Organized By',
                              style: paragraphStyle.copyWith(
                                  fontSize: 12, color: const Color(0xff8C8C8C)),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${data1.venu.createdBy.firstName} ${data1.venu.createdBy.lastName}",
                              style: paragraphStyle.copyWith(
                                  fontSize: 18,
                                  color: const Color(0xffE3E3E3),
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              data1.venu.createdBy.email,
                              style: paragraphStyle.copyWith(
                                fontSize: 14,
                                color: const Color(0xff8C8C8C),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              data1.venu.createdBy.phone == null
                                  ? ''
                                  : data1.venu.createdBy.phone.toString(),
                              style: paragraphStyle.copyWith(
                                fontSize: 14,
                                color: const Color(0xff8C8C8C),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      data1.venu.createdBy.instagram == null ||
                              data1.venu.createdBy.instagram == ""
                          ? const SizedBox()
                          : const SizedBox(height: 20),
                      data1.venu.createdBy.instagram == null ||
                              data1.venu.createdBy.instagram == ""
                          ? const SizedBox()
                          : const Text(
                              'Instagram',
                              style: labelStyle,
                            ),
                      data1.venu.createdBy.instagram == null ||
                              data1.venu.createdBy.instagram == ""
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                _launchUrl(data1.venu.createdBy.instagram);
                              },
                              child: Text(
                                '${data1.venu.createdBy.instagram}',
                                style:
                                    labelStyle.copyWith(color: kPrimaryColor),
                              ),
                            ),
                      data1.venu.createdBy.instagram == null ||
                              data1.venu.createdBy.instagram == ""
                          ? const SizedBox()
                          : const Divider(),
                      data1.venu.createdBy.instagram == null ||
                              data1.venu.createdBy.instagram == ""
                          ? const SizedBox()
                          : const SizedBox(height: 20),
                      data1.venu.createdBy.facebook == null ||
                              data1.venu.createdBy.facebook == ""
                          ? const SizedBox()
                          : const Text(
                              'Facebook',
                              style: labelStyle,
                            ),
                      data1.venu.createdBy.facebook == null ||
                              data1.venu.createdBy.facebook == ""
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                _launchUrl(data1.venu.createdBy.facebook);
                              },
                              child: Text(
                                '${data1.venu.createdBy.facebook}',
                                style:
                                    labelStyle.copyWith(color: kPrimaryColor),
                              ),
                            ),
                      data1.venu.createdBy.facebook == null ||
                              data1.venu.createdBy.facebook == ""
                          ? const SizedBox()
                          : const Divider(),
                      data1.venu.createdBy.facebook == null ||
                              data1.venu.createdBy.facebook == ""
                          ? const SizedBox()
                          : const SizedBox(height: 20),

                      //!
                      data1.venu.createdBy.linkedin == null ||
                              data1.venu.createdBy.linkedin == ""
                          ? const SizedBox()
                          : const Text(
                              'Linkedin',
                              style: labelStyle,
                            ),
                      data1.venu.createdBy.linkedin == null ||
                              data1.venu.createdBy.linkedin == ""
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                _launchUrl(data1.venu.createdBy.linkedin);
                              },
                              child: Text(
                                '${data1.venu.createdBy.linkedin}',
                                style:
                                    labelStyle.copyWith(color: kPrimaryColor),
                              ),
                            ),
                      data1.venu.createdBy.linkedin == null ||
                              data1.venu.createdBy.linkedin == ""
                          ? const SizedBox()
                          : const Divider(),
                      data1.venu.createdBy.linkedin == null ||
                              data1.venu.createdBy.linkedin == ""
                          ? const SizedBox()
                          : const SizedBox(height: 20),

                      //!

                      data1.venu.createdBy.youtube == null ||
                              data1.venu.createdBy.youtube == ""
                          ? const SizedBox()
                          : const Text(
                              'Youtube',
                              style: labelStyle,
                            ),
                      data1.venu.createdBy.youtube == null ||
                              data1.venu.createdBy.youtube == ""
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                _launchUrl(data1.venu.createdBy.youtube);
                              },
                              child: Text(
                                '${data1.venu.createdBy.youtube}',
                                style:
                                    labelStyle.copyWith(color: kPrimaryColor),
                              ),
                            ),
                      data1.venu.createdBy.youtube == null ||
                              data1.venu.createdBy.youtube == ""
                          ? const SizedBox()
                          : const Divider(),

                      data1.venu.createdBy.youtube == null ||
                              data1.venu.createdBy.youtube == ""
                          ? const SizedBox()
                          : const SizedBox(height: 20),
                      data1.venu.createdBy.website == null ||
                              data1.venu.createdBy.website == ""
                          ? const SizedBox()
                          : const Text(
                              'Website',
                              style: labelStyle,
                            ),
                      data1.venu.createdBy.website == null ||
                              data1.venu.createdBy.website == ""
                          ? const SizedBox()
                          : InkWell(
                              onTap: () {
                                _launchUrl(data1.venu.createdBy.website);
                              },
                              child: Text(
                                '${data1.venu.createdBy.website}',
                                style:
                                    labelStyle.copyWith(color: kPrimaryColor),
                              ),
                            ),
                      data1.venu.createdBy.website == null ||
                              data1.venu.createdBy.website == ""
                          ? const SizedBox()
                          : const Divider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  _rateThisEvent() {
    var eventInnerPreview = ModalRoute.of(context)!.settings.arguments;
    final _key = GlobalKey<FormState>();
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0,
          backgroundColor: kTextBlack,
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: StatefulBuilder(builder: (context, setStates) {
              return Form(
                key: _key,
                autovalidateMode: autovalidateMode,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            5,
                            (index) => GestureDetector(
                                  onTap: () {
                                    setStates(() {
                                      _rating = index + 1;
                                    });
                                    if (_rating > 0) {
                                      setStates(() {
                                        ratingValidation = false;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    _rating > index
                                        ? Icons.star
                                        : Icons.star_outline,
                                    color: _rating > index
                                        ? kPrimaryColor
                                        : kPrimaryColor, // Change color based on rating
                                    size: 42,
                                  ),
                                )),
                      ),
                      ratingValidation
                          ? const Text(
                              'Please provide a rating',
                              style: TextStyle(color: kTextError, fontSize: 14),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 25),
                      const Text('Write down your feedback here',
                          style: labelStyle),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: feedBackController,
                        maxLines: 6, //or null
                        decoration: InputDecoration(
                          hintText: "Write your review",
                          hintStyle: paragraphStyle.copyWith(
                              color: kTextWhite.withOpacity(0.6)),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.all(20.0),
                        ),
                        style: paragraphStyle,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some feedback';
                          }
                          if (value.length < 5) {
                            return 'Please  enter more than 5 character';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      MyElevatedButton(
                          //  loader: waiting
                          //     ? const CircularProgressIndicator()
                          //     : const SizedBox(),
                          onPressed: () {
                            _key.currentState!.validate();
                            autovalidateMode = AutovalidateMode.always;
                            if (_rating == 0) {
                              setStates(() {
                                ratingValidation = true;
                              });
                            }
                            if (_key.currentState!.validate() &&
                                ratingValidation == false) {
                              showWaitingDialoge(
                                  context: context, loading: waiting);
                              setState(() {
                                waiting = true;
                              });
                              EventReviewsService()
                                  .eventReviewsService(
                                context,
                                eventId: eventInnerPreview,
                                rating: _rating,
                                eventDescriptions: feedBackController.text,
                              )
                                  .then((value) {
                                if (value.responseStatus ==
                                    ResponseStatus.success) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  feedBackController.clear();
                                  _rating = 0;
                                  setState(() {
                                    waiting = false;
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
                          },
                          text: 'Submit'),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }

  reviewList(EventsModel data) {
    List datas = data.eventReview;
    Logger().e("User data ${datas[0].reviewUserData.profilePhoto}");
    return showBarModalBottomSheet(
      context: context,
      barrierColor: const Color(0xff000000).withOpacity(0.8),
      backgroundColor: kTextBlack.withOpacity(0.55),
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.size.height * 0.8),
          child: Padding(
            padding: const EdgeInsets.only(
                left: scaffoldPadding, right: scaffoldPadding, top: 50),
            child: ListView.separated(
              itemCount: datas.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: FadeInImage.assetNetwork(
                            height: 70,
                            width: 70,
                            placeholder: 'assets/images/avatar.jpg',
                            image: (datas[index].reviewUserData.profilePhoto ==
                                        '' ||
                                    datas[index].reviewUserData.profilePhoto ==
                                        null)
                                ? "https://imgs.search.brave.com/xKTJI0CZ0ySkNOdZadFhi5SlJi3nvxtQo9NnWcn09jg/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTA2/NzcwNzE1MC92ZWN0/b3IvYXZhdGFyLmpw/Zz9zPTYxMng2MTIm/dz0wJms9MjAmYz1T/T1pPU1gtSmprN29f/SXpKaDJIcHFSSHVi/dnlKT0xucnlyeEM3/dndLNGFJPQ"
                                : datas[index].reviewUserData.profilePhoto,
                            fit: BoxFit.cover,
                          )),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${datas[index].reviewUserData.firstName} ${datas[index].reviewUserData.lastName}",
                              style: paragraphStyle.copyWith(
                                  color: kPrimaryColor, fontSize: 22)),
                          Row(
                            children: [
                              Text(
                                datas[index].reviewStar.toString(),
                                style: paragraphStyle.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              const SizedBox(width: 5),
                              Row(
                                children: List.generate(
                                  5,
                                  (index2) => index2 < datas[index].reviewStar
                                      ? const Icon(
                                          Icons.star,
                                          size: 18,
                                        )
                                      : const Icon(
                                          Icons.star_border,
                                          size: 18,
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            datas[index].reviewText,
                            style: paragraphStyle.copyWith(
                              fontSize: 15,
                              color: const Color.fromARGB(255, 229, 226, 226),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 50, child: Divider());
              },
            ),
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
}
