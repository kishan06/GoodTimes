import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:good_times/data/repository/response_data.dart';

import '../../../view-models/auth/google_auth.dart';

class UserPlayerIdService {
  Dio dio = Dio();

  Future<ResponseModel> userPlayerIdService(context, {playerId}) async {
    log("player id $playerId");
    try {
      final formData = FormData.fromMap(
        {
          "player_id": playerId,
        },
      );

      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };

      Response response = await dio.post(
        Endpoints.sendPlayerId,
        options: Options(headers: header),
        data: formData,
      );

      log('Response status code: ${response.statusCode}');
      log('Response body: ${response.data}');

      if (response.statusCode == 200) {
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
         handleSignOut();
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
