import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/splashController/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SplashController().splashTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: SvgPicture.asset("assets/splash-icon.svg"),
            ),
            const SizedBox(height: 30,),
            const Text("Echo Talk",style: TextStyle(fontSize: 24,color: Colors.deepPurple,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}