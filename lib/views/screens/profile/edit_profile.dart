// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:good_times/data/repository/response_data.dart';

import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/common/textformfield.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/profile.dart';
import '../../../data/repository/services/profile.dart';
import '../../../utils/loading.dart';
import '../../../view-models/global_controller.dart';
import '../../widgets/common/parent_widget.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = 'edit-profile';

  final ProfileModel? profileData;
  const EditProfile({
    Key? key,
    this.profileData,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _instaController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final _key = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalController globalContoller = Get.put(GlobalController());
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    _fNameController.text = widget.profileData!.firstName;
    _lNameController.text = widget.profileData!.lastName;
    _instaController.text = widget.profileData!.instagram ?? '';
    _facebookController.text = widget.profileData!.facebook ?? '';
    _linkedinController.text = widget.profileData!.linkedin ?? '';
    _youtubeController.text = widget.profileData!.youtube ?? '';
    _websiteController.text = widget.profileData!.website ?? '';
    _phoneController.text = widget.profileData!.phone??'';
  }

  @override
  Widget build(BuildContext context) {
    log('globalContoller in build  ${globalContoller.profileImgPath.value}');

    var arg = ModalRoute.of(context)!.settings.arguments;
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context, 'true');
            },
            child: Platform.isAndroid
                ? const Icon(Icons.arrow_back)
                : const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _key,
                    autovalidateMode: autovalidateMode,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Manage Profile', style: headingStyle),
                        const SizedBox(height: 60),
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Obx(() {
                                log("globalContoller.profileImgPath.value ${globalContoller.profileImgPath.value}");
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: (globalContoller.profileImgPath.value =='' && widget.profileData!.profilePhoto == '')
                                      ? Image.asset(
                                          'assets/images/avatar.jpg',
                                          width: 118,
                                          height: 118,
                                          fit: BoxFit.cover,
                                        )
                                      : (globalContoller.profileImgPath.value.contains('/data/user/0/com.goodtimes') ||
                                              globalContoller.profileImgPath.value.contains('/Users/macos/Library/Developer') ||
                                              globalContoller.profileImgPath.value.contains('/private/var/mobile/')
                                              )
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Image.file(
                                                File(globalContoller
                                                    .profileImgPath.value),
                                                width: 118,
                                                height: 118,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : (globalContoller
                                                      .profileImgPath.value
                                                      .contains('') ||
                                                  widget.profileData!
                                                          .profilePhoto !=
                                                      '')
                                              ? Image.network(
                                                  widget.profileData!
                                                      .profilePhoto,
                                                  width: 118,
                                                  height: 118,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  'assets/images/avatar.jpg',
                                                  width: 118,
                                                  height: 118,
                                                  fit: BoxFit.cover,
                                                ),
                                );
                              }),
                              Positioned(
                                right: 10,
                                bottom: 5,
                                child: InkWell(
                                  onTap: () {
                                    log("clicked whe user");
                                    selectProfileImg(ImageSource.gallery);
                                    log("clicked ${globalContoller.profileImgPath.value}");
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: kTextBlack,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.edit,
                                        color: kTextWhite,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 38),
                        const Text('First Name', style: labelStyle),
                        textFormField(
                          controller: _fNameController,
                          inputFormate: [
                            FilteringTextInputFormatter(
                                RegExp(r'^[a-zA-Z\s]+$'),
                                allow: true)
                          ],
                          validationFunction: (values) {
                            var value = values.trim();
                            if (value == null || value.isEmpty) {
                              return kNamefNullError;
                            }
                            if (value.length < 2) {
                              return 'First name is too short';
                            }
                            if (value.length > 30) {
                              return 'First name is to large';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 35),
                        const Text('Last Name', style: labelStyle),
                        textFormField(
                          controller: _lNameController,
                          inputFormate: [
                            FilteringTextInputFormatter(
                                RegExp(r'^[a-zA-Z\s]+$'),
                                allow: true)
                          ],
                          validationFunction: (values) {
                            var value = values.trim();
                            if (value == null || value.isEmpty) {
                              return kNamelNullError;
                            }
                            if (value.length < 2) {
                              return 'Last name is too short';
                            }
                            if (value.length > 30) {
                              return 'Last lame is to large';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 35),
                        const Text('Phone No', style: labelStyle),
                        textFormField(
                          controller: _phoneController,
                          inputFormate: [
                            FilteringTextInputFormatter(RegExp(r'^\+?[0-9]+$'),allow: true)
                          ],
                          validationFunction: (values) {
                            var value = values.trim();
                            if (value == null || value.isEmpty) {
                              return "Please enter you mobile number";
                            }
                            if (value.length < 8) {
                              return 'Please enter valid phone number';
                            }
                            if (value.length > 16) {
                              return 'Please enter valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 35),
                        const Text('Instagram', style: labelStyle),
                        textFormField(
                          controller: _instaController,
                        ),
                        const SizedBox(height: 35),
                        const Text('Facebook', style: labelStyle),
                        textFormField(
                          controller: _facebookController,
                        ),
                        const SizedBox(height: 35),
                        const Text('Linkedin', style: labelStyle),
                        textFormField(
                          controller: _linkedinController,
                        ),
                        const SizedBox(height: 35),
                        const Text('Youtube', style: labelStyle),
                        textFormField(
                          controller: _youtubeController,
                        ),
                        const SizedBox(height: 35),
                        const Text('Website', style: labelStyle),
                        textFormField(
                          controller: _websiteController,
                        ),
                        // const Spacer(),
                        const SizedBox(height: 55),
                        MyElevatedButton(
                          //  loader: waiting
                          //     ? const CircularProgressIndicator()
                          //     : const SizedBox(),
                          onPressed: () {
                            _key.currentState!.validate();
                            if (_key.currentState!.validate()) {
                              showWaitingDialoge(
                                  context: context, loading: waiting);
                              setState(() {
                                waiting = true;
                              });
                              // log('user profile path ${globalContoller.profileImgPath.value}');
                              ProfileService()
                                  .editProfile(
                                context,
                                fName: _fNameController.text,
                                lastName: _lNameController.text,
                                profileImg: (globalContoller
                                            .profileImgPath.value
                                            .contains(
                                                '/data/user/0/com.goodtimes') ||
                                        globalContoller.profileImgPath.value
                                            .contains(
                                                '/Users/macos/Library/Developer') ||
                                        globalContoller.profileImgPath.value
                                            .contains('/private/var/mobile/'))
                                    ? globalContoller.profileImgPath.value
                                    : '',
                                instagram: _instaController.text,
                                facebook: _facebookController.text,
                                linkedin: _linkedinController.text,
                                youtube: _youtubeController.text,
                                website: _websiteController.text,
                                phoneNumber: _phoneController.text,
                              )
                                  .then((value) {
                                if (value.responseStatus ==
                                    ResponseStatus.success) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                  snackBarSuccess(context, message: 'Profile successfully updated');
                                  if (arg == "fromProfile") {
                                    Get.to(() => const HomeMain());
                                  }
                                  if (arg == "fromEvent") {
                                    Get.back();
                                    // Get.back();
                                  }
                                } else if (value.responseStatus ==
                                    ResponseStatus.failed) {
                                  setState(() {
                                    waiting = false;
                                  });
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                          text: 'Save',
                        ),
                        const SizedBox(height: 20),
                      ],
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
    log('globalContoller  ${globalContoller.profileImgPath.value}');
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImg = await picker.pickImage(source: imgSource);
    if (pickedImg != null) {
      final CroppedFile? croppedImg = await ImageCropper().cropImage(
        sourcePath: pickedImg.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        maxHeight: 512,
        maxWidth: 512,
        // compressQuality: 100,
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
      
      // ignore: unnecessary_null_comparison
      if (croppedImg != null) {
        globalContoller.profileImgPath.value = croppedImg.path;
      }
      log('picked image file ${croppedImg!.path}');
    }
  }
}
