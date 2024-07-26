import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:good_times/data/repository/response_data.dart';
import '../../models/events_model.dart';
import '../api_services.dart';
import '../endpoints.dart';

class EventManagerServices {
  Dio dio = Dio();
  Future getEventManagerEventas(context, {filterParams}) async {
    log("filter tab in service file $filterParams");
    // if (filterParams == "high_admission_cost")filterParams = "expensive"; //if event filter by high
    final ApiService apiService = ApiService(dio);
    try {
      ResponseModel<String?> response = await apiService.getData<String>(
        context,
        "${Endpoints.eventManager}?filter=$filterParams",
      );
      log("event filtered data get before sent to model ${response.data}");
      if (response.responseStatus == ResponseStatus.success) {
        List data = response.data["data"];
        log('data api services of venu $data');
        return data.map((e) => EventsModel.fromJson(e)).toList();
      } else {}
    } catch (e) {
      // Handle any exceptions
    }
  }
}
