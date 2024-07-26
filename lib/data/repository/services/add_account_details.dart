import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import '../../common/scaffold_snackbar.dart';
import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

class AddBankDetailsService{
  Dio dio = Dio();
  Logger logger = Logger();


  Future checkBankDetailsService(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context,Endpoints.checkPreference, // Pass the API endpoint
      );
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        var data = response.data["data"];
        logger.f('data api services of preference $data');
        return ResponseModel(responseStatus: ResponseStatus.success, data: data);
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }




  // !add bank details
  Future<ResponseModel> addBankDetails(context,{fName, lName, accountNumber,sortCode}) async {
    log("contact details $fName, $lName, $accountNumber, $sortCode");
    try {
      final formData = FormData.fromMap(
        {
          "first_name": fName,
          "last_name": lName,
          "account_no": accountNumber,
          "sort_code":sortCode,

        },
      );
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.post(Endpoints.addBankDetails,
          options: Options(headers: header), data: formData);

      if (response.statusCode == 200) {
        snackBarSuccess(context, message: response.data["message"]);
        logger.e('response.body ${response.data}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      logger.e('respose of contact us exceptions ${e.response}');
      if (e.response?.statusCode == 400) {
        snackBarError(context, message: "Something went wrong. Please check or try again.");
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        // Handle other DioErrors
        logger.e('Dio Error: ${e.message}');
        snackBarError(context,message: 'Something went wrong. Please try again later.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      // Handle other exceptions
      logger.e('Error: $e');
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