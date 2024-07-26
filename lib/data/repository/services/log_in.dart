import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:good_times/data/repository/response_data.dart';
import '../../common/scaffold_snackbar.dart';

class LogInService {
  Dio dio = Dio();

  // email login function
  Future<ResponseModel> logIn(context, {email, password}) async {
    try {
      Response response = await dio.post(
        Endpoints.logIn,
        data: {"email": email, "password": password},
      );

      log('response data ${response.data}');
      if (response.statusCode == 200) {
        snackBarSuccess(context, message: 'Login successful.');
        var data = response.data["data"];
        log('decode the data $data');
        log('decode the data access ${data["access"]}');
        GetStorage().write('accessToken', data["access"]);
        GetStorage().write('profileStatus', data["complete"]);
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: data,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        snackBarError(context, message: e.response?.data["message"]);
        return const ResponseModel(
          responseStatus: ResponseStatus.failed,
          data: null,
        );
      } else
      if (e.response?.statusCode == 403){
        snackBarError(context, message: e.response?.data["message"]);
        return const ResponseModel(
          responseStatus: ResponseStatus.failed,
          data: null,
        );
      }else
       if (e.response?.statusCode == 404){
        snackBarError(context, message: e.response?.data["message"]);
        return const ResponseModel(
          responseStatus: ResponseStatus.failed,
          data: null,
        );
      }else {
        // Handle other DioErrors
        log('Dio Error: ${e.message}');
        snackBarError(context, message: 'Something went wrong. Please try again later.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      log('Error: $e');

      snackBarError(context,
          message: 'An error occurred. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
    return const ResponseModel(
        responseStatus: ResponseStatus.failed, data: null);
  }
}
