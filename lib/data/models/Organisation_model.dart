class OrganisationModel {
  Data? data;

  OrganisationModel({this.data});

  OrganisationModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? aboutUs;
  String? termsCondition;
  String? termsConditionUser;
  String? termsConditionMerchant;
  String? privacyPolicy;
  String? privacyPolicyUser;
  String? privacyPolicyMerchant;
  String? subscriptionAgreement;
  String? licenseAgreementUser;
  String? licenseAgreementMerchant;
  String? contactUsEmail;
  String? instagramHandle;
  String? facebookHandle;
  String? linkedinHandle;
  String? websiteUrl;
  String? address;
  String? contactUsPhone;

  Data(
      {this.aboutUs,
      this.termsCondition,
      this.termsConditionUser,
      this.termsConditionMerchant,
      this.privacyPolicy,
      this.privacyPolicyUser,
      this.privacyPolicyMerchant,
      this.subscriptionAgreement,
      this.licenseAgreementUser,
      this.licenseAgreementMerchant,
      this.contactUsEmail,
      this.instagramHandle,
      this.facebookHandle,
      this.linkedinHandle,
      this.websiteUrl,
      this.address,
      this.contactUsPhone});

  Data.fromJson(Map<String, dynamic> json) {
    aboutUs = json['about_us'];
    termsCondition = json['terms_condition'];
    termsConditionUser = json['terms_condition_user'];
    termsConditionMerchant = json['terms_condition_merchant'];
    privacyPolicy = json['privacy_policy'];
    privacyPolicyUser = json['privacy_policy_user'];
    privacyPolicyMerchant = json['privacy_policy_merchant'];
    subscriptionAgreement = json['subscription_agreement'];
    licenseAgreementUser = json['license_agreement_user'];
    licenseAgreementMerchant = json['license_agreement_merchant'];
    contactUsEmail = json['contact_us_email'];
    instagramHandle = json['instagram_handle'];
    facebookHandle = json['facebook_handle'];
    linkedinHandle = json['linkedin_handle'];
    websiteUrl = json['website_url'];
    address = json['address'];
    contactUsPhone = json['contact_us_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about_us'] = this.aboutUs;
    data['terms_condition'] = this.termsCondition;
    data['terms_condition_user'] = this.termsConditionUser;
    data['terms_condition_merchant'] = this.termsConditionMerchant;
    data['privacy_policy'] = this.privacyPolicy;
    data['privacy_policy_user'] = this.privacyPolicyUser;
    data['privacy_policy_merchant'] = this.privacyPolicyMerchant;
    data['subscription_agreement'] = this.subscriptionAgreement;
    data['license_agreement_user'] = this.licenseAgreementUser;
    data['license_agreement_merchant'] = this.licenseAgreementMerchant;
    data['contact_us_email'] = this.contactUsEmail;
    data['instagram_handle'] = this.instagramHandle;
    data['facebook_handle'] = this.facebookHandle;
    data['linkedin_handle'] = this.linkedinHandle;
    data['website_url'] = this.websiteUrl;
    data['address'] = this.address;
    data['contact_us_phone'] = this.contactUsPhone;
    return data;
  }
}
