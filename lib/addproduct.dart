import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'colors.dart';
import 'groupinENG.dart';

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
  final ProductDescriptioncontroller = TextEditingController();
  String ProductCategory;

  int radioGroup = 0;
  void radioEventHandler(int value){
    setState(() {
      radioGroup = value;
      switch(radioGroup){
        case 0:
          ProductCategory="book";
          break;
        case 1:
          ProductCategory="utility";
          break;
        case 2:
          ProductCategory="clothes";
          break;
        case 3:
          ProductCategory="furniture";
          break;
        case 4:
          ProductCategory="other";
          break;
        case 5:
          ProductCategory="house";
          break;
      }
    });
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>(); // 글자 채워졌는지

  File _image;

  final FirebaseUser user;
  final String group;
  String groupENG;

  _AddProductState(this.user, this.group);

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<Null> uploadFile() async{

    String groupENG=groupinEng(group);

    final StorageReference firebaseStorageRef=
    FirebaseStorage.instance.ref().child('post/'+ProductNamecontroller.text+".jpg"); //일단 app에 저장하게 끔 //start에서 스쿨마다 번호 주고 start파일 받아오는 방법.
    final StorageUploadTask task = firebaseStorageRef.putFile(_image);

    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    StorageMetadata created = await taskSnapshot.ref.getMetadata();

    final docRef = await Firestore.instance.collection('Post/'+groupENG+'/'+groupENG) //post id 자동 생성
        .add({
      'title': ProductNamecontroller.text,
      'price': int.tryParse(ProductPricecontroller.text),
      'content': ProductDescriptioncontroller.text,
      'creator_name': widget.user.displayName, //
      'creator_pic': widget.user.photoUrl, //
      'creator_uid': widget.user.uid, //
      'group': group, // 그룹으로 바꾸기
      'category': ProductCategory,
      'created': DateTime.fromMillisecondsSinceEpoch(created.creationTimeMillis, isUtc: true),
      'modified': DateTime.fromMillisecondsSinceEpoch(created.updatedTimeMillis, isUtc: true),
      'imgurl': [downloadUrl],
      });

    //post id가 다른 곳에 저장되어 있다.
    String postId = docRef.documentID;
    Firestore.instance.collection('Post/'+groupENG+'/'+groupENG).document(postId)
        .updateData({
      'postid': postId});

  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Add Product',
      home: new Scaffold(

        backgroundColor: AddAppbarIcon,

        appBar:AppBar(
          backgroundColor: AddAppbarIcon,
          leading:
          IconButton(
            color: MainOrangeColor,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              //Navigate detail
            },
          ),
          title: Text('판매하기',style: TextStyle(color: MainOrangeColor),),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                '저장',
                style: TextStyle(
                  fontSize: 15.0,
                  color: MainOrangeColor,
                ),
              ),
              onPressed: () {
                if(_formKey.currentState.validate()){
                  uploadFile();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),

        body: new Container(
          height: 20000.0,
          child: new Form(
            key: _formKey,
            autovalidate: true,
          child : ListView(
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

                    Text("사진을 선택해주세요",style: TextStyle(fontSize: 7.0,fontWeight: FontWeight.bold, color: MainOrangeColor),),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 7.0, 300.0, 7.0),
                child:
                Text("상품 기본정보",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11.0, color: MainOrangeColor,),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child:
                TextFormField(
                  validator: (value)
                  => value.isEmpty ? '상품명을 입력하세요':null,
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
                TextFormField(
                  validator: (value)
                  => value.isEmpty ? '가격을 입력하세요':null,
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
                padding: EdgeInsets.fromLTRB(10.0, 7.0, 300.0, 7.0),
                child:
                Text("상품 카테고리",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11.0, color: MainOrangeColor,),
                ),
              ),

              new Column(
                children: <Widget>[
                  new RadioListTile<int>(
                    value: 0,
                    groupValue: radioGroup,
                    onChanged: radioEventHandler ,
                    title: new Text('책'),
                    activeColor: MainOrangeColor,
                  ),
                  new RadioListTile<int>(
                    value: 1,
                    groupValue: radioGroup,
                    onChanged: radioEventHandler ,
                    title: new Text('생활 용품'),
                    activeColor: MainOrangeColor,
                  ),
                  new RadioListTile<int>(
                    value: 2,
                    groupValue: radioGroup,
                    onChanged: radioEventHandler ,
                    title: new Text('의류 및 잡화'),
                    activeColor: MainOrangeColor,
                  ),
                  new RadioListTile<int>(
                    value: 3,
                    groupValue: radioGroup,
                    onChanged: radioEventHandler ,
                    title: new Text('가전 및 가구'),
                    activeColor: MainOrangeColor,
                  ),
                  new RadioListTile<int>(
                    value: 4,
                    groupValue: radioGroup,
                    onChanged: radioEventHandler ,
                    title: new Text('기타'),
                    activeColor: MainOrangeColor,
                  ),
                  new RadioListTile<int>(
                    value: 5,
                    groupValue: radioGroup,
                    onChanged: radioEventHandler ,
                    title: new Text('부동산'),
                    activeColor: MainOrangeColor,
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 7.0, 300.0, 7.0),
                child:
                Text("상품 상세정보",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11.0,color: MainOrangeColor,),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                child:
                TextFormField(
                  validator: (value)
                  => value.isEmpty ? '상세 정보를 입력하세요':null,
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
