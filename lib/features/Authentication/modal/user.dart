class User {
  final int? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? dob;
  final String? gender;
  final String? collegeCompanyName;
  final String? emergencyContactName;
  final String? emergencyContactNumber;
  final String? city;
  final bool? phoneVerified;

  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.dob,
    this.gender,
    this.collegeCompanyName,
    this.emergencyContactName,
    this.emergencyContactNumber,
    this.city,
    this.phoneVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      dob: json['dob'],
      gender: json['gender'],
      collegeCompanyName: json['collegeCompanyName'],
      emergencyContactName: json['emergencyContactName'],
      emergencyContactNumber: json['emergencyContactNumber'],
      city: json['city'],
      phoneVerified: json['phoneVerified'],
    );
  }
}