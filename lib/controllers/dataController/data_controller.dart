import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echotalk/views/screens/home_page.dart';
import 'package:echotalk/views/screens/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/userModel/user_model.dart';
import '../snackBarController/snackBar_controller.dart';

class DataController{
  //-------------add-data-to-firebase---------------------------------
  static Future<void> addDetails(String firstName, String lastName, int age,
      String email, String uid, BuildContext context) async {
    try {
      UserModel userModel = UserModel(
          firstName: firstName,
          lastName: lastName,
          age: age,
          email: email,
          uid: uid);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userModel.toJson());
    } catch (e) {
      SnackBarController.showSnackBar(context, e.toString());
    }
  }
  //-------------get-data-from-firebase-------------------------------
  static Future<UserModel?> getUserModelById(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot docSnap =
    await firestore.collection('users').doc(uid).get();
    if (docSnap.exists) {
      return UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
    }
  }
  //------------update-data--------------------------------------------
  static Future<void> updateUserDetails (BuildContext context,String firstName, String lastName, int age,
      String email, String uid) async {
    try{
      User? user = FirebaseAuth.instance.currentUser;
      UserModel userModel = UserModel(
          firstName: firstName,
          lastName: lastName,
          age: age,
          email: email,
          uid: uid);
      Map<Object, Object?> userMap = userModel.toJson().cast<Object, Object?>();
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).update(userMap);
      SnackBarController.showSnackBar(context, "Updated!");
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ProfilePage()));
    } catch (e){
      SnackBarController.showSnackBar(context, e.toString());
    }
  }
}