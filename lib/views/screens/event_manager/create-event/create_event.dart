// ignore_for_file: library_prefixes
import 'dart:async';
import 'dart:developer';
import 'dart:io' as IO;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_times/data/models/event_age_group_model.dart';
import 'package:good_times/data/repository/services/venue_services.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/utils/temp.dart';
import 'package:good_times/views/screens/profile/edit_profile.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/common/textformfield.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../../../../data/models/event_categories_model.dart';
import '../../../../data/models/profile.dart';
import '../../../../data/models/venu_model.dart';
import '../../../../data/repository/endpoints.dart';
import '../../../../data/repository/services/preferences_service.dart';
import '../../../../data/repository/services/profile.dart';
import '../../../../utils/helper.dart';
import '../../../../view-models/global_controller.dart';
import '../../../widgets/common/dropdown.dart';
import '../../../widgets/common/parent_widget.dart';
import '../venue/create_venue.dart';
import 'event_preivew.dart';

class CreateEvent extends StatefulWidget {
  static const String routeName = "createEvent";
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _key = GlobalKey<FormState>();
  String selectedVenue = "";
  String selectedAge = "";
  String selectedCategory = "";
  String selectedFeeType = "";
  TextEditingController venuCapacityController = TextEditingController();
  TextEditingController admissionCostController = TextEditingController();
  TextEditingController keyGuestController = TextEditingController();
  TextEditingController tagsGuestController = TextEditingController();
  TextEditingController couponCodeController = TextEditingController();
  TextEditingController couponDescriptionController = TextEditingController();
  RxBool isThumbNail = false.obs;
  RxBool isPhoto = false.obs;
  String? refresh;
  final StringTagController _stringTagController = StringTagController();
  late double _distanceToField;
  ProfileModel? profileData;
  bool loadings = true;
  // final tagsError = RxBool(false);
  bool tagsError = false;
  bool isRunOnce = true;

