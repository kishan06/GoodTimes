import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/common/textformfield.dart';

import '../../../../data/repository/response_data.dart';
import '../../../../data/repository/services/forgot_password.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/loading.dart';
import '../../../widgets/common/parent_widget.dart';
import 'otp_screen.dart';

class ForgotPassword extends StatefulWidget {
  static const String routeName = 'forgotPassword';
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _key = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool waiting = false;
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
                const Text('Forgot Password', style: headingStyle),
                const SizedBox(height: 5),
                Text('Enter your email for the verification proccess, we will send 4 digits code to your email',
                    style:paragraphStyle.copyWith(color: const Color(0xffBABABA))),
                const SizedBox(height: 40),
                // const Text('Email'),
                textFormField(
                  inputType: TextInputType.emailAddress,
                  controller: _emailController,
                  hintTxt: 'Email',
                  validationFunction: (values) {
                     var value = values.trim();
                    if (value == null || value.isEmpty) {
                      return kEmailNullError;
                    }
                    if (!value.contains(emailValidatorRegExp)) {
                      return kInvalidEmailError;
                    }
                    if (value.length > 60) {
                      return 'Email is to large';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                MyElevatedButton(
                  //  loader: waiting
                  //             ? const CircularProgressIndicator()
                  //             : const SizedBox(),
                    onPressed: () {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                     unfoucsKeyboard(context);
                      _key.currentState!.validate();
                      if (_key.currentState!.validate() == true) {
                        showWaitingDialoge(context:context,loading: waiting);
                        setState(() {
                          waiting = true;
                        });
      
                        ForgotPasswordService().reseteOtp(
                          context,
                          email: _emailController.text,
                        )
                            .then(
                          (value) {
                            if (value.responseStatus == ResponseStatus.success) {
                              // log("reposnse data for the OTP ${value.data["data"]}");
                              setState(() {
                                waiting = false;
                              });
                              Navigator.pop(context);
                              Navigator.pushNamed(context, VerifyOTP.routeName,
                                  arguments: [
                                    value.data["data"],
                                    _emailController.text
                                  ]);
                              _emailController.clear();
                              autovalidateMode = AutovalidateMode.disabled;
                            }
                            if (value.responseStatus == ResponseStatus.failed) {
                              setState(() {
                                waiting = false;
                              });
                              Navigator.pop(context);
                            }
                          },
                        );
                      }
      
                      // Navigator.pushNamed(context, VerifyOTP.routeName);
                    },
                    text: 'Continue'),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
