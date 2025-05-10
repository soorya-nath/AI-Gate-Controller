import 'package:flutter/material.dart';
import 'package:front_end/constants/colours.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> drivers;

  DetailsPage({super.key, required this.drivers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Driver Details', style: TextStyle(color: Colors.white)),
        backgroundColor: blue_clr,
        centerTitle: true,
        iconTheme:
            const IconThemeData(color: Colors.white), // Back button color
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Driver's Image
                CircleAvatar(
                  radius: 100,
                  backgroundImage:
                      NetworkImage(drivers['image_url']), // Ensure URL is valid
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 15),
        
                // Driver Info
                Text(
                  drivers['name'],
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: blue_clr),
                ),
                const SizedBox(height: 5),
                Text(
                  'License No: ${drivers['license_no']}',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                Text(
                  'Contact: ${drivers['contact']}',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
        
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      deleteUser();
                      Navigator.pop(
                          context, true); // Pass 'true' to indicate deletion
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Delete Driver',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Icon(Icons.delete, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Future<void> deleteUser() async {
  SupabaseClient supabase = Supabase.instance.client;

  // Extract file name from full image URL
  String imageUrl = drivers['image_url']; 
  Uri uri = Uri.parse(imageUrl);
  String imageName = uri.pathSegments.last; // Get the file name

  print("Deleting file: $imageName"); // Debugging

  // Delete the user from the database
  await supabase.from('drivers').delete().eq('id', drivers['id']);

  // Delete the image from the bucket
  final response = await supabase.storage.from('drivers_images').remove([imageName]);

  print("Delete response: $response");
}
}
