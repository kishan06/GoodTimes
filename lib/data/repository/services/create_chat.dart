import 'dart:developer';

import 'package:dio/dio.dart';

import '../../models/events_ikes_models.dart';
import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

class CreateEventsChatGroup {
  Dio dio = Dio();
  Future createEventsChatGroup(context,{chatId}) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        "${Endpoints.createChatEvent}$chatId/",// Pass the API endpoint
      );
      log("venu get before sent to model ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        List data = response.data["data"];
        log('data api services of events likes $data');
        return data.map((e) => EventsLikeModel.fromJson(e)).toList();
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