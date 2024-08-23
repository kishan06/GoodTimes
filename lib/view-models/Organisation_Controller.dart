import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/Organisation_model.dart';
import '../data/repository/response_data.dart';
import '../data/repository/services/orgnisation.dart';

class OrganisationController extends GetxController{
  Rx<OrganisationModel> Organisationdatacontroller=OrganisationModel().obs;

  Future<void> getOrganisationData(BuildContext context) async{
    ResponseModel response=await OrgnisataionsServices().orgnisataionsServices(context,passmodel: false);
    if(response.responseStatus==ResponseStatus.success){
      Organisationdatacontroller.value=OrganisationModel.fromJson(response.data);
    }
  }
}