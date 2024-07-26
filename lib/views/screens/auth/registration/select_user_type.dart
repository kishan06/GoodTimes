
import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/utils/temp.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../../widgets/common/parent_widget.dart';
import 'email_verify.dart';

class SelectUserType extends StatefulWidget {
  static String routeName = 'selectUserType';
  const SelectUserType({super.key});

  @override
  State<SelectUserType> createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
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
              const Text('Let’s get started', style: headingStyle),
              const SizedBox(height: 10),
              Text(
                'Select the user type',
                style: paragraphStyle.copyWith(
                  color: const Color(0xffBABABA),
                ),
              ),
              const SizedBox(height: 50),
              myElevatedButtonOutline(
                  onPressed: () {
                    Navigator.pushNamed(context, EmialVerify.routeName);
                    TempData.userType = 'event_user';
                  }, text: 'Continue as Event Visitor'),
              const SizedBox(height: 20),
              MyElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, EmialVerify.routeName);
                   TempData.userType = 'event_manager';
                },
                text: 'Continue as Event Manager',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
