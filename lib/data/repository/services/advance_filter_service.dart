import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';

import '../../../view-models/advance_filter_controller.dart';
import '../../../view-models/location_controller.dart';
import '../../models/home_event_modal.dart';
import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

RxBool filterLoder = false.obs;

class AdvanceFilterService {
  Dio dio = Dio();
  AdvanceFilterController advanceFilterController =
      getx.Get.put(AdvanceFilterController());
  final header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${GetStorage().read('accessToken')}"
  };
  Future advanceFilterEventServices(context) async {
    filterLoder.value = true;
    final ApiService apiService = ApiService(dio);
    const baseUrl = Endpoints.getAdvanceEventFilter;
    // Fetch user's current position

    try {
      // Prepare query parameters
      final evetCat = advanceFilterController.evetCategoryList;
      final sortCat = advanceFilterController.eventSort;
      final ageGroup = advanceFilterController.ageSort;
      final filterDate = advanceFilterController.formattedDateTime ?? '';
      final startPrice = advanceFilterController.startPrice;
      final endPrice = advanceFilterController.endPrice;
      final locationFilter = advanceFilterController.filterByLocation;
      final titleFilter = advanceFilterController.homeFilterByTitle;

      final List<String> encodedCategories =
          evetCat.map((category) => Uri.encodeComponent(category)).toList();
     /*  final List<String> encodedSort =
          sortCat.map((sort) => Uri.encodeComponent(sort)).toList(); */
      final List<String> ageSort =
          ageGroup.map((age) => Uri.encodeComponent(age)).toList();

      final positionMap = sortCat.contains('nearest')
          ? await LocationController().userCurrentPosition()
          : null;
      final latitude = positionMap?["latitude"];
      final longitude = positionMap?["longitude"];

      // Construct the complete URL with query parameters
              //  event sort todo
      final url = '$baseUrl?'
          '${evetCat.isEmpty ? '' : 'category=${encodedCategories.join(",")}&'}'
          '${sortCat.isNotEmpty ? "sort=$sortCat&":""}'
          //'${sortCat.isNotEmpty ? "sort=${encodedSort.join(",")}&" : ""}'
          '${ageGroup.isNotEmpty ? "age_group=${ageSort.join(",")}&" : ""}'
          '${startPrice.isNotEmpty ? "price_from=$startPrice&" : ""}'
          '${endPrice.isNotEmpty ? "price_to=$endPrice&" : ""}'
          '${(filterDate.isEmpty || filterDate == 'null') ? '' : "start_date=$filterDate&"}'
          '${sortCat.contains('nearest') ? "latitude=$latitude&longitude=$longitude&" : ""}'
          '${titleFilter.isNotEmpty ? "title=$titleFilter&" : ""}'
          '${locationFilter.isNotEmpty ? "location=$locationFilter&" : ""}';

      ResponseModel<String?> response =
          await apiService.getData<String>(context, url);
      if (response.responseStatus == ResponseStatus.success) {
        filterLoder.value = false;
        List data = response.data["data"];
        advanceFilterController.eventModalcontroller.value =
            data.map((e) => HomeEventsModel.fromJson(e)).toList();
        logger.f('data api services of filtred events $data');
        return data.map((e) => HomeEventsModel.fromJson(e)).toList();
      } else {
        filterLoder.value = false;
      }
    } catch (e) {
      filterLoder.value = false;
      // Handle any exceptions
    }
  }
}
