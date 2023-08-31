import 'package:echotalk/controllers/dataController/data_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/userModel/user_model.dart';
import '../../widgets/roundButton/round_button.dart';

class EditProfilePage extends StatefulWidget {
  final String firstname;
  final String lastName;
  final int age;
  final String email;
  const EditProfilePage({super.key,required this.firstname,required this.lastName,required this.age,required this.email});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? uid= FirebaseAuth.instance.currentUser?.uid;
  UserModel? userModel;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isObscure = true;
  bool isObscure1 = true;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _firstNameController.text = widget.firstname;
    _lastNameController.text = widget.lastName;
    _ageController.text = widget.age.toString();
    _emailController.text = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Edit Profile",
                    style: GoogleFonts.quicksand(
                        fontSize: 40,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "First Name",
                      errorText: _formKey.currentState?.validate() == false
                          ? 'Please enter a correct name'
                          : null,
                    ),
                    controller: _firstNameController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Last Name",
                      errorText: _formKey.currentState?.validate() == false
                          ? 'Please enter a correct name'
                          : null,
                    ),
                    controller: _lastNameController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Age",
                      errorText: _formKey.currentState?.validate() == false
                          ? 'Please enter correct age'
                          : null,
                    ),
                    controller: _ageController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.alternate_email),
                      hintText: "Email",
                      errorText: _formKey.currentState?.validate() == false
                          ? 'Please enter a valid email'
                          : null,
                    ),
                    controller: _emailController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    obscureText: isObscure,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: isObscure
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: "New Password",
                      errorText: _formKey.currentState?.validate() == false
                          ? 'Please enter a valid password'
                          : null,
                    ),
                    controller: _passwordController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    obscureText: isObscure1,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure1 = !isObscure1;
                            });
                          },
                          icon: isObscure1
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: "Confirm Password",
                      errorText: _formKey.currentState?.validate() == false
                          ? 'Please enter a valid password'
                          : null,
                    ),
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width:130,child: RoundButton(text: "Submit", isLoading: isLoading, onTap: (){
                        DataController.updateUserDetails(context, _firstNameController.text.trim(), _lastNameController.text.trim(), int.parse(_ageController.text.trim()), _emailController.text.trim(), uid!);
                      }, color: Colors.deepPurple)),
                      SizedBox(width:130,
                        child: RoundButton(text: "Cancel", onTap: (){
                          Navigator.pop(context);
                        }, color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}