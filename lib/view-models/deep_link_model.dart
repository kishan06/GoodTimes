import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/repository/endpoints.dart';
import '../views/screens/auth/registration/welcome_screen.dart';
import '../views/screens/event/event_preview.dart';

String? globalReferralCode;
BranchContentMetaData metadata = BranchContentMetaData();
BranchUniversalObject? buo;
BranchLinkProperties lp = BranchLinkProperties();

StreamSubscription<Map>? streamSubscription;
StreamController<String> controllerData = StreamController<String>();

void initDeepLinkData(dynamic generateLinkinkId, String metaDataId) {
  metadata = BranchContentMetaData()
    ..addCustomMetadata(metaDataId, generateLinkinkId);

  buo = BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      title: 'Good Times',
      imageUrl: "assets/images/logo.png",
      contentDescription: 'This is the best event app',
      contentMetadata: metadata,
      keywords: ['Plugin', 'Branch', 'Flutter'],
      publiclyIndex: true,
      locallyIndex: true,
      expirationDateInMilliSec: DateTime.now().add(const Duration(days: 365)).millisecondsSinceEpoch
      );

  lp = BranchLinkProperties(
    channel: 'facebook',
    feature: 'sharing',
    stage: 'new share',
  );
}

Future<String> generateLink(BuildContext context) async {
  var genratedLink;
  BranchResponse response =
      await FlutterBranchSdk.getShortUrl(buo: buo!, linkProperties: lp);
  if (response.success) {
    if (context.mounted) {
      log('show generated links ${response.result}');
      // showGeneratedLink(context, response.result);
      genratedLink = response.result.toString().split('//');
      log('genratedLink ${genratedLink[1]}');
      log('show genrated links response ${response.result}');
    }
    return genratedLink[1];
  } else {
    log('Error : ${response.errorCode} - ${response.errorMessage}');
    return "Error";
  }
}

void listenDynamicLinks() async {
  streamSubscription = FlutterBranchSdk.initSession().listen((data) {
    log('listenDynamicLinks - DeepLink Data: $data');
   String? isLoggedIn = GetStorage().read('accessToken');
   logger.f("is loggedin in deeplinking file $isLoggedIn ");
    controllerData.sink.add((data.toString()));
    if (data.containsKey('+clicked_branch_link') &&
        data['+clicked_branch_link'] == true) {
      log('------------------------------------Link clicked----------------------------------------------');
      log('Custom number: $data');
       
        if (data.containsKey('event_id')) {
        Platform.isIOS
            ? (isLoggedIn == null || isLoggedIn == '')? Get.toNamed(WelcomeScreen.routeName):Get.toNamed(EventPreview.routeName,
                arguments: [data['event_id'], null])
            : (isLoggedIn == null || isLoggedIn == '')? Get.toNamed(WelcomeScreen.routeName):Get.toNamed(EventPreview.routeName,
                arguments: [int.parse(data['event_id']), null]);

      } else if (data.containsKey('referral_code')) {
        Platform.isIOS
            ? (isLoggedIn == null || isLoggedIn == '')? Get.toNamed(WelcomeScreen.routeName):Get.toNamed(EventPreview.routeName,
                arguments: [data['event_id'], null])
            :(isLoggedIn == null || isLoggedIn == '')? Get.toNamed(WelcomeScreen.routeName): Get.toNamed(EventPreview.routeName,
                arguments: [int.parse(data['event_id']), null]);

      } else if (data.containsKey("referral_registration")) {
        globalReferralCode = data['referral_registration'];
      }

      
    }
    // }
  }, onError: (error) {
    log('InitSesseion error: ${error.toString()}');
  });
}
