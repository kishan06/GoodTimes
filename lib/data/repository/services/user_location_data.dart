import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:good_times/data/repository/response_data.dart';

class UserLocationService {
  Dio dio = Dio();

  Future<ResponseModel> userLocationData(context, {latitude,longitude}) async {
    try {
      if (latitude == null || longitude == null) {
        throw Exception("Latitude or longitude is null");
      }

      final formData = FormData.fromMap(
        {
          "latitude": latitude,
          "longitude": longitude,
        },
      );

      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };

      Response response = await dio.post(
        Endpoints.sendCurrentLocation,
        options: Options(headers: header),
        data: formData,
      );

      log('Response status code: ${response.statusCode}');
      log('Response body: ${response.data}');

      if (response.statusCode == 200) {
        log("user location data send in database $response");
        log("if success then response $response");
        log("if success then response with data ${response.data}");
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      } else {
        log('Server error: ${response.statusCode}');
        return const ResponseModel(
          responseStatus: ResponseStatus.failed,
          data: null,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log('Dio error response: ${e.response!.data}');
        log('Dio error status code: ${e.response!.statusCode}');
      } else {
        log('Dio error: ${e.message}');
      }

      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      log('Error: $e');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
  }
}
