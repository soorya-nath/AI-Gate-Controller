import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_end/auth/authentication.dart';
import 'package:front_end/constants/colours.dart';
import 'package:google_fonts/google_fonts.dart';

Card WelcomeBanner(String email, BuildContext context) {
  return Card(
    elevation: 10,
    child: Container(
      decoration: BoxDecoration(
        color:  Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 4,
      padding: EdgeInsets.symmetric(horizontal: 15), // Added padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Moves Logout button closer
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                "Welcome ${email[0].toUpperCase() + email.substring(1)} !",
                style: GoogleFonts.lato(
                  color: blue_clr,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
              subtitle: const Text("No Cards, No Keys—Just You !"),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers vertically
            children: [
              IconButton(
                icon: const Icon(
                  CupertinoIcons.square_arrow_right,
                  color: Colors.red,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                 AuthService().logout();
                },
              ),
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
