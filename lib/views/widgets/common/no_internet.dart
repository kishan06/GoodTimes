import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/signout.dart';
import 'package:lottie/lottie.dart';

import '../../../data/repository/services/advance_filter_service.dart';
import '../../../view-models/SubscriptionPreference.dart';

class NoInternetConnection extends StatefulWidget {
  static const String routeName = 'noInternet';
  const NoInternetConnection({Key? key}) : super(key: key);

  @override
  State<NoInternetConnection> createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const Spacer(),
            Lottie.asset('assets/images/lottie/no-internet.json', height: 400),
            const SizedBox(height: 16),
            const Text(
              'No Internet Connection!',
              style: TextStyle(
                fontSize: 18,
                color: kTextWhite,
                fontFamily: 'SFPRO',
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Due to some reason, we are unable to connect with our server. Please check your internet connection.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xffD9D9D9),
                fontFamily: 'SFPRO',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // myElevatedButtonOutline(
            //     text: 'Try Again',
            //     onPressed: () {
            //       setState(() {});
            //     }),
            const Spacer(),
          ],
        ),
      )),
    );
  }
}
