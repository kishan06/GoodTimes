import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/view-models/global_controller.dart';
import 'package:good_times/views/screens/event_manager/home.dart';
import 'package:good_times/views/screens/profile/profile.dart';
import 'package:good_times/views/screens/wallet/wallet.dart';
import '../../../data/models/account_trasfer_modal.dart';
import '../../../data/models/profile.dart';
import '../../../data/repository/endpoints.dart';
import '../../../data/repository/services/account_transfer.dart';
import '../../../data/repository/services/advance_filter_service.dart';
import '../../../data/repository/services/profile.dart';
import '../../../data/repository/services/send_player.dart';
import '../../../utils/constant.dart';
import '../../../view-models/bootomnavigation_controller.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../auth/login/login.dart';
import '../event/event_preview.dart';
import 'home.dart';
import 'sidebar-filter/widget/widget.dart';

class HomeMain extends StatefulWidget {
  static const String routeName = 'homeMain';

  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  HomePageController homePageController = Get.put(HomePageController());
  GlobalController globalController = Get.put(GlobalController());
  bool isLoading = true;
  bool isPasswordChange = GetStorage().read('isPasswordChanged') ?? false;
  bool isAccountTransferd = false;
  // late HomePageController homePageController;

  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            elevation: 10,
            backgroundColor: Colors.black,
            title: const Text(
              'Exit App',
              style: TextStyle(
                fontSize: 16,
                color: kTextWhite,
              ),
            ),
            content: const Text(
              'Do you want to exit the app?',
              style: TextStyle(
                fontSize: 16,
                color: kTextWhite,
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontSize: 16,
                    color: kTextWhite,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
                onPressed: () {
                  // Navigator.of(context).pop(true);
                  exit(0);
                },
                //return true when click on "Yes"
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 16,
                    color: kTextWhite,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  void listenDynamicLinks() async {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) {
      log('listenDynamicLinks - DeepLink Data: $data');
      controllerData.sink.add((data.toString()));
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        log('------------------------------------Link clicked----------------------------------------------');
        //  debugPrint('Custom string: ${data['custom_string']}');
        log('Custom number: $data');

        if (data.containsKey('event_id')) {
          Get.toNamed(EventPreview.routeName,
              arguments: [int.parse(data['event_id']), null]);
        }
      }
      // }
    }, onError: (error) {
      log('InitSesseion error: ${error.toString()}');
    });
  }

  senUserPlayer() {
    UserPlayerIdService()
        .userPlayerIdService(context, playerId: GetStorage().read("player_Id"));
  }

  @override
  void initState() {
    // homePageController = Get.put(HomePageController());
    // listenDynamicLinks();
    getProfileDetails();
    senUserPlayer();
    super.initState();
  }

  // profile view api called
  getProfileDetails() {
    ProfileService().getProfileDetails(context).then((value) {
      if (value.responseStatus == ResponseStatus.success) {
        ProfileModel data = value.data;
        globalController.email.value = data.email;
        globalController.accountIsActive.value = data.accoutIsActive;
        if (data.principalTypeName == "event_user") {
          homePageController.isUser.value = eventUser;
        } else if (data.principalTypeName == "event_manager") {
          homePageController.isUser.value = eventManager;
        }
        if (data.hasActiveSubscription == true) {
          globalController.hasActiveSubscription.value =
              data.hasActiveSubscription;
          globalController.hasActiveGracePeriod.value = false;
        } else {
          globalController.hasActiveSubscription.value = false;
          globalController.hasActiveGracePeriod.value =
              data.hasActiveGracePeriod;
        }
        if (data.principalTypeName == "event_manager") {
          checkIsPasswordChage();
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  Future checkIsPasswordChage() async {
    // log("is isAccountTransferd in $isAccountTransferd and $isPasswordChange");
    AccoutTransferService().accoutTransferService(context).then((value) {
      if (value.responseStatus == ResponseStatus.success) {
        AccountTransferModal accountData = value.data;

        log("check in service file function transferred ${accountData.isTransferred} is password chaged ${accountData.pwdChangedPostTransfer}");
        if (accountData.isOnBoarded) {
          if (accountData.isTransferred) {
            // globalController.accoutTransferSuccess.value ;
            if (!accountData.pwdChangedPostTransfer) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.routeName,
                  (route) => false,
                );
              });
            } else {
              setState(() {
                isLoading = false;
              });
            }
            setState(() {
              isAccountTransferd = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator()); // Or any other loading widget
    }

    // if (isAccountTransferd) {
    //   if(!isPasswordChange){
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.pushNamed(context, LoginScreen.routeName);
    //   });
    //   }
    // }

    List<Widget> footerWidget = [
      (homePageController.isUser.value == eventManager)
          ? const HomeScreen()
          : const HomeScreen(),
      (homePageController.isUser.value == eventManager)
          ? const EventeManagerHome()
          : const Wallet(),
      if (homePageController.isUser.value == eventManager) const Wallet(),
      const Profile(),
      // const Chat(),
    ];
    // log("get user in buidcontext ${TempData.isUser}");
    // getProfileDetails();
    //  print('one signal player id ${GetStorage().read('oneSignalPlayerId')}');
    return WillPopScope(
      child: Obx(() => footerWidget[curentIndex.value]),
      onWillPop: () async{
        if(!globalController.serverError.value){
            if (homePageController.bottomNavIndex.value == 0) {
          return showExitPopup();
        } else {
          homePageController.updateBottomNavIndex(0);
          return Future.value(false);
        }
        }else{
           advanceFilterController.clearAllFilter();
                 await AdvanceFilterService().advanceFilterEventServices(context);
                  globalController.serverError.value=false;
          return Future.value(false);
        }
      
      },
    );
  }
}
