import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/utils/temp.dart';
import 'package:good_times/views/screens/event_manager/create-event/event_title.dart';

import '../../../data/models/events_model.dart';
import '../../../data/repository/services/event_manager.dart';
import '../../../data/repository/services/profile.dart';
import '../../../view-models/global_controller.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';
import '../event/event_preview.dart';
import 'edit_event.dart/edit_event_title.dart';

class EventeManagerHome extends StatefulWidget {
  const EventeManagerHome({super.key});

  @override
  State<EventeManagerHome> createState() => _EventeManagerHomeState();
}

class _EventeManagerHomeState extends State<EventeManagerHome>
    with TickerProviderStateMixin {
  late TabController _tabController;
  GlobalController globalcontroller = Get.find();
  String activeTab = 'active';
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    ProfileService().getProfileDetails(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              TabBar(
                padding: const EdgeInsets.all(0),
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.zero,
                tabAlignment: TabAlignment.fill,
                labelColor: kTextWhite,
                unselectedLabelColor: kTextWhite.withOpacity(0.6),
                labelStyle:
                    paragraphStyle.copyWith(fontWeight: FontWeight.w500),
                controller: _tabController,
                indicatorColor: kPrimaryColor,
                onTap: (int index) {
                  log("show me index $index");
                  setState(() {
                    if (index == 0) activeTab = 'active';
                    if (index == 1) activeTab = 'active_past';
                    if (index == 2) activeTab = 'draft';
                  });
                },
                tabs: const <Widget>[
                  Tab(
                    text: 'My events',
                  ),
                  Tab(
                    text: 'Past',
                  ),
                  Tab(
                    text: 'Draft',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: FutureBuilder(
                      future: EventManagerServices().getEventManagerEventas(
                          context,
                          filterParams: activeTab),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data;
                          return TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              _myEvents(data),
                              _myEvents(data),
                              _myDraftEvents(data),
                            ],
                          );
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                ReusableSkeletonAvatar(
                                  height: 250,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ReusableSkeletonAvatar(
                                            height: 10,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          const SizedBox(height: 10),
                                          ReusableSkeletonAvatar(
                                            height: 10,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 50),
                                    Expanded(
                                      child: ReusableSkeletonAvatar(
                                        height: 10,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
          floatingActionButton: (globalcontroller.hasActiveSubscription.value)
              ? FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  shape: const CircleBorder(),
                  onPressed: () {
                    Navigator.pushNamed(context, EventTitile.routeName);
                  },
                  child: const Icon(Icons.add, size: 28),
                )
              : const SizedBox(),
          bottomNavigationBar: const BottomNavigationBars(),
        ),
      ),
    );
  }

  _myEvents(eventDataAsList) {
    List<EventsModel> data = eventDataAsList;
    return data.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  TempData.eventIdIndex = data[index].id;
                  log("events id ${data[index].id}");
                  Navigator.pushNamed(context, EventPreview.routeName,
                      arguments: [TempData.eventIdIndex, data[index]]);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadiusDirectional.circular(10),
                        child: Image.network("${data[index].thumbnail}",
                            width: double.infinity,
                            height: 185,
                            fit: BoxFit.cover)),
                    const SizedBox(height: 18),
                    Text(data[index].title!.capitalizeFirst.toString(),
                        style:
                            labelStyle.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 18),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 25),
            itemCount: data.length)
        : const Center(
            child: Text(
              "Data not found",
              style: headingStyle,
            ),
          );
  }

  _myDraftEvents(eventDataAsList) {
    List<EventsModel> data = eventDataAsList;
    return data.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, EditEventTitile.routeName,
                  // arguments: data[index]
                  // );

                  log("EventDraftId---> ${data[index]}");

                  Get.to(() => EditEventTitile(
                        eventData: data[index],
                      ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusDirectional.circular(10),
                      child: Image.network(
                        "${data[index].thumbnail}",
                        width: double.infinity,
                        height: 185,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      data[index].title!.capitalizeFirst.toString(),
                      style: labelStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 25),
            itemCount: data.length)
        : const Center(
            child: Text(
              "Data not found",
              style: headingStyle,
            ),
          );
  }
}
