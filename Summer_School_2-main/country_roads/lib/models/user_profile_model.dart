class UserProfile {
  String id;
  String firstName;
  String lastName;
  String email;
  String addressNPA;
  String addressCity;
  String addressStreet;
  double addressLatitude;
  double addressLongitude;
  String profileImage;
  bool isAdmin;


  String get fullName => '$firstName $lastName';

  static final UserProfile _empty = UserProfile(
      id: "",
      firstName: "",
      lastName: "",
      email: "",
      addressNPA: "",
      addressCity: "",
      addressStreet: "",
      addressLatitude: 0,
      addressLongitude: 0,
      profileImage: "",
      isAdmin: false);
  static UserProfile get empty => _empty;

  UserProfile({
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.addressNPA,
      required this.addressCity,
      required this.addressStreet,
      required this.addressLatitude,
      required this.addressLongitude,
      required this.profileImage,
      required this.isAdmin
    });

  factory UserProfile.fromMap(Map<String, dynamic> data, String documentId) {
    return UserProfile(
      id: documentId,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      addressNPA: data['addressNPA'] ?? '',
      addressCity: data['addressCity'] ?? '',
      addressStreet: data['addressStreet'] ?? '',
      addressLatitude: data['addressLatitude'] ?? 0,
      addressLongitude: data['addressLongitude'] ?? 0,
      profileImage: data['profileImage'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'addressNPA': addressNPA,
      'addressCity': addressCity,
      'addressStreet': addressStreet,
      'addressLatitude': addressLatitude,
      'addressLongitude': addressLongitude,
      'profileImage': profileImage,
      'isAdmin': isAdmin,
    };
  }
}
