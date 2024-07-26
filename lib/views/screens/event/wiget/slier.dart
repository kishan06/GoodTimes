import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constant.dart';

thumbnailSlider(context, {imageList}) {
  List<String> sliderImages = imageList;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 340,
            viewportFraction: 1.0,
            autoPlay: true,
            enableInfiniteScroll: true,
            pauseAutoPlayInFiniteScroll: true,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: sliderImages
              .map(
                (item) => Image.network(
                  item,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 1,
                  height: 300,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 10),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: sliderImages.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Column(
                children: [
                  Container(
                      width: 15,
                      height: (_current == entry.key) ? 4 : 2,
                      margin: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 2.0),
                      color: kPrimaryColor),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  });
}
