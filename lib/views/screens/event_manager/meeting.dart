import 'package:flutter/material.dart';

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,this.price,this.bgImage,this.id);
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String price;
  String bgImage;
  int id;
}