import 'package:echotalk/controllers/authController/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpVerificationPage(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  String smsCode = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey[600],
              size: 30,
            )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200, child: SvgPicture.asset("assets/otp.svg")),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Please enter the 6 Digit code sent to ${widget.phoneNumber}",
                style: GoogleFonts.quicksand(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                validator: (s) {
                  smsCode = s!;
                  return null;
                },
                showCursor: false,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await AuthController.verifyOtp(widget.verificationId, smsCode, context);
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
                      child: isLoading? const CircularProgressIndicator(color: Colors.white,) :Text(
                        "Verify Code",
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
    );
  }
}