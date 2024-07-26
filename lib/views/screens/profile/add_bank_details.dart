import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../../data/repository/services/add_account_details.dart';
import '../../../data/repository/services/wallet.dart';
import '../../../utils/helper.dart';
import '../../../utils/loading.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/textformfield.dart';

class AddBankDetails extends StatefulWidget {
  static const String routeName = 'addBankDetail';
  const AddBankDetails({super.key});

  @override
  State<AddBankDetails> createState() => _AddBankDetailsState();
}

class _AddBankDetailsState extends State<AddBankDetails> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final sortCodeController = TextEditingController();
  bool waiting = false;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kPrimaryColor),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              autovalidateMode: autovalidateMode,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Add Bank Details", style: headingStyle),
                  const SizedBox(height: 50),
                  const Text('First Name',
                      style: TextStyle(fontSize: 18, color: kTextWhite)),
                  textFormField(
                    inputType: TextInputType.name,
                    inputFormate: [
                      FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                    ],
                    controller: firstNameController,
                    hintTxt: 'First Name',
                    validationFunction: (values) {
                       var value = values.trim();
                      if (value == null || value.isEmpty) {
                        return "Please enter your first name";
                      }
                      if (!value.contains(textValidation)) {
                        return "Please enter a valid details";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  const Text('Last Name',
                      style: TextStyle(fontSize: 18, color: kTextWhite)),
                  textFormField(
                    inputType: TextInputType.name,
                    inputFormate: [
                      FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                    ],
                    controller: lastNameController,
                    hintTxt: 'Last Name',
                    validationFunction: (values) {
                       var value = values.trim();
                      if (value == null || value.isEmpty) {
                        return "Please enter your last name";
                      }
                      if (!value.contains(textValidation)) {
                        return "Please enter a valid details";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  const Text('Account Number',
                      style: TextStyle(fontSize: 18, color: kTextWhite)),
                  textFormField(
                    inputType: TextInputType.emailAddress,
                    controller: accountNumberController,
                    inputFormate: [
                      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
                    ],
                    hintTxt: 'Accout Number',
                    validationFunction: (values) {
                       var value = values.trim();
                      if (value == null || value.isEmpty) {
                        return "Please enter bank account number";
                      }
                      if (!value.contains(phoneValidation)) {
                        return "Please enter a valid details";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  const Text('Sort Code',
                      style: TextStyle(fontSize: 18, color: kTextWhite)),
                  textFormField(
                    inputType: TextInputType.emailAddress,
                    controller: sortCodeController,
                    inputFormate: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9\s]'),
                      ),
                    ],
                    hintTxt: 'Sort Code',
                    validationFunction: (values) {
                       var value = values.trim();
                      if (value == null || value.isEmpty) {
                        return "Please enter sort code";
                      }
      
                      if (!value.contains(acceptTxtNNumb)) {
                        return "Please enter a valid details";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 150),
                  // const Spacer(),
                  MyElevatedButton(onPressed: submitFunt, text: "Submit"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  submitFunt() {
    unfoucsKeyboard(context);
    _formKey.currentState!.validate();
    if (_formKey.currentState!.validate()) {
      showWaitingDialoge(context:context,loading: waiting);
      setState(() {
        waiting = true;
      });
      AddBankDetailsService()
          .addBankDetails(context,
        fName: firstNameController.text,
        lName: lastNameController.text,
        accountNumber: accountNumberController.text,
        sortCode: sortCodeController.text,
      )
          .then((value) {
        if (value.responseStatus == ResponseStatus.success) {
         
          setState(() {
            waiting = false;
          });
          //  Get.to(()=>HomeMain());
          Get.back();
          Get.back();
          // withdrawalRequest();
          clearForm();
        } else if (value.responseStatus == ResponseStatus.failed) {
          setState(() {
            waiting = false;
          });
        }
      });
    }
  }

  clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    accountNumberController.clear();
    sortCodeController.clear();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    accountNumberController.dispose();
    sortCodeController.dispose();
    super.dispose();
  }
  withdrawalRequest() {
    final TextEditingController notesController = TextEditingController();
    final _key = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kTextBlack,
          // title: const Text("My title"),
          content: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Add Notes', style: labelStyle),
                const SizedBox(height: 20),
                textFormField(
                  controller: notesController,
                  inputFormate: [
                    FilteringTextInputFormatter(RegExp(r'^[a-zA-Z0-9\s]+$'),
                        allow: true),
                  ],
                  validationFunction: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a some notes";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(color: kPrimaryColor),
              ),
              onPressed: () {
                _key.currentState!.validate();
                if (_key.currentState!.validate()) {
                  WallerService().requestWithdrawl(context, notes: notesController.text).then((value) {
                    if (value.responseStatus == ResponseStatus.success) {
                      Get.back();
                      setState(() {});
                    }
                  });
                }
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: kPrimaryColor),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
