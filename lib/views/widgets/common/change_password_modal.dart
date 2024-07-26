import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../screens/auth/forgot-password/create_new_password.dart';

class AccountTransfer extends StatefulWidget {
    static const String routeName = 'accountTransfer';
  const AccountTransfer({super.key});

  @override
  State<AccountTransfer> createState() => _AccountTransferState();
}

class _AccountTransferState extends State<AccountTransfer> {
  @override
  void initState() {
    log("message account transfer");
    accountTransferDialog(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(body: SizedBox(),)
    );
  }
}

accountTransferDialog(context,{email}) {
  return showDialog<String>(
    // barrierDismissible: false,
    barrierColor: kTextBlack,
    context: context,
    builder: (BuildContext context) => PopScope(
       canPop: false,
      child: AlertDialog(
        backgroundColor: kTextWhite.withOpacity(0.2),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("assets/svg/lock_icon.svg"),
              const SizedBox(height: 20),
              const Text(
                "Change your password to enhance security",
                style: TextStyle(
                    fontSize: 20, color: kTextWhite, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              MyElevatedButton(onPressed: () {
                Navigator.pushNamed(context, CreatePassword.routeName,arguments: [email, "accountTranfer",]);
              }, text: "Change password"),
            ],
          ),
        ),
      ),
    ),
  );
}
