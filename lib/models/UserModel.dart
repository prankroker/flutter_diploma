class ProfileModel {
  final String? uid;
  final String? email;
  final String? username;
  final DateTime? registrationDate;
  final double averageScore;

  ProfileModel({
    this.uid,
    this.email,
    this.username,
    this.registrationDate,
    this.averageScore = 0.0,
  });
}