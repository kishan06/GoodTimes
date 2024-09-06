// ignore_for_file: library_prefixes, use_build_context_synchronously
import 'dart:developer';
import 'dart:io' as IO;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:good_times/data/models/event_age_group_model.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/utils/temp.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/common/textformfield.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../../../../data/models/event_categories_model.dart';
import '../../../../data/models/events_model.dart';
import '../../../../data/models/profile.dart';
import '../../../../data/models/venu_model.dart';
// import '../../../../data/resources/services/preferences_service.dart';
import '../../../../data/repository/services/preferences_service.dart';
import '../../../../data/repository/services/profile.dart';
import '../../../../data/repository/services/venue_services.dart';
import '../../../../utils/helper.dart';
import '../../../../view-models/global_controller.dart';
import '../../../widgets/common/dropdown.dart';
import '../../../widgets/common/parent_widget.dart';
import '../../profile/edit_profile.dart';
import 'edit_event_preivew.dart';

List<List<dynamic>> tempImgs = [];

class EditEvent extends StatefulWidget {
  final EventsModel eventData;
  final List<VenuModel> venuList;
  final List<EventCategoriesModdel> categoryList;
  final List<ageData> ageGroupList;
  static const String routeName = "editEvent";
  const EditEvent(
      {super.key,
      required this.eventData,
      required this.venuList,
      required this.categoryList,
      required this.ageGroupList});

  @override
  State<EditEvent> createState() => _EditCreateEventState();
}

enum ImgTypes { network, file }

class _EditCreateEventState extends State<EditEvent> {
  final _key = GlobalKey<FormState>();
  String selectedVenue = "";
  String selectedAge = "";
  String selectedCategory = "";
  String selectedFeeType = "";
  // String tagsError = "";
  TextEditingController venuCapacityController = TextEditingController();
  TextEditingController admissionCostController = TextEditingController();
  TextEditingController keyGuestController = TextEditingController();
  String thumbnailImg = '';
  List<String> image = [];
  bool isThumbNail = false;
  bool isPhoto = false;
  bool waiting = false;
  bool loadings = false;
  List<VenuModel> venuList = [];
  List<EventCategoriesModdel> categoryList = [];
  bool tagsError = false;
  bool _callbackExecuted = false;

  final StringTagController _stringTagController = StringTagController();
  late double _distanceToField;
  final List<String> _initialTags = <String>[];

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  GlobalController globalController = Get.put(GlobalController());

  bool isLoading = true;
  ProfileModel? profileData;
  var isPaid = ''.obs;

  @override
  void initState() {
    tempImgs.clear();
    if (widget.eventData.thumbnail != null) {
      globalController.thumbImgType.value = ImgTypes.network.index;
      globalController.thumbImgPath.value = widget.eventData.thumbnail!;
    }
    multipleImageData();
    addEventData();
    futureFun();
    profileApi();
    super.initState();
  }

  multipleImageData() {
    log("category title tempImgs in multiple image");
    logger.f("");
    if (widget.eventData.images != null) {
      for (String imgUrl in widget.eventData.images!) {
        tempImgs.add([imgUrl, ImgTypes.network]);
      }
    }
  }

