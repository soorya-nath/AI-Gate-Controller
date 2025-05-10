import 'package:flutter/material.dart';
import 'package:front_end/Presentation/Drivers/driverspage.dart';
import 'package:front_end/Presentation/Home/custompage.dart';
import 'package:front_end/Presentation/Logs/logs.dart';
import 'package:front_end/constants/colours.dart';

ValueNotifier<int> pageindex = ValueNotifier(0);
class Homepage extends StatelessWidget {
  Homepage({super.key});

  void _onItemTapped(int index) {
    pageindex.value = index;
  }

  final List<Widget> _widgetOptions = [
    CustomPage(),
    DriversPage(),
    LogPage()
    
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: pageindex,
        builder: (context, value, child) {
          return _widgetOptions[value];
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: pageindex,
        builder: (context, value, child) {
          return BottomNavigationBar(
            currentIndex: value, 
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey, 
            selectedIconTheme:  IconThemeData(color: blue_clr),
            unselectedIconTheme: const IconThemeData(color: Colors.grey),
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Drivers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Recent logs',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.person_2),
              //   label: 'Profile',
              // ),
            ],
          );
        },
      ),
    );
  }
}
