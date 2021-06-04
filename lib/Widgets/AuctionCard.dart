import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_clone/Models/AuctionItem.dart';
import 'package:ebay_clone/Screens/AuctionDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildAuctionCard(BuildContext context, AuctionItem auctionItem){
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final globalFontSize = MediaQuery.of(context).textScaleFactor;

  DateFormat dateFormat = DateFormat('dd-MMM-yyyy');

  return GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => AuctionDetailScreen()));
    },
    child: Card(
      elevation: 2,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(width*0.025),
            child: Container(
              width: width*0.5,
              height: height*0.25,
              decoration: BoxDecoration(
                color: Colors.red,
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
  );
}
