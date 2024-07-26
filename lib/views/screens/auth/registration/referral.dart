import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/common/textformfield.dart';

import '../../../widgets/common/parent_widget.dart';
import 'select_preference.dart';

class ReferralScreen extends StatefulWidget {
  static const String routeName = 'referrals';
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  TextEditingController refferalCodeController = TextEditingController();
  final GlobalKey _key = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
          child: Form(
            key: _key,
            autovalidateMode: autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Referral Code', style: headingStyle),
                const SizedBox(height: 10),
                Text(
                  'Enter referral code',
                  style: paragraphStyle.copyWith(color: const Color(0xffC0C0C0)),
                ),
                textFormField(controller: refferalCodeController),
                const Spacer(),
                MyElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, SelectPrefrence.routeName);
                }, text: 'Continue'),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                        Navigator.pushNamed(context, SelectPrefrence.routeName);
                    },
                    child: Text(
                      'Skip',
                      style: paragraphStyle.copyWith(color: kPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
