import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../widgets/common/parent_widget.dart';

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(title: const Text(''),iconTheme: const IconThemeData(color: kPrimaryColor),),
        body: SafeArea(
          child: WebViewWidget(controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(const Color(0x00000000))
              ..currentUrl()
              ..canGoBack()
              ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
           },
            onPageStarted: (String url) {
              if(url =="${Endpoints.domain}/subscriptions/success/"){
                Navigator.pushNamedAndRemoveUntil(context, HomeMain.routeName, (route) => false);
                snackBarSuccess(context,message: 'Payment successful.');
          
              }
              if(url =="${Endpoints.domain}/subscriptions/subscription-cancel-success/"){
                 Navigator.pushNamedAndRemoveUntil(context, HomeMain.routeName, (route) => false);
                snackBarSuccess(context,message: 'Subscription Recurring cancel successful.');
              }
              //subscription-cancel-success/
              if(url =="${Endpoints.domain}/subscriptions/failed/"){
                 Navigator.pushNamedAndRemoveUntil(context, HomeMain.routeName, (route) => false);
                snackBarError(context,message: 'Payment Failed, Please go back and try again.');
              }
            },
            onPageFinished: (String url) {
            },
            onWebResourceError: (WebResourceError error) {
            },
          ),
              )
              ..loadRequest(Uri.parse(
            '${Endpoints.domain}/subscriptions/active/?token=${GetStorage().read('accessToken')}'))),
        ),
      ),
    );
  }
}


