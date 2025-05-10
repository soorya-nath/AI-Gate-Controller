import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbarwidget(
    context, IconData? icon, String message, Color ?iconcolor) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          icon != null
              ? Icon(icon, color: iconcolor, size: 28)
              : const SizedBox(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900], // Dark background
      behavior: SnackBarBehavior.floating, // Floating effect
      elevation: 6.0, // Adds depth
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      duration: const Duration(seconds: 3), // Controls visibility time
    ),
  );
}
