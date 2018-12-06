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

    return Scaffold(
      backgroundColor: AddAppbarIcon,
      appBar:AppBar(
        elevation: 2.0,
        backgroundColor: AddAppbarIcon,
        leading:
        IconButton(
          color: MainDarkColor2,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            //Navigate detail
          },
        ),
        title: Text('판매하기',style: Theme.of(context).textTheme.headline,),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              '저장',
              style: Theme.of(context).textTheme.headline,
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

                  _image == null
                  ? Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 80.0, 8.0, 100.0),
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.all(2.0),
                          onPressed: getImage,
                          icon: Icon(Icons.camera_alt),
                          iconSize: 40.0,
                        ),
                        Text("사진을 선택해주세요",style: Theme.of(context).textTheme.body2,),
                      ],
                    ),
                  )
                  : enableUpload(),

            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 7.0, 10.0, 7.0),
              child:
              Text("상품 기본정보", style: Theme.of(context).textTheme.title),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child:
              TextFormField(
                validator: (value)
                => value.isEmpty ? '상품명을 입력하세요':null,
                decoration: InputDecoration(
//                    border: OutlineInputBorder(),
                    hintText: '상품명 입력', hintStyle: Theme.of(context).textTheme.body2),
                controller: ProductNamecontroller,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child:
              TextFormField(
                keyboardType: TextInputType.number,///////////////////////////////////
                validator: (value)
                => value.isEmpty ? '가격을 입력하세요':null,
                decoration: InputDecoration(
//                    border: OutlineInputBorder(),
                    hintText: '가격 입력', hintStyle: Theme.of(context).textTheme.body2),
                controller: ProductPricecontroller,
              ),
            ),
            SizedBox(height: 40.0),

            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 7.0, 10.0, 7.0),
              child:
              Text("상품 카테고리", style: Theme.of(context).textTheme.title),
            ),

            new Column(
              children: <Widget>[
                new RadioListTile<int>(
                  value: 0,
                  groupValue: radioGroup,
                  onChanged: radioEventHandler ,
                  title: new Text('책', style: Theme.of(context).textTheme.body1),
                  activeColor: MainOrangeColor,
                ),
                new RadioListTile<int>(
                  value: 1,
                  groupValue: radioGroup,
                  onChanged: radioEventHandler ,
                  title: new Text('생활 용품', style: Theme.of(context).textTheme.body1),
                  activeColor: MainOrangeColor,
                ),
                new RadioListTile<int>(
                  value: 2,
                  groupValue: radioGroup,
                  onChanged: radioEventHandler ,
                  title: new Text('의류 및 잡화', style: Theme.of(context).textTheme.body1),
                  activeColor: MainOrangeColor,
                ),
                new RadioListTile<int>(
                  value: 3,
                  groupValue: radioGroup,
                  onChanged: radioEventHandler ,
                  title: new Text('가전 및 가구', style: Theme.of(context).textTheme.body1),
                  activeColor: MainOrangeColor,
                ),
                new RadioListTile<int>(
                  value: 4,
                  groupValue: radioGroup,
                  onChanged: radioEventHandler ,
                  title: new Text('기타', style: Theme.of(context).textTheme.body1),
                  activeColor: MainOrangeColor,
                ),
                new RadioListTile<int>(
                  value: 5,
                  groupValue: radioGroup,
                  onChanged: radioEventHandler ,
                  title: new Text('부동산', style: Theme.of(context).textTheme.body1),
                  activeColor: MainOrangeColor,
                ),
              ],
            ),
            SizedBox(height: 40.0),

            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 7.0, 10.0, 7.0),
              child:
              Text("상품 상세정보", style: Theme.of(context).textTheme.title),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              child:
              TextFormField(
                validator: (value)
                => value.isEmpty ? '상세 정보를 입력하세요':null,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),

                  hintText: '상세 정보 입력',
                  hintStyle: Theme.of(context).textTheme.body2
                ),
                controller: ProductDescriptioncontroller,
              ),
            ),
            SizedBox(height: 50.0),


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
