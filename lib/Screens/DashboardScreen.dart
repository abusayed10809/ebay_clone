import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_clone/Config/AppConfig.dart';
import 'package:ebay_clone/Widgets/SharedWidgets.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<charts.Series<Sales, int>> _seriesLineData;

  _generateData() {
    var linesalesdata = [
      new Sales(0, 20),
      new Sales(20, 56),
      new Sales(50, 55),
      new Sales(70, 60),
      new Sales(80, 61),
      new Sales(100, 70),
    ];
    var linesalesdata1 = [
      new Sales(0, 35),
      new Sales(20, 46),
      new Sales(50, 45),
      new Sales(70, 50),
      new Sales(80, 51),
      new Sales(100, 60),
    ];

    var linesalesdata2 = [
      new Sales(0, 20),
      new Sales(20, 24),
      new Sales(50, 25),
      new Sales(70, 40),
      new Sales(80, 45),
      new Sales(100, 60),
    ];

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Air Pollution',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Air Pollution1',
        data: linesalesdata1,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution2',
        data: linesalesdata2,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesLineData = [];
    _generateData();

    _getAuctionData();
    _getCompletedData();
    _getTotalBidCost();
  }

  AppConfig _appConfig = new AppConfig();
  int runningAuction = 0;
  int completedAuction = 0;
  int totalBidValue = 0;

  List<String> documentIdList = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final globalFontSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('Dashboard', globalFontSize),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              height: height*0.5,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AutoSizeText(
                                  'Running Bids',
                                  style: TextStyle(
                                    fontSize: globalFontSize*15,
                                  ),
                                ),
                                AutoSizeText(
                                  '$runningAuction',
                                  style: TextStyle(
                                    fontSize: globalFontSize*20,
                                    color: Colors.deepPurple
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AutoSizeText(
                                  'Completed Bids',
                                  style: TextStyle(
                                    fontSize: globalFontSize*15,
                                  ),
                                ),
                                AutoSizeText(
                                  '$completedAuction',
                                  style: TextStyle(
                                    fontSize: globalFontSize*20,
                                      color: Colors.deepPurple
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width*0.1),
                            child: AutoSizeText(
                              'Total bid amount',
                              style: TextStyle(
                                fontSize: globalFontSize*15,
                              ),
                            ),
                          ),
                          AutoSizeText(
                            '\$$totalBidValue',
                            style: TextStyle(
                              fontSize: globalFontSize*20,
                                color: Colors.deepPurple
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: width,
              height: height*0.7,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: height*0.025),
                child: charts.LineChart(
                    _seriesLineData,
                    defaultRenderer: charts.LineRendererConfig(
                        includeArea: true, stacked: false),
                    animate: true,
                    animationDuration: Duration(seconds: 3),
                    behaviors: [
                      charts.ChartTitle('Days',
                          behaviorPosition: charts.BehaviorPosition.bottom,
                          titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
                      charts.ChartTitle('Auctions',
                          behaviorPosition: charts.BehaviorPosition.start,
                          titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                      charts.ChartTitle('Departments',
                        behaviorPosition: charts.BehaviorPosition.end,
                        titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
                      )
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getTotalBidCost() async{
    await FirebaseFirestore.instance.collection(_appConfig.totalBidCollection)
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        print(doc.id);
        if(documentIdList.contains(doc.id)){
          int price = doc.data()[_appConfig.bidAmount];
          setState(() {
            totalBidValue += price;
          });
        }
      });
    });
  }

  _getCompletedData() async{
    await FirebaseFirestore.instance.collection(_appConfig.auctionPostCollection)
        .where(_appConfig.itemDate, isLessThanOrEqualTo: DateTime.now().add(Duration(days: -1)))
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        setState(() {
          documentIdList.add(doc.id);
          completedAuction++;
        });
      });
    });
  }

  _getAuctionData() async{
    // QueryDocumentSnapshot documentSnapshot;
    await FirebaseFirestore.instance.collection(_appConfig.auctionPostCollection)
        .where(_appConfig.itemDate, isGreaterThan: DateTime.now().add(Duration(days: -1)))
        .get()
        .then((QuerySnapshot querySnapshot){
          querySnapshot.docs.forEach((doc) {
            setState(() {
              runningAuction++;
            });
          });
    });
  }

  // Future _getAuctionData() async{
  //   int activeLength = await FirebaseFirestore.instance.collection(_appConfig.auctionPostCollection)
  //       .where(_appConfig.itemDate, isGreaterThan: DateTime.now())
  //       .snapshots().length;
  //
  //   int inactiveLength = await FirebaseFirestore.instance.collection(_appConfig.auctionPostCollection)
  //       .where(_appConfig.itemDate, isLessThan: DateTime.now())
  //       .snapshots().length;
  //
  //   print("total posts active");
  //   print(activeLength);
  //   print("total inactive posts");
  //   print(inactiveLength);
  //
  //   // int bidValue = await FirebaseFirestore.instance.collection(_appConfig.auctionPostCollection)
  //   //     .where(_appConfig.itemDate, isLessThan: DateTime.now())
  //   //     .snapshots().length;
  //   //
  //   // FirebaseFirestore.instance.collection(_appConfig.auctionBidCollection)
  //   //   .snapshots();
  //       // .collection(_appConfig.individualBidCollection)
  //       // .orderBy(_appConfig.bidAmount, descending: true)
  //       // .snapshots();
  //
  //   setState(() {
  //     runningAuction = activeLength;
  //     completedAuction = inactiveLength;
  //   });
  // }

  // Stream<QuerySnapshot> _getAuctionData() async*{
  //   yield* FirebaseFirestore.instance.collection(_appConfig.auctionPostCollection)
  //       .where(_appConfig.itemDate, isGreaterThan: DateTime.now())
  //       .snapshots();
  // }
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}
