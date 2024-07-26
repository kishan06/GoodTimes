import 'package:flutter/material.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';

class ReusableSkeletonAvatar extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool randomWidth;
  

  const ReusableSkeletonAvatar({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.randomWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
        ],
        stops: [
          0.0,
          0.2,
          0.5,
          0.8,
          1,
        ],
      ),
      child: SkeletonAvatar(
        style: SkeletonAvatarStyle(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          width: width,
          height: height,
          borderRadius:borderRadius,
          randomWidth: randomWidth,
        ),
      ),
    );
  }
}


class ReusableSkeletonParaGraph extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool randomLength;
  final int lines;

  const ReusableSkeletonParaGraph({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.randomLength = false,
    this.lines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
        ],
        stops: [
          0.0,
          0.2,
          0.5,
          0.8,
          1,
        ],
      ),
      child: SkeletonParagraph(
        style: SkeletonParagraphStyle(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          lineStyle: SkeletonLineStyle(
          width: width,
          height: height,
          borderRadius:borderRadius,
          randomLength: randomLength
          ),
          lines: lines,
          spacing: 12

        ),
      ),
    );
  }
}
