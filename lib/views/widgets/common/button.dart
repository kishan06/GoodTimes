import 'package:flutter/material.dart';

import '../../../utils/constant.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
   final Widget? loader;
  final String text;


  const MyElevatedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.borderRadius,
    this.width,
    this.loader,
    this.height = 50.0,
    this.gradient = const LinearGradient(
      colors: <Color>[
        Color(0xffD2AA58),
        Color(0xffF0D49D),
        Color(0xffD2AA58),
      ],
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: kTextBlack),
            ),
            const SizedBox(width: 5),
             loader ?? const SizedBox(),
          ],
        ),
      ),
    );
  }
}

Widget myElevatedButtonOutline({onPressed,text,icon,size}){
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 1, color: kPrimaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
           icon!=null?SvgPicture.asset(icon,width: size,):const SizedBox(),
           icon!=null?const SizedBox(width: 10):const SizedBox(),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
  );
}