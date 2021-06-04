import 'package:ebay_clone/Widgets/SharedWidgets.dart';
import 'package:flutter/material.dart';

class AuctionDetailScreen extends StatefulWidget {
  @override
  _AuctionDetailScreenState createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final globalFontSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle("Auction Bid", globalFontSize),
      ),
    );
  }
}
