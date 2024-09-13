import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/models/event_age_group_model.dart';
import 'package:good_times/data/models/home_event_modal.dart';
import 'package:good_times/data/repository/services/preferences_service.dart';
import 'package:good_times/view-models/global_controller.dart';
import 'package:good_times/views/screens/event/event_preview.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/common/parent_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/get_preferences_model.dart';
import '../../../data/repository/endpoints.dart';
import '../../../data/repository/response_data.dart';
import '../../../data/repository/services/advance_filter_service.dart';
import '../../../data/repository/services/chat_service.dart';
import '../../../data/repository/services/check_preference.dart';
import '../../../data/repository/services/event_category_drawar.dart';
import '../../../data/repository/services/logout_service.dart';
import '../../../data/repository/services/profile.dart';
import '../../../utils/constant.dart';
import '../../../utils/helper.dart';
import '../../../utils/temp.dart';
import '../../../view-models/Organisation_Controller.dart';
import '../../../view-models/Preferences/Preferences_Controller.dart';
import '../../../view-models/SubscriptionPreference.dart';
import '../../../view-models/advance_filter_controller.dart';
import '../../../view-models/app_version.dart';
import '../../../view-models/auth/google_auth.dart';
import '../../../view-models/bootomnavigation_controller.dart';
import '../../../view-models/location_controller.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../../widgets/common/bottom_sheet.dart';
import '../../widgets/common/desclaimer.dart';
import '../../widgets/common/skeleton.dart';
import '../../widgets/subscriptionmodule.dart';
import '../auth/registration/select_preference.dart';
import '../auth/registration/welcome_screen.dart';
import 'sidebar-filter/sidebar_filter.dart';
import '../subscription/open_website.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String filterTab = 'preference';
  GlobalController globalController = Get.put(GlobalController());
  AppVersionController appVersionController = Get.put(AppVersionController());
  EventCategoryDrawarService eventCategoryDrawarService =
      EventCategoryDrawarService();
  AdvanceFilterController advanceFilterController =
      Get.put(AdvanceFilterController());
  AdvanceFilterService advanceFilterServicee = AdvanceFilterService();
  List eventData = [];
  List<ageData>? ageList = [];

  String? sort;
  PreferenceController preferenceController =
      Get.put(PreferenceController(), permanent: true);
  ProfileExtendedDataController profileextendedcontroller =
      Get.put(ProfileExtendedDataController(), permanent: true);
  OrganisationController organisationController =
      Get.put(OrganisationController(), permanent: true);
  @override
  void initState() {
    super.initState();

    checkFunction();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _showInitialBottomSheet();
      if (profileextendedcontroller.profileextenddata.value.data != null) {
        if (profileextendedcontroller
                    .profileextenddata.value.data!.principalTypeName ==
                "event_user" &&
            !(profileextendedcontroller.profileextenddata.value.data!
                    .hasActiveSubscription!.hasActiveSubscription! ||
                profileextendedcontroller.profileextenddata.value.data!
                    .hasActiveSubscription!.inGracePeriod!)) {
          if (preferenceController.storeselectedPreferenceId.value.isEmpty) {
            PreferencesService().getPreferencesServices(context).then((value) {
              if (value.responseStatus == ResponseStatus.success) {
                PreferencesModel data = value.data;
                preferenceController.storeselectedPreferenceId.value
                    .addAll(data.preferenceList);
              }
            });
          }
        }
      }
      if (organisationController.Organisationdatacontroller.value.data ==
          null) {
        organisationController.getOrganisationData(context);
      }
      if (!globalController.serverError.value) {
        allowfilter.value = false;
        advanceFilterController.eventModalcontroller.value = [];
        advanceFilterServicee.advanceFilterEventServices(context);
      }
     
    });
  }

  Future<void> _showInitialBottomSheet() async {
    var checkifskip = GetStorage().read(TempData.SubscriptionSkip);
    String userid = GetStorage().read(TempData.StoreUserId) ??
        globalController.email.value.toString();

    profileextendedcontroller.fetchProfileExtendeddata(context).then((value) {
      if (profileextendedcontroller.profileextenddata.value.data != null) {
        if (profileextendedcontroller
                    .profileextenddata.value.data!.principalTypeName ==
                'event_user' &&
            !(profileextendedcontroller.profileextenddata.value.data!
                    .hasActiveSubscription!.hasActiveSubscription! ||
                profileextendedcontroller.profileextenddata.value.data!
                    .hasActiveSubscription!.inGracePeriod!)) {
          if (globalController.email != userid || checkifskip != true) {
            Subscriptionmodule(context, "event_user",
                email: globalController.email.value);
          }
          if (profileextendedcontroller
                  .profileextenddata.value.data!.principalpreferencecount! >
              profileextendedcontroller
                  .profileextenddata.value.data!.featureLimit!.categoryLimit!) {
            GetStorage().write(TempData.forceEditPref, true);
            GetStorage().write(
                TempData.StoreUserId, globalController.email.value.toString());

            GetStorage().write(
                TempData.categorylimit,
                profileextendedcontroller.profileextenddata.value.data!
                    .featureLimit!.categoryLimit!);
            TempData.forceedit = true;
            Get.offNamed(SelectPrefrence.routeName);
          }
        }
      }
    });
  }

  checkFunction() {
    CheckPreferenceService().checkPreferenceService(context).then((value) {
      if (value.responseStatus == ResponseStatus.success) {
        // preference = true;
        log('check preferences ${value.data}');

        bool preference = value.data;
        // Set the route based on the preference value here
        if (preference) {
          // If preference is true, navigate to HomeMain
          appVersionController.initPackageInfo(context);
          ProfileService().getProfileDetails(context);
          // advanceFilterServicee.advanceFilterEventServices(context);
          if (preferenceController.prefrencecontrollerdata.isEmpty) {
            preferenceController.eventCategory(context);
          }
          eventCategory();
          getAgeGroup();
        }
      }
    });
  }

  eventCategory() async {
    if (preferenceController.prefrencecontrollerdata.isEmpty) {
      await eventCategoryDrawarService.eventDrawarService(context).then((e) {
        if (e.responseStatus == ResponseStatus.success) {
          setState(() {
            eventData = e.data;
          });
        }
      });
    } else {
      eventData = preferenceController.prefrencecontrollerdata.value;
    }
  }

  getAgeGroup() {
     if(TempData.agedatagroup.isEmpty){
      PreferencesService().getAgeGroup(context).then((value) {
      log("log data of category list in event screen $value");
      setState(() {
         TempData.agedatagroup = value;
        ageList = value;
      });
    });
    }else{
  setState(() {
        ageList = TempData.agedatagroup;
      });
    }
  }
 // HomePageController homePageController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    log("advance filtered called build");

    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
        child: GestureDetector(onTap: () {
          unfoucsKeyboard(context);
        }, child: Obx(() {
          print("r");

          if (!allowfilter.value &&
              advanceFilterController.eventModalcontroller.isNotEmpty) {
            Future.delayed(const Duration(milliseconds: 200), () {
              allowfilter.value = true;
            });
          }
          if (advanceFilterController.eventModalcontroller.isEmpty &&
              !TempData.preventapicall) {
            TempData.preventapicall = true;
            advanceFilterController.clearAllFilter();
            AdvanceFilterService()
                .advanceFilterEventServices(context)
                .then((value) {
              print("rr");
              Future.delayed(const Duration(milliseconds: 200), () {
                allowfilter.value = true;
              });
              TempData.preventapicall = false;
            });
           /*   profileextendedcontroller
                .fetchProfileExtendeddata(context)
                .then((value) {
              TempData.preventextendeddatacall = false;
              if (profileextendedcontroller
                      .profileextenddata.value.data!.principalTypeName ==
                  "event_user") {
                homePageController.isUser.value = eventUser;
              } else if (profileextendedcontroller
                      .profileextenddata.value.data!.principalTypeName ==
                  "event_manager") {
                homePageController.isUser.value = eventManager;
              }
            });
         */    globalController.serverError.value = false;
          }

          return Stack(
            children: [
              Scaffold(
                  drawerEnableOpenDragGesture: false,
                  key: _scaffoldKey,
                  drawer: Builder(
                    builder: (scaffoldContext) =>
                        drawer(scaffoldContext, eventData, ageList),
                  ),
                  body: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      children: [
                        bannerArea(context),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text(
                                'Explore All Events',
                                style: paragraphStyle.copyWith(
                                  color: const Color(0xff6F6F6F),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: kTextWhite,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 18),
                        Obx(() {
                          List<HomeEventsModel> data =
                              advanceFilterController.eventModalcontroller;
                          List<HomeEventsModel> dataList = [];
                          if (data.length > 1) {
                            dataList = data.length > 5 ? data.sublist(5) : [];
                          }
                          int prelength = data.length > 5 ? 5 : data.length;
                          return filterLoder.value
                              ? const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  child: SkeletonEventWidget(),
                                )
                              : data.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 18),
                                          SizedBox(
                                            child: Column(
                                              children: List.generate(prelength,
                                                  (index) {
                                                return eventWidget(
                                                  eventId: data[index].id,
                                                  img: data[index].thumbnail,
                                                  title: data[index]
                                                      .title!
                                                      .capitalizeFirst
                                                      .toString(),
                                                  price: data[index].entryFee,
                                                  date: data[index].startDate,
                                                );
                                              }),
                                            ),
                                          ),
                                          ListView.builder(
                                            itemCount: dataList.length,
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return eventWidget(
                                                eventId: dataList[index].id,
                                                img: dataList[index]
                                                    .thumbnail,
                                                title:
                                                    dataList[index].title,
                                                price: dataList[index]
                                                    .entryFee,
                                                date: dataList[index]
                                                    .startDate,
                                              );
                                            },
                                          ),
                                        ],
                                      ))
                                  : const Text("No data found 😞",
                                      style: headingStyle);
                        }),
                      ],
                    ),
                  ),
                  bottomNavigationBar:
                      profileextendedcontroller.profileextenddata.value.data !=
                              null
                          ? (!(globalController.hasActiveSubscription.value ||
                                      globalController
                                          .hasActiveGracePeriod.value) &&
                                  profileextendedcontroller.profileextenddata
                                          .value.data!.principalTypeName !=
                                      "event_user")
                              ? Subscriptionmodule(context, "event_manager")
                              : const BottomNavigationBars()
                          : null),
            ],
          );
        })),
      ),
    );
  }

  //* sign oput modal start here
  signOutAccount() {
    return normalModelSheet(
      context,
      isDismissible: true,
      enableDrag: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Are you sure you want to\nSign out?',
                style: headingStyle.copyWith(fontSize: 20),
                textAlign: TextAlign.center),
            const SizedBox(height: 25),
            MyElevatedButton(
                onPressed: () {
                  if (advanceFilterController.checkFilterIsClearOrNot()) {
                    //return;
                  } else {
                    advanceFilterController.clearAllFilter();
                  }
                  setState(() {
                    curentIndex.value = 0;
                  });
                  SignOutAccountService().signOutAccountService(context);
                  GetStorage().write('accessToken', null);
                  GetStorage().write('profileStatus', null);
                  globalController.accessToken.value = '';
                  globalController.profileImgPath.value = '';
                  handleSignOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, WelcomeScreen.routeName, (route) => false);
                },
                text: 'Sign Out'),
            const SizedBox(height: 10),
            // ElevatedButton(onPressed: (){}, child: const Text('No')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: labelStyle.copyWith(color: kPrimaryColor),
                )),
          ],
        ),
      ),
    );
  }

  eventWidget({img, title, date, price, eventId}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, EventPreview.routeName,
            arguments: [eventId, null]);

        ChatServices()
            .createChatServices(context, eventId: eventId)
            .then((value) {
          if (value.responseStatus == ResponseStatus.success) {
            log("chat service created ${value.data["name"]}");
          }
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: img,
            placeholder: (context, url) =>
                Image.asset("assets/images/event/event_banner.jpg"),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: img == null
                      ? const DecorationImage(
                          image: AssetImage(
                              'assets/images/event/event_banner.jpg'),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: kTextWhite,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Exclusive',
                          style: paragraphStyle.copyWith(color: kTextBlack),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: kTextWhite,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child:
                            Image.asset('assets/images/event/blue_flame.png'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: labelStyle,
                ),
              ),
              Text(
                '£ ${price ?? ''}',
                style: paragraphStyle,
              )
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '$date',
            style: paragraphStyle.copyWith(fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //* baner area start here
  Widget bannerArea(context) {
    return GestureDetector(
      onTap: () {
        unfoucsKeyboard(context);
      },
      child: SizedBox(
        height: 262,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/banner.jpeg',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kTextBlack.withOpacity(0.6), // Adjust the opacity as needed
                    kTextBlack.withOpacity(0.8), // Adjust the opacity as needed
                    kTextBlack,
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                'Discover your city’s best\nevents & experiences',
                style: headingStyle.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    !allowfilter.value
                        ? Expanded(
                            child: ReusableSkeletonAvatar(
                              height: 40,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )
                        : Expanded(
                            child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: const Color(0xff676767)
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5)),
                                child: CupertinoSearchTextField(
                                  controller: advanceFilterController
                                      .titleController.value,
                                  style: const TextStyle(color: kTextWhite),
                                  decoration: const BoxDecoration(),
                                  placeholder: "Search",
                                  prefixIcon: const Icon(
                                    CupertinoIcons.search,
                                    color: kPrimaryColor,
                                  ),
                                  suffixIcon: const Icon(
                                    CupertinoIcons.xmark_circle_fill,
                                    color: kPrimaryColor,
                                  ),
                                  onSuffixTap: () {
                                    advanceFilterController
                                        .titleController.value
                                        .clear();
                                    advanceFilterServicee
                                        .advanceFilterEventServices(context);
                                    unfoucsKeyboard(context);
                                  },
                                  onChanged: (e) {
                                    if (e.length > 2) {
                                      advanceFilterController
                                          .homeFilterLocation(e);
                                      advanceFilterServicee
                                          .advanceFilterEventServices(context);
                                    }
                                  },
                                )),
                          ),
                    const SizedBox(width: 10),
                    !allowfilter.value
                        ? ReusableSkeletonAvatar(
                            height: 40,
                            width: 87,
                            borderRadius: BorderRadius.circular(5),
                          )
                        : InkWell(
                            onTap: () async {
                              if (latlong == null) {
                                LocationPermission permission =
                                    await Geolocator.checkPermission();
                                if (permission ==
                                        LocationPermission.whileInUse ||
                                    permission == LocationPermission.always) {
                                  Position currentP =
                                      await Geolocator.getCurrentPosition();
                                  latlong = LatLng(
                                      currentP.latitude, currentP.longitude);
                                }
                              }
                              if (profileextendedcontroller.profileextenddata
                                          .value.data!.principalTypeName ==
                                      "event_user" &&
                                  !(profileextendedcontroller
                                          .profileextenddata
                                          .value
                                          .data!
                                          .hasActiveSubscription!
                                          .hasActiveSubscription! ||
                                      profileextendedcontroller
                                          .profileextenddata
                                          .value
                                          .data!
                                          .hasActiveSubscription!
                                          .inGracePeriod!)) {
                                if (preferenceController
                                    .storeselectedPreferenceId.value.isEmpty) {
                                  await PreferencesService()
                                      .getPreferencesServices(context)
                                      .then((value) {
                                    if (value.responseStatus ==
                                        ResponseStatus.success) {
                                      PreferencesModel data = value.data;
                                      preferenceController
                                          .storeselectedPreferenceId.value
                                          .addAll(data.preferenceList);
                                    }
                                  });
                                }
                              }
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xff676767).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // const Icon(Icons.settings, color: kPrimaryColor),
                                  SvgPicture.asset("assets/svg/settings.svg"),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Filter",
                                    style: paragraphStyle.copyWith(
                                        color: kTextWhite),
                                  ),
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SkeletonEventWidget extends StatelessWidget {
  const SkeletonEventWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            ReusableSkeletonAvatar(
              height: 250,
              width: MediaQuery.of(context).size.width,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableSkeletonAvatar(
                        height: 10,
                        width: MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(height: 10),
                      ReusableSkeletonAvatar(
                        height: 10,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: ReusableSkeletonAvatar(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
