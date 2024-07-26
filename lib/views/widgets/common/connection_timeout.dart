import 'package:flutter/material.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../../utils/constant.dart';

class ConnectTimeOut extends StatefulWidget {
  const ConnectTimeOut({super.key});

  @override
  State<ConnectTimeOut> createState() => _ConnectTimeOutState();
}

class _ConnectTimeOutState extends State<ConnectTimeOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimaryColor),
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             const Text(connectionTime,
                  style: paragraphStyle, textAlign: TextAlign.center),
                 const SizedBox(height: 20),
                  myElevatedButtonOutline(onPressed: (){
                    setState(() {});
                  }, text: 'Try Again!')
            ],
          ),
        ),
      ),
    );
  }
}
