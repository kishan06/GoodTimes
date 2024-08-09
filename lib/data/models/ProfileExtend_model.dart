class ProfileExtenddataModel {

  Data? data;

  ProfileExtenddataModel({ this.data});

  ProfileExtenddataModel.fromJson(Map<String, dynamic> json) {
   
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
  String? principalTypeName;
  int? inviteCount;
  bool? registerComplete;
  HasActiveSubscription? hasActiveSubscription;
  bool? preference;
  bool? isActive;
  int? goingEventsCount;
  int? interestedEventsCount;
  FeatureLimit? featureLimit;

  Data(
      {this.principalTypeName,
      this.inviteCount,
      this.registerComplete,
      this.hasActiveSubscription,
      this.preference,
      this.isActive,
      this.goingEventsCount,
      this.interestedEventsCount,
      this.featureLimit});

  Data.fromJson(Map<String, dynamic> json) {
    principalTypeName = json['principal_type_name'];
    inviteCount = json['invite_count'];
    registerComplete = json['register_complete'];
    hasActiveSubscription = json['has_active_subscription'] != null
        ? new HasActiveSubscription.fromJson(json['has_active_subscription'])
        : null;
    preference = json['preference'];
    isActive = json['is_active'];
    goingEventsCount = json['going_events_count'];
    interestedEventsCount = json['interested_events_count'];
    featureLimit = json['feature_limit'] != null
        ? new FeatureLimit.fromJson(json['feature_limit'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['principal_type_name'] = this.principalTypeName;
    data['invite_count'] = this.inviteCount;
    data['register_complete'] = this.registerComplete;
    if (this.hasActiveSubscription != null) {
      data['has_active_subscription'] = this.hasActiveSubscription!.toJson();
    }
    data['preference'] = this.preference;
    data['is_active'] = this.isActive;
    data['going_events_count'] = this.goingEventsCount;
    data['interested_events_count'] = this.interestedEventsCount;
    if (this.featureLimit != null) {
      data['feature_limit'] = this.featureLimit!.toJson();
    }
    return data;
  }
}

class HasActiveSubscription {
  bool? hasActiveSubscription;
  bool? inGracePeriod;
  String? gracePeriodEndDate;

  HasActiveSubscription(
      {this.hasActiveSubscription,
      this.inGracePeriod,
      this.gracePeriodEndDate});

  HasActiveSubscription.fromJson(Map<String, dynamic> json) {
    hasActiveSubscription = json['has_active_subscription'];
    inGracePeriod = json['in_grace_period'];
    gracePeriodEndDate = json['grace_period_end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['has_active_subscription'] = this.hasActiveSubscription;
    data['in_grace_period'] = this.inGracePeriod;
    data['grace_period_end_date'] = this.gracePeriodEndDate;
    return data;
  }
}

class FeatureLimit {
  int? id;
  int? categoryLimit;

  FeatureLimit({this.id, this.categoryLimit});

  FeatureLimit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryLimit = json['category_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_limit'] = this.categoryLimit;
    return data;
  }
}
