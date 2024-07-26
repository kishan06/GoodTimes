import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:good_times/data/models/app_version_model.dart';
import 'package:good_times/data/repository/response_data.dart';
import '../api_services.dart';
import '../endpoints.dart';
import 'dart:io';

class AppVersionsService {
  Dio dio = Dio();
  Future appVersions(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      log("fewrfrew ${Endpoints.appVersion}?type=${Platform.isAndroid?"android":"ios"}");
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        "${Endpoints.appVersion}?type=${Platform.isAndroid?"android":"ios"}", // Pass the API endpoint
      );
      // logger.e("response of app versiona data ${response.data["data"]}");
      if (response.responseStatus == ResponseStatus.success) {
        var data = response.data;
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: AppVersionModel.fromjson(data["data"]),
        );
      }else{
        return const ResponseModel(data: null,responseStatus: ResponseStatus.failed);
      }
    } catch (e) {
      logger.e("error on $e");
      return const ResponseModel(data: null,responseStatus: ResponseStatus.failed);
    }
  }
}
