import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:good_times/data/repository/response_data.dart';

import '../../common/scaffold_snackbar.dart';
import '../endpoints.dart';

class ForgotPasswordService{

  Dio dio = Dio();

  Future<ResponseModel> reseteOtp(context,{email}) async{

    try {
      Response response = await dio.post(
        Endpoints.requestOtp,
        data: {
          "email": email,
          },
      );
      if (response.statusCode == 200) {
        snackBarSuccess(context, message: response.data["message"]);
        // log('response.body ${}');
        var data = response.data;
        log('response of forgot data $data');
        
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
      
    }on DioException catch(e){
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

    }  catch (e) {
      log('Error: $e');
      snackBarError(context,
          message: 'An error occurred. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
      
    }
    return const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
  }


  // create new password......api
  Future<ResponseModel> resetPassword(context,{email,password,confirmPassword}) async{
    log('faorgot password input in api $email, $password, $confirmPassword');

    try {
      Response response = await dio.post(
        
        Endpoints.resetPassword,
        data: {
          "email": email,
          "password":password,
          "confirm_password":confirmPassword
          },
      );
      if (response.statusCode == 200) {
        snackBarSuccess(context, message: response.data["message"]);
        // log('response.body ${}');
        var data = response.data;
        log('response of forgot data $data');
        
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
      
    }on DioException catch(e){
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

    }  catch (e) {
      log('Error: $e');
      snackBarError(context,
          message: 'An error occurred. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
      
    }
    return const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
  }
}