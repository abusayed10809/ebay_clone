import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_clone/Config/AppConfig.dart';

AppConfig _appConfig = AppConfig();

class BidInfoModel{
  String userUid;
  int bidAmount;
  String userName;
  String userEmail;
  BidInfoModel({this.userUid, this.bidAmount, this.userName, this.userEmail});

  BidInfoModel.jsonToString(QueryDocumentSnapshot documentSnapshot){
    this.userUid = documentSnapshot[_appConfig.currentUserUid];
    this.bidAmount = documentSnapshot[_appConfig.bidAmount];
    this.userName = documentSnapshot[_appConfig.userName];
    this.userEmail = documentSnapshot[_appConfig.userEmail];
  }

}