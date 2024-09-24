import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_times/data/repository/services/registration_services.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/utils/temp.dart';
import 'package:good_times/view-models/deep_link_model.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/common/textformfield.dart';
import '../../../../data/repository/response_data.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/loading.dart';
import '../../../../view-models/SubscriptionPreference.dart';
import '../../../../view-models/location_controller.dart';
import '../../../widgets/common/parent_widget.dart';
import 'select_preference.dart';

class CompleteDetails extends StatefulWidget {
  static const String routeName = 'complete-details';
  const CompleteDetails({super.key});

  @override
  State<CompleteDetails> createState() => _CompleteDetailsState();
}

class _CompleteDetailsState extends State<CompleteDetails> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController refferalCodeController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final _key = GlobalKey<FormState>();
  bool waiting = false;

  // String selectedVenue = eventUser;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    if (globalReferralCode != null) {
      refferalCodeController.text = globalReferralCode ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emailArgument = ModalRoute.of(context)!.settings.arguments;
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
            child: ListView(
                shrinkWrap: true,
                // reverse: true,
                children: [
                  const Text('Complete Profile', style: headingStyle),
                  const SizedBox(height: 28),
                  const Text(
                    'First Name',
                    style: labelStyle,
                  ),
                  textFormField(
                    controller: firstNameController,
                    inputFormate: [
                      FilteringTextInputFormatter(RegExp(r'^[a-zA-Z\s]+$'),
                          allow: true)
                    ],
                    validationFunction: (values) {
                      var value = values.trim();
                      if (value == null || value.isEmpty) {
                        return kNamefNullError;
                      }
                      if (value.length < 2) {
                        return 'Name is too short';
                      }
                      if (value.length > 30) {
                        return 'Name is to large';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    'Last Name',
                    style: labelStyle,
                  ),
                  textFormField(
                    controller: lastNameController,
                    inputFormate: [
                      FilteringTextInputFormatter(RegExp(r'^[a-zA-Z\s]+$'),
                          allow: true)
                    ],
                    validationFunction: (values) {
                      var value = values.trim();
                      if (value == null || value.isEmpty) {
                        return kNamelNullError;
                      }
                      if (value.length < 2) {
                        return 'Name is too short';
                      }
                      if (value.length > 30) {
                        return 'Name is to large';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    'Password',
                    style: labelStyle,
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
                      var trimmedValue = values.trim();
                      if (trimmedValue != values)
                        return 'Spaces are not allowed at the start or end';
                      if (trimmedValue.isEmpty) return 'Enter password';
                      if (trimmedValue.length < 8) return 'Min 8 characters';
                      if (trimmedValue.contains(' '))
                        return 'Spaces are not allowed';
                      if (!RegExp(r'(?=.*[a-z])').hasMatch(trimmedValue))
                        return 'One lowercase';
                      if (!RegExp(r'(?=.*[A-Z])').hasMatch(trimmedValue))
                        return 'One uppercase';
                      if (!RegExp(r'(?=.*\d)').hasMatch(trimmedValue))
                        return 'One number';
                      if (!RegExp(r'(?=.*[@#$%^&+=])').hasMatch(trimmedValue))
                        return 'One special character';
                      if (trimmedValue.length > 18)
                        return 'Exceeds 18 character limit';

                      return null; // Return null if the password is valid
                    },
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    'Confirm Password',
                    style: labelStyle,
                  ),
                  textFormField(
                    controller: confirmPasswordController,
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
                      if (values.contains(' ')) return 'Spaces are not allowed';
                      var value = values.trim();
                      if (value == null || value.isEmpty) {
                        return 'Enter confirm password';
                      }
                      if (value != passwordController.text) {
                        return kMatchPassError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    'Enter referral code',
                    style: labelStyle,
                    //     paragraphStyle.copyWith(color: const Color(0xffC0C0C0)),
                  ),
                  textFormField(
                    controller: refferalCodeController,
                    inputFormate: [
                      FilteringTextInputFormatter(acceptTxtNNumb, allow: true)
                    ],
                    validationFunction: (value) {},
                  ),
                  const SizedBox(height: 55),
                  MyElevatedButton(
                      //  loader: waiting
                      //           ? const CircularProgressIndicator()
                      //           : const SizedBox(),
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
                          RegistrationProccess()
                              .completeProfile(context,
                                  fName: firstNameController.text,
                                  lName: lastNameController.text,
                                  email: emailArgument,
                                  password: passwordController.text,
                                  refferalCodeController:
                                      refferalCodeController.text)
                              .then(
                            (value) {
                              if (value.responseStatus ==
                                  ResponseStatus.success) {
                                setState(() {
                                  waiting = false;
                                });
                                LocationController().getCurrentLocation(Get
                                    .context!); //send user location while login
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                    context, SelectPrefrence.routeName);
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

                        // completeProfile
                        // Navigator.pushNamed(context, ReferralScreen.routeName);
                      },
                      text: 'Continue'),
                ] //.reversed.toList(),
                ),
          ),
        ),
      ),
    );
  }
}
