import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:good_times/data/repository/response_data.dart';
import '../../models/events_model.dart';
import '../api_services.dart';
import '../endpoints.dart';

List<EventsModel>? eventmodelobj;

class EventManagerServices {
  Dio dio = Dio();
  Future<List<EventsModel>?> getEventManagerEventas(context, {filterParams}) async {
    log("filter tab in service file $filterParams");
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
        eventmodelobj = data.map((e) => EventsModel.fromJson(e)).toList();
        return eventmodelobj;
      } else {
        // Handle the case where responseStatus is not success
        log("Failed to retrieve event data");
        return null;
      }
    } catch (e) {
      // Handle any exceptions
      log("Error occurred: $e");
      return null;
    }
  }
}
