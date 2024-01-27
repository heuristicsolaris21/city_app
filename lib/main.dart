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
            print("###################################################");
            return FutureBuilder(
              future: _fetchUserData(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }
                if (userSnapshot.hasData && userSnapshot.data != null) {
                  // Retrieve user data and pass it to HomeScreen
                  final userData = userSnapshot.data as Map<String, dynamic>;
                  print("###################################################home1");
                  String phone = userData['phone']??'';
                  print(userData['phone']);
                  print("###################################################home2");
                  String userphoto = userData['imageurl']??'';
                  print("###################################################home3");
                  String username = userData['username'] ?? '';
                  print("###################################################home4");
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  print("###################################################home5");
                  if (phone=='' || phone==null){
                    return const AuthScreen();
                  }
                  return homescreen(
                    phone:phone,
                    userphoto:userphoto,
                    username:username,
                    uid:uid,
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
  if (snapshot.snapshot.value != null && snapshot.snapshot.value is Map) {
    return Map<String, dynamic>.from(snapshot.snapshot.value as Map);
  } else {
    return {};
  }
  }

}


