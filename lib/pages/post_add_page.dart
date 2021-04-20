import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostAddPage extends StatefulWidget {
  @override
  _PostAddPageState createState() => new _PostAddPageState();
}

class _PostAddPageState extends State<PostAddPage> {
  String _title;
  double _price;
  String _desc;
  List<File> _imageList;

  final _formKey = GlobalKey<FormState>();

  takePhoto() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      //imagesMap[imagesMap.length] = file;
      List<File> imageFile = new List();
      // imageList = new List.from(imageFile);
      imageFile.add(file);
      if (_imageList == null) {
        _imageList = new List.from(imageFile, growable: true);
      } else {
        for (int s = 0; s < imageFile.length; s++) {
          _imageList.add(file);
        }
      }
      setState(() {});
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void submit() {
    if (validateAndSave()) {
      print(_title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post New Clothing'),
      ),
      body: Stack(
        children: <Widget>[
          _showForm(),
        ],
      ),
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showTitleInput(),
              showPriceInput(),
              showDescInput(),
              showButton()
            ],
          ),
        ));
  }

  Widget showTitleInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Title',
            icon: new Icon(
              Icons.assistant,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Title can\'t be empty' : null,
        onSaved: (value) => _title = value.trim(),
      ),
    );
  }

  Widget showPriceInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Price',
            icon: new Icon(
              Icons.money,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Price can\'t be empty' : null,
        onSaved: (value) => _price = double.parse(value),
      ),
    );
  }

  Widget showDescInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        keyboardType: TextInputType.multiline,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Description',
            icon: new Icon(
              Icons.assignment_rounded,
              color: Colors.grey,
            )),
        validator: (value) =>
            value.isEmpty ? 'Description can\'t be empty' : null,
        onSaved: (value) => _desc = value.trim(),
      ),
    );
  }

  Widget showButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Post',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: takePhoto,
          ),
        ));
  }
}
