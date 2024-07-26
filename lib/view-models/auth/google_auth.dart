import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getX;
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/repository/endpoints.dart';
import '../../data/repository/response_data.dart';
import '../../data/repository/services/logout_service.dart';
import '../global_controller.dart';

// _handleSignIn functions
final GoogleSignIn _googleSignIn = GoogleSignIn();
GoogleSignInAccount? _currentUser;
Dio dio = Dio();
GlobalController globalContoller = getX.Get.put(GlobalController());
// RxBool _isAuthorized = false.obs; // has granted permissions?

Future<void> handleSignOut() => _googleSignIn.disconnect();

intTheFunc() {
  _googleSignIn.onCurrentUserChanged
      .listen((GoogleSignInAccount? account) async {
    bool isAuthorized = account != null;
    log('is authorized $isAuthorized');
    _currentUser = account;
    // setState(() {
    //   _currentUser = account;
    //   _isAuthorized = isAuthorized;
    // });
  });
  _googleSignIn.signInSilently();
}

Future handleSignIn(context, {userType, referralCode}) async {
  log("googlemessage user type when login with google $userType, referralCode $referralCode");

  try {
    var value = await _googleSignIn.signIn();
    var googleKey = await value?.authentication;
    globalContoller.accessToken.value = googleKey!.accessToken!;
    // log("login access token ${googleKey.accessToken}");
    // log("login id ${googleKey.idToken}");
    try {
      // log('check access token generated or not ${globalContoller.accessToken.value}');
      // log('check access token generated or not type ${globalContoller.accessToken.value.runtimeType}');
      Response response = await dio.post(
        Endpoints.googleLogin,
        data: {
          "access_token":globalContoller.accessToken.value,
          "principal_type": userType,
          "referral_code":referralCode,
        },
      );
      // Handle the response
      log("response of all data after call the api only response $response");
      log("response of all data after call the api ${response.data}");
      if (response.statusCode == 200) {
        log("googlemessage8");
        snackBarSuccess(context, message: 'Logged in successfull');
        log('user data ${response.data}');
        var data = response.data["data"];
        GetStorage().write('accessToken', data["access"]);
        GetStorage().write('profileStatus', data["complete"]);
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
        // Do something with the data
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        snackBarError(context, message: e.response?.data["message"]);
          handleSignOut();
           SignOutAccountService().signOutAccountService(context);
        return const ResponseModel(
          responseStatus: ResponseStatus.failed,
          data: null,
        );
      } else
      if (e.response?.statusCode == 403){
        snackBarError(context, message: e.response?.data["message"]);
         handleSignOut();
          SignOutAccountService().signOutAccountService(context);
        return const ResponseModel(
          responseStatus: ResponseStatus.failed,
          data: null,
        );
      }else
       if (e.response?.statusCode == 404){
        snackBarError(context, message: e.response?.data["message"]);
         handleSignOut();
          SignOutAccountService().signOutAccountService(context);
        return const ResponseModel(
          responseStatus: ResponseStatus.failed,
          data: null,
        );
      }else {
        // Handle other DioErrors
        log('Dio Error: ${e.message}');
         handleSignOut();
          SignOutAccountService().signOutAccountService(context);
        snackBarError(context, message: 'Something went wrong. Please try again later.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }catch (e) {
      log("error messgaes while login whith google $e");
      // Handle any exceptions
    }
  } catch (error) {
    log("login time errors $error");
  }
  return globalContoller.accessToken.value;
}
