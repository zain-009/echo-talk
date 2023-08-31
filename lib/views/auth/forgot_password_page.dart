import 'package:echotalk/controllers/authController/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 200,
                    child: SvgPicture.asset('assets/forgot-password.svg')),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Forgot\nPassword?",
                      style: GoogleFonts.quicksand(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Don\'t worry, Please enter the details associated with your account",
                  style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500]),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  onFieldSubmitted: (_){},
                  decoration: const InputDecoration(
                      icon: Icon(Icons.alternate_email), hintText: 'Email'),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Row(
                //   //mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Expanded(
                //         child: Divider(
                //           indent: 60,
                //           height: 5,
                //           thickness: 2,
                //           color: Colors.black,
                //           endIndent: 10,
                //         )),
                //     Text(
                //       "Or",
                //       style: GoogleFonts.quicksand(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.black),
                //     ),
                //     const Expanded(
                //         child: Divider(
                //           endIndent: 60,
                //           height: 5,
                //           thickness: 2,
                //           color: Colors.black,
                //           indent: 10,
                //         )),
                //   ],
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // IntlPhoneField(
                //   controller: _phoneNumberController,
                //   disableLengthCheck: true,
                //   style: const TextStyle(fontSize: 18),
                //   decoration: const InputDecoration(
                //     hintText: 'Phone Number',
                //     labelText: null,
                //     border: OutlineInputBorder(
                //       borderSide: BorderSide(),
                //     ),
                //   ),
                //   initialCountryCode: 'PK',
                //   onChanged: (phone) {
                //     phoneNumber = phone.completeNumber;
                //   },
                //   onSubmitted: (_){_emailController.clear();},
                // ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await AuthController.resetPassword(_emailController.text.trim(), context);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.deepPurple[400],
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          "Submit",
                          style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}