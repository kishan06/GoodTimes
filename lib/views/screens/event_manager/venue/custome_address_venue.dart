import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:logger/web.dart';

import '../../../../view-models/global_controller.dart';
import '../../../widgets/common/parent_widget.dart';
import '../../../widgets/common/textformfield.dart';

class VenueCustomAddress extends StatefulWidget {
  static String routeName = 'venueCustomAddress';
  const VenueCustomAddress({super.key});

  @override
  State<VenueCustomAddress> createState() => _VenueCustomAddressState();
}

class _VenueCustomAddressState extends State<VenueCustomAddress> {
  final _key = GlobalKey<FormState>();
  final country = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final townCity = TextEditingController();
  final state = TextEditingController();
  final postCode = TextEditingController();
  final latitude = TextEditingController();
  final longitude = TextEditingController();
  final AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final GlobalController globalcontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
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
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Country',
                    style: labelStyle,
                  ),
                  textFormField(
                    controller: country,
                    hintTxt: 'Country',
                    inputFormate: [
                      FilteringTextInputFormatter(RegExp(r'^[a-zA-Z\s]+$'),
                          allow: true)
                    ],
                    validationFunction: (values) {
                      var value = values.trim();
                      if (value == null || value.isEmpty) {
                        return 'Please enter country name';
                      }
                      if (value.length < 2) {
                        return 'Name is too short';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    'Address Line 1',
                    style: labelStyle,
                  ),
                  textFormField(
                    controller: address1,
                    hintTxt: 'Address Line 1',
                    inputFormate: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z0-9,\s]+$'))
                    ],
                    validationFunction: (values) {
                      var value = values.trim();
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      if (value.length < 2) {
                        return 'Name is too short';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    'Address Line 2',
                    style: labelStyle,
                  ),
                  textFormField(
                    controller: address2,
                    hintTxt: "Address Line 2",
                    inputFormate: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z0-9,\s]+$'))
                    ],
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    'Town/City',
                    style: labelStyle,
                  ),
                  textFormField(
                    controller: townCity,
                    hintTxt: "Town/City",
                    inputFormate: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z,\s]+$'))
                    ],
                    validationFunction: (values) {
                      var value = values.trim();
                      if (value == null || value.isEmpty) {
                        return "Please enter town/city";
                      }
                      if (value.length < 2) {
                        return 'Name is too short';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 35),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'State',
                              style: labelStyle,
                            ),
                            textFormField(
                              controller: state,
                              hintTxt: "State",
                              inputFormate: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[a-zA-Z\s]+$'),
                                    allow: true)
                              ],
                              validationFunction: (values) {
                                var value = values.trim();
                                if (value == null || value.isEmpty) {
                                  return "Please enter state";
                                }
                                if (value.length < 2) {
                                  return 'Name is too short';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Postcode',
                              style: labelStyle,
                            ),
                            textFormField(
                              controller: postCode,
                              hintTxt: "Postcode",
                              inputFormate: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z0-9\s]+$')),
                              ],
                              validationFunction: (values) {
                                var value = values.trim();
                                if (value == null || value.isEmpty) {
                                  return "Please enter postcode";
                                }
                                if (value.length < 2) {
                                  return 'Name is too short';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Latitude',
                              style: labelStyle,
                            ),
                            textFormField(
                              controller: latitude,
                              hintTxt: "Latitude",
                              validationFunction: (values) {
                                var trimmedValue = values.trim();
                                if (trimmedValue == null ||
                                    trimmedValue.isEmpty) {
                                  return "Please enter latitude";
                                }
                                if (trimmedValue.length < 2) {
                                  return 'Enter value is too short';
                                }
                                if (!RegExp(
                                        r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$')
                                    .hasMatch(trimmedValue)) {
                                  return 'Enter a valid latitude';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Longitude',
                              style: labelStyle,
                            ),
                            textFormField(
                              controller: longitude,
                              hintTxt: "Longitude",
                              validationFunction: (values) {
                                var trimmedValue = values.trim();
                                if (trimmedValue == null ||
                                    trimmedValue.isEmpty) {
                                  return "Please enter longitude";
                                }
                                if (trimmedValue.length < 2) {
                                  return 'Enter value is too short';
                                }
                                if (!RegExp(
                                        r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$')
                                    .hasMatch(trimmedValue)) {
                                  return 'Enter a valid longitude';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Spacer(),

                  MyElevatedButton(
                      onPressed: () {
                        _key.currentState!.validate();
                        if (_key.currentState!.validate()) {
                          globalcontroller.address.value =
                              '${country.text}, ${address1.text}, ${address2.text == '' ? '' : "${address2.text},"} ${townCity.text}, ${state.text}, ${postCode.text}';
                          Logger().i(globalcontroller.address.value);
                          globalController.long.value = longitude.text;
                          globalcontroller.lat.value = latitude.text;
                          Navigator.pop(context);
                          Navigator.pop(context);
                          clearAllText();
                        }
                      },
                      text: "Continue"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  clearAllText() {
    country.clear();
    address1.clear();
    address2.clear();
    townCity.clear();
    state.clear();
    postCode.clear();
  }
}
