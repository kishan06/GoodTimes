import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/repository/endpoints.dart';

import '../../../view-models/auth/google_auth.dart';
import '../../common/scaffold_snackbar.dart';
import '../response_data.dart';

class CreateVenu {
  Future<ResponseModel> createVenu(context,
      {title, adrs, img, lat, lang}) async {
    log("create venu title $title adrs $adrs, img $img, lat $lat, lng $lang");
    try {
      final formData = FormData.fromMap(
        {
          'title': title,
          'address': adrs,
          'image': await MultipartFile.fromFile(img, filename: 'venu_img.jpg'),
          'latitude': lat,
          'longitude': lang,
        },
      );
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.post(Endpoints.addVenu,
          options: Options(headers: header), data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // snackBarSuccess(context, message: "you have created venue successfully.");
        log('response.body ${response.data}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      log('respose of otp verification exceptions ${e.response}');
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        log('Bad Request Error: ${e.message}');
        snackBarError(context, message: e.response?.data["message"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        // Handle other DioErrors
        log('Dio Error: $e');
        snackBarError(context, message: 'An error occurred. Please try again later.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      // Handle other exceptions
      log('Error: $e');
      snackBarError(context,message: 'An error occurred. Please try again later.');
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
