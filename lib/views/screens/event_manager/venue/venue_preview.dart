import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/widgets/common/button.dart';
import '../../../../data/repository/services/create_venu.dart';
import '../../../../utils/loading.dart';
import '../../../../utils/temp.dart';
import '../../../../view-models/global_controller.dart';
import '../../../widgets/common/parent_widget.dart';
import 'create_venue.dart';

class VenuePreview extends StatefulWidget {
  static const String routeName = "venuePreview";
  const VenuePreview({super.key});

  @override
  State<VenuePreview> createState() => _VenuPreviewState();
}

class _VenuPreviewState extends State<VenuePreview> {
  
  GlobalController globalController = Get.find();
  bool waiting = false;
  @override
  Widget build(BuildContext context) {
    // logger.f("longitutde ${globalController.long.value} latitude ${globalController.lat.value}");
    final args = ModalRoute.of(context)!.settings.arguments;
    log("args in create venue $args");
    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Preview', style: labelStyle),
            iconTheme: const IconThemeData(color: kPrimaryColor),
            actions: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.edit_outlined),
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(
                File(globalController.venuImgPath.value),
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TempData.venueName,
                      style: labelStyle.copyWith(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => Text(globalController.address.value,
                          style: paragraphStyle),
                    )
                  ],
                ),
              ),
              const Spacer(),
              MyElevatedButton(
                  onPressed: () {
                    showWaitingDialoge(context: context, loading: waiting);
                    setState(() {
                      waiting = true;
                    });
                    CreateVenu().createVenu(
                      context,
                      title: TempData.venueName,
                      adrs: globalController.address.value,
                      img: globalController.venuImgPath.value,
                      lang: globalController.long.value,
                      lat: globalController.lat.value,
                    ).then((value) {
                      if (value.responseStatus == ResponseStatus.success) {
                        Navigator.pop(context);
                        if (args == "fromVenu") {
                          Navigator.pushNamed(context, HomeMain.routeName);
                          clearVenu();
                          setState(() {
                            waiting = false;
                          });
                        }
                        // if (args == "fromEvent") {
                        //   Navigator.pop(context);
                        //   Navigator.pop(context);
                        //   Navigator.pop(context);
                        //   Navigator.pop(context);
                        // }
                        if (args == "fromEvent") {
                          Get.back();
                          Get.back();
                          // Get.back();
                        }
                        clearVenu();
                        setState(() {
                          waiting = false;
                        });
                      }
                      if (value.responseStatus == ResponseStatus.failed) {
                        setState(() {
                          waiting = false;
                        });
                        Navigator.pop(context);
                      }
                    });
                  },
                  text: 'Save'),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
