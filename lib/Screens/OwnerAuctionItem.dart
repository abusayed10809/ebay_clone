import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_clone/Config/AppConfig.dart';
import 'package:ebay_clone/Models/AuctionItem.dart';
import 'package:ebay_clone/Widgets/AuctionCard.dart';
import 'package:ebay_clone/Widgets/SharedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OwnerAuctionItem extends StatefulWidget {
  @override
  _OwnerAuctionItemState createState() => _OwnerAuctionItemState();
}

class _OwnerAuctionItemState extends State<OwnerAuctionItem> {

  AppConfig _appConfig = new AppConfig();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final globalFontSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('My Posts', globalFontSize),
      ),

      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: getMyAuctionGalleryItem(),
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

  Stream<QuerySnapshot> getMyAuctionGalleryItem() async*{
    String currentUserUid = FirebaseAuth.instance.currentUser.uid;
    yield* FirebaseFirestore.instance.collection(_appConfig.auctionPostCollection)
        .where(_appConfig.currentUserUid, isEqualTo: currentUserUid)
        .snapshots();
  }
}
