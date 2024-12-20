// ignore_for_file: deprecated_member_use, unused_local_variable
//! SHA-1 KEY ; 87:6d:73:b3:ad:22:e3:58:5b:87:7a:f8:9b:75:ee:e4:29:c1:e8:98

import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:good_times/utils/constant.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'config/routes/app_route.config.dart';
import 'data/repository/response_data.dart';
import 'data/repository/services/check_preference.dart';
import 'firebase_options.dart';
import 'utils/temp.dart';
import 'view-models/deep_link_model.dart';
import 'view-models/global_controller.dart';
import 'view-models/location_controller.dart';
import 'views/screens/auth/registration/select_preference.dart';
import 'views/screens/auth/registration/welcome_screen.dart';
import 'views/screens/home/main_home.dart';
import 'views/screens/intro_slider/intro_slider.dart';
import 'views/widgets/common/custom_error.dart';

void main() async {
  //development
  //live bug fix
  WidgetsFlutterBinding.ensureInitialized();

  // if Error occured then it this will show
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    logger.e(details.exceptionAsString());
    runApp(
      CustomErrorWidget(
        errorMessage: details.exceptionAsString(),
      ),
    );
  };

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await FlutterBranchSdk.init(
      useTestKey: true, enableLogging: true, disableTracking: false);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool preference = false;
  String? isLoggedIn = GetStorage().read('accessToken');
  dynamic profileStatus = GetStorage().read('profileStatus');
  bool introSliderShow = GetStorage().read('introSlider') ?? true;

  @override
  void initState() {
    super.initState();
    listenDynamicLinks();
    _initializeServices();
    checkFunction();
  }

  Future<void> _initializeServices() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("cce790ba-066a-4f88-b101-f8a533580b5e");
    // await OneSignal.shared.setPromptLocation(true);
    OneSignal.Notifications.requestPermission(true);
    final id = OneSignal.User.pushSubscription.id;
    log("player id we got here $id");

    OneSignal.User.pushSubscription.addObserver((state) {
      GetStorage().write('player_Id', OneSignal.User.pushSubscription.id);
    });

    await LocationController().getCurrentLocation(Get.context!);
  }

  checkFunction() {
    CheckPreferenceService().checkPreferenceService(context).then((value) {
      if (value.responseStatus == ResponseStatus.success) {
        // preference = true;
        log('check preferences ${value.data}');
        setState(() {
          preference = value.data;
          // Set the route based on the preference value here
          if (preference) {
            // If preference is true, navigate to HomeMain
            Get.offNamed(HomeMain.routeName);
          } else {
            // If preference is false, navigate to SelectPreference
            Get.offNamed(SelectPrefrence.routeName);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(0.9),
          ),
          child: child!,
        );
      },
      title: 'Good Times',
      theme: ThemeData(
        scaffoldBackgroundColor: kTextBlack,
        iconTheme: const IconThemeData(color: kTextWhite),
        appBarTheme: const AppBarTheme(color: kTextBlack),
        useMaterial3: true,
      ),
      initialRoute: (isLoggedIn == null ||
              profileStatus == null ||
              profileStatus == false)
          ? introSliderShow
              ? IntroSlider.routeName
              : WelcomeScreen.routeName
          : HomeMain.routeName,
      routes: routes,
      // home: const ServerError(),
      // home: const MapViews(),
      // home: const SideBarDrawer(),
    );
  }
}
