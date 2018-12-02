import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddProductPage extends StatefulWidget{
  final FirebaseUser user;
  final String group;

  AddProductPage({Key key, this.user, this.group}) : super(key: key);
  @override
  _AddProductState createState() => _AddProductState(user, group);
}

class _AddProductState extends State<AddProductPage>{

  final ProductNamecontroller = TextEditingController();
  final ProductPricecontroller = TextEditingController();
  final ProductCategorycontroller = TextEditingController();
  final ProductTagcontroller = TextEditingController();
  final ProductDescriptioncontroller = TextEditingController();

  File _image;

  final FirebaseUser user;
  final String group;

  _AddProductState(this.user, this.group);

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<Null> uploadFile() async{

    final StorageReference firebaseStorageRef=
    FirebaseStorage.instance.ref().child("/app"+ProductNamecontroller.text+".jpg"); //일단 app에 저장하게 끔 //start에서 스쿨마다 번호 주고 start파일 받아오는 방법.
    final StorageUploadTask task = firebaseStorageRef.putFile(_image);

    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    StorageMetadata created = await taskSnapshot.ref.getMetadata();

    Firestore.instance.collection('picture').document(ProductNamecontroller.text)
        .setData({
      'name': ProductNamecontroller.text,
      'price': int.tryParse(ProductPricecontroller.text),
      'description': ProductDescriptioncontroller.text,
      'creator': widget.user.uid,
      'createdtime': DateTime.fromMillisecondsSinceEpoch(created.creationTimeMillis, isUtc: true).toString(),
      'uploadedtime': DateTime.fromMillisecondsSinceEpoch(created.updatedTimeMillis, isUtc: true).toString(),
      'url': downloadUrl});
  }
  //firebase 정보 넣기!

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Add Product',
      home: new Scaffold(

        backgroundColor: AddProductBackground,

        appBar:AppBar(
          backgroundColor: AddProductBackground,
          leading: IconButton(
            color: AddIcon,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              //Navigate detail
            },
          ),
          title: Text('판매하기',style: TextStyle(color: AddIcon),),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                '저장',
                style: TextStyle(
                  fontSize: 15.0,
                  color: AddIcon,
                ),
              ),
              onPressed: () {
                uploadFile();
              },
            ),
          ],
        ),

        body: new Container(
          height: 20000.0,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                child: Column(
                  children: <Widget>[
                    _image == null
                        ? FlatButton(
                      padding: EdgeInsets.all(2.0),
                      onPressed: getImage,
                      child: new Image.network("https://firebasestorage.googleapis.com/v0/b/mobile-app-project-6d4ab.appspot.com/o/app%2Fdefault.png?alt=media&token=f6037981-101d-4518-a98d-9f75aa185f0b",
                        width: 350.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    )
                        : enableUpload(),

                    Text("사진을 선택해주세요",style: TextStyle(fontSize: 7.0,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 7.0, 300.0, 7.0),
                child:
                Text("상품 기본정보",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11.0,),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child:
                TextField(
                  style: TextStyle(
                    color: AddIcon,
                    fontSize: 9.0,
                    height: 0.1,
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '상품명 입력'),
                  controller: ProductNamecontroller,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child:
                TextField(
                  style: TextStyle(
                    color: AddIcon,
                    fontSize: 9.0,
                    height: 0.1,
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '가격 입력'),
                  controller: ProductPricecontroller,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child:
                TextField(
                  style: TextStyle(
                    color: AddIcon,
                    fontSize: 9.0,
                    height: 0.1,
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '카테고리/세부 카테고리 선택'),
                  controller: ProductCategorycontroller,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child:
                TextField(
                  style: TextStyle(
                    color: AddIcon,
                    fontSize: 9.0,
                    height: 0.1,
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '#태그 입력'),
                  controller: ProductTagcontroller,
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 7.0, 300.0, 7.0),
                child:
                Text("상품 상세정보",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11.0,),
                ),
              ),



              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child:
                TextField(
                  style: TextStyle(
                    color: AddIcon,
                    fontSize: 9.0,
                    height: 3.0,
                  ),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '상세 정보 입력'),
                  controller: ProductDescriptioncontroller,
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget enableUpload(){
    return Container(
        child: Column(
          children: <Widget>[
            Image.file(_image, height: 300.0, width: 300.0,),
          ],
        )
    );
  }
}