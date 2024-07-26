import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:good_times/data/repository/services/forgot_password.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/auth/registration/complete_profile.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../data/repository/response_data.dart';
import '../../../../data/repository/services/registration_services.dart';
import '../../../../utils/loading.dart';
import '../../../widgets/common/parent_widget.dart';

class PreVerifyOTP extends StatefulWidget {
  static const String routeName = 'preVerifyOTP';
  const PreVerifyOTP({super.key});

  @override
  State<PreVerifyOTP> createState() => _PreVerifyOTPState();
}

class _PreVerifyOTPState extends State<PreVerifyOTP> {
  TextEditingController textEditingController = TextEditingController();
  bool waiting = false;
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  int _timerSeconds = 60;
  late Timer _timer;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
    super.initState();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds -= 1;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  resendOTP(email) {
    ForgotPasswordService().reseteOtp(context, email: email)
        .then((value) {
      if (value.responseStatus == ResponseStatus.success) {
        setState(() {
          _timerSeconds = 60;
        });
        startTimer();
      }
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 final List<dynamic>? arg =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>?;
    var otp = arg![0];
    var email = arg[1];
    log('email and otp $otp $email');
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Verify OTP', style: headingStyle),
              const SizedBox(height: 10),
              Text(
                'Enter the 4 digit code that you received on your email.',
                style: paragraphStyle.copyWith(color: const Color(0xffBABABA)),
              ),
              const SizedBox(height: 100),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: kTextWhite),
                      autovalidateMode: autovalidateMode,
                      textStyle: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          color: kTextWhite),
                      length: 4,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "Please enter the OTP";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        fieldHeight: 50,
                        fieldWidth: 80,
                        activeFillColor: kPrimaryColor,
                        inactiveColor: kPrimaryColor,
                        selectedColor: kPrimaryColor,
                        activeColor: kPrimaryColor,
                      ),
                      cursorColor: kPrimaryColor,
                      animationDuration: const Duration(milliseconds: 300),
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  (_timerSeconds > 0)
                      ? Text( 'Resend code in $_timerSeconds',
                          style: paragraphStyle,
                        )
                      : Row(
                          children: [
                            Text(
                              'Didn’t receive the code?',
                              style: paragraphStyle.copyWith(
                                  color: const Color(0xffBABABA)),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: (){
                               resendOTP(email);
                              },
                              child: Text(
                                'Resend',
                                style: paragraphStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    decorationColor: kTextWhite),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
              const Spacer(),
              MyElevatedButton(
                text: 'Continue',
                onPressed: () {
                  verifyAndContinue(context,email:email,otp:otp);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  verifyAndContinue(context,{email,otp}) {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });
    // formKey.currentState!.validate();
    // conditions for validating
    if (currentText.length != 4) {
      errorController!.add(
        ErrorAnimationType.shake,
      ); // Triggering error shake animation
      setState(
        () => hasError = true,
      );
    } else {
      showWaitingDialoge(context:context,loading: waiting);
      setState(() {
          waiting = true;
      });
            RegistrationProccess()
                .preVerifyOTP(context,
                    otp: textEditingController.text, email: email)
                .then(
              (value) {
                if (value.responseStatus == ResponseStatus.success) {
                  setState(() {
                    waiting = false;
                  });
                   Navigator.pop(context);
                  Navigator.pushReplacementNamed(context,CompleteDetails.routeName,arguments: email);
                } else {
                  setState(() {
                    waiting = false;
                  });
                   Navigator.pop(context);
                  errorController!.add(
                    ErrorAnimationType.shake,
                  );
                }
                if (value.responseStatus == ResponseStatus.failed &&
                    value.responseStatus == ResponseStatus.error) {
                  setState(() {
                    waiting = false;
                  });
                   Navigator.pop(context);
                }
              });
    }
  }
}
