import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final String text;
  final Color color;
  const RoundButton({super.key,required this.text,this.isLoading = false,required this.onTap,required this.color});

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.color,
          ),
          height: 50,
          width: double.infinity,
          child: Center(
              child:
              widget.isLoading? const CircularProgressIndicator(color: Colors.white,) :
              Text(
                widget.text,
                style: GoogleFonts.quicksand(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ))),
    );
  }
}