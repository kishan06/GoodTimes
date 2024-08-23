// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/constant.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart'
    as model_bottom_sheet;

modalBottomShetWidget(context,
    {title, child, isDismissible, enableDrag, defaultHeight, ontap}) {
  return model_bottom_sheet.showBarModalBottomSheet(
    context: context,
    isDismissible:false,
    enableDrag:false,
    barrierColor: const Color(0xff000000).withOpacity(0.8),
    backgroundColor: kTextBlack.withOpacity(0.55),
    builder: (context) => ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: defaultHeight ?? Get.size.height * 0.3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: headingStyle.copyWith(fontSize: 25),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: kPrimaryColor),
                  onPressed: ontap??()=>Get.back(),
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(height: 10),
          child,
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

normalModelSheet(context, {child, isDismissible, enableDrag}) {
  return model_bottom_sheet.showBarModalBottomSheet(
    expand: false,
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    barrierColor: const Color(0xff000000).withOpacity(0.8),
    backgroundColor: kTextBlack.withOpacity(0.55),
    builder: (context) => ConstrainedBox(
      // height: Get.size.height * 0.6,
      constraints: BoxConstraints(
        minHeight: Get.size.height * 0.3,
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
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
