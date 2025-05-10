import'package:flutter/material.dart';
import 'package:front_end/constants/colours.dart';
import 'package:google_fonts/google_fonts.dart';
Widget home_image_banner(String bannerImage) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Secure, and smart gate access control at your fingertips.',
            style: GoogleFonts.lato(
              color: black_clr,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              bannerImage,
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
        ),
      ],
    );
  }
