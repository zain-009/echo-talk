import 'package:echotalk/controllers/dataController/data_controller.dart';
import 'package:echotalk/controllers/snackBarController/snackBar_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditInfoScreen extends StatefulWidget {
  final String firstname;
  final String lastName;
  final int age;
  final String email;

  const EditInfoScreen(
      {super.key,
      required this.firstname,
      required this.lastName,
      required this.age,
      required this.email});

  @override
  State<EditInfoScreen> createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  bool isLoading = false;

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              "Edit Profile",
              style: GoogleFonts.quicksand(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Please edit the details to your liking!",
              style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: "First Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: "Last Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: _ageController,
              decoration: InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
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
                          if(_firstNameController.text.trim().isEmpty || _lastNameController.text.trim().isEmpty || _ageController.text.trim().isEmpty){
                            SnackBarController.showSnackBar(context, "Please enter all details!");
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            await DataController.updateUserDetails(
                                context,
                                _firstNameController.text.trim(),
                                _lastNameController.text.trim(),
                                int.parse(_ageController.text.trim()),
                                _emailController.text.trim(),
                                uid!);
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
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ))))
          ],
        ),
      ),
    );
  }
}

// TextFormField(
// textInputAction: TextInputAction.next,
// obscureText: isObscure,
// validator: (value) {
// if (value!.isEmpty) {
// return 'Please enter your password';
// } else if (value.length < 6) {
// return 'Password must be at least 6 characters';
// }
// return null;
// },
// decoration: InputDecoration(
// suffixIcon: IconButton(
// onPressed: () {
// setState(() {
// isObscure = !isObscure;
// });
// },
// icon: isObscure
// ? const Icon(Icons.visibility_off)
//     : const Icon(Icons.visibility)),
// prefixIcon: const Icon(Icons.lock_outline),
// hintText: "New Password",
// errorText: _formKey.currentState?.validate() == false
// ? 'Please enter a valid password'
//     : null,
// ),
// controller: _passwordController,
// ),
// const SizedBox(
// height: 15,
// ),
// TextFormField(
// textInputAction: TextInputAction.next,
// obscureText: isObscure1,
// validator: (value) {
// if (value!.isEmpty) {
// return 'Please enter your password';
// } else if (value.length < 6) {
// return 'Password must be at least 6 characters';
// }
// return null;
// },
// decoration: InputDecoration(
// suffixIcon: IconButton(
// onPressed: () {
// setState(() {
// isObscure1 = !isObscure1;
// });
// },
// icon: isObscure1
// ? const Icon(Icons.visibility_off)
//     : const Icon(Icons.visibility)),
// prefixIcon: const Icon(Icons.lock_outline),
// hintText: "Confirm Password",
// errorText: _formKey.currentState?.validate() == false
// ? 'Please enter a valid password'
//     : null,
// ),
// controller: _confirmPasswordController,
// ),
