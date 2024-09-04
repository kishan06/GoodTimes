import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/constant.dart';

import '../../../view-models/SubscriptionPreference.dart';
import '../../../view-models/bootomnavigation_controller.dart';

RxInt curentIndex = 0.obs;

class BottomNavigationBars extends StatefulWidget {
  const BottomNavigationBars({super.key});

  @override
  State<BottomNavigationBars> createState() => _BottomNavigationBarsState();
}

class _BottomNavigationBarsState extends State<BottomNavigationBars> {
  HomePageController homePageController = Get.put(HomePageController());
 
  ProfileExtendedDataController profileextendedcontroller =
      Get.put(ProfileExtendedDataController(), permanent: true);
  @override
  Widget build(BuildContext context) {
     List<String> footerString = [
     (profileextendedcontroller
              .profileextenddata.value.data!.principalTypeName ==
          "event_manager")?"Explore":"Explore",
     (profileextendedcontroller
              .profileextenddata.value.data!.principalTypeName ==
          "event_manager")?'Events':"Wallet",
     if(profileextendedcontroller
              .profileextenddata.value.data!.principalTypeName ==
          "event_manager")'Wallet',
    'Profile',
    // 'Chat',
  ];
  List<String> footerIcons = [
  (profileextendedcontroller
              .profileextenddata.value.data!.principalTypeName ==
          "event_manager")?'explore':'explore',
  (profileextendedcontroller
              .profileextenddata.value.data!.principalTypeName ==
          "event_manager")?"events":'wallet',
  if(profileextendedcontroller
              .profileextenddata.value.data!.principalTypeName ==
          "event_manager")"wallet",
  'user',
    // 'chat',
  ];
    return Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: Container(
          width: double.infinity,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xffFFFFFF).withOpacity(0.1)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var index = 0; index < footerString.length; index++)
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        setState(() {
                          curentIndex.value = index;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/bottom_navigation/${(curentIndex.value==index)?'selected':'unselected'}/${footerIcons[index]}_${(curentIndex.value==index)?'':'un'}selected.svg',
                            height: 30,
                          ),

                          Text(
                            footerString[index],
                            style: const TextStyle(
                              fontSize: 12,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      );
  }
}
