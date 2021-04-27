import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_demo/pages/post_detail_page.dart';

class PostAddPage extends StatefulWidget {
  @override
  _PostAddPageState createState() => new _PostAddPageState();
  static String routeName = "/postPage";
}

class _PostAddPageState extends State<PostAddPage> {
  String _title;
  double _price;
  String _desc;
  List<File> _imageList = new List();
  List<String> _imageUrl = new List();
  bool _isLoading = false;
  final databaseReference = Firestore.instance;

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  selectPhoto() async {
    if (_imageList.length >= 4) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Notice'),
                content: Text(('You can upload up to four pictures.')),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      return;
    }

    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
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

  takePhoto() async {
    if (_imageList.length >= 4) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Notice'),
                content: Text(('You can upload up to four pictures.')),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      return;
    }

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

  void uploadImage() async {
    if (_imageList == null || _imageList.length <= 0) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Notice'),
                content: Text(('You must submit at least 1 photo.')),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
      return;
    }
    setState(() {
      _isLoading = true;
    });
    if (_imageList != null && _imageList.length != 0) {
      for (var img in _imageList) {
        String fileName =
            UniqueKey().toString() + '_' + DateTime.now().toString() + '.jpg';
        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("clothing_sale")
            .child(fileName);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(img);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        print('File Uploaded');
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        _imageUrl.add(imageUrl.toString());
      }
    }

    await databaseReference.collection('clothing_items').add({
      'title': _title,
      'price': _price,
      'description': _desc,
      'images': _imageUrl,
    }).whenComplete(() => {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Yay! Submitted successfully!'),
          ))

          // showDialog(
          //     context: context,
          //     builder: (context) => AlertDialog(
          //           title: Text('Notice'),
          //           content: Text(('Submitted successfully!')),
          //           actions: <Widget>[
          //             new FlatButton(
          //               child: new Text("OK"),
          //               onPressed: () {
          //                 Navigator.of(context).pop();
          //                 Navigator.of(context).pop();
          //               },
          //             ),
          //           ],
          //         ))
        });
    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
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
      uploadImage();
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
              showCircularProgress(),
              showImageView(),
              showPhotoButton(),
              showGalleryButton(),
              showSubmitButton()
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
        maxLines: 3,
        minLines: 1,
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

  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showImageView() {
    return new Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: _imageList == null || _imageList.length == 0
            ? SizedBox(
                height: 20.0,
              )
            : Container(
                child: SizedBox(
                  height: 130,
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: List.generate(
                      _imageList.length,
                      (index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                              return Scaffold(
                                appBar: AppBar(
                                  title: const Text('Photo'),
                                ),
                                body: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: PhotoShowFromFile(
                                    photo: _imageList[index],
                                    //width: 300.0,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              );
                            }));
                          },
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.file(_imageList[index]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ));
  }

  Widget showPhotoButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Take Photo',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: takePhoto,
          ),
        ));
  }

  Widget showGalleryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Select Photo',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: selectPhoto,
          ),
        ));
  }

  Widget showSubmitButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Post',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: submit,
          ),
        ));
  }
}
