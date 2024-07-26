import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';
import 'package:lottie/lottie.dart';

class ServerError extends StatelessWidget {
  static const String routeName = 'noInternet';
  const ServerError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const Spacer(),
            Lottie.asset('assets/images/lottie/no-internet.json',height: 400),
            const SizedBox(height: 16),
            const Text(
              'Server Error',
              style: TextStyle(
                fontSize: 30,
                color: kTextWhite,
                fontFamily: 'SFPRO',
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'There some server error please try again later',
              style: TextStyle(
                fontSize: 22,
                color: Color(0xffD9D9D9),
                fontFamily: 'SFPRO',
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
          ],
        ),
      )),
    );
  }
}