  @override
  void didChangeDependencies() {
    log("category title tempImgs in multiple image");
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  Future profileApi() async {
    log("category title tempImgs in multiple image");
    var value = await ProfileService().getProfileDetails(context);
    setState(() {
      log("set 1");
      loadings = false;
      profileData = value.data;
    });
  }

  Future futureFun() async {
    log("category title tempImgs in multiple image");
    final venueData = await VenueServices().getVenue(context);
    final prefData =
        await PreferencesService().getEventCategoriesService(context);
    setState(() {
      log("set 2");
      venuList = venueData;
      categoryList = prefData;
      isLoading = false;
    });

    VenuModel selectedVenueObject = venuList
        .firstWhere((venue) => venue.title == widget.eventData.venu.title);
    log("venuList $selectedVenueObject");
    TempData.editEvetAddress = selectedVenueObject.address.toString();
    TempData.editselectVenuId = selectedVenueObject.id.toString();

    // edit category get id
    EventCategoriesModdel eventCatModel = categoryList
        .firstWhere((category) => category.title == widget.eventData.category);
    TempData.editcategoryID = eventCatModel.id.toString();
  }

  addEventData() {
    log("category title tempImgs in multiple image");
    selectedVenue = widget.eventData.venu.title;
    selectedAge = widget.eventData.ageGroup!;
    selectedCategory = widget.eventData.category!;
    selectedFeeType = widget.eventData.entryType!;
    venuCapacityController.text = widget.eventData.venuCapacity.toString();
    admissionCostController.text = widget.eventData.entryFee!;
    keyGuestController.text = widget.eventData.keyGuest!;
    for (var tagsItem in widget.eventData.tags!) {
      _initialTags.add(tagsItem.name);
    }
    isPaid.value = widget.eventData.entryType!;
  }

  @override
  Widget build(BuildContext context) {
    log("category title tempImgs $selectedAge");
    log("tagsItem temp images list $tempImgs");

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
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
                                items:
                                    venuList.map((e) => "${e.title}").toList(),
                                errorValue: 'venue',
                                onChanged: (String newValue) {
                                  // selectedVenue = newValue;
                                  VenuModel selectedVenueObject =
                                      venuList.firstWhere(
                                          (venue) => venue.title == newValue);
                                  selectedVenue =
                                      selectedVenueObject.id.toString();
                                  TempData.editEvetAddress =
                                      selectedVenueObject.address.toString();
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
                                      color: const Color(0xffA8A8A8)),
                                ),
                                selectedValue: selectedAge,
                                errorValue: 'age',
                                items: widget.ageGroupList
                                    .map((e) => e.name!)
                                    .toList(),
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
                                    return 'Enter a venue capacity.';
                                  }
                                  if (int.parse(venuCapacityController.text) <=
                                      14) {
                                    return 'Enter a venue capacity more than the 15.';
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
                                        ? Image.network(
                                            widget.eventData.thumbnail
                                                .toString(),
                                            width: 115,
                                            height: 115,
                                          )
                                        : Image.file(
                                            IO.File(globalController
                                                .eventThumbnailImgPath.value),
                                            width: 115,
                                            height: 115,
                                            fit: BoxFit.cover,
                                          ),
                                  ],
                                ),
                              ),
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
                              SingleChildScrollView(
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
                                        tempImgs.length,
                                        (index) => Row(
                                          children: [
                                            Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                Builder(builder: (context) {
                                                  // logger.f("tempImgs in builder0 ${tempImgs[index][0]}");
                                                  // logger.f("tempImgs in builder1 ${tempImgs[index][1]}");
                                                  // logger.f("tempImgs in builder all $tempImgs");
                                                  return (tempImgs[index][1] ==
                                                          ImgTypes.file)
                                                      ? Image.file(
                                                          IO.File(
                                                              tempImgs[index]
                                                                  [0]),
                                                          width: 115,
                                                          height: 115,
                                                          fit: BoxFit.cover,
                                                        )
                                                      // const SizedBox()
                                                      : Image.network(
                                                          // widget.eventData.images![index],
                                                          tempImgs[index][0],
                                                          width: 115,
                                                          height: 115,
                                                        );
                                                }),
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: kTextBlack,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        tempImgs.remove(
                                                            tempImgs[index]);
                                                      });
                                                    },
                                                    child: const Icon(
                                                        Icons.close,
                                                        size: 20,
                                                        color: kPrimaryColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 10)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ),
                              tempImgs.isEmpty
                                  ? Text('Please select the Photos',
                                      style: paragraphStyle.copyWith(
                                          color: kTextError.withOpacity(0.75),
                                          fontSize: 14,
                                          fontFamily: '',
                                          letterSpacing: 0.6))
                                  : const SizedBox(),
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
                                      color: const Color(0xffA8A8A8)),
                                ),
                                selectedValue: selectedFeeType,
                                items: const [
                                  "free",
                                  "paid",
                                ],
                                errorValue: 'entry type',
                                onChanged: (String newValue) {
                                  selectedFeeType = newValue;
                                  isPaid.value = newValue;
                                },
                              ),
                              Obx(() => (isPaid.value == 'free')
                                  ? const SizedBox()
                                  : const SizedBox(height: 40)),
                              Obx(
                                () => (isPaid.value == 'free')
                                    ? const SizedBox()
                                    : Text(
                                        'Admission Cost',
                                        style: labelStyle.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20),
                                      ),
                              ),
                              Obx(() => (isPaid.value == 'free')
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
                                  if (_stringTagController.getTags!.isEmpty) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (_callbackExecuted) {
                                        setState(() {
                                          tagsError = true;
                                        });
                                        _callbackExecuted = true;
                                      }
                                    });
                                  } else {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (_callbackExecuted) {
                                        setState(() {
                                          tagsError = false;
                                        });
                                        _callbackExecuted = true;
                                      }
                                    });
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
                              const SizedBox(height: 8),
                              tagsError
                                  ? Text(
                                      "Please enter tags",
                                      style: TextStyle(
                                        color: kTextError.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 50),
                              // MyElevatedButton(
                              //   onPressed: ()=> submitFunc(context),
                              //   text: 'Create Event',
                              // )
                              MyElevatedButton(
                                onPressed: () {
                                  // log("cecguvwcgv ${globalController.profileSocialDetails.value}");
                                  unfoucsKeyboard(context);
                                  autovalidateMode = AutovalidateMode.always;
                                  _key.currentState!.validate();
                                  if (_stringTagController.getTags!.isEmpty) {
                                    setState(() {
                                      tagsError = true;
                                    });
                                  }
                                  if (_key.currentState!.validate() &&
                                      tempImgs.isNotEmpty) {
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
                                    setState(() {
                                      isThumbNail = true;
                                    });
                                  } else {
                                    setState(() {
                                      isThumbNail = false;
                                    });
                                  }
                                  if (globalController
                                      .eventPhotosmgPath.isEmpty) {
                                    setState(() {
                                      isPhoto = true;
                                    });
                                  } else {
                                    setState(() {
                                      isPhoto = false;
                                    });
                                  }
                                },
                                text: 'Continue',
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
    );
  }

  submitFunc(context) {
    // autovalidateMode = AutovalidateMode.always;
    // _key.currentState!.validate();
    // if(_stringTagController.getTags!.isEmpty){
    //   return setState(() {
    //     tagsError = 'Please enter tags';
    //   });
    // }
    Get.to(
      () => EditedEventPreview(eventData: widget.eventData),
    );
    log('validation success');
    addDataToEvent(
      selectedVenue: selectedVenue,
      selectedAge: selectedAge,
      selectedFeeType: selectedFeeType,
      selectedCategory: selectedCategory,
      admissionCostController: admissionCostController.text,
      keyGuestController: keyGuestController.text,
      venuCapacityController: venuCapacityController.text,
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

  addDataToEvent(
      {selectedVenue,
      selectedAge,
      selectedCategory,
      selectedFeeType,
      venuCapacityController,
      admissionCostController,
      keyGuestController}) {
    TempData.editselectVenu = selectedVenue;
    TempData.editageGroup = selectedAge;
    TempData.editcategory = selectedCategory;
    TempData.editeventCapcity = venuCapacityController;
    TempData.editeventEntryType = selectedFeeType;
    TempData.editeventEntryCost = admissionCostController;
    TempData.editeventKeyGuest = keyGuestController;
    TempData.editEventPhotos = globalController.eventPhotosmgPath;
    TempData.editeventThumbnail = globalController.eventThumbnailImgPath.value;
    TempData.editEventTags = _stringTagController.getTags!;
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
    TempData.editEventTags = [];
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
        globalController.eventThumbnailImgPath.value = croppedImg.path;
        globalController.thumbImgType.value = ImgTypes.file.index;
        globalController.thumbImgPath.value = croppedImg.path;
      }
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
          setState(() {
            log("set 11");
            tempImgs.add([croppedImg.path, ImgTypes.file]);
          });
        }
      }
    }
  }
}
