import 'package:echotalk/views/screens/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../views/auth/otp_verification_page.dart';
import '../../views/auth/login_page.dart';
import '../../views/screens/home_page.dart';
import '../dataController/data_controller.dart';
import '../snackBarController/snackBar_controller.dart';

class AuthController {
  //---------Sign-in-----------------------------
  static Future<void> signIn(
      String email, String password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      if (user != null && user.emailVerified) {
        SnackBarController.showSnackBar(context, "Login Successful!");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        AuthController.sendVerificationMail()
            .then((value) => SnackBarController.showSnackBar(
                context, "Account not verified. Check email for verification"))
            .onError((error, stackTrace) =>
                SnackBarController.showSnackBar(context, error.toString()));
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          SnackBarController.showSnackBar(context, "Account does not exist!");
        }
        if (e.code == 'wrong-password') {
          SnackBarController.showSnackBar(context, "Wrong Password!");
        }
        if (e.code == 'too-many-requests') {
          SnackBarController.showSnackBar(
              context, "Too many requests! Try again after a few moments");
        }
      }
    }
  }

  //---------Sign-out-----------------------------
  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  //---------Sign-up-----------------------------
  static Future<void> signup(
    String email,
    String password,
    BuildContext context,
    String firstName,
    String lastName,
    int age,
  ) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? uid = auth.currentUser?.uid;
      DataController.addDetails(firstName, lastName, age, email, uid!, context);
      sendVerificationMail();
      SnackBarController.showSnackBar(
          context, "Signup Successful! Check inbox for email verification");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          SnackBarController.showSnackBar(context, "Email already in use");
        }
      } else {
        SnackBarController.showSnackBar(context, e.toString());
      }
    }
  }

  //---------verification-email-----------------------------
  static Future<void> sendVerificationMail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    await user?.sendEmailVerification();
  }

  //---------------password-reset----------------------------
  static Future<void> resetPassword(String email, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      auth.sendPasswordResetEmail(email: email).then((_) => {
            SnackBarController.showSnackBar(
                context, "Password Reset Email Sent!"),
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()))
          });
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          SnackBarController.showSnackBar(context, "Account does not exist!");
        }
        if (e.code == 'too-many-requests') {
          SnackBarController.showSnackBar(
              context, "Too many requests! Try again after a few moments");
        }
      }
    }
  }

  //---------phone-verification-----------------------------
  static Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (_) {},
          verificationFailed: (e) {
            SnackBarController.showSnackBar(context, e.toString());
          },
          codeSent: (String verificationId, int? token) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpVerificationPage(
                          verificationId: verificationId,
                          phoneNumber: phoneNumber,
                        )));
          },
          codeAutoRetrievalTimeout: (e) {
            SnackBarController.showSnackBar(context, e.toString());
          });
    } catch (e) {
      SnackBarController.showSnackBar(context, e.toString());
    }
  }

  //---------otp-verification-----------------------------
  static Future<void> verifyOtp(
      String verificationId, String smsCode, BuildContext context) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      SnackBarController.showSnackBar(context, e.toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  //--------change-password---------------------------------
  static Future<void> updatePassword(
      String password,String newPassword, String confirmPassword, BuildContext context) async {
    if (newPassword != confirmPassword) {
      SnackBarController.showSnackBar(context, "Passwords do not match!");
    }
    if (newPassword == confirmPassword) {
      User? user = FirebaseAuth.instance.currentUser;
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email.toString(),
          password: password,
        );
        await user?.reauthenticateWithCredential(credential);
        try{
          user.updatePassword(newPassword);
        } catch (e){
          SnackBarController.showSnackBar(context,e.toString());
        }
      } catch (e) {
        SnackBarController.showSnackBar(context, e.toString());
      }
    }
  }

  //--------change-email------------------------------------
  static Future<void> updateEmail(String email, String newEmail,
      String password, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user?.reauthenticateWithCredential(credential);
      try {
        await user?.updateEmail(newEmail);
        SnackBarController.showSnackBar(context, "Email updated!");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            SnackBarController.showSnackBar(context, "Email Already in use!");
          }
          if (e.code == 'requires-recent-login') {
            SnackBarController.showSnackBar(
                context, "Sign in again to change email!");
          }
          if (e.code == 'invalid-email') {
            SnackBarController.showSnackBar(context, "Invalid Email!");
          }
        }
        SnackBarController.showSnackBar(context, e.toString());
      }
    } catch (e) {
      SnackBarController.showSnackBar(context, e.toString());
    }
  }
}
