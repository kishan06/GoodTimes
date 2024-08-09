import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:good_times/view-models/global_controller.dart';

import '../data/models/ProfileExtend_model.dart';
import '../data/repository/api_services.dart';
import '../data/repository/endpoints.dart';
import '../data/repository/response_data.dart';
Dio dio = Dio();
  GlobalController globalController = Get.put(GlobalController(),permanent:true);

class ProfileExtendedDataController extends GetxController{
    Rx<ProfileExtenddataModel> profileextenddata=ProfileExtenddataModel().obs;

   Future<void> fetchProfileExtendeddata(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.profileextendeddata, // Pass the API endpoint
      );
      // log("venu get before sent to model ${response.data}");
      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        profileextenddata.value=ProfileExtenddataModel.fromJson(response.data);
         if (profileextenddata.value.data != null) {
        if (profileextenddata.value.data!
                .hasActiveSubscription!.hasActiveSubscription !=
            null) {
          globalController.hasActiveSubscription.value =
              profileextenddata.value.data!
                  .hasActiveSubscription!.hasActiveSubscription!;
        }
        if (globalController.hasActiveGracePeriod.value =
            profileextenddata.value.data!
                    .hasActiveSubscription!.inGracePeriod !=
                null) {
          globalController.hasActiveGracePeriod.value =
              globalController.hasActiveGracePeriod.value =
                  profileextenddata.value.data!
                      .hasActiveSubscription!.inGracePeriod!;
        }
      }
        print("r");
        // API call was successful
       
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }

   
}