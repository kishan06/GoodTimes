import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/event/event_preview.dart';
import 'package:good_times/views/screens/event_manager/meeting_source_data.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../data/models/home_event_modal.dart';
import '../../../data/repository/services/get_event_services.dart';
import '../../widgets/common/parent_widget.dart';
import 'meeting.dart';

import 'package:syncfusion_flutter_core/theme.dart';

/// The hove page which hosts the calendar
class SyncFusioCalendar extends StatefulWidget {
  static const String routeName = 'eventCalendar';

  /// Creates the home page to display teh calendar widget.
  const SyncFusioCalendar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SyncFusioCalendarState createState() => _SyncFusioCalendarState();
}

class _SyncFusioCalendarState extends State<SyncFusioCalendar> {
  List<HomeEventsModel> eventList = [];
  final List<Meeting> meetings = <Meeting>[];

  List<Meeting> allSource() {
    for (var e in eventList) {
      _getDataSource(
          date: e.startDate,
          startDate: e.startDate,
          endDate: e.endDate,
          title: "${e.title!.capitalizeFirst}",
          bgImage: e.thumbnail,
          id: e.id,
          price: e.entryFee);
    }
    return meetings;
  }

  List<Meeting> _getDataSource(
      {date, startDate, endDate, title, id, bgImage, price}) {
    log("all the data  source is $date,$startDate,$endDate,$title,$id,$bgImage,$price");
    final startTimes = DateTime.parse(startDate);
    final endTimes = DateTime.parse(endDate);
    final DateTime startTime =
        DateTime(startTimes.year, startTimes.month, startTimes.day);
    final DateTime endTime = endTimes.add(const Duration(hours: 2));
    meetings.add(Meeting(title, startTime, endTime, kPrimaryColor, false, price,
        bgImage ?? '', id));
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
          // backgroundColor: kTextWhite,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kPrimaryColor),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: GetEventServices()
                        .getEvent(context, filterParams: 'preference'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        meetings.clear();
                        eventList = snapshot.data;
                        return SfCalendarTheme(
                          data: const SfCalendarThemeData(
                            backgroundColor: Colors.black,
                            agendaDayTextStyle: TextStyle(color: kTextWhite),
                            agendaDateTextStyle: TextStyle(color: kTextWhite),
                            headerBackgroundColor: kTextBlack,
                            headerTextStyle: TextStyle(color: kTextWhite),
                            // agendaBackgroundColor:kTextWhite,
                            viewHeaderDateTextStyle: TextStyle(color: kTextWhite),
                            viewHeaderDayTextStyle: TextStyle(color: kTextWhite),
                            // viewHeaderBackgroundColor:kTextWhite,
                            // timeTextStyle:TextStyle(color: kTextWhite),
                            activeDatesTextStyle: TextStyle(color: kTextWhite),
                          ),
                          child: SfCalendar(
                            view: CalendarView.month,
                            todayHighlightColor: kPrimaryColor,
                            selectionDecoration: BoxDecoration(
                              color: kTextWhite.withOpacity(0.2),
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onTap: calendarTapped,
                            appointmentBuilder: (BuildContext context,
                                CalendarAppointmentDetails
                                    calendarAppointmentDetails) {
                              Meeting appointment =
                                  calendarAppointmentDetails.appointments.first;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xffD2AA58),
                                      Color(0xffF0D49D),
                                      Color(0xffD2AA58),
                                    ],
                                  ),
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appointment.eventName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: labelStyle.copyWith(
                                          color: kTextBlack,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Start Date - ${DateFormat('MMM dd, yyyy').format(appointment.from)}",
                                      style: labelStyle.copyWith(
                                          fontSize: 16,
                                          color: kTextBlack,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "End Date - ${DateFormat('MMM dd, yyyy').format(appointment.to)}",
                                      style: labelStyle.copyWith(
                                          fontSize: 16,
                                          color: kTextBlack,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              );
                            },
      
                            // appointmentTextStyle:TextStyle(color: kTextBlack),
                            dataSource: MeetingDataSource(allSource()),
                            monthViewSettings: const MonthViewSettings(
                                appointmentDisplayMode:
                                    MonthAppointmentDisplayMode.indicator,
                                showAgenda: true,
                                agendaItemHeight: 100),
                            cellBorderColor: Colors.transparent,
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      int eventId = calendarTapDetails.appointments![0].id;
      Navigator.pushNamed(context, EventPreview.routeName, arguments: [eventId,null]);
    }
  }
}
