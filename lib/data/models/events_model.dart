class EventsModel {
  final int id;
  final String? title;
  final String? description;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final String? category;
  final int? categoryId;
  final Venu venu;
  final int? venuCapacity;
  final String? thumbnail;
  final String? entryType;
  final String? couponCode;
  final String? couponCodeDescription;
  final String? entryFee;
  final String? keyGuest;
  final String? ageGroup;
  final bool? isLiked;
  List<EventReview> eventReview;
  List<Tags>? tags;
  final String? interactions;
  List<String>? images;

  EventsModel({
    required this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.category,
    this.categoryId,
    required this.venu,
    this.venuCapacity,
    this.thumbnail,
    this.entryType,
    this.entryFee,
    this.keyGuest,
    this.ageGroup,
    this.isLiked,
    required this.eventReview,
    this.tags,
    required this.interactions,
    this.images,
    this.couponCode,
    this.couponCodeDescription,
  });

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? rawImages = json["images"];
    return EventsModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        startTime: json["from_time"],
        endTime: json["to_time"],
        category: json["category"]['title'],
        categoryId: json["category"]['id'],
        venu: Venu.fromJson(json['venue']),
        venuCapacity: json["venue_capacity"],
        thumbnail: json["image"],
        entryType: json["entry_type"],
        entryFee: json["entry_fee"],
        keyGuest: json["key_guest"] ?? '',
        ageGroup: json["age_group"],
        couponCode: json["coupon_code"]??'',
        couponCodeDescription: json["coupon_description"]??'',
        isLiked: json["is_favorited"],
        images: rawImages?.map((e) => e["image"].toString()).toList(),
        eventReview: (json['reviews'] as List)
            .map((review) => EventReview.fromJson(review))
            .toList(),
        tags: (json['tags'] as List)
            .map((review) => Tags.fromJson(review))
            .toList(),
        interactions: (json["principal_interaction"] != null)
            ? json["principal_interaction"]["status"] ?? ''
            : '');
  }
}

class Venu {
  final int id;
  final String title;
  final String? address;
  final String image;
  final String? latitude;
  final String? longitude;
  final OrganizedBy createdBy;

  Venu(
      {required this.id,
      required this.title,
      this.address,
      required this.image,
      required this.createdBy,
      this.latitude,
      this.longitude,
      });

  factory Venu.fromJson(Map<String, dynamic> json) {
    return Venu(
        id: json["id"],
        title: json["title"],
        address: json["address"],
        image: json["image"],
        createdBy: OrganizedBy.fromJson(json["created_by"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
        );
  }
}

class OrganizedBy {
  final String profilePhoto;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? linkedin;
  final String? youtube;
  final String? facebook;
  final String? instagram;
  final String? website;

  OrganizedBy({
    required this.profilePhoto,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.website,
    this.youtube
  });

  factory OrganizedBy.fromJson(Map<String, dynamic> json) {
    return OrganizedBy(
      profilePhoto: json["profile_photo"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      email: json["email"],
      phone: json["phone_no"],
      facebook: json["facebook_profile"],
      instagram: json["instagram_profile"],
      linkedin: json["linkedin_profile"],
      youtube: json["youtube_profile"],
      website: json["website"],
    );
  }
}

class EventReview {
  final String reviewText;
  final int reviewStar;
  final ReviewUserData reviewUserData;

  EventReview(
      {required this.reviewText,
      required this.reviewStar,
      required this.reviewUserData});
  factory EventReview.fromJson(Map<String, dynamic> json) {
    return EventReview(
      reviewText: json["review_text"],
      reviewStar: json["rating"],
      reviewUserData: ReviewUserData.fromJson(json['principal']),
    );
  }
}

class Tags {
  final String name;
  // final int id;

  Tags({required this.name});

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(name: json["name"]);
  }
  }

class ReviewUserData {
  final String firstName;
  final String lastName;
  final String profilePhoto;

  ReviewUserData(
      {required this.firstName,
      required this.lastName,
      required this.profilePhoto});

  factory ReviewUserData.fromJson(Map<String, dynamic> json) {
    return ReviewUserData(
        firstName: json["first_name"],
        lastName: json["last_name"],
        profilePhoto: json["profile_photo"]);
  }
}

// TagsModel{}