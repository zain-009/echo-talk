import 'package:echotalk/controllers/authController/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'login_page.dart';
import 'otp_verification_page.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  var phoneNumber = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  height: 200,
                  child: SvgPicture.asset("assets/otp-phone.svg")),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Please enter your phone number to receive the code",
                style: GoogleFonts.quicksand(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              IntlPhoneField(
                disableLengthCheck: false,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  labelText: null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'PK',
                onChanged: (phone) {
                  phoneNumber = phone.completeNumber;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await AuthController.verifyPhoneNumber(phoneNumber, context);
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
                        "Send Code",
                        style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Want to go back? ",
                    style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}