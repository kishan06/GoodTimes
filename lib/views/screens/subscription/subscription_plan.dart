import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/view-models/global_controller.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../widgets/common/parent_widget.dart';
import '../home/main_home.dart';
import 'open_website.dart';

class SubScription extends StatefulWidget {
  static const String routeName = 'subScription';
  const SubScription({super.key});

  @override
  State<SubScription> createState() => _SubScriptionState();
}

class _SubScriptionState extends State<SubScription> {

 GlobalController globalController = Get.put(GlobalController());
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: parentWidgetWithConnectivtyChecker(
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/subscription_bg.jpg',
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      kTextBlack
                          .withOpacity(0.6), // Adjust the opacity as needed
                      kTextBlack.withOpacity(0.8),
                      kTextBlack,
                      kTextBlack,
                    ],
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Hey! Afrid',
                          style: headingStyle.copyWith(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        const Text('Subscribe Now', style: headingStyle),
                        const SizedBox(height: 5),
                        const Text('To Get unlimited access to every event!',
                            style: paragraphStyle),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          decoration: BoxDecoration(
                              border: Border.all(color: kTextWhite, width: 2),
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '£ 4.0/month',
                                style: headingStyle.copyWith(fontSize: 35),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Get unlimited access to every event',
                                    style:
                                        paragraphStyle.copyWith(fontSize: 14),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Get unlimited access to every event',
                                    style:
                                        paragraphStyle.copyWith(fontSize: 14),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Get unlimited access to every event',
                                    style:
                                        paragraphStyle.copyWith(fontSize: 14),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        MyElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WebViewExample(),
                              ),
                            );
                          },
                          text: 'Subscribe',
                        ),
                        const SizedBox(height: 40),
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color(0xff383838),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.0),
                                child: Text('or', style: paragraphStyle)),
                            Expanded(
                              child: Divider(
                                color: Color(0xff383838),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text(
                            'If you don’t want to subscribe for now, you can explore as a Guest User',
                            style: paragraphStyle),
                        const SizedBox(height: 35),
                        myElevatedButtonOutline(
                          onPressed: () {
                            Navigator.pushNamed(context, HomeMain.routeName);
                          },
                          text: 'Explore as Guest User',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
