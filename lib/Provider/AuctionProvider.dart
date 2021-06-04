import 'package:ebay_clone/Models/AuctionItem.dart';
import 'package:flutter/material.dart';

class AuctionProvider with ChangeNotifier{
  String itemDocumentId;

  AuctionItem auctionItem;

  void setDocumentId(String documentId){
    this.itemDocumentId = documentId;
    notifyListeners();
  }

  void setAuctionItem(AuctionItem auctionItem){
    this.auctionItem = auctionItem;
    notifyListeners();
  }
}