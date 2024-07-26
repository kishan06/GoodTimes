import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/view-models/global_controller.dart';
import 'package:good_times/views/screens/about-us/about_us.dart';
import 'package:good_times/views/screens/contact-us/contact_us.dart';
import 'package:good_times/views/screens/faq/faq.dart';
import 'package:good_times/views/screens/termCondition-privacyPolicy/privacy_and_polcy.dart';
import 'package:good_times/views/screens/termCondition-privacyPolicy/term_condition.dart';
import '../../../data/repository/services/delete_account.dart';
import '../../widgets/common/bottom_sheet.dart';
import '../../widgets/common/button.dart';
import '../../widgets/common/parent_widget.dart';
import '../auth/registration/welcome_screen.dart';
import 'feedback.dart';
import 'notification_setting.dart';

class Settings extends StatefulWidget {
  static const String routeName = 'settings';
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController feedBackController = TextEditingController();
  bool waiting = false;
  bool ratingValidation = false;

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final GlobalController globalContoller = Get.find();
  bool switch1 = false;
  List settinghList = [
    
    {"img": "bell", "text": "Notification Settings", "type": "notification"},
    {"img": "help-circle", "text": "FAQ’s", "type": "faq"},
    {"img": "phone-call", "text": "Contact Us", "type": "contact"},
    {"img": "smile", "text": "Feedback", "type": "feedback"},
    {
      "img": "term-condition",
      "text": "Terms & Condition",
      "type": "term&condition"
    },
    {"img": "shield", "text": "Privacy Policy", "type": "privacy&policy"},
    {"img": "alert-circle", "text": "About Us", "type": "about"},
    {"img": "trash", "text": "Delete Account", "type": "delete"},
  ];
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Settings', style: headingStyle),
              const SizedBox(height: 60),
              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if(settinghList[index]["img"]=="bell"){
                        if(globalContoller.hasActiveSubscription.value==false){
                          settinghList.removeAt(0);
                        }
                      }
                      return settingsRow(
                          img:  settinghList[index]["img"],
                          text: settinghList[index]["text"],
                          onTap: () {
                            if (settinghList[index]["type"] == "notification") {
                              Navigator.pushNamed(
                                  context, NotificationSetting.routeName);
                            } else
                             if (settinghList[index]["type"] == "faq") {
                              Navigator.pushNamed(context, FAQs.routeName);
                            } else if (settinghList[index]["type"] == "contact") {
                              Navigator.pushNamed(context, ContactUS.routeName);
                            } else if (settinghList[index]["type"] ==
                                "feedback") {
                              // feedback();
                              Navigator.pushNamed(context, FeedBack.routeName);
                            } else if (settinghList[index]["type"] ==
                                "term&condition") {
                              Navigator.pushNamed(
                                  context, TermAndConditions.routeName);
                            } else if (settinghList[index]["type"] ==
                                "privacy&policy") {
                              Navigator.pushNamed(
                                  context, PrivacyAndPolicy.routeName);
                            } else if (settinghList[index]["type"] == "about") {
                              Navigator.pushNamed(context, AboutUs.routeName);
                            }
                            if (settinghList[index]["type"] == "delete") {
                                  deleteAccount();
                            }
                          });
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(color: Color(0xff292929));
                    },
                    itemCount:globalContoller.hasActiveSubscription.value==false? settinghList.length-1:settinghList.length),
              )
            ],
          ),
        ),
      ),
    );
  }

  settingsRow({img, text, onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SvgPicture.asset('assets/images/setting/$img.svg'),
            const SizedBox(width: 15),
            Text(text, style: labelStyle),
          ],
        ),
      ),
    );
  }
  

  deleteAccount() {
    return normalModelSheet(context,
        isDismissible: true,
        enableDrag: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const Icon(Icons.delete_outline_rounded,color: kPrimaryColor,size: 50),
              // const SizedBox(height: 20),
              Text(
                "Are you sure you want to delete account?",
                style: headingStyle.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Text(
                "Your account will be suspended and your subscription will be cancelled; this action cannot be undone.",
                style: headingStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              MyElevatedButton(
                  onPressed: () {
                    DeleteUserServices().deleteUser(context).then((value) {
                      if (value.responseStatus == ResponseStatus.success) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, WelcomeScreen.routeName, (route) => false);
                        // preferencesList.map((e) => e["selected"]= false);
                      }
                    });
                  },
                  text: 'Yes',),
              const SizedBox(height: 10),
              // ElevatedButton(onPressed: (){}, child: const Text('No')),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'No',
                  style: labelStyle.copyWith(color: kPrimaryColor),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    feedBackController.dispose();
    super.dispose();
  }

}
