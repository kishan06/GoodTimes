// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/models/app_version_model.dart';
import '../data/repository/services/app_versions.dart';
import '../utils/constant.dart';
import 'global_controller.dart';
import 'dart:io';

class AppVersionController extends GetxController {
  bool isRecomended = GetStorage().read('recommendedUpdate')??true;
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  final GlobalController globalController = Get.find<GlobalController>();
  final Logger logger = Logger();
  RxBool canSkip = true.obs;

  Future<void> initPackageInfo(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();
    packageInfo = info;

    var value = await AppVersionsService().appVersions(context);
    AppVersionModel data = value.data;

    log("device info ${info.version}");
    log("device info from api ${data.version}");
    log("device info ${info.version.runtimeType}");
    log("device info from api ${data.version.runtimeType}");

    var isDataVersionGreaterThanInfoVersion = data.version!.compareTo(info.version) > 0;
    log("device isDataVersionGreaterThanInfoVersion $isDataVersionGreaterThanInfoVersion");

    if (isDataVersionGreaterThanInfoVersion) {
      globalController.forceUpdate.value = data.forceUpdate!;
      globalController.recommendUpdate.value = data.recommendUpdate!;
    } else {
      globalController.forceUpdate.value = false;
      globalController.recommendUpdate.value = false;
    }

    if (globalController.recommendUpdate.value) {
     isRecomended? showForceUpdateModal(context, canSkip.value):null;
    }

    if (globalController.forceUpdate.value && globalController.recommendUpdate.value) {
      canSkip.value = false;
      log("message1");
      showForceUpdateModal(context, canSkip.value);
    }

    if (globalController.forceUpdate.value) {
      canSkip.value = false;
      log("message1");
      showForceUpdateModal(context, canSkip.value);
    }
  }

  showForceUpdateModal(BuildContext context, bool canBack) {
    return showDialog(
      context: context,
      barrierDismissible: globalController.forceUpdate.value ? false : true,
      builder: (context) => PopScope(
        canPop: globalController.forceUpdate.value ? false : true,
        child: AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: kTextBlack,
          content: Text(
            "New version is available, please update.",
            style: paragraphStyle.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: [
            canSkip.value
                ? OutlinedButton(
                    onPressed: () {
                      canSkip.value = true;
                      Navigator.pop(context);
                      GetStorage().write('recommendedUpdate',false);

                    },
                    child: Text(
                      "Skip",
                      style: paragraphStyle.copyWith(color: kPrimaryColor),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(width: 5),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
              ),
              onPressed: () {
                Navigator.pop(context);
                GetStorage().write('recommendedUpdate',true);
                _launchUrl(
                  Platform.isAndroid
                      ? "https://play.google.com/store/apps/details?id=com.goodtimes"
                      : "https://apps.apple.com/in/app/good-times-app/id6479345939",
                );
              },
              child: const Text(
                "Update",
                style: paragraphStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw Exception('Could not launch $_url');
    }
  }
}
