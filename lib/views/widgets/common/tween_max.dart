import 'package:flutter/material.dart';

tweenMaxAnimationbottom(Widget childs, double val) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0, end: 1),
    duration: const Duration(milliseconds: 1000),
    builder: (BuildContext context, double value, Widget? child) {
      return Opacity(
        opacity: value,
        child: Padding(
          padding: EdgeInsets.only(bottom: value * val),
          child: childs,
        ),
      );
    },
  );
}

tweenMaxAnimationtop(Widget childs, double val) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 1, end: 0.8),
    duration: const Duration(milliseconds: 1000),
    builder: (BuildContext context, double value, Widget? child) {
      return Opacity(
        opacity: value,
        child: Padding(
          padding: EdgeInsets.only(top: value * val),
          child: childs,
        ),
      );
    },
  );
}

tweenMaxAnimationleft(Widget childs, double val) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 1, end: 0.8),
    duration: const Duration(milliseconds: 1000),
    builder: (BuildContext context, double value, Widget? child) {
      return Opacity(
        opacity: value,
        child: Padding(
          padding: EdgeInsets.only(left: value * val),
          child: childs,
        ),
      );
    },
  );
}
