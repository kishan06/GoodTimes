class ProfileModel {
  final String profilePhoto;
  final String firstName;
  final String lastName;
  final String email;
  final String principalTypeName;
  final bool accoutIsActive;
  final String? linkedin;
  final String? youtube;
  final String? facebook;
  final String? instagram;
  final String? website;
  final String? phone;
  final String? businessname;
  final String? twitter;

  ProfileModel({
    required this.profilePhoto,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.principalTypeName,
    required this.accoutIsActive,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.website,
    this.youtube,
    this.phone,
    this.businessname,
    this.twitter
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profilePhoto: json['profile_photo'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      principalTypeName: json['principal_type_name'],
      accoutIsActive: json["is_active"],
      facebook: json["facebook_profile"],
      instagram: json["instagram_profile"],
      linkedin: json["linkedin_profile"],
      youtube: json["youtube_profile"],
      website: json["website"],
      phone: json["phone_no"],
      businessname: json["business_name"],
      twitter: json["twitter_profile"]
    );
  }
}
