import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:good_times/data/models/venu_model.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/view-models/global_controller.dart';
import 'package:good_times/views/screens/event_manager/venue/create_venue.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/common/skeleton.dart';

import '../../../../data/repository/services/venue_services.dart';
import '../../../../utils/constant.dart';
import '../../../widgets/common/parent_widget.dart';

class Venue extends StatefulWidget {
  static const String routeName = "venue";
  const Venue({super.key});

  @override
  State<Venue> createState() => _VenueState();
}

class _VenueState extends State<Venue> {

  GlobalController globalController = Get.find();
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kPrimaryColor),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Venues', style: headingStyle),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: VenueServices().getVenue(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      log("log data of ${snapshot.data}");
                      List<VenuModel> data = snapshot.data;
                      return Expanded(
                        child: data.isEmpty
                            ? const Center(
                                child:
                                    Text("No data found 😞", style: headingStyle),
                              )
                            : ListView.separated(
                                itemCount: data.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: ValueKey(data[index].id),
                                    background: showBackground(0),
                                    secondaryBackground: showBackground(1),
                                    onDismissed: (_) {},
                                    confirmDismiss: (_) {
                                      return showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: const Text('Are you sure?'),
                                            content: const Text(
                                                'Do you really want to delete?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context, false),
                                                  child: const Text('No')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                    //  await Future.delayed(Duration(milliseconds: 100)); // Add a small delay
                                                    VenueServices()
                                                        .patchVenu(context,
                                                            venueId: data[index].id)
                                                        .then((value) {
                                                      if (value.responseStatus ==
                                                          ResponseStatus.success) {
                                                        //  _scaffoldKey.snackBarSuccess(context, message: "value.data[data']");
                                                      }
                                                    });
        
                                                    // log("venue id ${data[index].id}");
                                                  },
                                                  child: const Text('Yes')),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: fvrtMethode(
                                      img: data[index].image,
                                      title: data[index].title,
                                      address: data[index].address,
                                    ),
                                  );
                                },
                              ),
                      );
                    }
                    return Expanded(
                      child: ListView.separated(
                        itemCount: 10,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          return ReusableSkeletonAvatar(
                              width: MediaQuery.of(context).size.width, height: 100,borderRadius: BorderRadius.circular(10),);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          floatingActionButton: MyElevatedButton(
              onPressed: () {
               globalController.hasActiveSubscription.value? Navigator.pushNamed(context, CreateVenue.routeName, arguments: "fromVenu"):snackBarError(context,message:'Please activate your account.');
              },
              text: 'Add Venue'),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  Row fvrtMethode({img, title, address}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: img != null
              ? Image.network(img, fit: BoxFit.cover, height: 90, width: 110)
              : Image.asset("assets/images/event_preview.jpeg",
                  fit: BoxFit.cover, height: 90, width: 110),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: labelStyle),
              const SizedBox(height: 5),
              Text(
                address ?? 'add',
                style: paragraphStyle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget showBackground(int dirc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      margin: const EdgeInsets.all(4),
      color: Colors.red,
      alignment: dirc == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
