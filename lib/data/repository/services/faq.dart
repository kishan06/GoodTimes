import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:good_times/data/repository/response_data.dart';
import '../../models/faq_model.dart';
import '../api_services.dart';
import '../endpoints.dart';

class FaqService {
  Dio dio = Dio();
  Future faq(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.faq, // Pass the API endpoint
      );
      // log("venu get before sent to model ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        List data = response.data["data"];
        log('data api services of of faq in apiservices $data');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: data.map((e) => FaqModel.fromJson(e)).toList(),
        );
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }
}
