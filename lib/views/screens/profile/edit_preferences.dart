import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../../data/repository/response_data.dart';
import '../../../data/repository/services/preferences_service.dart';
import '../../../data/models/get_preferences_model.dart';
import '../../../utils/loading.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';

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

  @override
  void initState() {
    super.initState();
    callTheApi();
  }

  callTheApi() {
    PreferencesService().getPreferencesServices(context).then((value) {
      // Logger().t("chekc response ${value.responseStatus}");
      if (value.responseStatus == ResponseStatus.success) {
        PreferencesModel data = value.data;
        prefrencesList = data.preferenceList;
        for (var element in preferencesList) {
          if (data.preferenceList.contains(element["id"])) {
            element["selected"] = true;
          } else {
            element["selected"] = false;
          }
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
                  itemCount: preferencesList.length,
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
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1.4),
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      preferencesList[index]["selected"] = !preferencesList[index]["selected"];
              
                      if (preferencesList[index]["selected"] == true) {
                        prefrencesList.add(preferencesList[index]["id"]);
                      } else {
                        prefrencesList.remove(preferencesList[index]["id"]);
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
                            width: !preferencesList[index]["selected"] ? 1 : 3),
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
                onPressed: waiting
                    ? null
                    : () {
                        if (prefrencesList.length >= 1) {
                          showWaitingDialoge(context:context,loading: waiting);
                          setState(() {
                            waiting = true;
                          });
                          PreferencesService()
                              .postPreferences(context,
                                  categoriesList: prefrencesList)
                              .then((value) {
                            if (value.responseStatus ==ResponseStatus.success) {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, HomeMain.routeName);
                              setState(() {
                                waiting = false;
                              });
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
    );
  }
}
