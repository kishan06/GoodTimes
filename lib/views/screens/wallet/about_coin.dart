import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';

class AboutCoins extends StatefulWidget {
  const AboutCoins({super.key});

  @override
  State<AboutCoins> createState() => _AboutCoinsState();
}

class _AboutCoinsState extends State<AboutCoins> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimaryColor),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
