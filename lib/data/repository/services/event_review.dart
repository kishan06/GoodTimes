import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/scaffold_snackbar.dart';
import '../endpoints.dart';
import '../response_data.dart';

class EventReviewsService{
  Dio dio = Dio();
  Future<ResponseModel> eventReviewsService(context,{eventId, rating,eventDescriptions}) async {
    log('Event rating services ${eventId[0]} - descriptions $rating - start date $eventDescriptions');

    try {
      final formData = FormData.fromMap({
        "event": eventId[0],
        "rating": rating,
        "review_text": eventDescriptions,
      });
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.post(Endpoints.eventRatings,
          options: Options(headers: header), data: formData);
      log('respose of create event status only response  $response');
      log('respose of create event status ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        snackBarSuccess(context, message: "Thank you for your feedback.");
        log('response.body ${response.data}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      // log('respose of create event exceptions only e ${e}');
      log('respose of create event exceptions ${e.response?.data["message"]}');
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        log('Bad Request Error: ${e.message}');
        snackBarError(context, message: e.response?.data["message"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        // Handle other DioErrors
        log('Dio Error: ${e.message}');
        snackBarError(context,
            message: 'Something went wronng try again.');
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
          message: 'Something went wronng try again.');
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
}