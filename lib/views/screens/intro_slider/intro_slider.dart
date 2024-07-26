import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/utils/constant.dart';

import '../../widgets/common/tween_max.dart';
import '../auth/registration/welcome_screen.dart';

class IntroSlider extends StatefulWidget {
  static String routeName = "/intro";
  const   IntroSlider({Key? key}) : super(key: key);

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  final box = GetStorage();
  int _current = 0;
  final CarouselController _controller = CarouselController();

  List<dynamic> list = [
    {
      'img': 'assets/images/intro_slider/intro_slide.png',
      'headTxt': 'Your Events, Your\nWay!',
      'shortdesc':'Your events, your way. Effortless event management at your fingertips. Dive into a world.',
    },
    {
      'img': 'assets/images/intro_slider/intro_slide1.png',
      'headTxt': 'Precision and Style in\nEvery Event!',
      'shortdesc': 'Elevate your events with precision and style. Seamlessly plan and execute unforgettable experiences.',
    }
  ];
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: screenSize.height - 75,
                viewportFraction: 1.0,
                autoPlay: true,
                enableInfiniteScroll: false,
                pauseAutoPlayInFiniteScroll:true,
                autoPlayInterval: const Duration(seconds: 3),
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: list
                  .map(
                    (item) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(150),
                              bottomRight: Radius.circular(150),
                            ),
                            child: Image.asset(
                              item['img'],
                              fit: BoxFit.cover,
                              width: screenSize.width*1,
                              height: screenSize.height * 0.6,
                            ),
                          ),
                          // const SizedBox(height: 30),
                          tweenMaxAnimationtop(
                              Text(
                                item['headTxt'],
                                style: headingStyle,
                                textAlign: TextAlign.center,
                              ),
                              30),
                          // const SizedBox(height: 18),
                          tweenMaxAnimationtop(
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                child: Text(
                                  item['shortdesc'],
                                  textAlign: TextAlign.center,
                                  style:paragraphStyle,
                                ),
                              ),
                              20),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:scaffoldPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
                        GetStorage().write('introSlider',false);
                        // _controller.nextPage();
                      },
                      child: Text(
                        _current == 1 ? '' : 'Skip',
                        style: const TextStyle(
                          fontSize: 14,
                          color: kTextWhite,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: list.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Column(
                          children: [
                            Container(
                                width: 15,
                                height: (_current == entry.key) ? 4 : 2,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 6.0, horizontal: 2.0),
                                color: kTextWhite),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  GestureDetector(
                    onTap: (){
                      _current == 1?Navigator.pushReplacementNamed(context, WelcomeScreen.routeName):_controller.nextPage();
                       GetStorage().write('introSlider',false);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration:  BoxDecoration(
                          gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.9],
                        transform: GradientRotation(2.8),
                        colors: <Color>[
                          Color(0xffF0D49D),
                          Color(0xffD2AA58),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(100)
                      ),
                      child: const Icon(Icons.arrow_forward_ios,color: kTextBlack,size: 18,),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
