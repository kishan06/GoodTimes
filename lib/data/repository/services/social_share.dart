import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getxx;
import 'package:get_storage/get_storage.dart';

import '../../../view-models/auth/google_auth.dart';
import '../../../view-models/global_controller.dart';
import '../../common/scaffold_snackbar.dart';
import '../endpoints.dart';
import '../response_data.dart';

class SocialShareService {
  Dio ddio = Dio();
  GlobalController globalController = getxx.Get.find();
  Future<ResponseModel> socialShare(context, {eventid, platforms}) async {
    log("event platform details $eventid, $platforms");
    try {
      final formData = FormData.fromMap(
        {
          // "name": name,
          // "email_address": email,
          // "mobile_number": "$mobileNumber",
          // "subject":"Hello",
          // "message":messgae,
        },
      );
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response =
          await dio.get("${Endpoints.socialshare}$eventid/?platform=$platforms",
              // Endpoints.socialshare,
              options: Options(headers: header),
              data: formData);
      log('respose of contact us form ${response.statusCode}');

      if (response.statusCode == 500) {
        globalController.serverError.value = true;
        snackBarError(context,
            message: 'Bad Request. Please check your input.');
      } else if (response.statusCode == 200) {
        globalController.serverError.value = false;
        log('response.body ${response.data["success_messages"]}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      log('respose of contact us exceptions ${e.response?.data["message"]}');
      if (e.response?.statusCode == 400) {
        snackBarError(context,
            message: "Something went wrong. Please check or try again.");
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        // Handle other DioErrors
        log('Dio Error: ${e.message}');
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
          message: 'Something went wrong. Please try again later.');
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
