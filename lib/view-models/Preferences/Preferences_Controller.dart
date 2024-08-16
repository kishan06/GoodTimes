import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/event_category.dart';
import '../../data/repository/endpoints.dart';
import '../../data/repository/response_data.dart';
import '../../data/repository/services/event_category_drawar.dart';

class PreferenceController extends GetxController {
  RxList prefrencecontrollerdata = [].obs;
  RxList<bool> selectedpreference=<bool>[].obs;
  RxList storeselectedPreferenceId=[].obs;

  eventCategory(BuildContext context) async {
    await EventCategoryDrawarService()
        .eventDrawarService(context)
        .then((e) {
      if (e.responseStatus == ResponseStatus.success) {
        prefrencecontrollerdata.value = e.data;
        selectedpreference.value=List.filled(prefrencecontrollerdata.value.length, false);
      }
    });

  }
}
