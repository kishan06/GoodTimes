import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/notification/nofication_model.dart';
import 'package:intl/intl.dart';

import '../../../data/models/notification_model.dart';
import '../../../data/repository/services/notification.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';

class Notifications extends StatefulWidget {
  static const String routeName = 'notifications';
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Notifications', style: headingStyle),
              // const SizedBox(height: 20),
              // const Text('Recent', style: paragraphStyle),
              const SizedBox(height: 20),
              FutureBuilder(
                  future: NotificationServices().getNotificationList(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data.reversed.toList();
                      return data.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        showDetailedData(context,data[index]);
                                      },
                                      child: notification(data[index]),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 20),
                                  itemCount: data.length),
                            )
                          : const Center(
                              child:Text("No data found 😞", style: headingStyle),
                            );
                    }
                    return Expanded(
                      child: ListView.separated(
                        itemCount: 10,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          return ReusableSkeletonAvatar(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            borderRadius: BorderRadius.circular(6),
                          );
                        },
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  notification(data) {
    NotificationList newList = data;
    // log("notification data ${DateTime.parse(newList.date)}");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
      decoration: BoxDecoration(
        color: kTextWhite.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 0,
              child: SvgPicture.asset('assets/svg/notification_logo.svg')),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(newList.title,
                          style: paragraphStyle.copyWith(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        // '. Dec 12, 2024',
                        DateFormat.yMMMd('en_US')
                            .format(DateTime.parse(newList.date)),
                        style: paragraphStyle.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Text(newList.message, style: paragraphStyle, maxLines: 2)
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 5.0),
          //   child: Container(
          //     width: 8,
          //     height: 8,
          //     decoration: BoxDecoration(
          //         color: kTextWhite, borderRadius: BorderRadius.circular(100)),
          //   ),
          // )
        ],
      ),
    );
  }

 
}