  static const List<String> _initialTags = <String>[];

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalController globalController = Get.put(GlobalController());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    getvenuData();
    getCategoryData();
    profileApi();
    getAgeGroup();
    super.initState();
  }

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
    if (TempData.agedatagroup.isEmpty) {
      PreferencesService().getAgeGroup(context).then((value) {
        log("log data of category list in event screen $value");
        setState(() {
          ageList = value;
        });
      });
    } else {
      setState(() {
        ageList = TempData.agedatagroup;
      });
    }
  }

  Future profileApi() async {
    var value = await ProfileService().getProfileDetails(context);
    setState(() {
      loadings = false;
      profileData = value.data;
    });
  }

  checkReferesh() async {
    Get.back();
    refresh = await Get.to(() => const CreateVenue(), arguments: "fromEvent");
    bool booleanValue = refresh == 'true';
    setState(() {
      getvenuData();
    });

    if (booleanValue) {
      setState(() {});
    }
  }

  List<VenuModel> venuList = [];
  List<EventCategoriesModdel> categoryList = [];
  List<ageData> ageList = [];

  var isPaid = ''.obs;

  @override
  Widget build(BuildContext context) {
    // log("check venu data when create a event $_stringTagController $_initialTags");
    // logger
    //     .f("User profile userData in create events ${profileData!.firstName}");
    return PopScope(
      canPop: true,
      onPopInvoked: (e) {
        clearAllTempData();
      },
      child: parentWidgetWithConnectivtyChecker(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IO.Platform.isAndroid
                  ? IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        clearAllTempData();
                      },
                      icon: const Icon(Icons.arrow_back),
                    )
                  : IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        clearAllTempData();
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
              iconTheme: const IconThemeData(color: kPrimaryColor),
            ),
            body: GestureDetector(
              onTap: () {
                unfoucsKeyboard(context);
              },
              child: loadings
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: scaffoldPadding),
                        child: Form(
                          key: _key,
                          autovalidateMode: autovalidateMode,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Add event information',
                                  style: headingStyle),
                              const SizedBox(height: 40),
                              Text(
                                'Select Venue',
                                style: labelStyle.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              CustomDropdown(
                                hintText: Text(
                                  'Select',
                                  style: paragraphStyle.copyWith(
                                      color: const Color(0xffA8A8A8)),
                                ),
                                selectedValue: selectedVenue,
                                items: [
                                  ...venuList.map((e) => "${e.title}").toList(),
                                  'Add Venue',
                                ],
                                errorValue: 'venue',
                                onChanged: (String newValue) {
                                  if (newValue == "Add Venue") {
                                    checkReferesh();
                                  } else {
                                    VenuModel selectedVenueObject =
                                        venuList.firstWhere(
                                            (venue) => venue.title == newValue);
                                    selectedVenue =
                                        selectedVenueObject.id.toString();
                                    TempData.evetAddress =
                                        selectedVenueObject.address.toString();
                                    print("rr");
                                  } // selectedVenue = newValue;
                                },
                                onAddVenueClicked: () {
                                  // Navigate to another screen when "Add Venue" is clicked
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => const CreateVenue(),barrierDismissible: true,fullscreenDialog: true),
                                  // );
                                  // Navigator.pushNamed(context, CreateVenue.routeName,arguments: "fromEvent");
                                  checkReferesh();
                                },
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Age Group',
                                style: labelStyle.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              CustomDropdown(
                                hintText: Text(
                                  'Select',
                                  style: paragraphStyle.copyWith(
                                    color: const Color(0xffA8A8A8),
                                  ),
                                ),
                                selectedValue: selectedAge,
                                errorValue: 'age',
                                items: [
                                  ...ageList.map((e) => "${e.name}").toList(),
                                ],
                                onChanged: (String newValue) {
                                  selectedAge = newValue;
                                },
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Category',
                                style: labelStyle.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              CustomDropdown(
                                hintText: Text(
                                  'Select',
                                  style: paragraphStyle.copyWith(
                                      color: const Color(0xffA8A8A8)),
                                ),
                                selectedValue: selectedCategory,
                                items:
                                    categoryList.map((e) => e.title).toList(),
                                errorValue: 'category',
                                onChanged: (String newValue) {
                                  EventCategoriesModdel eventCatModel =
                                      categoryList.firstWhere((category) =>
                                          category.title == newValue);
                                  selectedCategory =
                                      eventCatModel.id.toString();
                                },
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Venue Capacity',
                                style: labelStyle.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              textFormField(
                                controller: venuCapacityController,
                                inputType: TextInputType.number,
                                inputFormate: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[0-9]+$')),
                                ],
                                validationFunction: (values) {
                                  var value = values.trim();
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a venue capacity.';
                                  }
                                  if (value.length < 2) {
                                    return 'Please enter a venue capacity more than 9.';
                                  }
                                  if (value.length > 5) {
                                    return 'Please enter a venue capacity not more than 99999';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Add Thumbnail',
                                style: labelStyle.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Select any thumbnail or add from your gallery',
                                style: paragraphStyle.copyWith(
                                    color: const Color(0xffA8A8A8),
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(height: 24),
                              Obx(
                                () => Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        selectThumbnailImg(ImageSource.gallery);
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 115,
                                        color: kTextWhite.withOpacity(0.15),
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 38,
                                              ),
                                              SizedBox(height: 5),
                                              Text('Add Thumbnail from gallery',
                                                  style: paragraphStyle,
                                                  textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    (globalController
                                                .eventThumbnailImgPath.value ==
                                            '')
                                        ? const SizedBox()
                                        : Image.file(
                                            IO.File(globalController
                                                .eventThumbnailImgPath.value),
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                  ],
                                ),
                              ),
                              Obx(() => isThumbNail.value
                                  ? Text(
                                      'Please select the thumbnail',
                                      style: paragraphStyle.copyWith(
                                        color: kTextError.withOpacity(0.75),
                                        fontSize: 14,
                                        fontFamily: '',
                                        letterSpacing: 0.6,
                                      ),
                                    )
                                  : const SizedBox()),
                              const SizedBox(height: 40),
                              Text(
                                'Add Photos',
                                style: labelStyle.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Photos',
                                style: paragraphStyle.copyWith(
                                    color: const Color(0xffA8A8A8),
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(height: 24),
                              // UI code to display selected images
                              Obx(
                                () => SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          globalController.eventPhotosmgPath
                                              .clear();
                                          selectMultiplePhotoImg(
                                              globalController.eventPhotosmgPath
                                                  as RxList<String>);
                                        },
                                        child: Container(
                                          width: 150,
                                          height: 115,
                                          color: Colors.white.withOpacity(0.15),
                                          child: const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  size: 38,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Row(
                                        children: List.generate(
                                          globalController
                                              .eventPhotosmgPath.length,
                                          (index) => Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Image.file(
                                                  IO.File(globalController
                                                          .eventPhotosmgPath[
                                                      index]),
                                                  width: 150,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Obx(() => isPhoto.value
                                  ? Text('Please select the Photos',
                                      style: paragraphStyle.copyWith(
                                          color: kTextError.withOpacity(0.75),
                                          fontSize: 14,
                                          fontFamily: '',
                                          letterSpacing: 0.6))
                                  : const SizedBox()),
                              // Multiple image ui end

                              const SizedBox(height: 40),
                              Text(
                                'Entry Type',
                                style: labelStyle.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              CustomDropdown(
                                hintText: Text(
                                  'If paid ; enter amount',
                                  style: paragraphStyle.copyWith(
                                    color: const Color(0xffA8A8A8),
                                  ),
                                ),
                                selectedValue: selectedFeeType,
                                items: const [
                                  "Free",
                                  "Paid",
                                ],
                                errorValue: 'entry type',
                                onChanged: (String newValue) {
                                  selectedFeeType = newValue;
                                  isPaid.value = newValue;
                                },
                              ),
                              Obx(() => (isPaid.value == 'Free')
                                  ? const SizedBox()
                                  : const SizedBox(height: 40)),
                              Obx(
                                () => (isPaid.value == 'Free')
                                    ? const SizedBox()
                                    : Text(
                                        'Admission Cost',
                                        style: labelStyle.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                      ),
                              ),
                              Obx(() => (isPaid.value == 'Free')
                                  ? const SizedBox()
                                  : textFormField(
                                      controller: admissionCostController,
                                      inputType: TextInputType.number,
                                      inputFormate: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9]+$')),
                                      ],
                                      validationFunction: (values) {
                                        var value = values.trim();
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a entry fee';
                                        }
                                        // if (value.length < 2) {
                                        //   return 'Enter a venue capacity more than the 15.';
                                        // }
                                        return null;
                                      },
                                    )),
                              const SizedBox(height: 40),
                              Text(
                                'Key Guest',
                                style: labelStyle.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              textFormField(
                                controller: keyGuestController,
                                inputFormate: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[a-zA-Z\s]+$')),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Add tags',
                                style: labelStyle.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              Text(
                                'Add tags comma sperated if multiple tags',
                                style: labelStyle.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 10),
                              ),
                              TextFieldTags<String>(
                                textfieldTagsController: _stringTagController,
                                initialTags: _initialTags,
                                textSeparators: const [' ', ','],
                                letterCase: LetterCase.normal,
                                validator: (String tag) {
                                  if (tag == 'porn') {
                                    return 'No, please just no';
                                  } else if (_stringTagController.getTags!
                                      .contains(tag)) {
                                    return 'You\'ve already entered that';
                                  }
                                  return null;
                                },
                                inputFieldBuilder: (context, inputFieldValues) {
                                  logger.f(
                                      "tag is empty or not ${_stringTagController.getTags!.isEmpty}");
                                  if (!isRunOnce) {
                                    setState(() {
                                      isRunOnce = false;
                                    });
                                    if (_stringTagController.getTags!.isEmpty) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        setState(() {
                                          tagsError = false;
                                        });
                                      });
                                    } else {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        setState(() {
                                          tagsError = true;
                                        });
                                      });
                                    }
                                  }
                                  return TextField(
                                    onTap: () {
                                      _stringTagController.getFocusNode
                                          ?.requestFocus();
                                    },
                                    style: const TextStyle(
                                      color: kTextWhite,
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    controller:
                                        inputFieldValues.textEditingController,
                                    focusNode: inputFieldValues.focusNode,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: kPrimaryColor)),
                                      border: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: kPrimaryColor)),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: kPrimaryColor)),
                                      // helperText: 'Enter Tags...',
                                      helperStyle: const TextStyle(
                                        color: kPrimaryColor,
                                      ),
                                      hintText: inputFieldValues.tags.isNotEmpty
                                          ? ''
                                          : "Enter tag...",
                                      errorText: inputFieldValues.error,
                                      prefixIconConstraints: BoxConstraints(
                                          maxWidth: _distanceToField * 0.8),
                                      prefixIcon: inputFieldValues
                                              .tags.isNotEmpty
                                          ? SingleChildScrollView(
                                              controller: inputFieldValues
                                                  .tagScrollController,
                                              scrollDirection: Axis.vertical,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 8,
                                                  left: 8,
                                                ),
                                                child: Wrap(
                                                    runSpacing: 4.0,
                                                    spacing: 4.0,
                                                    children: inputFieldValues
                                                        .tags
                                                        .map((String tag) {
                                                      return Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                20.0),
                                                          ),
                                                          color: kPrimaryColor,
                                                        ),
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 5.0),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    10.0,
                                                                vertical: 5.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            InkWell(
                                                              child: Text(
                                                                '#$tag',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              onTap: () {},
                                                            ),
                                                            const SizedBox(
                                                                width: 4.0),
                                                            InkWell(
                                                              child: const Icon(
                                                                Icons.cancel,
                                                                size: 14.0,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        233,
                                                                        233,
                                                                        233),
                                                              ),
                                                              onTap: () {
                                                                inputFieldValues
                                                                    .onTagRemoved(
                                                                        tag);
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }).toList()),
                                              ),
                                            )
                                          : null,
                                    ),
                                    onChanged: inputFieldValues.onTagChanged,
                                    onSubmitted:
                                        inputFieldValues.onTagSubmitted,
                                  );
                                },
                              ),
                              tagsError
                                  ? Text(
                                      "Please enter tags",
                                      style: TextStyle(
                                        color: kTextError.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 40),
                              Text(
                                'Coupon Code',
                                style: labelStyle.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              textFormField(
                                controller: couponCodeController,
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Coupon Description',
                                style: labelStyle.copyWith(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              textFormField(
                                controller: couponDescriptionController,
                              ),
                              const SizedBox(height: 90),
                              MyElevatedButton(
                                onPressed: () {
                                  // log("${globalController.profileSocialDetails.value}");
                                  unfoucsKeyboard(context);
                                  autovalidateMode = AutovalidateMode.always;
                                  _key.currentState!.validate();
                                  if (_stringTagController.getTags!.isEmpty) {
                                    setState(() {
                                      tagsError = true;
                                    });
                                  }
                                  if (_key.currentState!.validate() &&
                                      globalController
                                              .eventThumbnailImgPath.value !=
                                          '' &&
                                      globalController
                                          .eventPhotosmgPath.isNotEmpty &&
                                      _stringTagController
                                          .getTags!.isNotEmpty) {
                                    profileApi().then((value) {
                                      !globalController
                                              .profileSocialDetails.value
                                          ? showModalAlert()
                                          : submitFunc(context);
                                    });
                                  }

                                  if (globalController
                                          .eventThumbnailImgPath.value ==
                                      '') {
                                    isThumbNail.value = true;
                                    // setState(() {
                                    // });
                                  } else {
                                    isThumbNail.value = false;
                                    // setState(() {
                                    // });
                                  }
                                  if (globalController
                                      .eventPhotosmgPath.isEmpty) {
                                    isPhoto.value = true;
                                    // setState(() {
                                    // });
                                  } else {
                                    isPhoto.value = false;
                                    // setState(() {
                                    // });
                                  }

                                  // submitFunc(context);
                                  // log("check legth of tags ${_stringTagController.getTags!.length}");},
                                  // onPressed: (){
                                  // log("check tags data ${_stringTagController.getTags.runtimeType}");
                                },
                                text: 'Create Event',
                              )
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

  showModalAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        onPopInvoked: (e) async => true,
        child: AlertDialog(
          backgroundColor: kTextBlack,
          alignment: Alignment.center,
          title: Align(
              alignment: Alignment.topCenter,
              child: Text('Hey ${globalController.profileUserName.value}',
                  style: headingStyle.copyWith(color: kPrimaryColor))),
          content: Text(
              "It seems you haven't added your social media handles in your profile, adding the handles will help in customer engagement. Do you want to proceed with event creation?",
              style: paragraphStyle.copyWith(
                  fontSize: 16, color: kTextWhite.withOpacity(0.8)),
              textAlign: TextAlign.left),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                autovalidateMode = AutovalidateMode.always;
                submitFunc(context);
              },
              child: const Text("Yes", style: paragraphStyle),
            ),
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  autovalidateMode = AutovalidateMode.always;
                  Get.to(
                      () => EditProfile(
                            profileData: profileData,
                          ),
                      arguments: "fromEvent");
                },
                child: const Text(
                  "View Profile",
                  style: paragraphStyle,
                )),
            // OutlinedButton(onPressed: (){}, child: Text("Yes",style: paragraphStyle,)),
          ],
        ),
      ),
    );
  }

  submitFunc(context) {
    Navigator.pushNamed(context, CreatedEventPreview.routeName);
    log('validation success');
    addDataToEvent(
      selectedVenue: selectedVenue,
      selectedAge: selectedAge,
      selectedFeeType: selectedFeeType,
      selectedCategory: selectedCategory,
      admissionCostController: admissionCostController.text,
      keyGuestController: keyGuestController.text,
      venuCapacityController: venuCapacityController.text,
      couponCodeController: couponCodeController.text,
      couponDescriptionController: couponDescriptionController.text,
    );
  }

  addDataToEvent({
    selectedVenue,
    selectedAge,
    selectedCategory,
    selectedFeeType,
    venuCapacityController,
    admissionCostController,
    keyGuestController,
    couponCodeController,
    couponDescriptionController,
  }) {
    TempData.selectVenu = selectedVenue;
    TempData.ageGroup = selectedAge;
    TempData.category = selectedCategory;
    TempData.eventCapcity = venuCapacityController;
    TempData.eventEntryType = selectedFeeType;
    TempData.eventEntryCost = admissionCostController;
    TempData.eventKeyGuest = keyGuestController;
    TempData.eventKeyGuest = keyGuestController;
    TempData.eventPhotos = globalController.eventPhotosmgPath;
    TempData.eventThumbnail = globalController.eventThumbnailImgPath.value;
    TempData.eventTags = _stringTagController.getTags!;
    TempData.couponCode = couponCodeController;
    TempData.couponCodeDescription = couponDescriptionController;
  }

  clearAllTempData() {
    TempData.eventCapcity = '';
    TempData.ageGroup = '';
    TempData.category = '';
    TempData.selectVenu = '';
    TempData.eventEntryType = '';
    TempData.eventEntryCost = '';
    TempData.eventKeyGuest = '';
    globalController.eventPhotosmgPath.clear();
    globalController.eventThumbnailImgPath.value = '';
    TempData.eventTags = [];
    TempData.couponCode = '';
    TempData.couponCodeDescription = '';
  }

