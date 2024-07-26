import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/models/account_trasfer_modal.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/data/repository/services/account_transfer.dart';
import 'package:good_times/data/repository/services/user_location_data.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/auth/registration/select_preference.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/widgets/common/change_password_modal.dart';
import 'package:good_times/views/widgets/common/textformfield.dart';
import '../../../../data/repository/services/check_preference.dart';
import '../../../../data/repository/services/log_in.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/loading.dart';
import '../../../../view-models/auth/google_auth.dart';
import '../../../../view-models/location_controller.dart';
import '../../../widgets/common/button.dart';
import '../../../widgets/common/parent_widget.dart';
import '../forgot-password/forgot_password.dart';
import '../registration/complete_profile.dart';
import '../registration/select_user_type.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "Login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool waiting = false;
  bool _passwordVisible = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var playerId = GetStorage().read("player_Id");
    log("player Id in login screen $playerId");
    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kPrimaryColor),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Login', style: headingStyle),
                        const SizedBox(height: 28),
                        Form(
                          key: _key,
                          autovalidateMode: autovalidateMode,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Email',
                                  style: TextStyle(
                                      fontSize: 18, color: kTextWhite)),
                              textFormField(
                                inputType: TextInputType.emailAddress,
                                controller: emailController,
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
                              const SizedBox(height: 30),
                              const Text(
                                'Password',
                                style:
                                    TextStyle(fontSize: 18, color: kTextWhite),
                              ),
                              textFormField(
                                controller: passwordController,
                                obscureText: !_passwordVisible,
                                inputType: TextInputType.text,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: kPrimaryColor,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                hintTxt: '*******',
                                validationFunction: (values) {
                                  var value = values.trim();
                                  if (value.isEmpty)return 'Password is required';
                                  return null; // Return null if the password is valid
                                },
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    // Get.to(());
                                    Navigator.pushNamed(
                                        context, ForgotPassword.routeName);
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: paragraphStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        MyElevatedButton(
                          //  loader: waiting
                          //     ? const CircularProgressIndicator()
                          //     : const SizedBox(),
                          width: double.infinity,
                          onPressed: () {
                            setState(() {
                              autovalidateMode = AutovalidateMode.always;
                            });
                           unfoucsKeyboard(context);
                            _key.currentState!.validate();
                            if (_key.currentState!.validate()) {
                              showWaitingDialoge(
                                  context: context, loading: waiting);
                              setState(() {
                                waiting = true;
                              });
                              LogInService()
                                  .logIn(
                                context,
                                email: emailController.text,
                                password: passwordController.text,
                              ).then((value) async{

                                if (value.responseStatus == ResponseStatus.success){
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                  LocationController().getCurrentLocation(Get.context!);
                                  AccoutTransferService().accoutTransferService(context).then(
                                    (success) {
                                      if (success.responseStatus == ResponseStatus.success) {
                                        AccountTransferModal accountData = success.data;
                                        if (accountData.isTransferred) {
                                          if (accountData.pwdChangedPostTransfer == false) {
                                            accountTransferDialog(context,email: emailController.text);
                                          } else {
                                            loginWithConditions(value);
                                          }
                                        } else {
                                          loginWithConditions(value);
                                        }
                                      } else {
                                        loginWithConditions(value);
                                      }
                                    },
                                  );
                                }
                                if (value.responseStatus == ResponseStatus.failed) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                          text: 'Login',
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don’t have an account?',
                              style: paragraphStyle.copyWith(
                                  color: const Color(0xffBEBEBE)),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, SelectUserType.routeName);
                              },
                              child: Text(
                                'Sign Up',
                                style: paragraphStyle.copyWith(
                                    color: kPrimaryColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
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
                                          handleSignIn(context,userType: "event_user").then((value) {
                                            log("response of all data  $value");
                                            if (value.responseStatus ==ResponseStatus.success) {

                                              log("response of all data value");
                                              CheckPreferenceService().checkPreferenceService(context).then((value) {
                                                if (value.responseStatus ==ResponseStatus.success) {
                                                  if (value.data == true) {
                                                    Navigator.pushNamed(context,HomeMain.routeName);
                                                  } else if (value.data == false) {
                                                        Navigator.pushNamed(context,SelectPrefrence.routeName);
                                                  }
                                                }
                                              });
                                            }
                                          });
                                        },
                                        text: 'Login with google'),
                                  )
                                : const SizedBox(),
                            // Platform.isIOS
                            //     ? Expanded(
                            //         child: myElevatedButtonOutline(
                            //             icon: 'assets/svg/apple.svg',
                            //             size: 30.0,
                            //             onPressed: () {
                            //               signInWithApple();
                            //             },
                            //             text: 'Login with Apple'),
                            //       )
                            //     : const SizedBox(),

                            //handleSignIn(context)
                          ],
                        ),
                        const SizedBox(height: 30)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginWithConditions(value) {  
    if (value.data["preference"] == false) {
      Navigator.pushNamed(context, SelectPrefrence.routeName);
    }
    if (value.data["preference"] == true) {
      Navigator.pushNamed(context, HomeMain.routeName);
    }
    if (value.data["complete"] == false) {
      Navigator.pushNamed(context, CompleteDetails.routeName,
          arguments: value.data["email"]);
    }
    if (value.data["complete"] == true) {
      Navigator.pushNamed(context, HomeMain.routeName);
    }
  }
}
