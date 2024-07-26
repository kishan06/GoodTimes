class CMSModel {
  final String? aboutUs;
  final String? termAndConditions;
  final String? privacyAndPolicy;

  CMSModel({
     this.aboutUs,
     this.termAndConditions,
     this.privacyAndPolicy,
  });

  factory CMSModel.fromJson(Map<String, dynamic> json) {
    return CMSModel(
      aboutUs: json['about_us']??'',
      termAndConditions: json['terms_condition']??'',
      privacyAndPolicy: json['privacy_policy']??'',
    );
  }
}
