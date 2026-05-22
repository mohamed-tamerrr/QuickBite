class UserModel {
  String name;
  String email;
  String? image;
  String? address;
  String? visa;
  String? token;
  UserModel({
    required this.name,
    required this.email,
    this.image,
    this.address,
    this.visa,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
      token: json['token'] ?? '',
      visa: json['Visa'] ?? '',
    );
  }
}
