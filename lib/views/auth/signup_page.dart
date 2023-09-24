import 'package:echotalk/controllers/authController/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/snackBarController/snackBar_controller.dart';
import '../../widgets/roundButton/round_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;
  bool isObscure1 = true;
  final _formKey = GlobalKey<FormState>();

  String? firstNameError;
  String? lastNameError;
  String? ageError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
          color: Colors.grey[700],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Sign up",
                        style: GoogleFonts.quicksand(
                            fontSize: 38, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
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
                      errorText: firstNameError,
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
                      errorText: lastNameError,
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
                      errorText: ageError,
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
                      errorText: emailError,
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
                      if (value != null && value.length < 6) {
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
                      hintText: "Password",
                      errorText: passwordError,
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
                      if (value != null && value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure1= !isObscure1;
                            });
                          },
                          icon: isObscure1
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: "Confirm Password",
                      errorText: confirmPasswordError,
                    ),
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RoundButton(
                    text: "Signup",
                    isLoading: isLoading,
                    color: Colors.deepPurple,
                    onTap: () async {
                      setState(() {
                        firstNameError = null;
                        lastNameError = null;
                        ageError = null;
                        emailError = null;
                        passwordError = null;
                        confirmPasswordError = null;
                        isLoading = true;
                      });

                      if (_formKey.currentState!.validate()) {
                        if (_passwordController.text.trim() !=
                            _confirmPasswordController.text.trim()) {
                          setState(() {
                            confirmPasswordError = "Passwords do not match!";
                            isLoading = false;
                          });
                        } else {
                          await AuthController.signup(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            context,
                            _firstNameController.text.trim(),
                            _lastNameController.text.trim(),
                            int.parse(_ageController.text.trim()),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
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
