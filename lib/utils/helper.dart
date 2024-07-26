import 'package:flutter/material.dart';

void unfoucsKeyboard(BuildContext context) {
  // Unfocus any focused text field
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}