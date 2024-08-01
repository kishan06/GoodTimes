import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_times/data/models/event_age_group_model.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/home/sidebar-filter/widget/widget.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../../../data/common/locationwidget.dart';
import '../../../../data/repository/services/advance_filter_service.dart';
import '../../../../view-models/location_controller.dart';

Drawer drawer(BuildContext context, List eventData, List<ageData>? ageGroups) {
  return Drawer(
    backgroundColor: kTextgreyDark,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kTextgreyDark,
          title: const Text(
            "Filters",
            style: TextStyle(
              fontSize: 20,
              color: kTextWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                if (advanceFilterController.checkFilterIsClearOrNot()) {
                  return;
                } else {
                  advanceFilterController.clearAllFilter();
                  AdvanceFilterService().advanceFilterEventServices(context);
                }
              },
              icon: const Icon(
                Icons.close,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
        Expanded(
            child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: serachByLocation(context),
                ),
                divider(),
                byCategory(context, eventData),
                divider(),
                sortBy(context),
                divider(),
                byDate(context),
                divider(),
                byPriceRange(),
                divider(),
                ageGroup(context, ageGroups),
                const SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: MyElevatedButton(
                    onPressed: () async {
                      bool checknearest = false;
                      if (advanceFilterController.eventSortbyfilter.value=="nearest") {
                        checknearest = true;
                      }
                      if (checknearest != false && latlong == null) {
                        await locationpermission(context);
                      } else {
                        AdvanceFilterService()
                            .advanceFilterEventServices(context);
                        Get.back();
                      }
                    },
                    text: "Apply Filters",
                  ),
                ),
              ],
            ),
          ),
        ))
      ],
    ),
  );
}

Widget divider() {
  return const Divider(
    color: Color(0xff5C5C5C),
  );
}
