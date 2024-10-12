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




  factory UserModel.FromDoc(Map<String, dynamic> doc) => UserModel(
      name: doc['name'],
      number: doc['number'],
      email: doc['email'],
      gender: doc['gender'],
      age: doc['age']);

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
