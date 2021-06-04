import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_clone/Config/AppConfig.dart';

AppConfig _appConfig = new AppConfig();

class AuctionItem{

  String name;
  String description;
  int price;
  DateTime date;
  String imagePath;
  String currentUserUid;

  AuctionItem.jsonToString(QueryDocumentSnapshot documentSnapshot){
    this.name = documentSnapshot[_appConfig.itemName];
    this.description = documentSnapshot[_appConfig.itemDescription];
    this.price = documentSnapshot[_appConfig.itemPrice];
    this.date = documentSnapshot[_appConfig.itemDate].toDate();
    this.imagePath = documentSnapshot[_appConfig.itemImageUrl];
    this.currentUserUid = documentSnapshot[_appConfig.currentUserUid];
  }

  AuctionItem({this.name, this.description, this.date, this.price, this.imagePath, this.currentUserUid});
}