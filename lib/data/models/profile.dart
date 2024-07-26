class ProfileModel {
  final String profilePhoto;
  final String firstName;
  final String lastName;
  final String email;
  final int innviteCount;
  final int? goingEventCount;
  final int? intrestedEventCount;
  final String principalTypeName;
  final bool registerComplete;
  final bool hasActiveSubscription;
  final bool hasActiveGracePeriod;
  final bool accoutIsActive;
  final bool hasPreferences;
  final String? linkedin;
  final String? youtube;
  final String? facebook;
  final String? instagram;
  final String? website;
  final String? phone;


  ProfileModel({
    required this.profilePhoto,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.innviteCount,
    required this.principalTypeName,
    required this.registerComplete,
    required this.accoutIsActive,
    required this.hasPreferences,
    required this.hasActiveSubscription,
    required this.hasActiveGracePeriod,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.website,
    this.youtube,
    this.goingEventCount,
    this.intrestedEventCount,
    this.phone,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profilePhoto: json['profile_photo']??'',
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      innviteCount: json['invite_count'],
      principalTypeName: json['principal_type_name'],
      hasActiveSubscription: json["has_active_subscription"]["has_active_subscription"],
      hasActiveGracePeriod: json["has_active_subscription"]["in_grace_period"],
      accoutIsActive: json["is_active"],
      hasPreferences: json["has_preferences"],
      registerComplete: json["register_complete"],
      facebook: json["facebook_profile"],
      instagram: json["instagram_profile"],
      linkedin: json["linkedin_profile"],
      youtube: json["youtube_profile"],
      website: json["website"],
      goingEventCount: json["going_events_count"],
      intrestedEventCount: json["interested_events_count"],
      phone: json["phone_no"],
    );
  }
}
