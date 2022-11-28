

import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(new MaterialApp(
    title: "low light image enhancement app",
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late File imageFile;

  _openGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    var selectedimage = await _picker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(selectedimage!.path);
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    var selectedimage = await _picker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(selectedimage!.path);
    });
    Navigator.of(context).pop();
  }


  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Make a choice"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                child: Text("Gallery"),
                onTap: (){
                  _openGallery(context);
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text("Camera"),
                onTap: (){
                  _openCamera(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _decideImagetoView(){
    if(imageFile==null){
      return Text("No Image Selected!");
    }
    else{
      return Image.file(imageFile,width:400,height: 400,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _decideImagetoView(),
              ElevatedButton(onPressed: (){
                _showChoiceDialog(context);

              },
               child:Text("Select Image"),)
            ],
          ),
        ),
      ),
    );
  }
}


