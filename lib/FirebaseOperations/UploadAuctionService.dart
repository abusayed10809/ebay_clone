import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_clone/Config/AppConfig.dart';
import 'package:ebay_clone/Models/AuctionItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadAuctionService{

  AppConfig _appConfig = new AppConfig();

  Future uploadAuction(AuctionItem auctionItem, File imageFile) async{
    String timePath = DateTime.now().millisecondsSinceEpoch.toString();
    String currentUserUid = FirebaseAuth.instance.currentUser.uid;

    UploadTask uploadTask;

    Reference reference = FirebaseStorage.instance
        .ref()
        .child("${_appConfig.auctionImageBaseUrl}/$currentUserUid/$timePath");

    uploadTask = reference.putFile(imageFile);

    await uploadTask.whenComplete((){
      reference.getDownloadURL().then((imageUrl){
        auctionItem.imagePath = imageUrl;
        auctionItem.currentUserUid = currentUserUid;
        FirebaseFirestore.instance
            .collection(_appConfig.auctionPostCollection)
            .add({
          _appConfig.currentUserUid: auctionItem.currentUserUid,
          _appConfig.itemName: auctionItem.name,
          _appConfig.itemDescription: auctionItem.description,
          _appConfig.itemPrice: auctionItem.price,
          _appConfig.itemDate: auctionItem.date,
          _appConfig.itemImageUrl: auctionItem.imagePath,
        });
      });
    }).catchError((onError){
      Fluttertoast.showToast(
          msg: onError.message.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15
      );
    });

    print(auctionItem.name);
    print(auctionItem.description);
    print(auctionItem.price.toString());
    print(auctionItem.date.toString());
    print(timePath);
  }
}