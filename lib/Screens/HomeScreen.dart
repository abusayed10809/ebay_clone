import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_clone/Config/AppConfig.dart';
import 'package:ebay_clone/FirebaseOperations/AuthService.dart';
import 'package:ebay_clone/Models/AuctionItem.dart';
import 'package:ebay_clone/Provider/AuctionProvider.dart';
import 'package:ebay_clone/Screens/AuthScreen.dart';
import 'package:ebay_clone/Screens/CreateAuction.dart';
import 'package:ebay_clone/Widgets/AuctionCard.dart';
import 'package:ebay_clone/Widgets/SharedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  AppConfig _appConfig = new AppConfig();

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final globalFontSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('Auction Gallery', globalFontSize),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAuction()));
            },
            child: Padding(
              padding: EdgeInsets.only(right: width*0.03),
              child: Icon(
                Icons.add,
                size: width*0.07,
              ),
            ),
          ),
        ],
      ),

      drawer: appBarDrawer(context),
      
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: getAllAuctionGalleryItem(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState != ConnectionState.active){
                      return Center(
                        child: SpinKitDoubleBounce(color: Colors.indigo,),
                      );
                    }
                    else if(!snapshot.hasData){
                      return Center(
                        child: AutoSizeText(
                          "No data in database",
                          style: TextStyle(
                            fontSize: globalFontSize*15,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.size,
                      itemBuilder: ((BuildContext context, int index){
                        AuctionItem auctionItem = AuctionItem.jsonToString(snapshot.data.docs[index]);

                        String documentId = (snapshot.data.docs[index].id);

                        return buildAuctionCard(context, auctionItem, documentId);
                      }),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getAllAuctionGalleryItem() async*{
    String currentUserUid = FirebaseAuth.instance.currentUser.uid;
    yield* FirebaseFirestore.instance.collection(_appConfig.auctionPostCollection)
        .where(_appConfig.currentUserUid, isNotEqualTo: currentUserUid)
        .snapshots();
  }
}
