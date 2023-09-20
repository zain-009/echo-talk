import 'package:echotalk/controllers/authController/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/snackBarController/snackBar_controller.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;
  bool isObscure1 = true;
  bool isObscure2 = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                "Change Password",
                style: GoogleFonts.quicksand(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Please enter the new password below!",
                style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                obscureText: isObscure,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                  hintText: "Current Password",
                ),
                controller: _passwordController,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                obscureText: isObscure1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                  hintText: "New Password",
                ),
                controller: _newPasswordController,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                obscureText: isObscure2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure2 = !isObscure2;
                        });
                      },
                      icon: isObscure2
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility)),
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: "Confirm Password",
                ),
                controller: _confirmPasswordController,
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                  child: SizedBox(
                      height: 40,
                      width: 100,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple),
                          onPressed: () async {
                            if (_passwordController.text.trim().isEmpty ||
                                _newPasswordController.text.trim().isEmpty ||
                                _confirmPasswordController.text
                                    .trim()
                                    .isEmpty) {
                              SnackBarController.showSnackBar(
                                  context, "Please fill out all the fields!");
                            }
                            if (_passwordController.text.trim().isNotEmpty &&
                                _newPasswordController.text.trim().isNotEmpty &&
                                _confirmPasswordController.text
                                    .trim()
                                    .isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });
                              await AuthController.updatePassword(
                                  _passwordController.text.trim(),
                                  _newPasswordController.text.trim(),
                                  _confirmPasswordController.text.trim(),
                                  context);
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Submit",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ))))
            ],
          ),
        ),
      ),
    );
  }
}
