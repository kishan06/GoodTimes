import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:good_times/data/models/chat_model.dart';

import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

class ChatServices{
  Dio dio = Dio();
  Future chatServices(context,{eventId}) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        "${Endpoints.chatHistory}$eventId/", // Pass the API endpoint
      );
      log("chat history data ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        List data = response.data["data"];
        log('chat api services $data');
        return ResponseModel(responseStatus: ResponseStatus.success, data: data.map((e) => ChatModel.fromJson(e)).toList());
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }

  Future createChatServices(context,{eventId}) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        "${Endpoints.createChatEvent}$eventId/", // Pass the API endpoint
      );
      log("chat history data ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        var data = response.data["data"];
        log('creat chat api services $data');
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
}