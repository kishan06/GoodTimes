import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view-models/global_controller.dart';
import '../../../view-models/no_internet_controller.dart';
import 'connection_timeOut.dart';
import 'no_internet.dart';
import 'server_error.dart';

RxBool requireddataload = false.obs;
ConnectivityController connectivityController =
    Get.put(ConnectivityController());
GlobalController globalController = Get.put(GlobalController());
Widget parentWidgetWithConnectivtyChecker({child}) {
  return Obx(() {
    if (globalController.connectionTimeout.value == true) {
      requireddataload.value = true;
      return const ConnectTimeOut();
    } else if (connectivityController.isConnected.value == false) {
      requireddataload.value = true;

      return const NoInternetConnection();
    }
    if (globalController.serverError.value == true) {
      requireddataload.value = true;

      return const ServerError();
    } else {
      return child;
    }
  });
}

// Widget parentWidgetWithConnectivtyChecker({required Widget child}) {
//   return Obx(() {
//     if (globalController.connectionTimeout.value) {
//       return const ConnectTimeOut();
//     } else if (!connectivityController.isConnected.value) {
//       return const NoInternetConnection();
//     } else if (globalController.serverError.value) {
//       return const ServerError();
//     } else {
//       return child;
//     }
//   });
// }
