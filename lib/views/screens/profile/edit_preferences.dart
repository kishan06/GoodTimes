import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../../data/repository/response_data.dart';
import '../../../data/repository/services/preferences_service.dart';
import '../../../data/models/get_preferences_model.dart';
import '../../../utils/loading.dart';
import '../../../view-models/Preferences/Preferences_Controller.dart';
import '../../../view-models/SubscriptionPreference.dart';
import '../../widgets/common/desclaimer.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';
import '../../widgets/subscriptionmodule.dart';
import '../subscription/open_website.dart';

class EditPrefrence extends StatefulWidget {
  static const String routeName = 'editPrefrence';
  const EditPrefrence({super.key});

  @override
  State<EditPrefrence> createState() => EditPrefrenceState();
}

class EditPrefrenceState extends State<EditPrefrence> {
  List<int> prefrencesList = [];
  bool waiting = false;
  bool isLoading = true;
  PreferenceController preferenceController = Get.find<PreferenceController>();
  ProfileExtendedDataController profileextendedcontroller =
      Get.find<ProfileExtendedDataController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await callTheApi().then((value) {
        print(preferenceController.prefrencecontrollerdata);
      });
    });
  }

  Future<void> callTheApi() async {
    PreferencesService().getPreferencesServices(context).then((value) {
      if (value.responseStatus == ResponseStatus.success) {
        PreferencesModel data = value.data;
        prefrencesList = data.preferenceList;
        for (int i = 0; i < prefrencesList.length; i++) {
          int index = prefrencesList[i];
          preferenceController.selectedpreference[index - 1] = true;
        }
        setState(() {
          isLoading = false;
        });
      } else if (value.responseStatus == ResponseStatus.failed) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return parentWidgetWithConnectivtyChecker(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kPrimaryColor),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReusableSkeletonAvatar(
                    height: 15,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1.4),
                  itemBuilder: (_, index) => Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReusableSkeletonAvatar(
                        height: 110,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                  itemCount:
                      preferenceController.prefrencecontrollerdata.length,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
        child: Column(
          children: [
            const Text(
              'Edit your preferences',
              style: headingStyle,
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (preferenceController.selectedpreference.isEmpty &&
                  preferenceController.prefrencecontrollerdata.isNotEmpty) {
                preferenceController.selectedpreference.value = List.filled(
                    preferenceController.prefrencecontrollerdata.value.length,
                    false);
              }
              return Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1.4),
                  itemBuilder: (_, index) {
                    String imageurl =
                        "${preferenceController.prefrencecontrollerdata.value[index].image}";
                    String title =
                        "${preferenceController.prefrencecontrollerdata.value[index].title}";

                    return GestureDetector(
                      onTap: () {
                        if (profileextendedcontroller
                                .profileextenddata
                                .value
                                .data!
                                .hasActiveSubscription!
                                .hasActiveSubscription! ||
                            profileextendedcontroller.profileextenddata.value
                                .data!.hasActiveSubscription!.inGracePeriod!) {
                          setState(() {
                            preferenceController.selectedpreference[index] =
                                !preferenceController.selectedpreference[index];
                            if (preferenceController
                                    .selectedpreference[index] ==
                                true) {
                              prefrencesList.add(preferenceController
                                  .prefrencecontrollerdata.value[index].id);
                            } else {
                              prefrencesList.remove(preferenceController
                                  .prefrencecontrollerdata.value[index].id);
                            }
                          });
                        } else {
                          Get.snackbar(
                              "Join Us", "Please Subscribe to Edit the preferences.");
                        }
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          height: 110,
                          decoration: BoxDecoration(
                            color: /*  !preferencesList[index]["selected"]
                                      ? Colors.transparent
                                      : */
                                preferenceController.selectedpreference[index]
                                    ? Colors.transparent
                                    : const Color(0xffffffff).withOpacity(0.1),
                            border: Border.all(
                                color: kPrimaryColor,
                                width:
                                    /*  !preferencesList[index]["selected"] ? 1 :  */
                                    !preferenceController
                                            .selectedpreference[index]
                                        ? 1
                                        : 3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                child: CachedNetworkImage(
                                    cacheKey: " ${title}1",
                                    key: UniqueKey(),
                                    imageUrl: imageurl,
                                    height: 30,
                                    width: 30,
                                    placeholder: (context, url) => Container(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover),
                              ),
                              // SvgPicture.asset(preferencesList[index]["img"]),
                              const SizedBox(height: 7),
                              Text(
                                title.replaceAll("&", "&\n"),
                                // preferencesList[index]["headTxt"],
                                style: paragraphStyle,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount:
                      preferenceController.prefrencecontrollerdata.length,
                ),
              );
            }),
            // ignore: prefer_const_constructors
            SizedBox(height: 30),
            MyElevatedButton(
                onPressed: waiting
                    ? null
                    : () {
                        if (profileextendedcontroller
                                .profileextenddata
                                .value
                                .data!
                                .hasActiveSubscription!
                                .hasActiveSubscription! ||
                            profileextendedcontroller.profileextenddata.value
                                .data!.hasActiveSubscription!.inGracePeriod!) {
                          if (prefrencesList.length >= 1) {
                            showWaitingDialoge(
                                context: context, loading: waiting);
                            setState(() {
                              waiting = true;
                            });
                            PreferencesService()
                                .postPreferences(context,
                                    categoriesList: prefrencesList)
                                .then((value) {
                              if (value.responseStatus ==
                                  ResponseStatus.success) {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, HomeMain.routeName);
                                setState(() {
                                  waiting = false;
                                });
                              }
                              if (value.responseStatus ==
                                  ResponseStatus.failed) {
                                snackBarError(context,
                                    message:
                                        "Something went wrong, please try again.");
                                setState(() {
                                  waiting = false;
                                });
                                Navigator.pop(context);
                              }
                            });
                          } else {
                            snackBarError(context,
                                message: 'Please select at least one services');
                          }
                        } else {
                          redirectsubscribe(context);
                        }
                      },
                text: profileextendedcontroller.profileextenddata.value.data!
                            .hasActiveSubscription!.hasActiveSubscription! ||
                        profileextendedcontroller.profileextenddata.value.data!
                            .hasActiveSubscription!.inGracePeriod!
                    ? 'Continue'
                    : "Join Us"),
            // TextButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, SubScription.routeName);
            //   },
            //   child: Text(
            //     'skip',
            //     style: labelStyle.copyWith(color: kPrimaryColor),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
