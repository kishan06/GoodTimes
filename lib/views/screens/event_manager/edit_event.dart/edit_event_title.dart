// ignore_for_file: unrelated_type_equality_checks

import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_times/data/models/event_age_group_model.dart';
import 'package:good_times/utils/constant.dart';
// import 'package:good_times/views/screens/event_manager/create-event/create_event.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:intl/intl.dart';
import '../../../../data/common/scaffold_snackbar.dart';
import '../../../../data/models/event_categories_model.dart';
import '../../../../data/models/events_model.dart';
import '../../../../data/models/venu_model.dart';
import '../../../../data/repository/services/preferences_service.dart';
import '../../../../data/repository/services/venue_services.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/temp.dart';
import '../../../widgets/common/parent_widget.dart';
import '../../../widgets/common/textformfield.dart';
import 'edit_event.dart';

class EditEventTitile extends StatefulWidget {
  static const String routeName = "editEventTitile";
  final EventsModel eventData;
  const EditEventTitile({super.key, required this.eventData});
  @override
  State<EditEventTitile> createState() => EditEventTitileState();
}

class EditEventTitileState extends State<EditEventTitile> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _eventTitle = TextEditingController();
  final TextEditingController _eventDescriptions = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  dynamic fromTime;
  dynamic toTime;
  RxBool fromDateTime = false.obs;
  RxBool endDateTime = false.obs;

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool waiting = false;
  List<VenuModel> venuList = [];
  List<EventCategoriesModdel> categoryList = [];
  List<ageData> ageList = [];

  @override
  void initState() {
    super.initState();
    _eventTitle.text = widget.eventData.title!;
    _eventDescriptions.text = widget.eventData.description!;
    fromDate = DateTime.parse(widget.eventData.startDate!);
    toDate = DateTime.parse(widget.eventData.endDate!);
    fromTime = TimeOfDay.fromDateTime(DateTime.parse(
        '${widget.eventData.startDate} ${widget.eventData.startTime!}'));
    toTime = TimeOfDay.fromDateTime(DateTime.parse(
        '${widget.eventData.endDate} ${widget.eventData.endTime!}'));
    getvenuData();
    getCategoryData();
    getAgeGroup();
  }

  // get all venues from the api and pass to next screen
  getvenuData() {
    VenueServices().getVenue(context).then((value) {
      log("log data of venu in event screen $value");
      setState(() {
        venuList = value;
      });
    });
  }

  getCategoryData() {
    PreferencesService().getEventCategoriesService(context).then((value) {
      log("log data of category list in event screen $value");
      setState(() {
        categoryList = value;
      });
    });
  }

  getAgeGroup() {
    if(TempData.agedatagroup.isEmpty){
      PreferencesService().getAgeGroup(context).then((value) {
      log("log data of category list in event screen $value");
      setState(() {
        ageList = value;
      });
    });
    }else{
  setState(() {
        ageList = TempData.agedatagroup;
      });
    }
    
  }

  checkstartTimeIsBeforeFun() {
    if (fromDate == toDate) {
      DateTime fromDateTime = DateTime(fromDate!.year, fromDate!.month,
          fromDate!.day, fromTime.hour, fromTime.minute);
      DateTime toDateTime = DateTime(
          toDate!.year, toDate!.month, toDate!.day, toTime.hour, toTime.minute);

      if (toDateTime.isBefore(fromDateTime)) {
        setState(() {
          toTime = null;
        });
        snackBarError(context,
            message:
                "Please check the time, end time must be after the start time.");
      } else {}
    }
  }

  // start date function=================
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: toDate ?? DateTime(2150),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primarySwatch,
            accentColor: kTextBlack,
            backgroundColor: Colors.lightBlue,
            cardColor: kTextBlack,
            brightness: Brightness.dark,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
      });
      log('Selected start date: $picked');
      // Do something with the selected date
    }
    checkstartTimeIsBeforeFun();
    if (fromDate != null && fromTime != null) {
      fromDateTime.value = false;
    }
  }

// start time function =======================
  Future<void> _startTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: fromTime ?? TimeOfDay.now(),
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
      setState(() {
        fromTime = picked;
      });
      log('Selected start time: $picked');
      // Do something with the selected date
    }
    checkstartTimeIsBeforeFun();
    if (fromDate != null && fromTime != null) {
      fromDateTime.value = false;
    }
  }

