import 'package:flutter/material.dart';
import 'package:front_end/Presentation/Logs/logdetail.dart';
import 'package:front_end/constants/colours.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final SupabaseClient supabase = Supabase.instance.client;
List<Map<String, dynamic>> logs = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    setState(() => isLoading = true);

    try {
      final response = await supabase
          .from('access_logs')
          .select()
          .order('timestamp', ascending: false)
          .limit(50);

      setState(() => logs = List<Map<String, dynamic>>.from(response));
    } catch (e) {
      print("Error fetching logs: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch logs")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Access Logs", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: blue_clr,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : logs.isEmpty
              ? const Center(
                  child: Text("No logs found!", style: TextStyle(fontSize: 18)))
              : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    final status = log[
                        'status']; // Example: "Authorized" or "Unauthorized"
                    final timestamp = log['timestamp'];

                    // Construct the correct image URL
                    final imageUrl = supabase.storage
                        .from('processed-images')
                        .getPublicUrl('logs/$status/${log['image_name']}');

                    return LogTile(
                      imageUrl: imageUrl,
                      status: status,
                      timestamp: timestamp,
                      logData: logs[index],
                    );
                  },
                ),
    );
  }
}

class LogTile extends StatelessWidget {
  final String imageUrl;
  final String status;
  final String timestamp;
  final Map<String, dynamic> logData;

  LogTile(
      {required this.imageUrl,
      required this.status,
      required this.timestamp,
      required this.logData});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('yyyy-MM-dd – HH:mm:ss').format(DateTime.parse(timestamp));

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LogDetailsPage(imageUrl: imageUrl, logData: logData),));
      } ,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: Colors.grey[300],
          ),
          title: Text(
            status,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: status == "Authorized" ? Colors.green : Colors.red,
            ),
          ),
          subtitle: Text(formattedDate,
              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ),
      ),
    );
  }
}
