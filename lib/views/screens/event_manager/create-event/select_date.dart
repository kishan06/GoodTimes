import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/view-models/evevnt_filter_controller.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:intl/intl.dart';

import '../../../widgets/common/parent_widget.dart';

class SelectEventDate extends StatefulWidget {
  static const String routeName = "selectEventDate";
  const SelectEventDate({super.key});

  @override
  State<SelectEventDate> createState() => _SelectEventDateState();
}

class _SelectEventDateState extends State<SelectEventDate> {
  dynamic fromDate;
  dynamic toDate;
  dynamic fromTime;
  dynamic toTime;

  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Set the date of your event', style: headingStyle),
              const SizedBox(height: 60),
              Text(
                'From :',
                style: headingStyle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      selectDate(context, true, fromDate, toDate,
                          (DateTime picked) {
                        setState(() {
                          fromDate = picked;
                        });
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Color(0xff626262),
                        ),
                        const SizedBox(width: 10),
                        fromDate == null
                            ? Text(
                                'Date',
                                style: paragraphStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff626262)),
                              )
                            : Text(
                                DateFormat('MMM d yyyy').format(fromDate),
                                style: paragraphStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kTextWhite),
                              )
                      ],
                    ),
                  ),
                  const SizedBox(width: 35),
                  GestureDetector(
                    onTap: () {
                      timePick(context, true, fromTime, toTime,
                          (TimeOfDay picked) {
                        setState(() {
                          fromTime = picked;
                        });
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.watch_later_outlined,
                          color: Color(0xff626262),
                        ),
                        const SizedBox(width: 10),
                        fromTime == null
                            ? Text(
                                'Time',
                                style: paragraphStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff626262)),
                              )
                            : Text(
                                '${fromTime.format(context)}',
                                style: paragraphStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kTextWhite),
                              )
                        // Text(
                        //   fromTime??'Time',
                        //   style: paragraphStyle.copyWith(
                        //       fontWeight: FontWeight.bold,
                        //       color: const Color(0xff626262)),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 55),
              Text(
                'To :',
                style: headingStyle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      selectDate(context, false, fromDate, toDate,
                          (DateTime picked) {
                        setState(() {
                          toDate = picked;
                        });
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Color(0xff626262),
                        ),
                        const SizedBox(width: 10),
                        toDate == null
                            ? Text(
                                'Date',
                                style: paragraphStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff626262)),
                              )
                            : Text(
                                DateFormat('MMM d yyyy').format(toDate),
                                style: paragraphStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kTextWhite),
                              )
                      ],
                    ),
                  ),
                  const SizedBox(width: 35),
                  GestureDetector(
                    onTap: () {
                      timePick(context, false, fromTime, toTime,
                          (TimeOfDay picked) {
                        setState(() {
                          toTime = picked;
                        });
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.watch_later_outlined,
                          color: Color(0xff626262),
                        ),
                        const SizedBox(width: 10),
                        toTime == null
                            ? Text(
                                'Time',
                                style: paragraphStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff626262)),
                              )
                            : Text(
                                toTime.format(context),
                                style: paragraphStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kTextWhite),
                              )
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              MyElevatedButton(onPressed: (){}, text: 'Continue')
            ],
          ),
        ),
      ),
    );
  }
}
