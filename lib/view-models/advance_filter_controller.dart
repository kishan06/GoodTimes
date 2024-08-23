import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:good_times/data/repository/endpoints.dart';

import '../data/models/home_event_modal.dart';

class AdvanceFilterController extends GetxController{
  final RxList _artsEvetCategory = [].obs;
   final RxString eventSortbyfilter = "".obs;

  final RxList<String> _ageSort = <String>[].obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<TextEditingController> startPriceController = TextEditingController().obs;
  Rx<TextEditingController> endPriceController = TextEditingController().obs;
  Rx<TextEditingController> locationController = TextEditingController().obs;
  Rx<TextEditingController> titleController = TextEditingController().obs;
  RxList<HomeEventsModel> eventModalcontroller= RxList<HomeEventsModel>();


  List get evetCategoryList => _artsEvetCategory;

  String get eventSort => eventSortbyfilter.value;

  List<String> get ageSort => _ageSort;
  String get formattedDateTime => selectedDate.value.toString().split(' ')[0];
  String get startPrice => startPriceController.value.text;
  String get endPrice => endPriceController.value.text;
  String get filterByLocation => locationController.value.text;
  String get homeFilterByTitle => titleController.value.text;


  void updateEvetCategory(List<String> updatedList){
    _artsEvetCategory.assignAll(updatedList);
  }
 
  void ageGroup(List<String> updatedList) {
    _ageSort.assignAll(updatedList);
  }
  void selectDateTime(DateTime date) {
    selectedDate.value = date;
  }
  void startPriceFunc(String price) {
    startPriceController.value.text = price;
  }
  void endPriceFunc(String price) {
    endPriceController.value.text = price;
  }
  void filterLocation(String locationTitle) {
    locationController.value.text = locationTitle;
  }
  void homeFilterLocation(String locationTitle) {
    titleController.value.text = locationTitle;
  }

  clearAllFilter(){
    _artsEvetCategory.clear();
    eventSortbyfilter.value="";
    _ageSort.clear();
    selectedDate.value = null;
    startPriceController.value.clear();
    endPriceController.value.clear();
    locationController.value.clear();
    titleController.value.clear();
  }

  bool checkFilterIsClearOrNot(){
    if(_artsEvetCategory.isEmpty && eventSortbyfilter.isEmpty && _ageSort.isEmpty && selectedDate.value == null && startPriceController.value.text=="" && endPriceController.value.text=="" && titleController.value.text==""){
      return true;
    }else{
      return false;
    }

  }
}