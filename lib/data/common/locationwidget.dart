import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view-models/location_controller.dart';
import '../../views/screens/home/sidebar-filter/widget/widget.dart';

locationpermission(BuildContext context,
    {String text = "To sort by nearest", bool filter = true}) {
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
              "$text, Good Times requires access to your device's location. Please enable location permissions in your device settings.",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: const Color(0xff54595F),
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                if (filter) {
                  advanceFilterController.eventSortbyfilter.value = "";
                }

                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: const Color(0xff000000),
                ),
              ),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTap: () async {
                Get.back();
                Get.back();
                await LocationController()
                    .getUserCurrentLocation(redirect: true);
                //await Geolocator.openAppSettings();
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: const Color(0xffB90101),
                ),
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      );
    },
  );
}
