import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/scaffold_snackbar.dart';
import '../../models/venu_model.dart';
import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

class VenueServices {
  Dio dio = Dio();

  Future getVenue(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.getVenue, // Pass the API endpoint
      );
      // log("venu get before sent to model ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        List data = response.data["data"];
        log('data api services of venu $data');
        return data.map((e) => VenuModel.fromJson(e)).toList();
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }

// patch venues
  Future<ResponseModel> patchVenu(context, {venueId}) async {
    try {
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.patch("${Endpoints.deleteVenue}$venueId/",
          options: Options(headers: header));
      log('respose of edit profile status ${response.statusCode}');

      if (response.statusCode == 200) {
        log('response.body while deleting thge venue ${response.data}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      log('respose of otp verification exceptions ${e.response?.data["message"]}');
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
            message: 'An error occurred. Please try again later.');
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
}
