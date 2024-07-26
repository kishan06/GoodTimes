// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';

import '../utils/constant.dart';

Future<void> selectDate(
    BuildContext context,
    bool isStartDate,
    DateTime? startDate,
    DateTime? endDate,
    Function(DateTime) onDateSelected) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: isStartDate
        ? startDate ?? DateTime.now()
        : (endDate != null && endDate.isAfter(startDate ?? DateTime.now())
            ? endDate
            : startDate ?? DateTime.now()),
    firstDate: DateTime.now(),
    lastDate: DateTime(2050),
    builder: (context, child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primarySwatch,
          accentColor: kTextBlack,
          backgroundColor: Colors.lightBlue,
          cardColor: kTextBlack,
          brightness: Brightness.dark,
        ),
      ),
      child: child!,
    ),
  );
  if (picked != null) {
    onDateSelected(picked);
  }
}

Future<void> timePick(
    BuildContext context,
    bool isStartTime,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Function(TimeOfDay) onTimeSelected) async {
  final TimeOfDay now = TimeOfDay.now();
  final TimeOfDay initialTime = isStartTime ? startTime ?? now : endTime ?? now;

  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primarySwatch,
          accentColor: kTextBlack,
          backgroundColor: Colors.lightBlue,
          cardColor: kTextBlack,
          brightness: Brightness.dark,
        ),
      ),
      child: child!,
    ),
  );

  if (picked != null) {
    if (endTime != null && picked == now) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Please select a time other than the current time.'),
      //   ),
      // );
      snackBarBasic(context,message: "Please select a time other than the current time");
    } else if (startTime != null && endTime != null && picked == startTime) {
      snackBarBasic(context,message: "Please select a time after the start time.");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Please select a time after the start time.'),
      //   ),
      // );
    }
    // else if (startTime == endTime) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Please select a time after the start time.'),
    //     ),
    //   );
    // }
    else {
      onTimeSelected(picked);
    }
  }
}

getTimeDifference(TimeOfDay startTime, TimeOfDay endTime) {
  final startMinutes = startTime.hour * 60 + startTime.minute;
  final endMinutes = endTime.hour * 60 + endTime.minute;

  final inHours = (endMinutes - startMinutes).abs();
  return inHours / 60;
}

TimeOfDay stringToTimeOfDay(String timeString) {
  List<String> parts = timeString.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}


 bool isDateTimeLessThanOrEqualToSubtractedDate({String? endDate, String? startTime}) {
    DateTime dateTime = DateTime.parse('$endDate $startTime');
    // log("dateTimes time for edit events $dateTime");
    DateTime subtractedDateTime = dateTime.subtract(const Duration(hours: 48));
    // log("dateTimes substracted time and date $subtractedDateTime");
    DateTime currentDateTime = DateTime.now();
    // log("dateTimes current date time $currentDateTime");
    return currentDateTime.isBefore(subtractedDateTime) || currentDateTime.isAtSameMomentAs(subtractedDateTime);
  }
