import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/temp.dart';
import 'package:good_times/views/screens/event_manager/venue/venue_preview.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utils/constant.dart';
// import '../../../../view-models/global_controller.dart';
import '../../../../utils/helper.dart';
import '../../../../view-models/global_controller.dart';
import '../../../widgets/common/button.dart';
import '../../../widgets/common/parent_widget.dart';
import '../../../widgets/common/textformfield.dart';
import 'search_place.dart';

class CreateVenue extends StatefulWidget {
  static const String routeName = "createVenue";
  const CreateVenue({super.key});

  @override
  State<CreateVenue> createState() => _CreateVenuState();
}

class _CreateVenuState extends State<CreateVenue> {
  final _key = GlobalKey<FormState>();
  final TextEditingController venuNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  GlobalController globalController = Get.put(GlobalController());

  String locationValidation = '';
  String venuPhotoValidation = '';
  var args;

  @override
  void initState() {
    super.initState();
    args = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {

    return parentWidgetWithConnectivtyChecker(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: kPrimaryColor),
          ),
          body: PopScope(
            onPopInvoked: (e) async {
             clearVenu();
        
            },
            canPop: true,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _key,
                        autovalidateMode: _autovalidateMode,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Add Venue ', style: headingStyle),
                            const SizedBox(height: 40),
                            const Text('Venue Name', style: labelStyle),
                            textFormField(
                              controller: venuNameController,
                              inputFormate: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z\s]+$')),
                              ],
                              validationFunction: (values) {
                                 var value = values.trim();
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a venue name.';
                                }
                                if (value.length < 2) {
                                  return 'Name is too short';
                                }
                                if (value.length > 50) {
                                  return 'Name is to large';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 40),
                            const Text('Location', style: labelStyle),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => SearchPlace());
                              },
                              child: Container(
                                height: 60,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: kPrimaryColor),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        color: kPrimaryColor, size: 30),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Obx(
                                        () => Text(
                                          globalcontroller.address.value,
                                          style: paragraphStyle.copyWith(
                                            color: kTextWhite,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              locationValidation,
                              style: paragraphStyle.copyWith(
                                  color: kTextError, fontSize: 12),
                            ),
                            const SizedBox(height: 40),
                            const Text('Add Photos', style: labelStyle),
                            Text(
                              'Photos',
                              style: paragraphStyle.copyWith(
                                  color: const Color(0xffA8A8A8)),
                            ),
                            const SizedBox(height: 16),
                            Obx(() =>
                            Row(children: [
                            InkWell(
                              onTap: (){
                                 selectProfileImg(ImageSource.gallery);
                              },
                              child: Container(
                                width: 100,
                                height: 100,
                                color: kTextWhite.withOpacity(0.15),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            (globalController.venuImgPath.value == '')
                                ? const SizedBox()
                                : Image.file(
                                  File(globalController.venuImgPath.value),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                            ],),
                            ),
                            Text(
                              venuPhotoValidation,
                              style: paragraphStyle.copyWith(
                                  color: kTextError, fontSize: 12),
                            ),
                            const Spacer(),
                            MyElevatedButton(
                              onPressed: () {
                                unfoucsKeyboard(context);
                                _key.currentState!.validate();
                                if (_key.currentState!.validate() &&
                                    globalcontroller.address.value != '' && globalcontroller.venuImgPath.value != '') {
                                      setState(() {
                                        TempData.venueName = venuNameController.text;
                                      });
                                      Navigator.pushNamed(context, VenuePreview.routeName,arguments: args);
                                }
                                if (globalcontroller.address.value == '') {
                                  setState(() {
                                    locationValidation =
                                        'Please select a address';
                                  });
                                }else {
                                  setState(() {
                                    locationValidation ="";
                                  });
                                }
                                if(globalcontroller.venuImgPath.value == ''){
                                  setState(() {
                                    venuPhotoValidation = 'Please add photo';
                                  });
                                }else{
                                  setState(() {
                                    venuPhotoValidation = "";
                                  });
                                }
                              },
                              text: 'Add Venue',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void selectProfileImg(ImageSource imgSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImg = await picker.pickImage(source: imgSource);
    if (pickedImg != null) {
      final CroppedFile? croppedImg = await ImageCropper().cropImage(
        sourcePath: pickedImg.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        maxHeight: 512,
        maxWidth: 512,
        compressQuality: 100,
        // cropStyle: CropStyle.square,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Image",
            toolbarColor: kTextBlack,
            toolbarWidgetColor: kTextWhite,
            backgroundColor: kTextBlack,
            activeControlsWidgetColor: kPrimaryColor,
            // initAspectRatio: CropAspectRatioPreset.original,
            cropFrameColor: kTextBlack,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );
      // log('picked image file ${croppedImg!.path}');
      if (croppedImg != null) {
        globalController.venuImgPath.value = croppedImg.path;
      }
    }
  }

}
  clearVenu(){
     globalcontroller.address.value = '';
     globalcontroller.venuImgPath.value = '';
     TempData.venueName ='';
  }
