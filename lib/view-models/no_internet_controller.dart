import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  var connectionType = "".obs;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription streamSubscription;
  RxBool isConnected = true.obs;
  @override
  void onInit() {
    super.onInit();
    // getConnctionStatus();
    streamSubscription =
        connectivity.onConnectivityChanged.listen(getConnectionType);
    getConnctionStatus();
  }

  void getConnctionStatus() async {
    List<ConnectivityResult> connectionResult;
    try {
      connectionResult = await connectivity.checkConnectivity();
      getConnectionType(connectionResult);
    } catch (e) {
      Get.snackbar("excepetion", "Error during connectivity cheking");
      return;
    }
  }

  void getConnectionType(connectionResult) {
    if (connectionResult[0] == ConnectivityResult.none) {
      connectionType.value = "No Internet";
      isConnected.value = false;
      // Get.snackbar(
      //   'No Internet',
      //   'Please check you\'r Internet connection',
      //   backgroundColor: kTextBlack,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
    } else {
      connectionType.value = "Mobile Internet";
      isConnected.value = true;
      // if (!isConnected.value) {
      // Get.snackbar(
      //   'Internet Connection',
      //   'Internet Connected',
      //   backgroundColor: kTextBlack,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      // }
    }
  }

  @override
  void onClose() {
    streamSubscription.cancel();
    super.onClose();
  }
}
