import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_clone/Config/AppConfig.dart';
import 'package:ebay_clone/Models/AuctionItem.dart';
import 'package:ebay_clone/Models/BidInfoModel.dart';
import 'package:ebay_clone/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildAuctionCardDetailed(BuildContext context, AuctionItem auctionItem, bool showBidClosed, BidInfoModel bidInfoModel){
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final globalFontSize = MediaQuery.of(context).textScaleFactor;

  DateFormat dateFormat = DateFormat('dd-MMM-yyyy');

  return Container(
    child: Column(
      children: [
        Card(
          elevation: 2,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(width*0.025),
                child: Container(
                  width: width*0.5,
                  height: height*0.25,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    image: DecorationImage(
                      image: NetworkImage(
                        auctionItem.imagePath,
                      ),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(width*0.025),
                  ),
                ),
              ),
              Container(
                height: height*0.25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AutoSizeText(
                      auctionItem.name,
                      style: TextStyle(
                          fontSize: globalFontSize*15
                      ),
                    ),
                    SizedBox(height: height*0.01,),
                    Container(
                      height: height*0.12,
                      width: width*0.4,
                      child: AutoSizeText(
                        auctionItem.description,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: globalFontSize*12,
                        ),
                      ),
                    ),
                    Spacer(),
                    AutoSizeText(
                      dateFormat.format(auctionItem.date).toString(),
                      style: TextStyle(
                          fontSize: globalFontSize*12
                      ),
                    ),
                    SizedBox(height: height*0.01,),
                    AutoSizeText(
                      "\$${auctionItem.price.toString()}",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: globalFontSize*15
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        showBidClosed ? Card(
          child: Container(
            height: height*0.2,
            width: width,
            color: Colors.green[50],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AutoSizeText(
                  'Bid Closed',
                  style: TextStyle(
                    fontSize: globalFontSize*15,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width*0.38,
                      height: height*0.075,
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        "Won By",
                        style: TextStyle(
                          fontSize: globalFontSize*15,
                        ),
                      ),
                    ),
                    Container(
                      width: width*0.2,
                      height: height*0.075,
                      child: Icon(
                        Icons.arrow_right_alt_rounded,
                        size: width*0.15,
                      ),
                    ),
                    Container(
                      width: width*0.38,
                      height: height*0.075,
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        bidInfoModel!=null ? bidInfoModel.userEmail : "No Bidder",
                        style: TextStyle(
                          fontSize: globalFontSize*15,
                        ),
                      ),
                    ),
                  ],
                ),
                AutoSizeText(
                  bidInfoModel!=null ?
                  "\$${bidInfoModel.bidAmount}":"\$0",
                  style: TextStyle(
                    fontSize: globalFontSize*15,
                    color: Colors.deepPurple
                  ),
                ),
              ],
            ),
          ),
        ) : Divider(),
      ],
    ),
  );
}


Widget buildBidCard(BuildContext context, BidInfoModel bidInfoModel){
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final globalFontSize = MediaQuery.of(context).textScaleFactor;

  // getUserInfo(bidInfoModel.userUid);

  return Card(
    child: Container(
      color: Colors.blue[50],
      width: width,
      height: height*0.15,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            width: width*0.45,
            child: AutoSizeText(
              "\$${bidInfoModel.bidAmount.toString()}",
              style: TextStyle(
                fontSize: globalFontSize*15,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: width*0.5,
                height: height*0.075,
                alignment: Alignment.center,
                child: AutoSizeText(
                  bidInfoModel.userName,
                  style: TextStyle(
                    fontSize: globalFontSize*12,
                  ),
                ),
              ),
              Container(
                width: width*0.5,
                height: height*0.075,
                alignment: Alignment.center,
                child: AutoSizeText(
                  bidInfoModel.userEmail,
                  style: TextStyle(
                    fontSize: globalFontSize*12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Future getUserInfo(String userUid) async{
//   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(_appConfig.userCollection)
//     .doc(userUid)
//     .get();
//   print(documentSnapshot[_appConfig.userName]);
//   print(documentSnapshot[_appConfig.userEmail]);
// }