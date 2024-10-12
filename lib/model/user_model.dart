class UserModel {
  String name;
  String email;
  String gender;
  int age;
  String number;

  UserModel({
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.number,
  });

  Map<String, dynamic> toDoc() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'age': age,
      'number': number,
    };
  }
}
