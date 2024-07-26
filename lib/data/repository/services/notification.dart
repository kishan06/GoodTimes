import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getxx;
import 'package:get_storage/get_storage.dart';

import '../../common/scaffold_snackbar.dart';
import '../../models/notification_model.dart';
import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

class NotificationServices{
 Dio dio = Dio();
 Future getNotificationList(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.notificationList, // Pass the API endpoint
      );
      // log("venu get before sent to model ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        List data = response.data["data"];
        log('Notification services category data $data');
        return data.map((e) => NotificationList.fromJson(e)).toList();
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }
  Future getNotificationCategory(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.notificationCategory, // Pass the API endpoint
      );
      // log("venu get before sent to model ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        List data = response.data["data"];
        log('Notification services category data $data');
        return data.map((e) => NotificationCategory.fromJson(e)).toList();
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }


  // enable and disable category notification
   Future<ResponseModel> notificationCategoryEableDisabled(context,{notificationCategory,enableDisable}) async {
    if(enableDisable == false)enableDisable = "False";
    if(enableDisable == true)enableDisable = "True";
    // log("check boolean value in string $enableDisable");

    try {
      final formData = FormData.fromMap({
        "notification_category": notificationCategory,
        "enable": enableDisable,
      });
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.post(Endpoints.notificationCategoryEnableDisable,
          options: Options(headers: header), data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var message = response.data["data"].toString().split(":");
        snackBarSuccess(context, message: "${message[0].capitalize} notification ${message[1]==" False."?"disabled":"enabled"}");
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {

      // log('respose of create event exceptions only ${e}');
      // log('respose of create event exceptions ${e.response?.data["message"]}');
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