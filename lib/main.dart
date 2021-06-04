import 'package:ebay_clone/Screens/AuthScreen.dart';
import 'package:ebay_clone/Screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

String currentUser;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if(FirebaseAuth.instance.currentUser!=null){
    currentUser = FirebaseAuth.instance.currentUser.uid;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.white,
        appBarTheme: AppBarTheme(
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.white
                )
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
                color: Colors.white
            ),
        ),
      ),
      home: currentUser==null ? AuthScreen() : HomeScreen(),
    );
  }
}