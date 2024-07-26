import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';

Widget textFormField(
    {controller,
    hintTxt,
    validationFunction,
    onSavedFunction,
    inputFormate,
    suffixIcon,
    preffixIcon,
    TextInputType?inputType,
    obscureText = false,
    initailValue,
    readOnly = false,
    autofocus=false,
    autovalidateMode=AutovalidateMode.onUserInteraction
    }) {
  return TextFormField(
    initialValue: initailValue,
    obscureText: obscureText,
    readOnly: readOnly,
    textCapitalization: TextCapitalization.sentences,
    style: const TextStyle(
      color: kTextWhite,
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    controller: controller,
    keyboardType: inputType,
    autovalidateMode: autovalidateMode,
    inputFormatters: inputFormate,
    autofocus: autofocus,
    decoration: InputDecoration(
      hintText: hintTxt,
      hintStyle:  TextStyle(
        fontSize: 16,
        color: const Color(0xffC5C5C5).withOpacity(0.35),
      ),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
      border: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
      errorStyle: const TextStyle(fontSize: 14.0),
      prefixIcon: preffixIcon,
      suffixIcon: suffixIcon,
    ),
    validator: validationFunction,
    onSaved: onSavedFunction,
  );

}
