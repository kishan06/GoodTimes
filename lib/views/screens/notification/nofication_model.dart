 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../data/models/notification_model.dart';
import '../../../utils/constant.dart';

showDetailedData(context,detailsData,) {
    NotificationList detailsDataModal = detailsData;

    return showBarModalBottomSheet(
      // expand: false,
      context: context,
      // isDismissible:isDismissible,
      // enableDrag:enableDrag,
      barrierColor: const Color(0xff000000).withOpacity(0.8),
      backgroundColor: kTextBlack.withOpacity(0.55),
      builder: (context) => Column(
        // mainAxisAlignment: MainAxisAlignment.start,
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
                    "Notification",
                    style: headingStyle.copyWith(fontSize: 25),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: kPrimaryColor),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    DateFormat.yMMMd('en_US').format(DateTime.parse(detailsDataModal.date)),
                    style: paragraphStyle.copyWith(fontSize: 14)),
                    const SizedBox(height: 5),
                Text(detailsDataModal.title,
                    style: paragraphStyle.copyWith(fontSize: 18)),
                const SizedBox(height: 20),
                Text(detailsDataModal.message,
                    style: paragraphStyle.copyWith(fontSize: 16)),
                const SizedBox(height: 20),
              ],
            ),
          )
          // Padding(
          //   padding: EdgeInsets.all(scaffoldPadding),
          //   child: child,
          // ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
    );
  }