import 'package:flutter/material.dart';

import 'constant.dart';

showWaitingDialoge({context,loading}) {
  showDialog(
    barrierDismissible: false,
    useRootNavigator: !loading,
    context: context,
    builder: (context) {
      return  WillPopScope(
      onWillPop: () async {
        // Return false to prevent the back button from closing the dialog
        return false;
      }, // Prevent dialog from closing when back button is pressed
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: AlertDialog(
                backgroundColor: Color.fromARGB(255, 21, 20, 20),
                content: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
              ),
            ),
          ],
        ),
      );
    },
  );
}


showSavedDialoge({context,loading}) {
  showDialog(
    barrierDismissible: !loading,
    useRootNavigator: !loading,
    context: context,
    builder: (context) {
      return PopScope(
        onPopInvoked: (e) async => !loading, // Prevent dialog from closing when back button is pressed
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: AlertDialog(
                backgroundColor: Color.fromARGB(255, 21, 20, 20),
                content: Center(child: Text("Event has been saved")),
              ),
            ),
          ],
        ),
      );
    },
  );
}