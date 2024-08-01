import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../../../data/repository/endpoints.dart';
import '../../../../data/repository/response_data.dart';
import '../../../../data/repository/services/event_category_drawar.dart';
import '../../../../data/repository/services/preferences_service.dart';
import '../../../../utils/loading.dart';
import '../../../../view-models/Preferences/Preferences_Controller.dart';
import '../../../widgets/common/parent_widget.dart';

class SelectPrefrence extends StatefulWidget {
  static const String routeName = 'selectPrefrence';
  const SelectPrefrence({super.key});

  @override
  State<SelectPrefrence> createState() => _SelectPrefrenceState();
}

class _SelectPrefrenceState extends State<SelectPrefrence> {
  List<int> prefrenceList = [];
  //List preferencesList=[];
  bool waiting = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      for (var item in preferencesList) {
        item['selected'] = false;
      }
    });
  }

  PreferenceController preferenceController= Get.put(PreferenceController(),permanent:true);
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
                  GestureDetector(
                    onTap: () async{
                     await preferenceController.eventCategory(context);
                      print(preferenceController.prefrencecontrollerdata);
  
                    },
                    child: const Text(
                      'Select your\npreferences',
                      style: headingStyle,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 1.4),
                      itemBuilder: (_, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            preferencesList[index]["selected"] =
                                !preferencesList[index]["selected"];
                            if (preferencesList[index]["selected"] == true) {
                              prefrenceList.add(preferencesList[index]["id"]);
                            } else {
                              prefrenceList.remove(preferencesList[index]["id"]);
                            }
                          });
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 110,
                            decoration: BoxDecoration(
                              color: !preferencesList[index]["selected"]
                                  ? Colors.transparent
                                  : const Color(0xffffffff).withOpacity(0.1),
                              border: Border.all(
                                  color: kPrimaryColor,
                                  width:
                                      !preferencesList[index]["selected"] ? 1 : 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(preferencesList[index]["img"]),
                                const SizedBox(height: 7),
                                Text(
                                  preferencesList[index]["headTxt"],
                                  style: paragraphStyle,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      itemCount: preferencesList.length,
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(height: 30),
                  MyElevatedButton(
                    //  loader: waiting
                    //           ? const CircularProgressIndicator()
                    //           : const SizedBox(),
                      onPressed:  () {
                              if (prefrenceList.length >= 1) {
                                showWaitingDialoge(context:context,loading: waiting);
                                setState(() {
                                  waiting = true;
                                });
                                PreferencesService()
                                    .postPreferences(context,
                                        categoriesList: prefrenceList)
                                    .then((value) {
                                  if (value.responseStatus ==ResponseStatus.success) {
                                    setState(() {
                                      waiting = false;
                                    });
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, HomeMain.routeName);
                                  }
                                  if (value.responseStatus == ResponseStatus.failed) {
                                    snackBarError(context,message:"Something went wrong, please try again.");
                                    setState(() {
                                      waiting = false;
                                    });
                                     Navigator.pop(context);
                                  }
                                });
                              } else {
                                snackBarError(context,message:'Please select at least one services');
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
