class PreferencesModel {
  List<int> preferenceList;
  PreferencesModel({
    required this.preferenceList,
  });

  factory PreferencesModel.fromJson(Map<String,dynamic>json){
    return PreferencesModel(preferenceList: List<int>.from(json['preferred_categories']));
  }
  
}