import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/repository/response_data.dart';
import '../../../data/repository/services/feebabck.dart';
import '../../../utils/constant.dart';
import '../../../utils/loading.dart';
import '../../widgets/common/button.dart';
import '../../widgets/common/parent_widget.dart';

class FeedBack extends StatefulWidget {
    static const String routeName = "feedBack";
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
   AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
       final _key = GlobalKey<FormState>();
       TextEditingController feedBackController = TextEditingController();
       int _rating = 0; // Initial rating value
       List ratings = [
      {"name": "Very Bad", "icon": "very_bad","id":1},
      {"name": "Bad", "icon": "bad_emoji","id":2},
      {"name": "Neutral", "icon": "neutral_emoji","id":3},
      {"name": "Good", "icon": "good_emoji","id":4},
      {"name": "Excited", "icon": "excited_emoji","id":5}
    ];
      bool waiting = false;
  bool ratingValidation = false;
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),child: Form(
              key: _key,
              autovalidateMode: autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                  'Feedback',
                  style: headingStyle,
                ),
                const SizedBox(height: 38),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      ratings.length,
                      (index) => GestureDetector(
                        onTap: () { 
                          setState(() {
                            _rating = ratings[index]["id"];
                          });
                          if (_rating > 0) {
                            setState(() {
                              ratingValidation = false;
                            });
                          }
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                                'assets/images/feedback/${ratings[index]["icon"]}.svg',width: 60,height: 60,),
                            const SizedBox(height: 10),
                            Text(ratings[index]["name"], style: paragraphStyle),
                            const SizedBox(height: 5),
                            (_rating == ratings[index]["id"])?Container(
                              height: 5,
                              width: MediaQuery.of(context).size.width/10,
                              decoration: const BoxDecoration(
                            // color: kTextWhite.withOpacity(0.1)
                            color: kPrimaryColor
                          ),):const SizedBox(height: 5)
                          ],
                        ),
                      ),
                    ),
                  ),
                  ratingValidation
                      ? const Text(
                          'Please provide a rating',
                          style: TextStyle(color: kTextError, fontSize: 14),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  const Text('Write down your feedback here', style: labelStyle),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: feedBackController,
                    maxLines: 6, //or null
                    decoration: InputDecoration(
                      hintText: "Write your review",
                      hintStyle: paragraphStyle.copyWith(
                          color: kTextWhite.withOpacity(0.6)),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(20.0),
                    ),
                    style: paragraphStyle,
                    validator: (value) {
                    
                      if (value == null || value.isEmpty ) {
                        return 'Please enter some feedback';
                      }
                      if(value.trim().isEmpty){
                        return 'Please enter valid feedback.';
                      }
                      if (value.length < 5) {
                        return 'Please  enter more than 5 character';
                      }
                      return null;
                    },
                  ),
                 
                  // const Spacer(),
                  const SizedBox(height: 150),
                  MyElevatedButton(
                    //  loader: waiting
                    //           ? const CircularProgressIndicator()
                    //           : const SizedBox(),
                      onPressed: () {
                        _key.currentState!.validate();
                        autovalidateMode = AutovalidateMode.always;
                        if (_rating == 0) {
                          setState(() {
                            ratingValidation = true;
                          });
                        }
                        if (_key.currentState!.validate() && ratingValidation == false) {
                              showWaitingDialoge(context:context,loading: waiting);
                          setState(() {
                            waiting = true;
                          });
                          FeedbackService()
                              .feedbackService(
                            context,
                            rating: _rating,
                            comment: feedBackController.text,
                          )
                              .then((value) {
                            if (value.responseStatus == ResponseStatus.success) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              feedBackController.clear();
                              setState(() {
                                _rating = 0;
                                waiting = false;
                              });
                            } else if (value.responseStatus ==
                                ResponseStatus.failed) {
                              setState(() {
                                waiting = false;
                              });
                              Navigator.pop(context);
                            }
                          });
                        }
                      },
                      text: 'Submit'),
                  const SizedBox(height: 30),
          
                ],
              ),
            ),),
        ),
        ),
    );
  }
}