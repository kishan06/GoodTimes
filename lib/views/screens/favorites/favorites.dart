import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/constant.dart';
import 'package:intl/intl.dart';

import '../../../data/models/events_ikes_models.dart';
import '../../../data/repository/endpoints.dart';
import '../../../data/repository/services/event_likes.dart';
import '../../../view-models/copy_clipboard.dart';
import '../../../view-models/deep_link_model.dart';
import '../../../view-models/global_controller.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';
import '../event/event_preview.dart';

class Favorites extends StatefulWidget {
  static const String routeName = 'favorites';
  const Favorites({super.key});

  @override
  State<Favorites> createState() => FfavoritesState();
}

class FfavoritesState extends State<Favorites> {
  GlobalController globalcontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kPrimaryColor),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Favorites', style: headingStyle),
                  const SizedBox(height: 24),
                  FutureBuilder(
                    future: EventsLikes().getLikesEvents(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<EventsLikeModel> data = snapshot.data;
                        logger.e("events list in ui $data");
                        return data.isEmpty
                            ? const Center(
                                child: Text(
                                  "No Data Found",
                                  style: paragraphStyle,
                                ),
                              )
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 30),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, EventPreview.routeName,
                                          arguments: [data[index].id, null]);
                                    },
                                    child: fvrtMethode(
                                      img: data[index].thumbnail,
                                      dates:
                                          "${DateFormat('MMM dd,EEE').format(data[index].startDate)} - ${DateFormat('MMM dd,EEE').format(data[index].endDate)}",
                                      title: data[index].title,
                                      id: data[index].id,
                                    ),
                                  );
                                },
                              );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 12,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ReusableSkeletonAvatar(
                                      height: 90,
                                      width: MediaQuery.of(context).size.width,
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ReusableSkeletonAvatar(
                                          height: 10,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          randomWidth: true,
                                        ),
                                        const SizedBox(height: 20),
                                        ReusableSkeletonAvatar(
                                          height: 10,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          randomWidth: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row fvrtMethode({img, dates, title, id}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Image.network(img, fit: BoxFit.cover, height: 90, width: 110),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dates, style: paragraphStyle),
              const SizedBox(height: 5),
              Text(
                title,
                style: headingStyle.copyWith(fontSize: 18),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: kPrimaryColor,
                  ),
                  globalcontroller.hasActiveSubscription.value
                      ? GestureDetector(
                          onTap: () {
                            EasyDebounce.debounce('my-debouncer',
                                const Duration(milliseconds: 700), () {
                              initDeepLinkData(id, 'event_id');
                              generateLink(context).then((value) {
                                CopyClipboardAndSahreController().shareLink(
                                    data: value,
                                    message:"Hey there! I've got something super exciting to share with you – an event you won't want to miss! Click the link to get all the juicy details! 🎉");
                              });
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/share.png',
                                width: 25,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
