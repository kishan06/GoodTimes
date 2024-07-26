import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';

import '../../../utils/temp.dart';
import '../endpoints.dart';
import '../response_data.dart';

var dio = Dio();

class RegistrationProccess {
  // sent otp and user type
  // String userTypes = '';
  Future verifyEmail(context, {email, userType}) async {
    log("user type ${TempData.userType}");
    try {
      Response response = await dio.post(
        Endpoints.registrations,
        data: {
          'email': email,
          'principal_type': TempData.userType,
        },
      );

      if (response.statusCode == 200) {
        snackBarSuccess(context, message: response.data["message"]);
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        snackBarError(context,
            message: 'Email already exist, please check your email.');
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      }
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        log('Bad Request Error: ${e.message}');
        snackBarError(context,
            message: 'Bad Request. Please check your input.');
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
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
    } on Exception catch (e) {
      // Handle other exceptions
      log('Error: $e');

      snackBarError(context,
          message:
              'An error occurred. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
  }

// verify otp with email
  Future preVerifyOTP(context, {email, otp}) async {
    log('otp and emails $otp $email');

    try {
        Response response = await dio.post(
        Endpoints.preRegisterOtpVerify,
        data: {
          "otp": otp,
          "email": email,
        },
      );
       log('respose of otp verification ${response.statusCode}');

     
      if (response.statusCode == 200) {
        snackBarSuccess(context, message: response.data["message"]);
        log('response.body in verify otp ${response.data}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
       log('respose of otp verification exceptions ${e.response?.data["message"]}');
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        log('Bad Request Error: ${e.message}');
        snackBarError(context,
            message: e.response?.data["message"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        // Handle other DioErrors
        log('Dio Error: ${e.message}');
        snackBarError(context,
            message: 'An error occurred. Please try again later.');
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
          message: 'An error occurred. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
    
  }

  // complete profile service

  Future completeProfile(context, {fName,lName,email,password,refferalCodeController}) async {
    log('profile complete $fName $lName $email $password,$refferalCodeController');
    try {
      var response = await dio.post(
        Endpoints.completeProfile,
        data: {
          "first_name":fName,
          "last_name":lName,
          "email": email,
          "password":password,
          "confirm_password":password,
          "referral_code":refferalCodeController
          },
      );
      if (response.statusCode == 200) {
        snackBarSuccess(context, message: response.data["message"]);

        // log('response.body ${}');
        var data = response.data["data"];
        log('decode the data ${data["access"]}');
        GetStorage().write('accessToken', data["access"]);
        GetStorage().write('profileStatus', data["complete"]);
        
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        // log('Bad Request Error: ${e.message}');
        snackBarError(context, message: 'Bad Request. Please check your input.');
      } else if (e.response?.statusCode == 404) {
        // Handle 404 reffarl code error
        snackBarError(context, message: e.response?.data["message"]);
      }else {
        // Handle other DioErrors
        log('Dio Error: ${e.message}');
        snackBarError(context,
            message: 'An error occurred. Please try again later.');
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      // Handle other exceptions
      log('Error: $e');
      snackBarError(context,
          message: 'An error occurred. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
  }
}