// Pick single image for thumbnail
  void selectThumbnailImg(ImageSource imgSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImg = await picker.pickImage(source: imgSource);
    if (pickedImg != null) {
      final CroppedFile? croppedImg = await ImageCropper().cropImage(
        sourcePath: pickedImg.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        maxHeight: 512,
        maxWidth: 512,
        compressQuality: 85,
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
        globalController.eventThumbnailImgPath.value = croppedImg.path;
        isThumbNail.value = false;
      }
      // if(croppedImg != null){
      //   isThumbNail.value= false;
      // }
    }
  }

  // Function to select and crop multiple images
  void selectMultiplePhotoImg(List<String> imgPaths) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedImgs = await picker.pickMultiImage();

    if (pickedImgs != null) {
      for (var pickedImg in pickedImgs) {
        final CroppedFile? croppedImg = await ImageCropper().cropImage(
          sourcePath: pickedImg.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          compressFormat: ImageCompressFormat.jpg,
          maxHeight: 512,
          maxWidth: 512,
          compressQuality: 100,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: "Crop Image",
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              backgroundColor: Colors.black,
              activeControlsWidgetColor: Colors.blue,
              cropFrameColor: Colors.black,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              title: 'Crop Image',
            ),
          ],
        );

        if (croppedImg != null) {
          imgPaths.add(croppedImg.path);
          isPhoto.value = false;
        }
      }
    }
  }
}
