// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:donation_app/Screens/AccountScreen.dart';
import 'package:donation_app/Screens/FulfillRequestScreen.dart';
import 'package:donation_app/Screens/Landing.dart';
import 'package:donation_app/Screens/NGOLoginFlow.dart';
import 'package:donation_app/Screens/Something.dart';
import 'package:donation_app/Screens/UserLoginFlow.dart';
import 'package:donation_app/Screens/VolunteerScreen.dart';
import 'package:donation_app/Service/CustomUser.dart';
import 'package:donation_app/Service/NGO.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'globals/colors.dart' as colors;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Solution Challenge enTWEAK',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: colors.primary,
            secondary: colors.mediumGrey,
          ),
          fontFamily: 'PlusJakartaSans'),
      home:Landing(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final NGO? ngo;
  final CustomUser? user;

  const MyHomePage({Key? key,this.ngo,this.user}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int activeTabIndex = 0;

  final tabs = const [
    SomeThing(),
    FulfillRequest(),
    VolunteerScreen(),
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: tabs[activeTabIndex],
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: TextStyle(
              color: colors.primary,
              fontSize: 12.0,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              color: colors.mediumGrey,
              fontSize: 12.0,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
            currentIndex: activeTabIndex,
            onTap: (index) {
              setState(() {
                activeTabIndex = index;
              });
            },
            backgroundColor: Colors.white,
            iconSize: 20,
            selectedItemColor: colors.primary,
            unselectedItemColor: colors.mediumGrey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 50,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Iconsax.home),
                  label: "Home",
                  activeIcon: Icon(Iconsax.home5)),
              BottomNavigationBarItem(
                  icon: Icon(Iconsax.like),
                  activeIcon: Icon(Iconsax.like5),
                  label: "Fulfil a request"),
              BottomNavigationBarItem(
                  icon: Icon(Iconsax.flag),
                  activeIcon: Icon(Iconsax.flag5),
                  label: "Volunteer"),
              BottomNavigationBarItem(
                  icon: Icon(Iconsax.profile_circle),
                  activeIcon: Icon(Iconsax.profile_circle5),
                  label: "Account"),
            ],
          )),
    );
  }
}
