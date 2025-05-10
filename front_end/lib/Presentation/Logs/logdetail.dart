import 'package:flutter/material.dart';
import 'package:front_end/constants/size.dart';
import 'package:intl/intl.dart';

class LogDetailsPage extends StatelessWidget {
  final Map<String, dynamic> logData;
  final String imageUrl;

  LogDetailsPage({required this.logData, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final status = logData['status'];
    final timestamp = logData['timestamp'];

    final formattedDate =
        DateFormat('yyyy-MM-dd – HH:mm:ss').format(DateTime.parse(timestamp));

    // Theme based on status
    final isAuthorized = status == "Authorized";
    final bgColor = isAuthorized ? Colors.green[50] : Colors.red[50];
    final borderColor = isAuthorized ? Colors.green : Colors.red;
    final textColor = isAuthorized ? Colors.green[900] : Colors.red[900];
    final icon = isAuthorized
        ? Icons.verified_user // Green Verified Icon
        : Icons.error; // Red Warning Icon

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        color: bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // User Image
            ClipOval(
              child: Image.network(
                imageUrl,
                width: 170,
                height: 170, 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.person, size: 120, color: Colors.grey),
              ),
            ),
            sizedbox_height_20,

            // Status with Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: borderColor, size: 28),
                SizedBox(width: 8),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            sizedbox_height_10,

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor, width: 2),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    logDetailRow("Status", status),
                    logDetailRow("Timestamp", formattedDate),
                    status == 'Authorized'
                        ? logDetailRow(
                            "Details", 'Authorized access. No issues detected.')
                        : logDetailRow(
                            "Details", 'Unauthorized access,issues detected.'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Back Button
            ElevatedButton.icon(
              icon: Icon(Icons.arrow_back),
              label: Text("Back"),
              style: ElevatedButton.styleFrom(
                backgroundColor: borderColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget logDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
