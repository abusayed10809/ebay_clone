import 'package:auto_size_text/auto_size_text.dart';
import 'package:ebay_clone/FirebaseOperations/AuthService.dart';
import 'package:ebay_clone/Screens/AuthScreen.dart';
import 'package:ebay_clone/Screens/OwnerAuctionItem.dart';
import 'package:flutter/material.dart';

Widget appBarTitle(String title, double globalFontSize){
  return AutoSizeText(
    title,
    style: TextStyle(
      fontSize: globalFontSize*15,
    ),
  );
}

Drawer appBarDrawer(BuildContext context){
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  final globalFontSize = MediaQuery.of(context).textScaleFactor;
  return Drawer(
    child: ListView(
      children: [
        Container(
          height: height,
          child: Column(
            children: [
              Container(
                height: height*0.3,
              ),

              Container(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.list_alt
                      ),
                      title: AutoSizeText(
                        'My Posted Items',
                        style: TextStyle(
                          fontSize: globalFontSize*13,
                        ),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerAuctionItem()));
                      },
                    ),
                    Divider(
                      height: height*0.001,
                      color: Colors.grey,
                      thickness: height*0.0005,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                      ),
                      title: AutoSizeText(
                        'Logout',
                        style: TextStyle(
                          fontSize: globalFontSize*13,
                        ),
                      ),
                      onTap: () async{
                        await AuthService().signOut();
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}