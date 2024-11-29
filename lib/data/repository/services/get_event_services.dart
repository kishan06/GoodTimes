import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:intl/intl.dart';

import '../../models/events_model.dart';
import '../../models/home_event_modal.dart';
import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

class GetEventServices {
  Dio dio = Dio();
  final header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${GetStorage().read('accessToken')}"
  };

  Future getEvent(context, {filterParams, startDate, endDate}) async {
    dynamic startDates;
    dynamic endDates;

    if (startDate != null && startDate!='' && endDate != null && endDate!='') {
      log("not null $startDates and $endDates");
        startDates = DateFormat('yyyy-MM-dd').format(DateTime.parse(startDate));
        endDates = DateFormat('yyyy-MM-dd').format(DateTime.parse(endDate));
    }
    
    log("filter data url ${Endpoints.getEventFilter}?filter=$filterParams");
  final ApiService apiService = ApiService(dio);
    try {
      ResponseModel<String?> response = await apiService.getData<String>(
        context,
        "${Endpoints.getEventFilter}calendar",
      );
      if (response.responseStatus == ResponseStatus.success) {
        List data = response.data["data"];
        log('data api services of filtred events $data');
        return data.map((e) => HomeEventsModel.fromJson(e)).toList();
      } else {}
    } catch (e) {
      // Handle any exceptions
    }
  }
  // get events details with id
  Future getEventDetails(context, {getEventId}) async {
    final ApiService apiService = ApiService(dio);
    try {
      ResponseModel<String?> response = await apiService.getData<String>(
        context,
        "${Endpoints.getEventDetailsWithId}$getEventId/",
      );
      if (response.responseStatus == ResponseStatus.success) {

        return EventsModel.fromJson(response.data["data"]);
      } else {
        snackBarError(context, message: "No data found 😞");
      }
    } catch (e) {
      log("get all the  event error ${e.toString()}");
      // Handle any exceptions
    }
  }

  // like the event
  Future<ResponseModel> eventLike(context, {eventId}) async {
    try {
      Response response = await dio.post("${Endpoints.eventLike}$eventId/",
          options: Options(headers: header));
      log("event like ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        snackBarSuccess(context, message: response.data["data"]);
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        log('Bad Request Error: ${e.message}');
        snackBarError(context, message: e.response?.data["message"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        // Handle other DioErrors
        log('Dio Error: $e');
        snackBarError(context,
            message: 'Something went wrong. Please try again later.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }

      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      // Handle other exceptions
      log('Error: $e');
      snackBarError(context,
          message: 'An error occurred. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
    return const ResponseModel(
      responseStatus: ResponseStatus.failed,
      data: null,
    );
  }

  // like the intrest and going
  Future<ResponseModel> eventIntrestedAndGoing(context,
      {eventId, intrestedAndGoing}) async {
    log("create venu title $eventId $intrestedAndGoing");
    try {
      Response response = await dio.post(
          "${Endpoints.eventIntrestedAndGoing}$eventId/",
          options: Options(headers: header),
          data: {"status": intrestedAndGoing});
      if (response.statusCode == 200 || response.statusCode == 201) {
        snackBarSuccess(context, message: response.data["message"]);
        log('response.body when i click on going ${response.data["message"]}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        log('Bad Request Error: ${e.message}');
        snackBarError(context, message: e.response?.data["message"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        // Handle other DioErrors
        log('Dio Error: $e');
        snackBarError(context,
            message: 'Something went wrong. Please try again later.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      // Handle other exceptions
      log('Error: $e');
      snackBarError(context,
          message: 'An error occurred. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
    return const ResponseModel(
      responseStatus: ResponseStatus.failed,
      data: null,
    );
  }


   // get events all tags and filter
  Future getEventsAllTags(context, {getEventId}) async {
    final ApiService apiService = ApiService(dio);
    try {
      ResponseModel<String?> response = await apiService.getData<String>(
        context,
        Endpoints.getEventFilterTags,
      );
      if (response.responseStatus == ResponseStatus.success) {
        List data = response.data["data"];
        log('data api services of event inner data $data');
        return data.map((e) => Tags.fromJson(e)).toList();
        
      } else {
        snackBarError(context, message: "No data found 😞");
      }
    } catch (e) {
      log("get all the  event error ${e.toString()}");
      log("get all the  event error ${e}");
      // Handle any exceptions
    }
  }
}
