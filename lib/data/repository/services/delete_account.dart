import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import '../../../view-models/auth/google_auth.dart';
import '../../../view-models/deep_link_model.dart';
import '../../common/scaffold_snackbar.dart';
import '../endpoints.dart';
import '../response_data.dart';
import 'logout_service.dart';

class DeleteUserServices {
  Dio ddio = Dio();
  Future<ResponseModel> deleteUser(context) async {
    try {
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.delete(Endpoints.accoutDelete,
          options: Options(headers: header));
      Logger().e('respose of delete api $response');

      if (response.statusCode == 200) {
        snackBarSuccess(context, message: response.data["message"]);
        SignOutAccountService().signOutAccountService(context);
        log('response.body ${response.data}');
        GetStorage().write('accessToken', null);
        GetStorage().write('profileStatus', null);
        globalContoller.accessToken.value = '';
        globalReferralCode = '';
        handleSignOut();
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      log('respose of contact us exceptions ${e.response?.data["message"]}');
      if (e.response?.statusCode == 400) {
        snackBarError(context,
            message: "Something went wrong. Please check or try again.");
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        // Handle other DioErrors
        log('Dio Error: ${e.message}');
        snackBarError(context,
            message: 'Something went wrong. Please try again later.');
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
