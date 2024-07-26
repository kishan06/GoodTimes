import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/widgets/common/bottom_sheet.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/common/textformfield.dart';

import '../../../data/repository/services/contact_us.dart';
import '../../../utils/loading.dart';
import '../../widgets/common/parent_widget.dart';

class ContactUS extends StatefulWidget {
  static const String routeName = "contactUS";
  const ContactUS({super.key});

  @override
  State<ContactUS> createState() => _ContactUSState();
}

class _ContactUSState extends State<ContactUS> {
  final _key = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();
  bool waiting = false;
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
          child: ListView(
            reverse: true,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello!\nHave any query?',
                style: headingStyle,
              ),
              const SizedBox(height: 38),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '123 Main Street, London, SW1A 1AA, United Kingdom',
                    style: paragraphStyle.copyWith(fontSize: 14),
                  )),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      '(7845124512)\ngoodtimes@gmail.com',
                      style: paragraphStyle.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(
                color: Color(0xff5F5F5F),
              ),
              const SizedBox(height: 18),
              Form(
                autovalidateMode: autovalidateMode,
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Name', style: labelStyle),
                    textFormField(
                      controller: nameController,
                      inputFormate: [
                        FilteringTextInputFormatter(RegExp(r'^[a-zA-Z\s]+$'), allow: true)
                      ],
                      validationFunction: (values) {
                        var value = values.trim();
                        if (value == null || value.isEmpty) {
                          return "Enter your name";
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
                    const SizedBox(height: 25),
                    const Text('Phone Number', style: labelStyle),
                    textFormField(
                      controller: phoneController,
                      inputType: TextInputType.phone,
                      inputFormate: [
                        FilteringTextInputFormatter(phoneValidation, allow: true)
                      ],
                      validationFunction: (values) {
                        var value = values.trim();
                        if (value == null || value.isEmpty) {
                          return kPhoneNumberNullError;
                        }
                        if (value.length < 8 || value.length > 13) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    const Text('Email', style: labelStyle),
                    textFormField(
                      controller: emailController,
                      inputType: TextInputType.emailAddress,
                      inputFormate: [
                        FilteringTextInputFormatter(textNmbSpclCha, allow: true)
                      ],
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
                    const SizedBox(height: 25),
                    const Text('Your message', style: labelStyle),
                    textFormField(
                      controller: messageController,
                      validationFunction: (values) {
                         var value = values.trim();
                        if (value == null || value.isEmpty) {
                          return "Enter your comment.";
                        }
                        if (value.length < 2) {
                          return 'Enter at least two characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    MyElevatedButton(
                      //  loader: waiting
                      //         ? const CircularProgressIndicator()
                      //         : const SizedBox(),
                        onPressed: () {
                          autovalidateMode = AutovalidateMode.always;
                          _key.currentState!.validate();
                          if (_key.currentState!.validate()) {
                            showWaitingDialoge(context:context,loading: waiting);
                            setState(() {
                              waiting = true;
                            });
                            ContactUsServices()
                                .contactUs(context,
                                    name: nameController.text,
                                    email: emailController.text,
                                    mobileNumber: phoneController.text,
                                    messgae: messageController.text)
                                .then((value) {
                              if (value.responseStatus ==ResponseStatus.success) {
                                setState(() {
                                  waiting = false;
                                });
                                Navigator.pop(context);
                                niceToMeet();
                              } else if (value.responseStatus ==
                                  ResponseStatus.failed) {
                                setState(() {
                                  waiting = false;
                                });
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  waiting = false;
                                });
                                Navigator.pop(context);
                              }
                            });
                          }
                        },
                        text: 'Submit'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ].reversed.toList(),
          ),
        ),
      ),
    );
  }

  niceToMeet() {
    return normalModelSheet(
      context,
      enableDrag: false,
      isDismissible: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Nice to meet you, we will contact soon.',
                style: headingStyle, textAlign: TextAlign.center),
            const SizedBox(height: 25),
            MyElevatedButton(
              onPressed: () {
                log('message');
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeMain.routeName, (route) => true);
                //  HomePageController.SessionsActiveTabIndex = 0;
                // homePageController.updateBottomNavIndex(0);
              },
              // text: 'Explore More Events',
              text: "Continue",
            ),
          ],
        ),
      ),
    );
  }
}
