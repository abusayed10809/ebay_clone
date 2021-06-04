import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_clone/Config/AppConfig.dart';
import 'package:ebay_clone/Models/AuctionItem.dart';
import 'package:ebay_clone/Models/BidInfoModel.dart';
import 'package:ebay_clone/Provider/AuctionProvider.dart';
import 'package:ebay_clone/Widgets/AuctionCard.dart';
import 'package:ebay_clone/Widgets/AuctionCardDetailed.dart';
import 'package:ebay_clone/Widgets/CustomTextField.dart';
import 'package:ebay_clone/Widgets/SharedWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AuctionDetailScreen extends StatefulWidget {
  @override
  _AuctionDetailScreenState createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {

  AppConfig _appConfig = new AppConfig();
  TextEditingController _bidTextEditingController = new TextEditingController();

  AuctionItem auctionItemDetail = new AuctionItem();
  String documentId = "";

  bool showBidClosed = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final globalFontSize = MediaQuery.of(context).textScaleFactor;

    Provider.of<AuctionProvider>(context);
    auctionItemDetail = Provider.of<AuctionProvider>(context, listen: false).auctionItem;
    documentId = Provider.of<AuctionProvider>(context, listen: false).itemDocumentId;

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle("Auction Bid", globalFontSize),
      ),

      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: getAuctionBid(),
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
                      itemCount: snapshot.data.size+1,
                      itemBuilder: ((BuildContext context, int index){
                        showBidClosed = DateTime.now().isAfter(auctionItemDetail.date.add(Duration(days: 1)));
                        if(index==0){
                          BidInfoModel bidInfoModel;
                          if(snapshot.data.docs.isNotEmpty){
                            bidInfoModel = BidInfoModel.jsonToString(snapshot.data.docs[0]);
                          }
                          return buildAuctionCardDetailed(context, auctionItemDetail, showBidClosed, bidInfoModel);
                        }
                        else if(!showBidClosed){
                          BidInfoModel bidInfoModel = BidInfoModel.jsonToString(snapshot.data.docs[index-1]);
                          return buildBidCard(context, bidInfoModel);
                        }
                        else{
                          return Container();
                        }
                      }),
                    );
                  }
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          String currentUserUid = FirebaseAuth.instance.currentUser.uid;
          if(currentUserUid==auctionItemDetail.currentUserUid){
            Fluttertoast.showToast(
                msg: "Your cannot bid on your own post.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: globalFontSize*15
            );
          }
          else if(DateTime.now().isAfter(auctionItemDetail.date.add(Duration(days: 1)))){
            Fluttertoast.showToast(
                msg: "Cannot bid, date expired",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: globalFontSize*15
            );
          }
          else{
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context){
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      width: width,
                      height: height*0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AutoSizeText(
                            'Enter bid amount',
                            style: TextStyle(
                              fontSize: globalFontSize*20,
                            ),
                          ),
                          CustomTextField(
                            controller: _bidTextEditingController,
                            data: Icons.attach_money,
                            hintText: 'Bid amount',
                            isObsecure: false,
                            textInputType: TextInputType.datetime,
                          ),
                          GestureDetector(
                            onTap: () async{
                              int bidAmount = int.parse(_bidTextEditingController.text.trim());
                              if(bidAmount>=auctionItemDetail.price){
                                Navigator.pop(context);
                                await confirmBidAmount(bidAmount);
                              }
                              else{
                                Fluttertoast.showToast(
                                    msg: "Your bid must be greater than minimum bid amount",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: globalFontSize*15
                                );
                              }
                              _bidTextEditingController.text = "";
                            },
                            child: Container(
                              width: width*0.4,
                              height: height*0.06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.green,
                              ),
                              child: AutoSizeText(
                                'Confirm Bid',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: globalFontSize*15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
          }
        },
        child: Icon(
          Icons.monetization_on,
          size: width*0.1,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Stream<QuerySnapshot> getAuctionBid() async*{
    yield* FirebaseFirestore.instance.collection(_appConfig.auctionBidCollection)
        .doc(documentId)
        .collection(_appConfig.individualBidCollection)
        .orderBy(_appConfig.bidAmount, descending: true)
        .snapshots();
  }

  Future confirmBidAmount(int bidAmount) async{
    String currentUserUid = FirebaseAuth.instance.currentUser.uid;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection(_appConfig.userCollection)
        .doc(currentUserUid)
        .get();
    print(documentSnapshot[_appConfig.userName]);
    print(documentSnapshot[_appConfig.userEmail]);

    String userName = documentSnapshot[_appConfig.userName];
    String userEmail = documentSnapshot[_appConfig.userEmail];

    await FirebaseFirestore.instance.collection(_appConfig.auctionBidCollection)
        .doc(documentId)
        .collection(_appConfig.individualBidCollection)
        .doc(currentUserUid)
        .set(
      {
        _appConfig.currentUserUid: currentUserUid,
        _appConfig.bidAmount: bidAmount,
        _appConfig.userName: userName,
        _appConfig.userEmail: userEmail,
      }
    );
  }
}
