import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:good_times/data/repository/response_data.dart';

import '../../common/scaffold_snackbar.dart';
import '../../models/orgnisations_model.dart';

class OrgnisataionsServices {
  Dio dio = Dio();
  Future<ResponseModel> orgnisataionsServices(context,
      {bool passmodel = true}) async {
    try {
      Response response = await dio.get(Endpoints.orgnisataions);
      if (response.statusCode == 200) {
        var data = response.data;
        log('cms data ${data["data"]}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: passmodel
              ? CMSModel.fromJson(
                  data["data"],
                )
              : data,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        snackBarError(context,
            message: 'Bad Request. Please check your input.');
      } else if (e.response?.statusCode == 404) {
        // Handle 404 reffarl code error
        snackBarError(context, message: e.response?.data["message"]);
      } else {
        // Handle other DioErrors
        log('Dio Error: ${e.message}');
        snackBarError(context,
            message: 'An error occurred. Please try again later.');
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } on Exception catch (e) {
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
