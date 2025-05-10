import 'package:flutter/material.dart';
import 'package:front_end/constants/colours.dart';

Widget quickActionBtn(context, title, route) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context, route);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: blue_clr,
    ),
    child: Text(
      title,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
