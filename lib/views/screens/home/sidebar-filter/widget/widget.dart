import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:good_times/data/models/event_age_group_model.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/constant.dart';
import '../../../../../utils/helper.dart';
import '../../../../../view-models/advance_filter_controller.dart';
import 'reuseable_checkbox.dart';

AdvanceFilterController advanceFilterController =
    Get.put(AdvanceFilterController());
Widget serachByLocation(context) {
  return GestureDetector(
    onTap: () {
      unfoucsKeyboard(context);
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'By Location',
          style: labelStyle.copyWith(fontSize: 16, color: kTextWhite),
        ),
        const SizedBox(height: 12),
        CupertinoSearchTextField(
          controller: advanceFilterController.locationController.value,
          placeholder: 'Search by location',
          style: paragraphStyle,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color(0xffA1A1A1),
            ),
          ),
          prefixIcon: const Icon(
            CupertinoIcons.search,
            color: kTextWhite,
          ),
          suffixIcon: const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: kTextWhite,
          ),
          onSuffixTap: () {
            advanceFilterController.locationController.value.clear();
            unfoucsKeyboard(context);
          },
          onChanged: (e) {
            advanceFilterController.filterLocation(e);
          },
        ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

Widget byCategory(context, categoryData) {
  List<String> categoryDetails = [];

  for (var element in categoryData) {
    categoryDetails.add(element.title);
  }

  List<bool> checkBoxValues = categoryDetails
      .map((category) =>
          advanceFilterController.evetCategoryList.contains(category))
      .toList();
  final ExpansionTileController controller = ExpansionTileController();
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                iconColor: kTextWhite,
                collapsedIconColor: kTextWhite,
                controller: controller,
                title: Text(
                  'By Category',
                  style: paragraphStyle.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                children: [
                  CheckboxList(
                    options: categoryDetails,
                    checkBoxValues: checkBoxValues,
                    onChangedCallback: (value, index) {
                      setState(() {
                        checkBoxValues[index] = value!;
                      });

                      if (advanceFilterController.evetCategoryList
                          .contains(categoryDetails[index])) {
                        advanceFilterController.evetCategoryList
                            .remove(categoryDetails[index]);
                      } else {
                        advanceFilterController.evetCategoryList
                            .add(categoryDetails[index]);
                      }
                    },
                  ),
                ]),
          ),
        ],
      );
    },
  );
}

int? _selectedValue;

Widget sortBy(context) {
  List<Map<String, String>> sortFilter = [
    {"label": "Latest", "value": "latest"},
    {"label": "Nearest", "value": "nearest"},
    {"label": "Popular", "value": "popularity"},
    {"label": "Price", "value": "price"},
  ];
  //  event sort todo
  /* List<bool> checkBoxValues = sortFilter
      .map((sort) => advanceFilterController.eventSort.contains(sort["value"]))
      .toList(); */

  List<String> valueList =
      sortFilter.map((item) => item["label"] as String).toList();
  _selectedValue = advanceFilterController.eventSortbyfilter.value.isEmpty
      ? null
      : _selectedValue;
  final ExpansionTileController controller = ExpansionTileController();
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: kTextWhite,
              collapsedIconColor: kTextWhite,
              controller: controller,
              title: Text(
                'Sort BY',
                style: paragraphStyle.copyWith(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              children: [
                for (int i = 0; i < sortFilter.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Row(children: [
                        CustomRadio(
                          value: i,
                          groupValue: _selectedValue ?? -1,
                          activeColor: kPrimaryColor,
                          inactiveColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value!;
                              advanceFilterController
                                      .eventSortbyfilter.value =
                                  sortFilter[i]["value"].toString();
                            });
                          },
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width *
                                  0.055,
                        ),
                         GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedValue = i;
                              advanceFilterController
                                      .eventSortbyfilter.value =
                                  sortFilter[i]["value"].toString();
                              print("rrr//");
                            });
                          },
                          child: Text('${sortFilter[i]['label']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xffE6E6E6),
                              )),
                        )
                      ]),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: GestureDetector(
                        onTap: () {
                          advanceFilterController.eventSortbyfilter.value = "";
                          _selectedValue = null;

                          setState(() {});
                        },
                        child: Text(
                          "Clear",
                          style: paragraphStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    },
  );
}

