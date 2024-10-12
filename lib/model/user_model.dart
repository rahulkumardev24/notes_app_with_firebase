class UserModel {
  String name;
  String email;
  String gender;
  int age;
  String number;
  String? profilePic; // Nullable, as it may not be present initially

  UserModel({
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.number,
    this.profilePic, // Optional in the constructor
  });

  /// Factory constructor to create UserModel from a Firestore document
  factory UserModel.FromDoc(Map<String, dynamic> doc) => UserModel(
    name: doc['name'],
    number: doc['number'],
    email: doc['email'],
    gender: doc['gender'],
    age: doc['age'],
    profilePic: doc['profilePic'], // Fetching the profilePic if available
  );

  /// Convert the UserModel instance to a Firestore document (map)
  Map<String, dynamic> toDoc() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'age': age,
      'number': number,
      'profilePic': profilePic, // Include profilePic in the map
    };
  }
}
