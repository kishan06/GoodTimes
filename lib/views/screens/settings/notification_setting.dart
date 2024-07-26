import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/notification_model.dart';
import '../../../data/repository/endpoints.dart';
import '../../../data/repository/services/notification.dart';
import '../../../utils/constant.dart';
import '../../widgets/common/parent_widget.dart';

class NotificationSetting extends StatefulWidget {
  static const String routeName = "notificationSeting";
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  @override
  Widget build(BuildContext context) {
    NotificationServices().getNotificationCategory(context);
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Notification Settings', style: headingStyle),
              const SizedBox(height: 10),
              FutureBuilder(
                future: NotificationServices().getNotificationCategory(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<NotificationCategory> data = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        logger.f(
                            "notification settings  ${data[index].isEnabled}");
                        return InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Text(data[index].categoryTitle,
                                    style: labelStyle),
                                const Spacer(),
                                Transform.scale(
                                  scale: 0.9,
                                  child: CupertinoSwitch(
                                    value: data[index].isEnabled,
                                    thumbColor: kTextBlack,
                                    onChanged: (value) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        NotificationServices()
                                            .notificationCategoryEableDisabled(
                                          context,
                                          notificationCategory:
                                              data[index].categoryName,
                                          enableDisable: value,
                                        )
                                            .then((value) {
                                          setState(() {});
                                        });
                                      });
                                    },
                                    activeColor: kPrimaryColor,
                                    trackColor: const Color(0xFFB2B2B2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
