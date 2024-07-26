import 'package:dio/dio.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:logger/logger.dart';

import '../api_services.dart';
import '../response_data.dart';

class SignOutAccountService {
  Dio dio = Dio();
  Logger logger = Logger();
  Future signOutAccountService(context,{version}) async {
    final ApiService apiService = ApiService(dio);
    try {
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.deletePlayerId, // Pass the API endpoint
      );
      if (response.responseStatus == ResponseStatus.success) {
        var data = response.data;
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: data,
        );
      } else {
      }
    } catch (e) {
      logger.e("error on $e");
    }
  }
}