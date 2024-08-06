import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:good_times/data/models/ProfileExtend_model.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../../../data/repository/endpoints.dart';
import '../../../../data/repository/response_data.dart';
import '../../../../data/repository/services/event_category_drawar.dart';
import '../../../../data/repository/services/preferences_service.dart';
import '../../../../utils/loading.dart';
import '../../../../utils/temp.dart';
import '../../../../view-models/Preferences/Preferences_Controller.dart';
import '../../../../view-models/SubscriptionPreference.dart';
import '../../../widgets/common/parent_widget.dart';

class SelectPrefrence extends StatefulWidget {
  static const String routeName = 'selectPrefrence';
  const SelectPrefrence({super.key});

  @override
  State<SelectPrefrence> createState() => _SelectPrefrenceState();
}

class _SelectPrefrenceState extends State<SelectPrefrence> {
  List<int> prefrenceList = [];
  bool waiting = false;
  PreferenceController preferenceController =
      Get.put(PreferenceController(), permanent: true);
  ProfileExtendedDataController profileextendedcontroller =
      Get.put(ProfileExtendedDataController(), permanent: true);
  @override
  void initState() {
    super.initState();
    if (preferenceController.prefrencecontrollerdata.isEmpty) {
      preferenceController.eventCategory(context);
      print(preferenceController.prefrencecontrollerdata);
    }
    if (TempData.userType == "event_user") {
      profileextendedcontroller.fetchProfileExtendeddata(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: parentWidgetWithConnectivtyChecker(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Select your\npreferences',
                    style: headingStyle,
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    if (preferenceController.selectedpreference.isEmpty &&
                        preferenceController
                            .prefrencecontrollerdata.isNotEmpty) {
                      preferenceController.selectedpreference.value =
                          List.filled(
                              preferenceController
                                  .prefrencecontrollerdata.value.length,
                              false);
                    }
                    return Expanded(
                      child: preferenceController
                              .prefrencecontrollerdata.isEmpty
                          ? Center(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.05,
                                child: const CircularProgressIndicator(
                                  color: kPrimaryColor,
                                ),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 1.4),
                              itemBuilder: (_, index) {
                                String imageurl =
                                    "${preferenceController.prefrencecontrollerdata.value[index].image}";
                                String title =
                                    "${preferenceController.prefrencecontrollerdata.value[index].title}";
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      preferenceController
                                              .selectedpreference[index] =
                                          !preferenceController
                                              .selectedpreference[index];
                                      if (preferenceController
                                              .selectedpreference[index] ==
                                          true) {
                                        if (prefrenceList.length ==
                                                profileextendedcontroller
                                                    .profileextenddata
                                                    .value
                                                    .data!
                                                    .featureLimit!
                                                    .categoryLimit &&
                                            TempData.userType == "event_user") {
                                          preferenceController
                                                  .selectedpreference[index] =
                                              false;
                                          Get.snackbar("Selection Limitation",
                                              "For now you can only select ${profileextendedcontroller.profileextenddata.value.data!.featureLimit!.categoryLimit} to complete the process.");
                                        } else {
                                          prefrenceList.add(preferenceController
                                              .prefrencecontrollerdata
                                              .value[index]
                                              .id);
                                        }
                                      } else {
                                        prefrenceList.remove(
                                            preferenceController
                                                .prefrencecontrollerdata
                                                .value[index]
                                                .id);
                                      }
                                    });
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      height: 110,
                                      decoration: BoxDecoration(
                                        color: /*  !preferencesList[index]["selected"]
                                      ? Colors.transparent
                                      : */
                                            preferenceController
                                                    .selectedpreference[index]
                                                ? Colors.transparent
                                                : const Color(0xffffffff)
                                                    .withOpacity(0.1),
                                        border: Border.all(
                                            color: kPrimaryColor,
                                            width:
                                                /*  !preferencesList[index]["selected"] ? 1 :  */
                                                !preferenceController
                                                            .selectedpreference[
                                                        index]
                                                    ? 1
                                                    : 3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                placeholder: (context, url) =>
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: kPrimaryColor,
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
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
                              itemCount: preferenceController
                                  .prefrencecontrollerdata.length,
                            ),
                    );
                  }),
                  // ignore: prefer_const_constructors
                  SizedBox(height: 30),
                  MyElevatedButton(
                      //  loader: waiting
                      //           ? const CircularProgressIndicator()
                      //           : const SizedBox(),
                      onPressed: () {
                        if (prefrenceList.length >= 1) {
                          showWaitingDialoge(
                              context: context, loading: waiting);
                          setState(() {
                            waiting = true;
                          });
                          PreferencesService()
                              .postPreferences(context,
                                  categoriesList: prefrenceList)
                              .then((value) {
                            if (value.responseStatus ==
                                ResponseStatus.success) {
                              setState(() {
                                waiting = false;
                              });
                              Navigator.pop(context);
                              Navigator.pushNamed(context, HomeMain.routeName);
                            }
                            if (value.responseStatus == ResponseStatus.failed) {
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
                      },
                      text: 'Continue'),
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
          ),
        ));
  }
}
