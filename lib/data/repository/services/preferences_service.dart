import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:good_times/data/models/event_age_group_model.dart';
import 'package:good_times/data/models/event_categories_model.dart';

import '../../models/get_preferences_model.dart';
import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

class PreferencesService {
  Dio dio = Dio();
  Future getEventCategoriesService(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel response = await apiService.getData<String>(
          context, Endpoints.getEventCategories);

      if (response.responseStatus == ResponseStatus.success) {
        List data = response.data;
        return data.map((e) => EventCategoriesModdel.fromJson(e)).toList();
      } else {
        snackBarError(context,
            message: 'Something went wrong, Please try again.');
      }
    } catch (e) {
      snackBarError(context,
          message: 'Something went wrong, Please try again.');
    }
  }

  final header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${GetStorage().read('accessToken')}"
  };

  Future<ResponseModel> postPreferences(context, {categoriesList}) async {
    log('preferences details in services $categoriesList');
    try {
      Response response = await dio.post(Endpoints.postEventCategories,
          data: {"preferred_categories": categoriesList},
          options: Options(headers: header));

      if (response.statusCode == 200 || response.statusCode == 201) {
        snackBarSuccess(context,
            message: 'Your preferences selected successfully.');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
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
      } else {
        // Handle other DioErrors
        log('Dio Error: ${e.message}');
        snackBarError(context,
            message:
                'An error occurred. Please try again later. dio exceptions');
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

  Future getPreferencesServices(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.getPreferences, // Pass the API endpoint
      );
      // log("venu get before sent to model ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        log('data api services of preferences id ${response.data["data"]}');
        return ResponseModel(
            responseStatus: ResponseStatus.success,
            data: PreferencesModel.fromJson(response.data["data"]));

        // UserPreferences.fromJson(jsonDecode(response.body));
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }

  Future getAgeGroup(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel response =
          await apiService.getData<String>(context, Endpoints.getAgeGroup);
      log("get age group ${response.data}");
      if (response.responseStatus == ResponseStatus.success) {
        var ageObj = AgeGroupModel.fromJson(response.data);
        List ageGroupList = ageObj.data ?? [];
        return ageGroupList;
      } else {
        snackBarError(context,
            message: 'Something went wrong, Please try again.');
      }
    } catch (e) {
      snackBarError(context,
          message: 'Something went wrong, Please try again.');
    }
  }
}
