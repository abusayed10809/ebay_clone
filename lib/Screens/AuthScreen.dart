import 'package:auth_buttons/res/buttons/google_auth_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ebay_clone/FirebaseOperations/AuthService.dart';
import 'package:ebay_clone/Screens/NavigationScreen.dart';
import 'package:ebay_clone/Widgets/SharedWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final globalFontSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.deepPurple,

      body: Container(
        child: Center(
          child: isLoading ? SpinKitDoubleBounce(color: Colors.white) : GoogleAuthButton(
            splashColor: Colors.blue,
            onPressed: () async{
              setState(() {
                isLoading = true;
              });
              String userId = await AuthService().signInWithGoogle();
              setState(() {
                isLoading = false;
              });
              if(userId!=null){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavigationScreen()));
              }
            },
          ),
        ),
      ),
    );
  }
}
