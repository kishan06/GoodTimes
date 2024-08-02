import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:good_times/data/repository/services/registration_services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// import '../../../../utils/base_manager.dart';
import '../../../../data/models/orgnisations_model.dart';
import '../../../../data/repository/endpoints.dart';
import '../../../../data/repository/response_data.dart';
import '../../../../data/repository/services/check_preference.dart';
import '../../../../data/repository/services/orgnisation.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/loading.dart';
import '../../../../utils/temp.dart';
import '../../../../view-models/Preferences/Preferences_Controller.dart';
import '../../../../view-models/auth/google_auth.dart';

import '../../../../view-models/deep_link_model.dart';
import '../../../widgets/common/button.dart';
import '../../../widgets/common/parent_widget.dart';
import '../../../widgets/common/textformfield.dart';
import '../../home/main_home.dart';
import '../login/login.dart';
import 'otp_verify.dart';
import 'select_preference.dart';

class EmialVerify extends StatefulWidget {
  static const String routeName = 'email-verify';
  const EmialVerify({super.key});

  @override
  State<EmialVerify> createState() => _EmialVerifyState();
}

class _EmialVerifyState extends State<EmialVerify> {
  final _key = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  TextEditingController refferalCodeController = TextEditingController();
  // String selectedVenue = eventUser;
  bool waiting = false;
  bool isChecked = false;
  // String usreType = '';