class CustomRadio extends StatelessWidget {
  final int value;
  final int groupValue;
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<int?> onChanged;

  const CustomRadio({
    required this.value,
    required this.groupValue,
    required this.activeColor,
    required this.inactiveColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? activeColor : inactiveColor,
            border: Border.all(color: kPrimaryColor, width: 1.5)),
      ),
    );
  }
}

Widget byDate(context) {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: advanceFilterController.selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2550),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: primarySwatch,
            accentColor: kTextBlack,
            backgroundColor: Colors.lightBlue,
            cardColor: kTextBlack,
            brightness: Brightness.dark,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      advanceFilterController.selectDateTime(picked);
    }
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By Date',
              style: paragraphStyle.copyWith(
                  fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                await _selectDate(context);
              },
              child: Obx(
                () => Container(
                  width: MediaQuery.of(context).size.width - 230,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: kTextWhite.withOpacity(0.6), width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(
                    advanceFilterController.selectedDate.value == null
                        ? 'MM / DD / YY'
                        : DateFormat('MMM / d / yyyy').format(
                            advanceFilterController.selectedDate.value!),
                    style: paragraphStyle.copyWith(color: kTextWhite),
                  ),
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            advanceFilterController.selectedDate.value = null;
          },
          child: Text(
            "Clear",
            style: paragraphStyle.copyWith(
                fontSize: 14, fontWeight: FontWeight.w500),
          ),
        )
      ],
    ),
  );
}

Widget byPriceRange() {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'By Event price',
          style: paragraphStyle.copyWith(
              fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 90,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "From",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffE1E1E1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: const TextStyle(
                          color: kTextWhite,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp(r'^\+?[0-9]+$'),
                              allow: true)
                        ],
                        controller:
                            advanceFilterController.startPriceController.value,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "0",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: const Color(0xffC5C5C5).withOpacity(0.35),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kTextWhite.withOpacity(0.6))),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kTextWhite.withOpacity(0.6))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kTextWhite.withOpacity(0.6))),
                          errorStyle: const TextStyle(fontSize: 14.0),
                        ),
                        onChanged: (e) {
                          advanceFilterController.startPriceFunc(e);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "To",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffE1E1E1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: const TextStyle(
                          color: kTextWhite,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp(r'^\+?[0-9]+$'),
                              allow: true)
                        ],
                        controller:
                            advanceFilterController.endPriceController.value,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "0",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: const Color(0xffC5C5C5).withOpacity(0.35),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: kTextWhite.withOpacity(0.6),
                          )),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: kTextWhite.withOpacity(0.6),
                          )),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: kTextWhite.withOpacity(0.6),
                          )),
                          errorStyle: const TextStyle(fontSize: 14.0),
                        ),
                        onChanged: (e) {
                          advanceFilterController.endPriceFunc(e);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget ageGroup(context, List<ageData>? ageGroups) {
  logger.d("age list is :- ${ageGroups?.first.toString()}");
  // List<Map<String, dynamic>> ageGroup = [
  //   {"age": "18-21"},
  //   {"age": "21-30"},
  //   {"age": "30-40"},
  //   {"age": "40-50"},
  //   {"age": "50+"},
  // ];
  List<bool> checkBoxValues = ageGroups!
      .map((age) => advanceFilterController.ageSort.contains(age.name))
      .toList();
  final ExpansionTileController controller = ExpansionTileController();

  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: kTextWhite,
              collapsedIconColor: kTextWhite,
              controller: controller,
              title: Text(
                'Age group',
                style: paragraphStyle.copyWith(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              children: [
                CheckboxList(
                  options: ageGroups.map((age) => age.name!).toList(),
                  checkBoxValues: checkBoxValues,
                  onChangedCallback: (value, index) {
                    setState(() {
                      checkBoxValues[index] = value!;
                    });
                    if (advanceFilterController.ageSort
                        .contains(ageGroups[index].name)) {
                      advanceFilterController.ageSort
                          .remove(ageGroups[index].name);
                    } else {
                      advanceFilterController.ageSort
                          .add(ageGroups[index].name.toString());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
