import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/models/profile.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:logger/logger.dart';

import '../../../view-models/auth/google_auth.dart';
import '../../../view-models/global_controller.dart';
import '../../../views/screens/auth/login/login.dart';
import '../../common/scaffold_snackbar.dart';
import '../api_services.dart';

class ProfileService {
    GlobalController globalContoller = getx.Get.put(GlobalController());
  Dio dio = Dio();
    Logger logger = Logger();
  // grt profile data 
  Future<ResponseModel> getProfileDetails(context) async{
    logger.e("check profiole api data api runs");
    try {
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.get(Endpoints.profile,options: Options(headers: header));

      var data = response.data["data"];
      if(response.statusCode == 200){
        logger.e("profile data $data");
        globalContoller.profileImgPath.value = response.data["data"]["profile_photo"];
        if(data["linkedin_profile"]!=null || data["linkedin_profile"]!=""||data["youtube_profile"]!=null||data["youtube_profile"]!=""||data["facebook_profile"]!=null||data["facebook_profile"]!=""||data["instagram_profile"]!=null||data["instagram_profile"]!=""||data["website"]!=null||data["website"]!=""){
          globalContoller.profileSocialDetails.value = true;
        }
        if(data["linkedin_profile"] == "" && data["youtube_profile"] == ""&& data["facebook_profile"] == "" && data["instagram_profile"] == "" && data["website"] == ""){
          globalContoller.profileSocialDetails.value = false;
        }
         if(data["linkedin_profile"] == null && data["youtube_profile"] == null&& data["facebook_profile"] == null && data["instagram_profile"] == null && data["website"] == null){
          globalContoller.profileSocialDetails.value = false;
        }
        globalContoller.profileUserName.value= "${data["first_name"]} ${data["last_name"]} ";
      return ResponseModel(
        responseStatus: ResponseStatus.success,
        data: ProfileModel.fromJson(data),
      );
      }
      
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        snackBarError(context, message: 'Bad Request. Please try again.');
      } else if (e.response?.statusCode == 404) {
        snackBarError(context, message: e.response?.data["message"]);
      }
      if (e.response?.statusCode == 401) {
        // snackBarError(context, message: "Session expired, Please try again.");
        GetStorage().write("accessToken", "");
        logger.e("e.response ${e.response}");
        if(e.response?.data["detail"] == "User is inactive"){
          handleSignOut();
          getx.Get.offAll(()=>const LoginScreen());
        }
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      logger.e('Error: $e');
      snackBarError(context,
          message: 'Something went wrong. Please try again later');
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
// edit profile
  Future<ResponseModel> editProfile(context,{fName, lastName, profileImg,linkedin,youtube,facebook,instagram,website, phoneNumber}) async {
        logger.e("all data $fName, $lastName, $profileImg, $linkedin, $youtube, $facebook, $instagram, $website $phoneNumber}");
    try {
      final formData = FormData.fromMap(
        {
          "first_name": fName,
          "last_name": lastName,
          "profile_photo": profileImg == ''? '': await MultipartFile.fromFile(profileImg,filename: 'profile_img.jpg'),
          "linkedin_profile":linkedin,
          "instagram_profile":instagram,
          "facebook_profile":facebook,
          "youtube_profile":youtube,
          "website":website,
          "phone_no":phoneNumber,
        },
      );
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.post(Endpoints.profile,
          options: Options(headers: header), data: formData);
      log('respose of edit profile status ${response.statusCode}');

      if (response.statusCode == 200) {
        snackBarSuccess(context, message: response.data["message"]);
        log('response.body ${response.data}');
        log('response.body new ${response.data["data"]["profile_photo"]}');
        //  globalContoller.profileImgPath.value = response.data["data"]["profile_photo"];
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      log('respose of otp verification exceptions ${e.response?.data["message"]}');
      log('respose of otp verification exceptions ${e.response?.data["errors"]}');
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        log('Bad Request Error: ${e.message}');
        snackBarError(context, message: e.response?.data["message"]);
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

    return const ResponseModel(
      responseStatus: ResponseStatus.failed,
      data: null,
    );
  }

// get referral code
  Future getUserReferral(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.referralCode, // Pass the API endpoint
      );
      // log("venu get before sent to model ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        // API call was successful
        var data = response.data["data"][0]["referral_code"];

        log('data api services of referral codes $data');
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
