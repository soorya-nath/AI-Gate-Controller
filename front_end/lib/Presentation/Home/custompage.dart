import 'package:flutter/material.dart';
import 'package:front_end/Presentation/Home/homepage.dart';
import 'package:front_end/auth/authentication.dart';
import 'package:front_end/constants/colours.dart';
import 'package:front_end/constants/size.dart';
import 'package:front_end/widgets/home/home_image_banner.dart';
import 'package:front_end/widgets/home/quickaction_button.dart';
import 'package:front_end/widgets/home/recentlog.dart';
import 'package:front_end/widgets/home/welcomebanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
bool isopened = false;
String open_cmd='Opened';
String close_cmd="Closed";
class CustomPage extends StatefulWidget {
  @override
  State<CustomPage> createState() => _CustomPageState();
}
class _CustomPageState extends State<CustomPage> {
  List<Map<String, dynamic>> logs = [];
  
  String gateStatus = 'Closed';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading spinner
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}"); // Show error message
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("No email found"); // Handle empty response
          }
          const bannerImage =
              'https://butterflymx.com/wp-content/uploads/2023/04/cellular-gate-entry-system-social-image.jpg';
          String email = snapshot.data!.split('@')[0];
          return SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: card_clr,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //function call for welcome banner
                      sizedbox_height_20,
                      WelcomeBanner(email, context),
                      sizedbox_height_20,
                      sizedbox_height_20,
                      Text('Quick Actions',
                          style: GoogleFonts.abel(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: blue_clr)),
                      sizedbox_height_10,
                      //Quick action buttons
                      quick_access_btn(context),
                      sizedbox_height_10,
                      // home_image_banner(bannerImage),
                      sizedbox_height_20,
                      //gate status card
                      gate_status_card(),
            
                      sizedbox_height_20,
            
                      recentLogs_homepage(),
            
                      home_image_banner(bannerImage.toString()),
                      // Center(
                      //   child: Container(
                      //       height: 200,
                      //       decoration: BoxDecoration(
                      //         color: Colors.black12,
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Image(
                      //         image: NetworkImage(
                      //           'https://i.pinimg.com/736x/6a/d2/f0/6ad2f036fe48b36e4656241986bc2cc5.jpg',
                      //         ),
                      //         fit: BoxFit.cover,
                      //       )),
                      // ),
                      // const SizedBox(height: 10),
                      // Center(
                      //   child: Container(
                      //       height: 200,
                      //       decoration: BoxDecoration(
                      //         color: Colors.black12,
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Image(
                      //         image: NetworkImage(
                      //           'https://i.pinimg.com/736x/6a/d2/f0/6ad2f036fe48b36e4656241986bc2cc5.jpg',
                      //         ),
                      //         fit: BoxFit.cover,
                      //       )),
                      // ),
                      // SizedBox(height: 10),
            
                      // Center(
                      //   child: Container(
                      //       height: 200,
                      //       decoration: BoxDecoration(
                      //         color: Colors.black12,
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Image(
                      //         image: NetworkImage(
                      //           'https://i.pinimg.com/736x/6a/d2/f0/6ad2f036fe48b36e4656241986bc2cc5.jpg',
                      //         ),
                      //         fit: BoxFit.cover,
                      //       )),
                      // ),
                      // const SizedBox(height: 10),
                      // Center(
                      //   child: Container(
                      //       height: 200,
                      //       decoration: BoxDecoration(
                      //         color: Colors.black12,
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Image(
                      //         image: NetworkImage(
                      //           'https://i.pinimg.com/736x/6a/d2/f0/6ad2f036fe48b36e4656241986bc2cc5.jpg',
                      //         ),
                      //         fit: BoxFit.cover,
                      //       )),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Card gate_status_card() {
    
    return Card(
      elevation: 1,
      child: Container(
        decoration: BoxDecoration(
          color: isopened == true
              ? const Color.fromARGB(255, 189, 252, 176)
              : const Color.fromARGB(255, 250, 191, 191),
          border: Border.all(color: card_clr, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            sizedbox_height_10,
            Center(
                child: Text(
              'Controll your gate in one click!',
              style: GoogleFonts.abel(
                  fontWeight: FontWeight.bold, color: blue_clr, fontSize: 20),
            )),
            Center(
              child: Switch(
                value: isopened,
                onChanged: (value) {
                  setState(() {
                    isopened = value;
                    isopened == true
                        ? gateStatus = open_cmd
                        : gateStatus = close_cmd;
                  });
                },
                activeColor: Colors.green,
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey.withOpacity(0.5),
              ),
            ),
            Center(
                child: Text(
              gateStatus,
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: isopened == true ? Colors.green : Colors.red),
            )),
            sizedbox_height_10
          ],
        ),
      ),
    );
  }

  SingleChildScrollView quick_access_btn(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          quickActionBtn(context, 'Register Driver', '/registration'),
          sizedbox_width_10,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blue_clr,
            ),
            onPressed: () {
              pageindex.value = 2;
            },
            child:  Text(
              'View Logs',
              style:
                  GoogleFonts.abel(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          sizedbox_width_10,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blue_clr,
            ),
            onPressed: () {
              // Open/Close gate logic
            },
            child:  Text(
              'Open Gate',
              style:
                  GoogleFonts.abel(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout(ctx) async {
    SupabaseClient supabase = Supabase.instance.client;
    await supabase.auth.signOut();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('islogedin', false);
    Navigator.pushNamed(ctx, '/login');
  }

  Future<void> fetchLogs() async {
    final SupabaseClient supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('access_logs')
          .select()
          .order('timestamp', ascending: false);
      logs = List<Map<String, dynamic>>.from(response);

      logs = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching logs: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch logs")),
      );
    }
  }
}
