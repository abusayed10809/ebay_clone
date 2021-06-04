import 'package:ebay_clone/FirebaseOperations/AuthService.dart';
import 'package:ebay_clone/Screens/AuthScreen.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: FlatButton(
          onPressed: () async{
            await AuthService().signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()));
          },
          child: Text(
            'Sign Out',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
