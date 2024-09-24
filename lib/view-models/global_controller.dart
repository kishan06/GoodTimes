import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/views/screens/event_manager/edit_event.dart/edit_event.dart';
import 'package:logger/logger.dart';

import '../data/models/profile.dart';
import '../data/repository/endpoints.dart';
import '../data/repository/response_data.dart';
import '../views/screens/auth/login/login.dart';
import 'auth/google_auth.dart';

class GlobalController extends GetxController {

  RxBool apiCall =  false.obs;
  Logger logger = Logger();

  RxString locationName = "".obs;
  RxString profileImgPath = "".obs;
  RxString profileUserName = "".obs;
  RxString email = "".obs;
  RxString venuImgPath = "".obs;
  RxString accessToken = "".obs;
  // check subscription value
  RxBool profileSocialDetails = false.obs;
  RxBool hasActiveSubscription = false.obs;
  RxBool hasActiveGracePeriod = false.obs;
  RxBool accountIsActive = false.obs;
  RxBool forceUpdate = false.obs;
  RxBool recommendUpdate = false.obs;
  RxBool connectionTimeout = false.obs;
  RxBool checkiffilterload =true.obs;
  RxBool serverError = false.obs;
  RxBool accoutTransferSuccess = false.obs;


  RxBool hasPreference = false.obs;

  // venue variable
  RxString address = ''.obs;
  RxString lat = ''.obs;
  RxString long = ''.obs;

  //Event image variable path
  RxString eventThumbnailImgPath = "".obs;
  RxList eventPhotosmgPath = <String>[].obs;

  RxInt thumbImgType = ImgTypes.network.index.obs;
  RxString thumbImgPath = "".obs;
  RxList eventFilterCategory = [].obs;

  @override
  void onInit() {
    log("On init called");
    getProfileDetail();
    // getPlayerId();
    super.onInit();
  }

  getProfileDetail() async {
    try {
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      
      var response = await dio.get(Endpoints.profile, options: Options(headers: header));
       Logger().e("profile data ${response.data}");
      var data = response.data["data"];
       Logger().e("profile data $data");
      if (response.statusCode == 200) {
        // Logger().e("profile data ${data["profile_photo"]}");
        profileImgPath.value = data["profile_photo"];
        return ProfileModel.fromJson(data);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // snackBarError(context, message: 'Bad Request. Please try again.');
      } else if (e.response?.statusCode == 404) {
        // snackBarError(context, message: e.response?.data["message"]);
      }
      if (e.response?.statusCode == 401) {
        // snackBarError(context, message: "Session expired, Please try again.");
        GetStorage().write("accessToken", "");
        logger.e("e.response ${e.response}");
        if(e.response?.data["detail"] == "User is inactive"){
           handleSignOut();
          Get.offAll(()=>const LoginScreen());
        }
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      logger.e('Error: $e');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
  }
}
