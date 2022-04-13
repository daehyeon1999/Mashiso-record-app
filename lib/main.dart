import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';

import 'employee_app/home.dart';
import 'employee_app/login.dart';
import 'employee_app/preferences.dart';
import 'mobile_app/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await LoginPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AdminApp();
    // const EmployeeApp();
  }
}

class EmployeeApp extends StatefulWidget {
  const EmployeeApp({Key? key}) : super(key: key);

  @override
  State<EmployeeApp> createState() => _EmployeeAppState();
}

class _EmployeeAppState extends State<EmployeeApp> {
  String? userId = 'empty_user_id';
  var login;

  autoLogin() async {
    final employee = await FirebaseFirestore.instance
        .collection('employee')
        .doc(userId)
        .get();
    return employee.data();
  }

//*Service and permission
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  Location location = Location();
  //*check the permission
  checkPermission() async {
    //check the service in enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    //*check the permission is enabled
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }

    setState(() {
      _serviceEnabled;
      _permissionGranted;
    });
  }

  @override
  void initState() {
    super.initState();
    userId = LoginPreferences.getUserId();
    login = autoLogin();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Work Record App',
        theme: ThemeData(
            fontFamily: 'Inter',
            primarySwatch: Colors.orange,
            brightness: Brightness.light),
        darkTheme: ThemeData(
            fontFamily: 'Inter',
            primarySwatch: Colors.orange,
            brightness: Brightness.dark),
        themeMode: ThemeMode.system,
        home: FutureBuilder(
          future: login,
          builder: (context, user) {
            if (user.hasData) {
              Map<String, dynamic> data = user.data! as Map<String, dynamic>;
              return Home(
                name: data['name'],
                location: location,
              );
            } else if (user.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            return Login(
              location: location,
            );
          },
        ));
  }
}

class AdminApp extends StatefulWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Work Record App',
        theme: ThemeData(
            fontFamily: 'Inter',
            primarySwatch: Colors.orange,
            brightness: Brightness.light),
        darkTheme: ThemeData(
            fontFamily: 'Inter',
            primarySwatch: Colors.orange,
            brightness: Brightness.dark),
        themeMode: ThemeMode.system,
        home: const Scaffold(body: SafeArea(child: MobileHome())));
  }
}
