import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as getX;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/views/screens/event_manager/refer_friend.dart';
import 'package:good_times/views/screens/event_manager/venue/venue.dart';
import 'package:good_times/views/screens/favorites/favorites.dart';
import 'package:good_times/views/screens/profile/edit_profile.dart';
import 'package:good_times/views/screens/refferal/refer.dart';
import 'package:good_times/views/screens/settings/settings.dart';
import '../../../data/common/scaffold_snackbar.dart';
import '../../../data/models/profile.dart';
import '../../../data/repository/services/logout_service.dart';
import '../../../data/repository/services/profile.dart';
import '../../../utils/constant.dart';
import '../../../view-models/Preferences/Preferences_Controller.dart';
import '../../../view-models/advance_filter_controller.dart';
import '../../../view-models/auth/google_auth.dart';
import '../../../view-models/bootomnavigation_controller.dart';
import '../../../view-models/deep_link_model.dart';
import '../../../view-models/global_controller.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';
import '../event_manager/syncfusion_calendar.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../../widgets/common/bottom_sheet.dart';
import '../../widgets/common/button.dart';
import '../auth/registration/welcome_screen.dart';
import '../home/sidebar-filter/widget/widget.dart';
import '../notification/notification.dart';
import '../subscription/open_website.dart';
import 'edit_preferences.dart';

class Profile extends StatefulWidget {
  static const String routeName = 'profile';
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  HomePageController homePageController = getX.Get.find();
  GlobalController globalContoller = getX.Get.put(GlobalController());
  String? refresh;

  checkReferesh(userData) async {
    refresh = await getX.Get.to(() => EditProfile(profileData: userData),
        arguments: "fromProfile");
    bool booleanValue = refresh == 'true';
    if (booleanValue) {
      setState(() {});
    }
    globalContoller.profileImgPath.value = userData.profilePhoto;
  }

