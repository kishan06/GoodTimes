import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Testing extends StatefulWidget {
  static String routeName = "/testingpage";

  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {  
  static const platform = MethodChannel('com.example/native_to_flutter');

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      platform.setMethodCallHandler((call) async {
        if (call.method == 'makeCall') {
          String phoneNumber = call.arguments;
          // Handle the call initiation and data processing here
          print('Received call request from native platform: $phoneNumber');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'makeCall') {
        String phoneNumber = call.arguments;
        // Handle the call initiation and data processing here
        print('Received call request from native platform: $phoneNumber');
      }
    });
    return const Scaffold(
      body: Column(
        children: [Text("MITHUL")],
      ),
    );
  }
}
