import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_times/view-models/global_controller.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../../data/repository/services/advance_filter_service.dart';
import '../../../utils/constant.dart';
import '../../../view-models/SubscriptionPreference.dart';

// class ConnectTimeOut extends StatefulWidget {
//   const ConnectTimeOut({super.key});

//   @override
//   State<ConnectTimeOut> createState() => _ConnectTimeOutState();
// }

// class _ConnectTimeOutState extends State<ConnectTimeOut> {
//   // final GlobalController globalController = Get.find<GlobalController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: kPrimaryColor),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(connectionTime,
//                   style: paragraphStyle, textAlign: TextAlign.center),
//               const SizedBox(height: 20),
//               myElevatedButtonOutline(
//                   onPressed: () {
//                     setState(() {});

//                   },
//                   text: 'Try Again!')
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ConnectTimeOut extends StatefulWidget {
  const ConnectTimeOut({super.key});

  @override
  State<ConnectTimeOut> createState() => _ConnectTimeOutState();
}

class _ConnectTimeOutState extends State<ConnectTimeOut> {
  final GlobalController globalController = Get.find<GlobalController>();

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      globalController.connectionTimeout.value = false;
    }
  }
  ProfileExtendedDataController profileextendedcontroller =
      Get.put(ProfileExtendedDataController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!globalController.connectionTimeout.value) {
        // If the connection timeout is false, pop this screen
        profileextendedcontroller.profileextenddata.value.data=null;
        Navigator.pop(context);
      }
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(connectionTime,
                    style: paragraphStyle, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                myElevatedButtonOutline(
                  onPressed: () async {
                    globalController.connectionTimeout.value = true;
                    _checkConnectivity(); // Recheck connectivity
                  },
                  text: 'Try Again!',
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
