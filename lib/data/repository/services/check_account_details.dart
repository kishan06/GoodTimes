import 'package:dio/dio.dart';

import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

class CheckBankDetails {
  Dio dio = Dio();
  Future getLikesEvents(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.checkBankDetails, // Pass the API endpoint
      );
      // log("venu get before sent to model ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        var data = response.data["data"];
        return data;
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