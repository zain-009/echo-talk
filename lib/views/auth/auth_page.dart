import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/home_page.dart';
import 'login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          User? user = snapshot.data;
          if(user != null && user.emailVerified){
            return const HomePage();
          }
        } else {
          return const LoginPage();
        }
        return const LoginPage();
      },
    );
  }
}