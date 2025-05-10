import 'package:flutter/material.dart';
import 'package:front_end/Presentation/Home/homepage.dart';
import 'package:front_end/Presentation/Logs/logs.dart';
import 'package:front_end/constants/colours.dart';
import 'package:front_end/constants/size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;
Widget recentLogs_homepage() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: getloglist(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
            child: CircularProgressIndicator(
          color: blue_clr,
        ));
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text('No logs available');
      } else {
        var logs = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Recent Access Logs',
                    style: GoogleFonts.abel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blue_clr)),
                TextButton(
                  onPressed: () {
                   pageindex.value=2;
                  },
                  child: Text(
                    'See all logs',
                    style: GoogleFonts.lato(
                      color: blue_clr,
                      fontWeight: FontWeight.bold,
                      decorationColor: blue_clr,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1.0,
                    ),
                  ),
                )
              ],
            ),
            ListView.builder(
             shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                final log = logs[index];
                final status = log['status'];
                final timestamp = log['timestamp'];

                // Construct the correct image URL
                final imageUrl = supabase.storage
                    .from('processed-images')
                    .getPublicUrl('logs/$status/${log['image_name']}');

                return LogTile(
                  imageUrl: imageUrl,
                  status: status,
                  timestamp: timestamp,
                  logData: log,
                );
              },
            ),
           sizedbox_height_20
          ],
        );
      }
    },
  );
}

Future<List<Map<String, dynamic>>> getloglist() async {
  List<Map<String, dynamic>> logs = [];

  try {
    await Supabase.instance.client.auth.refreshSession();
    ;
    final response = await supabase
        .from('access_logs')
        .select()
        .order('timestamp', ascending: false)
        .limit(50);

    logs = List<Map<String, dynamic>>.from(response);
    return logs;
  } catch (e) {
    print("Error fetching logs: $e");
  }
  return logs;
}
