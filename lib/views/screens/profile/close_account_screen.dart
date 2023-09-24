import 'package:echotalk/controllers/authController/auth_controller.dart';
import 'package:echotalk/controllers/snackBarController/snackBar_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CloseAccountPage extends StatefulWidget {
  final String email;

  const CloseAccountPage({super.key, required this.email});

  @override
  State<CloseAccountPage> createState() => _CloseAccountPageState();
}

class _CloseAccountPageState extends State<CloseAccountPage> {
  final _emailController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;

  @override
  void initState() {
    _emailController.text = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newEmailController.dispose();
    _passwordController.dispose();
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
                "Close Account",
                style: GoogleFonts.quicksand(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "We are sorry to see you go!",
                style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Current Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
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
                  hintText: "Password",
                ),
                controller: _passwordController,
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
                            if (_passwordController.text.trim().length < 6) {
                              SnackBarController.showSnackBar(context,
                                  "Password must me at least 6 digits!");
                            }
                            if (_passwordController.text.trim().isNotEmpty &&
                                _passwordController.text.trim().length >= 6) {
                              setState(() {
                                isLoading = true;
                              });
                              await AuthController.updateEmail(
                                  _emailController.text.trim(),
                                  _newEmailController.text.trim(),
                                  _passwordController.text.trim(),
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