// end date function=================
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate ?? fromDate,
      firstDate: fromDate ?? DateTime.now(),
      lastDate: DateTime(2150),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          // inputDecorationTheme:InputDecorationTheme(
          //   labelStyle:TextStyle(color: kPrimaryColor),
          //   hintStyle:TextStyle(color: kPrimaryColor),
          //   helperStyle:TextStyle(color: kPrimaryColor),
          //   counterStyle:TextStyle(color: kPrimaryColor),
          // ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primarySwatch,
            accentColor: kTextBlack,
            backgroundColor: Colors.lightBlue,
            cardColor: kTextBlack,
            brightness: Brightness.dark,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        toDate = picked;
      });
      log('Selected end date: $picked');
      // Do something with the selected date
    }
    checkstartTimeIsBeforeFun();
    if (toDate != null && toTime != null) {
      endDateTime.value = false;
    }
  }

// end time function =======================
  Future<void> _endTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: fromTime ?? TimeOfDay.now(),
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
      setState(() {
        toTime = picked;
      });
      log('Selected start time: $picked');
      // Do something with the selected date
    }
    checkstartTimeIsBeforeFun();
    if (toDate != null && toTime != null) {
      endDateTime.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // log("evets data in edit evets screens ${widget.eventData.startDate}");
    // log("evets data in edit evets screens ${TempData.editEvetStartDate}");
    log("evets data in edit evets screens ${widget.eventData.venu.title}");
    return PopScope(
      onPopInvoked: (e) {
        removeData();
      },
      canPop: true,
      child: parentWidgetWithConnectivtyChecker(
        child: Scaffold(
          appBar: AppBar(
            leading: Platform.isAndroid
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      removeData();
                    },
                    icon: const Icon(Icons.arrow_back))
                : IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      removeData();
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
            iconTheme: const IconThemeData(color: kPrimaryColor),
          ),
          body: GestureDetector(
            onTap: () {
              unfoucsKeyboard(context);
            },
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                child: Form(
                  key: _key,
                  autovalidateMode: autovalidateMode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enter event details', style: headingStyle),
                      const SizedBox(height: 35),
                      Text(
                        'Event Title',
                        style: labelStyle.copyWith(fontWeight: FontWeight.w600),
                      ),
                      textFormField(
                        controller: _eventTitle,
                        inputFormate: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z0-9\s!@#\$&*~%(),.?\-_=+|{}[\]:;"<>^`/]')),
                        ],
                        validationFunction: (values) {
                          var value = values.trim();
                          if (value == null || value.isEmpty) {
                            return 'Enter a event name.';
                          }
                          if (value.length < 2) {
                            return 'Name is too short';
                          }
                          if (value.length > 150) {
                            return 'Name is to large';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 35),
                      Text(
                        'Event Description',
                        style: labelStyle.copyWith(fontWeight: FontWeight.w600),
                      ),
                      textFormField(
                        controller: _eventDescriptions,
                        inputFormate: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z0-9\s!@#\$&*~%(),.?\-_=+|{}[\]:;"<>^`/]')),
                        ],
                        validationFunction: (values) {
                          var value = values.trim();
                          if (value == null || value.isEmpty) {
                            return 'Enter a event descriptions.';
                          }
                          if (value.length < 2) {
                            return 'Name is too short';
                          }
                          // if (value.length > 30) {
                          //   return 'Name is to large';
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(height: 35),
                      Text(
                        'From :',
                        style: headingStyle.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectStartDate(context);
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
                                            // fontWeight: FontWeight.bold,
                                            color: const Color(0xff626262)),
                                      )
                                    : Text(
                                        DateFormat('MMM d yyyy')
                                            .format(fromDate!),
                                        style: paragraphStyle.copyWith(
                                            // fontWeight: FontWeight.bold,
                                            color: kTextWhite),
                                      )
                              ],
                            ),
                          ),
                          const SizedBox(width: 35),
                          GestureDetector(
                            onTap: () {
                              _selectEndDate(context);
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
                                            // fontWeight: FontWeight.bold,
                                            color: const Color(0xff626262)),
                                      )
                                    : Text(
                                        DateFormat('MMM d yyyy')
                                            .format(toDate!),
                                        style: paragraphStyle.copyWith(
                                            // fontWeight: FontWeight.bold,
                                            color: kTextWhite),
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Obx(() => fromDateTime.value
                          ? Text(
                              'Please select event start date and time.',
                              style: paragraphStyle.copyWith(
                                  color: kTextError.withOpacity(0.75),
                                  fontSize: 14,
                                  fontFamily: '',
                                  letterSpacing: 0.6),
                            )
                          : const SizedBox()),
                      const SizedBox(height: 35),
                      Text(
                        'To :',
                        style: headingStyle.copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _startTime(context);
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
                                            // fontWeight: FontWeight.bold,
                                            color: const Color(0xff626262)),
                                      )
                                    : Text(
                                        '${fromTime.format(context)}',
                                        style: paragraphStyle.copyWith(
                                            // fontWeight: FontWeight.bold,
                                            color: kTextWhite),
                                      )
                              ],
                            ),
                          ),
                          const SizedBox(width: 35),
                          GestureDetector(
                            onTap: () {
                              // timePick(context, false, fromTime, toTime,
                              //     (TimeOfDay picked) {
                              //   setState(() {
                              //     toTime = picked;
                              //     if (toTime != null && toDate != null) {
                              //       endDateTime = false;
                              //     }
                              //   });
                              // });
                              _endTime(context);
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
                                            // fontWeight: FontWeight.bold,
                                            color: const Color(0xff626262)),
                                      )
                                    : Text(
                                        toTime.format(context),
                                        style: paragraphStyle.copyWith(
                                            // fontWeight: FontWeight.bold,
                                            color: kTextWhite),
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Obx(() => endDateTime.value
                          ? Text(
                              'Please select event end date and time.',
                              style: paragraphStyle.copyWith(
                                color: kTextError.withOpacity(0.75),
                                fontSize: 14,
                                fontFamily: '',
                                letterSpacing: 0.6,
                              ),
                            )
                          : const SizedBox()),
                      // const Spacer(),
                      const SizedBox(height: 50),
                      MyElevatedButton(
                        onPressed: waiting
                            ? null
                            : () {
                                unfoucsKeyboard(context);
                                _key.currentState!.validate();
                                bool dateTimetime = fromDate != null &&
                                    toDate != null &&
                                    fromTime != null &&
                                    toTime != null &&
                                    fromDate != '' &&
                                    toDate != '' &&
                                    fromTime != '' &&
                                    toTime != '';
                                if (_key.currentState!.validate() &&
                                    dateTimetime) {
                                  addData(
                                      eventTitle: _eventTitle.text,
                                      eventDescription: _eventDescriptions.text,
                                      startDate: fromDate,
                                      startTime: fromTime,
                                      endDate: toDate,
                                      endTime: toTime);
                                  // Navigator.pushNamed(
                                  //     context, EditEvent);
                                  Get.to(
                                    () => EditEvent(
                                      eventData: widget.eventData,
                                      venuList: venuList,
                                      categoryList: categoryList,
                                      ageGroupList: ageList,
                                    ),
                                  );
                                  log("Data of all the fields are added ${TempData.evetTitle} ${TempData.evetDescription} ${TempData.evetStartDate} ${TempData.evetStartTime} ${TempData.evetEndDate} ${TempData.evetEndTime}");
                                }
                                // start date and time validation
                                if (fromDate == null && fromTime == null) {
                                  fromDateTime.value = true;
                                  setState(() {});
                                  // snackBarError(context,message: 'Please select date and time from start to end date.');
                                } else {
                                  fromDateTime.value = false;
                                  setState(() {});
                                }
                                // end date and time validation
                                if (toDate == null && toTime == null) {
                                  endDateTime.value = true;
                                  setState(() {});
                                } else {
                                  endDateTime.value = false;
                                  setState(() {});
                                }
                              },
                        text: 'Continue',
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // add all the event data in temp variable and then send it to server using dio package
  addData(
      {eventTitle, eventDescription, startDate, startTime, endDate, endTime}) {
    log("heh khgwer h erwkh $eventTitle, $eventDescription, $startDate, $startTime, $endDate, $endTime}");
    TempData.editEvetTitle = eventTitle;
    TempData.editEvetDescription = eventDescription;
    TempData.editEvetStartDate = startDate;
    TempData.editEvetStartTime = startTime;
    TempData.editEvetEndDate = endDate;
    TempData.editEvetEndTime = endTime;
  }

  // remove all the event data in temp variable
  removeData() {
    TempData.evetTitle = '';
    TempData.evetDescription = '';
    TempData.evetStartDate = '';
    TempData.evetStartTime = '';
    TempData.evetEndDate = '';
    TempData.evetEndTime = '';
    TempData.selectVenu = '';
    TempData.ageGroup = '';
    TempData.category = '';
    TempData.eventCapcity = '';
    TempData.eventThumbnail = '';
    TempData.eventEntryType = '';
    TempData.eventEntryCost = '';
    TempData.eventKeyGuest = '';
    TempData.eventPhotos.clear();
  }
}
