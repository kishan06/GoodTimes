class AppVersionModel {
  final String? appType;
  final String? version;
  final bool? forceUpdate;
  final bool? recommendUpdate;

  AppVersionModel({
    this.appType,
    this.version,
    this.forceUpdate,
    this.recommendUpdate,
  });
  factory AppVersionModel.fromjson(Map<String, dynamic> json) {
    return AppVersionModel(
      appType: json["app_type"],
      version: json["version"],
      forceUpdate: json["force_upgrade"],
      recommendUpdate: json["recommend_upgrade"],
    );
  }
}
