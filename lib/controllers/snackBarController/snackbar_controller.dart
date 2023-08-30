import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackBarController{
  static void showSnackBar(BuildContext context, String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.grey[700],
      content:
      Center(child: Text(text,style: GoogleFonts.quicksand(
          fontSize: 14, fontWeight: FontWeight.bold),
      ),),
    ));
  }
}