  PreferenceController preferenceController =
      Get.put(PreferenceController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    // log('globalContoller  ${globalContoller.profileImgPath.value}');
    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          leadingWidth: 0,
          title: const Text('Profile', style: headingStyle),
          iconTheme: const IconThemeData(color: kPrimaryColor),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Notifications.routeName);
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 28,
                )),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Settings.routeName);
              },
              icon: const Icon(Icons.settings_outlined, size: 28),
            ),
          ],
        ),
        body: FutureBuilder(
            future: ProfileService().getProfileDetails(context),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                ProfileModel userData = snapshot.data!.data;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            checkReferesh(userData);
                          },
                          child: Row(
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
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${userData.firstName} ${userData.lastName}",
                                    style: labelStyle.copyWith(fontSize: 20),
                                  ),
                                  Text(
                                    userData.email,
                                    style: labelStyle.copyWith(
                                        fontSize: 14,
                                        color: const Color(0xff9D9D9D)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    color: kTextWhite.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData.goingEventCount!
                                          .toString(), //only going data will see here
                                      style: paragraphStyle.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Events Attended',
                                      style:
                                          paragraphStyle.copyWith(fontSize: 14),
                                    ),
                                    // const SizedBox(height: ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 15,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                    color: globalContoller
                                                            .hasActiveSubscription
                                                            .value
                                                        ? kTextSuccess
                                                        : kTextError,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                100))),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                globalContoller
                                                        .hasActiveSubscription
                                                        .value
                                                    ? "Active"
                                                    : "Inactive",
                                                style:
                                                    paragraphStyle.copyWith(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        globalContoller
                                                .hasActiveSubscription.value
                                            ? const SizedBox()
                                            : OutlinedButton(
                                                onPressed: () {
                                                  Get.to(() =>
                                                      const WebViewExample());
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                      width: 1.0,
                                                      color: kPrimaryColor),
                                                ),
                                                child: const Text(
                                                  "Renew",
                                                  style: paragraphStyle,
                                                ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 20),
                        (homePageController.isUser.value == eventManager)
                            ? _userOptions(
                                icon: 'qrcode',
                                text: 'View QR Code',
                                svgs: 1,
                                ontap: () {
                                  Navigator.pushNamed(
                                      context, ReferFriend.routeName);
                                })
                            : _userOptions(
                                icon: 'user',
                                text: 'Refer to earn G-tokens',
                                svgs: 1,
                                ontap: () {
                                  Navigator.pushNamed(
                                      context, Reffer.routeName);
                                }),
                        const Divider(color: Color(0xff5F5F5F)),
                        (homePageController.isUser.value == eventManager)
                            ? _userOptions(
                                icon: 'location',
                                text: 'My Venues',
                                svgs: 1,
                                ontap: () {
                                  Navigator.pushNamed(context, Venue.routeName);
                                })
                            : const SizedBox(),
                        (homePageController.isUser.value == eventManager)
                            ? const Divider(color: Color(0xff5F5F5F))
                            : const SizedBox(),
                        _userOptions(
                          icon: 'user',
                          text: 'Favorites',
                          svgs: 2,
                          ontap: () {
                            Navigator.pushNamed(context, Favorites.routeName);
                          },
                        ),
                        const Divider(color: Color(0xff5F5F5F)),
                        _userOptions(
                            icon: 'events_unselected',
                            text: 'Event Calendar',
                            svgs: 3,
                            ontap: () {
                              Navigator.pushNamed(
                                  context, SyncFusioCalendar.routeName);
                            }),
                        const Divider(color: Color(0xff5F5F5F)),
                        _userOptions(
                            icon: 'edit-preferences',
                            text: 'Edit Preferences',
                            svgs: 1,
                            ontap: () async{
                              if (globalController
                                  .hasActiveSubscription.value) {
                                if (preferenceController
                                    .prefrencecontrollerdata.isEmpty) {
                               
                                    await preferenceController
                                        .eventCategory(context);
                                    print(preferenceController
                                        .prefrencecontrollerdata);
                                  
                                }
                                Navigator.pushNamed(
                                    context, EditPrefrence.routeName);
                              } else {
                                snackBarError(context,
                                    message: 'Please activate your account.');
                              }
                            }),
                        const Divider(color: Color(0xff5F5F5F)),
                        _userOptions(
                          icon: 'user',
                          text: 'Sign Out',
                          svgs: 4,
                          ontap: signOutAccount,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        ReusableSkeletonAvatar(
                          height: 70,
                          width: 70,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ReusableSkeletonParaGraph(
                            width: MediaQuery.of(context).size.width,
                            height: 18,
                            lines: 2,
                            randomLength: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: 10,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        return ReusableSkeletonAvatar(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          borderRadius: BorderRadius.circular(10),
                        );
                      },
                    )
                  ],
                ),
              );
            }),
        bottomNavigationBar: const BottomNavigationBars(),
      )),
    );
  }

  _userOptions({icon, text, svgs, ontap}) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            if (svgs == 1)
              SvgPicture.asset(
                'assets/svg/$icon.svg',
                width: 30,
                height: 30,
              )
            else if (svgs == 2)
              const Icon(
                Icons.favorite_outline,
                color: kPrimaryColor,
                size: 25,
              )
            else if (svgs == 3)
              SvgPicture.asset(
                  'assets/images/bottom_navigation/unselected/$icon.svg')
            else if (svgs == 4)
              const Icon(
                Icons.logout,
                color: kPrimaryColor,
                size: 25,
              ),
            const SizedBox(width: 20),
            Text(
              text,
              style: paragraphStyle,
            ),
          ],
        ),
      ),
    );
  }

  signOutAccount() {
    return normalModelSheet(context,
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
                    } else {
                      advanceFilterController.clearAllFilter();
                    }
                    setState(() {
                      curentIndex.value = 0;
                    });
                    SignOutAccountService().signOutAccountService(context);
                    GetStorage().write('accessToken', null);
                    GetStorage().write('profileStatus', null);
                    globalContoller.accessToken.value = '';
                    globalContoller.profileImgPath.value = '';
                    globalReferralCode = '';
                    AdvanceFilterController().clearAllFilter();

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
        ));
  }
}