  PreferenceController preferenceController =
      Get.put(PreferenceController(), permanent: true);
  @override
  void initState() {
    super.initState();
    if (globalReferralCode != null) {
      refferalCodeController.text = globalReferralCode ?? "";
    }
     if (preferenceController.prefrencecontrollerdata.isEmpty) {
      preferenceController.eventCategory(context);
      print(preferenceController.prefrencecontrollerdata);
    }
    intTheFunc();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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
            autovalidateMode: autovalidateMode,
            key: _key,
            child: ListView(shrinkWrap: true, children: [
              const Text('Sign up as a user', style: headingStyle),
              const SizedBox(height: 35),
              const Text(
                'Email Address',
                style: labelStyle,
              ),
              textFormField(
                controller: emailController,
                hintTxt: 'Email',
                inputType: TextInputType.emailAddress,
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
              const SizedBox(height: 200),
              FormField<bool>(
                builder: (state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 28,
                            child: Checkbox(
                              checkColor: kTextWhite,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              activeColor: kPrimaryColor,
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                  state.didChange(value);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text:
                                          'By creating an account you agree to the ',
                                      style: labelStyle.copyWith(
                                          fontSize: 14,
                                          color: const Color(0xffA8A8A8))),
                                  TextSpan(
                                      text: ' terms of use',
                                      style: labelStyle.copyWith(
                                        fontSize: 14,
                                        color: kTextWhite,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        decorationColor: kTextWhite,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          termAndCondition();
                                        }),
                                  TextSpan(
                                      text: ' and',
                                      style: labelStyle.copyWith(
                                          fontSize: 14,
                                          color: const Color(0xffA8A8A8))),
                                  TextSpan(
                                      text: ' privacy policy',
                                      style: labelStyle.copyWith(
                                        fontSize: 14,
                                        color: kTextWhite,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        decorationColor: kTextWhite,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          privacyAndPolicyModel();
                                        }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          state.errorText ?? '',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      )
                    ],
                  );
                },
                validator: (value) {
                  if (!isChecked) {
                    return 'You need to accept terms';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 10),
              MyElevatedButton(
                //  loader: waiting
                //               ? const CircularProgressIndicator()
                //               : const SizedBox(),
                onPressed: () {
                  setState(() {
                    autovalidateMode = AutovalidateMode.always;
                  });
                  unfoucsKeyboard(context);
                  _key.currentState!.validate();
                  if (_key.currentState!.validate()) {
                    setState(() {
                      waiting = true;
                    });
                    showWaitingDialoge(context: context, loading: waiting);
                    RegistrationProccess()
                        .verifyEmail(
                      context,
                      email: emailController.text,
                      userType: TempData.userType,
                    ).then(
                      (value) {
                        if (value.responseStatus == ResponseStatus.success) {
                          logger.f("reposnse data for the OTP ${value.data}");
                          setState(() {
                            waiting = false;
                          });
                          Navigator.pop(context);
                          Navigator.pushNamed(context, PreVerifyOTP.routeName,
                              arguments: [
                                value.data["data"],
                                emailController.text
                              ]);
                          emailController.clear();
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
                },
                text: 'Sign Up',
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'or',
                      style: paragraphStyle.copyWith(),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Platform.isAndroid
                      ? Expanded(
                          child: myElevatedButtonOutline(
                              icon: 'assets/svg/google.svg',
                              size: 40.0,
                              onPressed: () {
                                (globalReferralCode == "" || globalReferralCode == null) ? referralModel() : handleSignFu();
                              },
                              text: 'Sign up with google'),
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Already have an account? ',
                          style: labelStyle.copyWith(
                              fontSize: 14, color: const Color(0xffA8A8A8))),
                      TextSpan(
                          text: 'Login',
                          style: labelStyle.copyWith(
                            fontSize: 14,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: kPrimaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, LoginScreen.routeName);
                            }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ] //.reversed.toList(),
                ),
          ),
        ),
      ),
    );
  }

  referralModel() {
    final _referralKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0,
          backgroundColor: kTextBlack,
          title: Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: StatefulBuilder(builder: (context, setStates) {
              return Form(
                key: _referralKey,
                autovalidateMode: autovalidateMode,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter referral code',
                        style: labelStyle,
                        //     paragraphStyle.copyWith(color: const Color(0xffC0C0C0)),
                      ),
                      textFormField(
                        controller: refferalCodeController,
                        inputFormate: [
                          FilteringTextInputFormatter(acceptTxtNNumb,
                              allow: true)
                        ],
                        validationFunction: (values) {
                          var value = values.trim();
                          if (value == null || value.isEmpty) {
                            return 'Enter referral code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 55),
                      Row(
                        children: [
                          Expanded(
                            child: MyElevatedButton(
                                onPressed: () {
                                  if (_referralKey.currentState!.validate()) {
                                    log("googlemessage1");
                                    Get.back();
                                    log("googlemessage2");
                                    handleSignFu();
                                  }
                                },
                                text: "Submit"),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: myElevatedButtonOutline(
                                  onPressed: () {
                                    Get.back();
                                    handleSignFu();
                                  },
                                  text: "Skip"))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  privacyAndPolicyModel() {
    return showBarModalBottomSheet(
      expand: false,
      context: context,
      barrierColor: const Color(0xff000000).withOpacity(0.8),
      backgroundColor: kTextBlack.withOpacity(0.55),
      builder: (context) => ConstrainedBox(
        // height: Get.size.height * 0.6,
        constraints: BoxConstraints(
          minHeight: Get.size.height * 0.3,
        ),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Privacy And Policy',
                      style: headingStyle.copyWith(fontSize: 25),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close, color: kPrimaryColor),
                      onPressed: () => Get.back()),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            FutureBuilder<ResponseModel>(
              future: OrgnisataionsServices().orgnisataionsServices(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  CMSModel data = snapshot.data!.data;
                  log('data of CMS ${data.privacyAndPolicy}');
                  return Html(
                    data: data.privacyAndPolicy,
                    style: {
                      "body": Style(
                        fontSize: FontSize(18.0),
                        fontWeight: FontWeight.bold,
                        color: kTextWhite,
                      ),
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            // Padding(
            //   padding: EdgeInsets.all(scaffoldPadding),
            //   child: child,
            // ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
    );
  }

  // term and condition model

  termAndCondition() {
    return showBarModalBottomSheet(
      expand: false,
      context: context,
      barrierColor: const Color(0xff000000).withOpacity(0.8),
      backgroundColor: kTextBlack.withOpacity(0.55),
      builder: (context) => ConstrainedBox(
        // height: Get.size.height * 0.6,
        constraints: BoxConstraints(
          minHeight: Get.size.height * 0.3,
        ),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Term And Conditions',
                      style: headingStyle.copyWith(fontSize: 25),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close, color: kPrimaryColor),
                      onPressed: () => Get.back()),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            FutureBuilder<ResponseModel>(
              future: OrgnisataionsServices().orgnisataionsServices(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  CMSModel data = snapshot.data!.data;
                  log('data of CMS ${data.privacyAndPolicy}');
                  return Html(
                    data: data.termAndConditions,
                    style: {
                      "body": Style(
                        fontSize: FontSize(18.0),
                        fontWeight: FontWeight.bold,
                        color: kTextWhite,
                      ),
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            // Padding(
            //   padding: EdgeInsets.all(scaffoldPadding),
            //   child: child,
            // ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
    );
  }

  handleSignFu() {
    handleSignIn(context,
            userType: TempData.userType,
            referralCode: refferalCodeController.text)
        .then((value) {
      log("response of all data  $value");
      if (value.responseStatus == ResponseStatus.success) {
        log("response of all data value");

        CheckPreferenceService().checkPreferenceService(context).then((value) {
          if (value.responseStatus == ResponseStatus.success) {
            if (value.data == true) {
              Navigator.pushNamed(context, HomeMain.routeName);
            } else if (value.data == false) {
              Navigator.pushNamed(context, SelectPrefrence.routeName);
            }
          }
        });
      }
    });
  }
}
