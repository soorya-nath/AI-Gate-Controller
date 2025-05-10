import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_end/Presentation/Drivers/details_page.dart';
import 'package:front_end/constants/colours.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DriversPage extends StatefulWidget {
  @override
  _DriversPageState createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  List<Map<String, dynamic>> drivers = [];
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    loadDrivers();
  }

Future<void> loadDrivers() async {
  await Supabase.instance.client.auth.refreshSession();

  final data = await Supabase.instance.client.from('drivers').select();
  
  if (mounted) {  
    setState(() {
      drivers = List<Map<String, dynamic>>.from(data);
      isloading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
           final bool? isAdded = await Navigator.pushNamed(context, '/registration') as bool?;
           if(isAdded!=null && isAdded){
             loadDrivers();
           }
          },
          backgroundColor: blue_clr,
          child: const Icon(
            CupertinoIcons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
        appBar: AppBar(
          title: const Text(
            'Registered Drivers',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: blue_clr,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(9.0),
          child: isloading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ))
              : drivers.isEmpty
                  ? const Center(
                      child: Text(
                        "No Driver Registered!.",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: drivers.length,
                      itemBuilder: (context, index) {
                        final driver = drivers[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: GestureDetector(
                            onTap: () async{
                              final bool? isAdded = await  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    DetailsPage(drivers: driver),

                              ));
                              if(isAdded!=null && isAdded){
                                loadDrivers();
                              }
                             
                            },
                            child: Card(
                              color: Colors.grey[100],
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      NetworkImage(driver["image_url"]),
                                ),
                                title: Text(
                                  driver['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('Phone: ${driver['contact']}'),

                                trailing: const Icon(Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors
                                        .grey), // ✅ Adds arrow for navigation
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ));
  }
}
