import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';

import 'widgets/common/button.dart';

class TestModal extends StatefulWidget {
  const TestModal({super.key});

  @override
  State<TestModal> createState() => _TestModalState();
}

class _TestModalState extends State<TestModal> {
  final feedBackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    log("message");
    return  Scaffold(
backgroundColor: kTextWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyElevatedButton(onPressed: (){
              _rateThisEvent();

            }, text: "Click Me")
        
        ],),
      ),
    );
  }

  _rateThisEvent() {
    return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          insetPadding: EdgeInsets.all(10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 0,
          backgroundColor: kTextBlack,
          content: Text("data",style: paragraphStyle,),
        );
      },
    );
  }
}
