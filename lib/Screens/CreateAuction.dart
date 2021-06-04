import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ebay_clone/FirebaseOperations/UploadAuctionService.dart';
import 'package:ebay_clone/Models/AuctionItem.dart';
import 'package:ebay_clone/Screens/HomeScreen.dart';
import 'package:ebay_clone/Widgets/CustomTextField.dart';
import 'package:ebay_clone/Widgets/SharedWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateAuction extends StatefulWidget {
  @override
  _CreateAuctionState createState() => _CreateAuctionState();
}

class _CreateAuctionState extends State<CreateAuction> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();

  File _imageFile;
  DateFormat formatter;
  String date;
  DateTime endDate;

  bool isLoading = false;

  UploadAuctionService _uploadAuctionService = new UploadAuctionService();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final globalFontSize = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle('Create Auction', globalFontSize),
      ),

      body: SingleChildScrollView(
        child: isLoading==true ?
        Center(
          child: SpinKitDoubleBounce(
            color: Colors.deepPurple,
          ),
        )
            :
        Column(
          children: [
            GestureDetector(
              onTap: () async{
                await _selectImage();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width*0.01, vertical: width*0.02),
                width: width,
                height: height*0.4,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                  image: _imageFile!=null ? DecorationImage(
                      image: FileImage(
                        _imageFile,
                      ),
                      fit: BoxFit.fill
                  ) : null,
                ),
                child: _imageFile==null ? Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.deepPurple,
                  size: width*0.3,
                ) : null,
                // Image.file(_imageFile, width: width*0.9, height: height*0.4,),
              ),
            ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.drive_file_rename_outline,
                    hintText: "Name",
                    isObsecure: false,
                    textInputType: TextInputType.name,
                  ),

                  CustomTextField(
                    controller: _descriptionTextEditingController,
                    data: Icons.drive_file_rename_outline,
                    hintText: "Description",
                    isObsecure: false,
                    textInputType: TextInputType.name,
                  ),

                  CustomTextField(
                    controller: _priceTextEditingController,
                    data: Icons.attach_money,
                    hintText: "Min Bid Price",
                    isObsecure: false,
                    textInputType: TextInputType.datetime,
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () async{
                await _selectDate(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width*0.01),
                child: Container(
                  width: width,
                  height: height*0.075,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width*0.025),
                        child: Icon(
                          Icons.date_range,
                          color: Colors.deepPurple,
                        ),
                      ),
                      AutoSizeText(
                        date==null ? 'Pick End Date' : date,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: globalFontSize*12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: height*0.05,
            ),

            GestureDetector(
              onTap: () async{
                if(!_formKey.currentState.validate()){
                  Fluttertoast.showToast(
                    msg: "Form not validated,",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: globalFontSize*15,
                  );
                }
                else if(date==null){
                  Fluttertoast.showToast(
                    msg: "Please pick a date,",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: globalFontSize*15,
                  );
                }
                else if(_imageFile==null){
                  Fluttertoast.showToast(
                      msg: "Please select an image.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: globalFontSize*15
                  );
                }
                else{
                  setState(() {
                    isLoading = true;
                  });
                  AuctionItem auctionItem = new AuctionItem();
                  auctionItem.name = _nameTextEditingController.text.trim();
                  auctionItem.description = _descriptionTextEditingController.text.trim();
                  auctionItem.price = int.parse(_priceTextEditingController.text.trim());
                  auctionItem.date = endDate;
                  await _uploadAuctionService.uploadAuction(auctionItem, _imageFile);
                  setState(() {
                    isLoading = false;
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: "Post has been uploaded.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: globalFontSize*15
                    );
                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                  });
                }
              },
              child: Container(
                width: width*0.4,
                height: height*0.06,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: AutoSizeText(
                  'Submit',
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


  Future<void> _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null){
      setState(() {
        endDate = picked;
        formatter = DateFormat('dd-MMM-yyyy');
        date = formatter.format(picked);
      });
    }
  }


  Future _selectImage() async{
    ImagePicker _picker = ImagePicker();
    var pickedImage = await _picker.getImage(source: ImageSource.gallery);
    if(_picker != null){
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }
}
