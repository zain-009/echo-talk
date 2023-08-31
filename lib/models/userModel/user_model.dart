import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String firstName;
  String lastName;
  int age;
  String email;
  String? uid;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    this.uid,
  });

  UserModel.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        email = map['email'],
        age = map['age'];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'firstName': firstName,
    'lastName': lastName,
    'age': age,
    'email': email,
  };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      firstName: snapshot['firstName'],
      lastName: snapshot['lastName'],
      email: snapshot['email'],
      age: snapshot['age'],
    );
  }
}