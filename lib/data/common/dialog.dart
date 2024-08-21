import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constant.dart';
import '../../views/widgets/subscriptionmodule.dart';

forceeditprefdialog(BuildContext context, {String number = "3"}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: AlertDialog(
          surfaceTintColor: Color(0xFFFFFFFF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          insetPadding: const EdgeInsets.symmetric(vertical: 10),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Your subscription has ended. You can now select only $number preferences. To unlock more, consider joining us.",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: const Color(0xff54595F),
              ),
            ),
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  Get.back();
                  redirectsubscribe(context).then((value) {
                    profileextendedcontroller.fetchProfileExtendeddata(context);
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: kPrimaryColor),
                ),
                child:const Text(
                  "Join Us",
                  style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
                )),
            const SizedBox(width: 15),
             OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: kPrimaryColor),
                ),
                child:const Text(
                  "Continue",
                  style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: kPrimaryColor,
                ),
                )),
            const SizedBox(width: 15),
          ],
        ),
      );
    },
  );
}
