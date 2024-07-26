import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/constant.dart';

import '../../../view-models/bootomnavigation_controller.dart';

RxInt curentIndex = 0.obs;

class BottomNavigationBars extends StatefulWidget {
  const BottomNavigationBars({super.key});

  @override
  State<BottomNavigationBars> createState() => _BottomNavigationBarsState();
}

class _BottomNavigationBarsState extends State<BottomNavigationBars> {
  HomePageController homePageController = Get.put(HomePageController());
 
  @override
  Widget build(BuildContext context) {
     List<String> footerString = [
     (homePageController.isUser.value==eventManager)?"Explore":"Explore",
     (homePageController.isUser.value==eventManager)?'Events':"Wallet",
     if(homePageController.isUser.value==eventManager)'Wallet',
    'Profile',
    // 'Chat',
  ];
  List<String> footerIcons = [
  (homePageController.isUser.value==eventManager)?'explore':'explore',
  (homePageController.isUser.value==eventManager)?"events":'wallet',
  if(homePageController.isUser.value==eventManager)"wallet",
  'user',
    // 'chat',
  ];
    // print('curentIndex ${curentIndex}');
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
