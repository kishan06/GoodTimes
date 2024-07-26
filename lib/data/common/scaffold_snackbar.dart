import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';

snackBarSuccess(context, {title, message}) {
   ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: paragraphStyle.copyWith(
          color: kTextWhite,
        ),
      ),
       behavior:SnackBarBehavior.floating,
      backgroundColor: kTextSuccess,
      
    ),
  );
}

snackBarError(context, {title, message}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(

    SnackBar(
      content: Text(
        message,
        style: paragraphStyle.copyWith(
          color: kTextWhite,
        ),
      ),
      backgroundColor: kTextError,
      behavior:SnackBarBehavior.floating,
    ),
  );
}

snackBarBasic(context, {title, message}) {
   ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: paragraphStyle.copyWith(
          color: kTextWhite,
        ),
      ),
      backgroundColor: kPrimaryColor,
      behavior:SnackBarBehavior.floating,
    ),
  );
}
