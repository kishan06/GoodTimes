// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/views/screens/auth/login/login.dart';

import '../../view-models/global_controller.dart';
import '../common/scaffold_snackbar.dart';
import 'response_data.dart';

class ApiService {
  final Dio dio;
  GlobalController globalController = Get.put(GlobalController());

  ApiService(this.dio);

  Future<ResponseModel<T>> getData<T>(
    BuildContext context,
    String endpoint,
  ) async {
    try {
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      dio.interceptors.add(RetryInterceptor(
        dio: dio,
        logPrint: print, // specify log function (optional)
        retries: 3, // retry count (optional)
        retryDelays: const [
          // set delays between retries (optional)
          Duration(seconds: 1),
          Duration(seconds: 2),
        ],
        retryEvaluator: (error, attempt) {
          log("error in RetryInterceptor message  ${error.message}");
          log("error in RetryInterceptor type  ${error.type}");
          log("error in RetryInterceptor attempt  $attempt");
          return false;
        },
      ));
      final response = await dio.get(
        endpoint,
        options: Options(
          headers: header,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          receiveDataWhenStatusError: true,
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        globalController.connectionTimeout.value = false;
        log('Response data: $data');
        return ResponseModel<T>(
          responseStatus: ResponseStatus.success,
          data: data,
        );
      }
    } on DioException catch (e) {
      log("time exception ${e.type}");

      if (e.response?.statusCode == 500) {
        globalController.serverError.value = true;

        snackBarError(context,
            message: 'Bad Request. Please check your input.');
      } else if (e.response?.statusCode == 400) {
        globalController.serverError.value = false;
        snackBarError(context,
            message: 'Bad Request. Please check your input.');
      } else if (e.response?.statusCode == 401) {
        GetStorage().write('accessToken', null);
        GetStorage().write('profileStatus', null);
        globalController.serverError.value = false;
      } else if (e.response?.data["message"]["message"] ==
          "Token is invalid or expired") {
        Get.to(() => const LoginScreen());
        globalController.serverError.value = false;
      } else if (e.response?.statusCode == 404) {
        snackBarError(context, message: e.response?.data["message"]);
        globalController.serverError.value = false;
      } else if (e.type == DioExceptionType.connectionTimeout) {
        log("message connectionTimeout");
        globalController.connectionTimeout.value = true;
        snackBarError(context,
            message: Exception("Connection  Timeout Exception"));
        globalController.serverError.value = false;
      } else if (e.type == DioExceptionType.connectionError) {
        log("message connectionError");
        globalController.connectionTimeout.value = true;
        globalController.serverError.value = false;
        snackBarError(context,
            message: Exception("Connection  Timeout Exception"));
        return ResponseModel<T>(
          responseStatus: ResponseStatus.error,
          data: e.type,
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        log("message receiveTimeout");
        globalController.connectionTimeout.value = true;
        globalController.serverError.value = false;
      } else {
        log('Dio Error: ${e.message}');
        snackBarError(context,
            message: 'An error occurred. Please try again later.');
        globalController.serverError.value = false;
      }
      return ResponseModel<T>(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      log('Error: $e');
      globalController.serverError.value = false;
      snackBarError(context,
          message: 'An error occurred. Please try again later.');
      return ResponseModel<T>(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
    return ResponseModel<T>(
      responseStatus: ResponseStatus.failed,
      data: null,
    );
  }

// Post api function defined here  with type parameter T which is the model class for the API response.
  Future<ResponseModel<T>> postData<T>(
    BuildContext context,
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      final response = await dio.post(endpoint,
          data: data, options: Options(headers: header));
      log('direct response $response');
      if (response.statusCode == 200) {
        final responseData = response.data;
        log('Response data: $responseData');
        return ResponseModel<T>(
          responseStatus: ResponseStatus.success,
          data: responseData,
        );
      }
    } on DioException catch (e) {
      log("dio exceptiosn ${e.response}");
      if (e.response?.statusCode == 400) {
        snackBarError(context,
            message: 'Bad Request. Please check your input.');
      } else if (e.response?.statusCode == 404) {
        snackBarError(context, message: e.response?.data["message"]);
      } else {
        log('Dio Error: ${e.message}');
        snackBarError(context,
            message: 'An error occurred. Please try again later.');
      }
      return ResponseModel<T>(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      log('Error: $e');
      snackBarError(context,
          message: 'An error occurred. Please try again later.');
      return ResponseModel<T>(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
    return ResponseModel<T>(
      responseStatus: ResponseStatus.failed,
      data: null,
    );
  }
}
