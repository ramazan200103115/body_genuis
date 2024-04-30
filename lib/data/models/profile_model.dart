// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileModel {
  int id;
  String urlAvatar;
  String name;
  int age;
  int medcoins;
  String email;
  String aboutMe;

  ProfileModel({
    required this.id,
    required this.urlAvatar,
    required this.name,
    required this.age,
    required this.medcoins,
    required this.email,
    required this.aboutMe,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? -1,
      urlAvatar: json['urlAvatar'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? -1,
      medcoins: json['medcoins'] ?? '',
      email: json['email'] ?? '',
      aboutMe: json['aboutMe'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ProfileModel(id: $id, urlAvatar: $urlAvatar, name: $name, age: $age, medcoins: $medcoins, email: $email, aboutMe: $aboutMe)';
  }
}
