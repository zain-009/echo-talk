import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Tile extends StatefulWidget {
  final VoidCallback onPress;
  final String leading;

  const Tile({super.key, required this.onPress, required this.leading});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () { widget.onPress(); },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.leading,
              style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
