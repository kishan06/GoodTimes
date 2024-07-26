import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view-models/global_controller.dart';
import '../../../view-models/no_internet_controller.dart';
import 'connection_timeOut.dart';
import 'no_internet.dart';
import 'server_error.dart';

ConnectivityController connectivityController = Get.put(ConnectivityController());
  GlobalController globalController = Get.put(GlobalController());
Widget parentWidgetWithConnectivtyChecker({child}) {
  return Obx(() {
    if(globalController.connectionTimeout.value==true){
      return  const ConnectTimeOut();
    }else if (connectivityController.isConnected.value == false){
      return const NoInternetConnection();
    } if(globalController.serverError.value == true){
      return const ServerError();
    } else {
      return child;
    }
  });
}
