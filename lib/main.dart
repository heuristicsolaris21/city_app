import 'package:city_app/firebase_api.dart';
import 'package:city_app/others/splashscreen.dart';
import 'package:city_app/screens/Authscreen.dart';
import 'package:city_app/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityApp',
      theme: ThemeData().copyWith(
        useMaterial3: false,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 9, 89, 164)),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return FutureBuilder(
              future: _fetchUserData(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }

                if (userSnapshot.hasData) {
                  // Retrieve user data and pass it to HomeScreen
                  final userData = userSnapshot.data as Map<String, dynamic>;

                  return homescreen(
                    phone: userData['phone'] as String,
                    userphoto: userData['imageurl'] as String,
                    username: userData['username'] as String,
                  );
                } else {
                  return const AuthScreen();
                }
              },
            );
          }
          return const AuthScreen();
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchUserData(String userId) async {
  final snapshot = await FirebaseDatabase.instance.reference().child('users').child(userId).once();
  
  // Check if the snapshot exists and has data
  if (snapshot.snapshot.value != null && snapshot.snapshot.value is Map) {
    return Map<String, dynamic>.from(snapshot.snapshot.value as Map);
  } else {
    // Return an empty map or handle the case where data is not available
    return {};
  }
  }

}


