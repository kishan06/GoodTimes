import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/repository/services/account_transfer.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/view-models/global_controller.dart';
import 'package:good_times/views/screens/auth/login/login.dart';
import '../../../../data/repository/response_data.dart';
import '../../../../data/repository/services/forgot_password.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/loading.dart';
import '../../../widgets/common/button.dart';
import '../../../widgets/common/parent_widget.dart';
import '../../../widgets/common/textformfield.dart';

class CreatePassword extends StatefulWidget {
  static const String routeName = 'createPassword';
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =TextEditingController();
  final _key = GlobalKey<FormState>();
  bool waiting = false;
  bool _passwordVisible = false;
  bool isChecked = false;
  bool _confirmPasswordVisible = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalController globalController = Get.put(GlobalController());

  @override
  Widget build(BuildContext context) {
    // final emailArgument = "boobywork114@gmail.com";
     final List<dynamic>? arg = ModalRoute.of(context)?.settings.arguments as List<dynamic>?;
     log("arg in create passwords $arg");
    return parentWidgetWithConnectivtyChecker(
      child: PopScope(
        canPop: arg![1] == "accountTranfer" ? false : true,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kPrimaryColor),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
            child: Form(
              key: _key,
              autovalidateMode: autovalidateMode,
              child: ListView(
                children: [
                  const Text('Reset Password', style: headingStyle),
                  const SizedBox(height: 5),
                  Text(
                      'Set a new password for your account so you can login and access all the features.',
                      style: paragraphStyle.copyWith(
                          color: const Color(0xffBABABA))),
                  const SizedBox(height: 50),
                  const Text(
                    'Password',
                    style: paragraphStyle,
                  ),
                  textFormField(
                    controller: _passwordController,
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
                      // logger.e("value of password without trim $values");
                      var trimmedValue = values.trim();
                      if (trimmedValue != values)return 'Spaces are not allowed at the start or end';
                      if (trimmedValue.isEmpty) return 'Enter password';
                      if (trimmedValue.length < 8) return 'Min 8 characters';
                      if (trimmedValue.contains(' '))return 'Spaces are not allowed';
                      if (!RegExp(r'(?=.*[a-z])').hasMatch(trimmedValue))return 'One lowercase';
                      if (!RegExp(r'(?=.*[A-Z])').hasMatch(trimmedValue))return 'One uppercase';
                      if (!RegExp(r'(?=.*\d)').hasMatch(trimmedValue))return 'One number';
                      if (!RegExp(r'(?=.*[@#$%^&+=])').hasMatch(trimmedValue))return 'One special character';
                      if (trimmedValue.length > 18)return 'Exceeds 18 character limit';
                      return null; // Return null if the password is valid
                    },
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Confirm Password',
                    style: paragraphStyle,
                  ),
                  textFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_confirmPasswordVisible,
                    inputType: TextInputType.text,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: kPrimaryColor,
                        size: 25,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                    hintTxt: '*******',
                    validationFunction: (values) {
                      var trimmedValue = values.trim();
                      if (trimmedValue != values)return 'Spaces are not allowed at the start or end';
                      if (trimmedValue.contains(' '))return 'Spaces are not allowed';
                      if (trimmedValue == null || trimmedValue.isEmpty) {
                        return 'Please confirm your password';
                      }

                      if (trimmedValue != _passwordController.text) {
                        return kMatchPassError;
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
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
                          showWaitingDialoge(
                              context: context, loading: waiting);
                          setState(() {
                            waiting = true;
                          });
                          ForgotPasswordService()
                              .resetPassword(context,
                                  email: arg[0],
                                  password: _passwordController.text,
                                  confirmPassword:
                                      _confirmPasswordController.text)
                              .then(
                            (value) {
                              if (value.responseStatus ==ResponseStatus.success) {
                                setState(() {
                                  waiting = false;
                                });
                                Navigator.pop(context);
                                AccoutTransferService().resetPasswordDoneService(context).then((value){
                                  if(value.responseStatus == ResponseStatus.success){
                                    // globalController.accoutTransferSuccess.value = true;
                                    GetStorage().write('isPasswordChanged', true);
                                  }
                                });
                                Navigator.pushNamedAndRemoveUntil(context,LoginScreen.routeName, (route) => false);
                              }
                              if (value.responseStatus ==
                                  ResponseStatus.failed) {
                                setState(() {
                                  waiting = false;
                                });
                                Navigator.pop(context);
                              }
                            },
                          );
                        }
                        // ForgotPasswordService().resetPassword(context,email: '',password: '',confirmPassword: '');
                        // Navigator.pushNamedAndRemoveUntil(
                        //     context, WelcomeScreen.routeName, (route) => false);
                      },
                      text: 'Reset Password'),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
