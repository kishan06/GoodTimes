import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

// import '../../../views/screens/event_manager/edit_event.dart/edit_event.dart';
import '../../common/scaffold_snackbar.dart';
import '../endpoints.dart';
import '../response_data.dart';

class CreateEventService {
  Dio dio = Dio();
  Logger  logger = Logger();
  Future<ResponseModel> createEventServices(context,
      {title,
      description,
      ageGroup,
      startDate,
      fromTime,
      endDate,
      toTime,
      venueCapacity,
      entryType,
      venue,
      category,
      enteryFee,
      guest,
      thumbnailImg,
      images,
      draft,
      tags,
      couponCodeController,
      couponDescriptionController,
      }) async {

    logger.e('Event title in services $title - descriptions $description - start date $startDate - start time $fromTime - end data $endDate - end time $toTime - select venu $venue - age group $ageGroup - category $category - venu capacity $venueCapacity - entry type ${entryType.toLowerCase()} - admission cost $enteryFee - key guest $guest - thumbnail image $thumbnailImg - photos ab $images tags $tags tags ${jsonEncode(tags)} coupon code $couponCodeController coupon code descriptions $couponDescriptionController');
    DateTime startTime = DateTime(1, 1, 1, fromTime.hour, fromTime.minute);
    DateTime endTime = DateTime(1, 1, 1, toTime.hour, toTime.minute);
    var i = 1;

    try {
      final formData = FormData.fromMap({
        "title": title,
        "description": description,
        "start_date":DateFormat("yyyy-MM-dd").format(startDate), //DateTime(startDate),
        "from_time": DateFormat("HH:mm:ss").format(startTime),
        "end_date": DateFormat("yyyy-MM-dd").format(endDate),
        "to_time": DateFormat("HH:mm:ss").format(endTime),
        "venue_capacity": venueCapacity,
        "entry_type": entryType.toLowerCase(),
        "category": int.parse(category),
        "venue": int.parse(venue),
        "key_guest": guest,
        "entry_fee": enteryFee,
        "age_group": ageGroup,
        "draft": draft,
        "coupon_code":couponCodeController,
        "coupon_description":couponDescriptionController,
        "image": await MultipartFile.fromFile(
          thumbnailImg,
          filename: 'thumbnail_img.jpg',
        ),
        "images": [
          for (var file in images)
            {
              await MultipartFile.fromFile(file,
                  filename: 'eventPhoto_${i + 1}.jpg')
            }.toList()
        ],
        "tags": jsonEncode(tags)
      });
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.post(Endpoints.createEvent,options: Options(headers: header), data: formData);
      // logger.e('respose of create event status only response  $response');
      // logger.e('respose of create event status ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // snackBarSuccess(context, message: "Event Created successfully.");
        logger.e('response.body ${response.data}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      // logger.e('respose of create event exceptions only e $e');
      // logger.e('respose of create event exceptions ${e.response?.data["message"]}');
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        logger.e('Bad Request Error: ${e.message}');
        // snackBarError(context, message: e.response?.data["message"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        // Handle other DioErrors
        logger.e('Dio Error: ${e.message}');
        // snackBarError(context, message: 'Something went wronng try again.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      // Handle other exceptions
      logger.e('Error: $e');
      // snackBarError(context, message: 'Something went wronng try again.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }

    return const ResponseModel(
      responseStatus: ResponseStatus.failed,
      data: null,
    );
  }

// Edit events service function start from here
  Future<ResponseModel> editEventServices(context,
      {eventId,
      title,
      description,
      ageGroup,
      startDate,
      fromTime,
      endDate,
      toTime,
      venueCapacity,
      entryType,
      venue,
      category,
      enteryFee,
      guest,
      thumbnailImg,
      images,
      tags,
      draft}) async {
    logger.e('Edit event title in services $eventId $title - descriptions $description - start date $startDate - start time $fromTime - end data $endDate - end time $toTime - select venu $venue - age group $ageGroup - category $category - venu capacity $venueCapacity - entry type $entryType - admission cost $enteryFee - key guest $guest - thumbnail image $thumbnailImg - photos ab $images  $tags tags ${jsonEncode(tags)}');
    List<dynamic> newImagesList = images.map((e) => e[0]).toList();
    logger.f("newImagesList images in edit service file ${newImagesList}");
    logger.e("new image list ${newImagesList[0]}");
    DateTime startTime = DateTime(1, 1, 1, fromTime.hour, fromTime.minute);
    DateTime endTime = DateTime(1, 1, 1, toTime.hour, toTime.minute);
    List<MultipartFile> imageFiles = [];

    var i = 1;
    for (var file in newImagesList) {
    if (file.contains(Endpoints.domain)) {
        imageFiles.add(await _getLocalImagePath(file));
    } else {
        imageFiles.add(await MultipartFile.fromFile(file, filename: 'eventPhoto_${i++}.jpg'));
    }
}

    try {
      logger.f("imageFiles $imageFiles");
      final formData = FormData.fromMap({
        "title": title,
        "description": description,
        "start_date":
            DateFormat("yyyy-MM-dd").format(startDate), //DateTime(startDate),
        "from_time": DateFormat("HH:mm:ss").format(startTime),
        "end_date": DateFormat("yyyy-MM-dd").format(endDate),
        "to_time": DateFormat("HH:mm:ss").format(endTime),
        "venue_capacity": venueCapacity,
        "entry_type": entryType.toLowerCase(),
        "category": int.parse(category),
        "venue": int.parse(venue),
        "key_guest": guest,
        "entry_fee": (entryType=="Free")?"0.00":enteryFee,
        "age_group": ageGroup,
        "draft": "False",
         "tags": jsonEncode(tags),
        "image": thumbnailImg.contains(Endpoints.domain)
            ? await _getLocalImagePath(thumbnailImg)
            : await MultipartFile.fromFile(
                thumbnailImg,
                filename: 'thumbnail_img.jpg',
              ),
              "images":imageFiles,
 
        // "images": [
              // for (var file in newImagesList){
              //   logger.i("images list of netwrok $file"),
              //   if(file.contains(Endpoints.domain)){
              //     await _getLocalImagePath(file),
              //   }else{
              //     // logger.i("images list of local $file"),
              //     logger.f("_getLocalImagePath check direct multipart"),
              //     logger.f(MultipartFile.fromFile(file, filename: 'eventPhoto_${i+1}.jpg')),
              //     await MultipartFile.fromFile(file, filename: 'eventPhoto_${i+1}.jpg')
              //   },
              //   }.toList()
          // ]


      });
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.patch("${Endpoints.editevents}$eventId/",
          options: Options(headers: header), data: formData);
      logger.e('respose of create event status only response  $response');
      logger.e('respose of create event status ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        snackBarSuccess(context, message: "Event Created successfully.");
        logger.e('response.body ${response.data}');
        newImagesList.clear();
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      // logger.e('respose of create event exceptions only e ${e}');
      logger.e('respose of create event exceptions ${e.response?.data["message"]}');
      if (e.response?.statusCode == 400) {
        // Handle 400 Bad Request Error
        logger.e('Bad Request Error: ${e.message}');
        snackBarError(context, message: e.response?.data["message"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        // Handle other DioErrors
        logger.e('Dio Error: ${e.message}');
        snackBarError(context, message: 'Something went wronng try again.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      // Handle other exceptions
      logger.e('Error: $e');
      snackBarError(context, message: 'Something went wronng try again.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }

    return const ResponseModel(
      responseStatus: ResponseStatus.failed,
      data: null,
    );
  }

  Future<MultipartFile> _getLocalImagePath(String fileUrl) async {

    // Download the image from the URL and save it locally
    Response<List<int>> response = await Dio().get<List<int>>(
      fileUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    String fileName = fileUrl.split('/').last;
    logger.f("fileName fileName $fileName");
    String filePath = await _saveImageLocally(fileName, response.data!);
    logger.f("fileName filePath $filePath");

    return await MultipartFile.fromFile(filePath, filename: fileName);
  }

  Future<String> _saveImageLocally(String fileName, List<int> imageData) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String filePath = '$appDocPath/$fileName';

    File file = File(filePath);
    await file.writeAsBytes(imageData);

    return filePath;
  }
}
