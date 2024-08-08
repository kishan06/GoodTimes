 //* sign oput modal start here
  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/repository/services/logout_service.dart';
import '../../utils/constant.dart';
import '../../view-models/advance_filter_controller.dart';
import '../../view-models/auth/google_auth.dart';
import '../screens/auth/registration/welcome_screen.dart';
import 'common/bottom_navigation.dart';
import 'common/bottom_sheet.dart';
import 'common/button.dart';
import 'common/parent_widget.dart';
  AdvanceFilterController advanceFilterController =
      Get.put(AdvanceFilterController());
signOutAccount(BuildContext context) {
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
                 
                    curentIndex.value = 0;
                  
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