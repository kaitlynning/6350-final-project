import 'package:flutter_login_demo/components/authentication.dart';
import 'package:flutter_login_demo/pages/login_signup_page.dart';
import 'package:flutter_login_demo/pages/post_add_page.dart';
import 'package:flutter_login_demo/pages/post_detail_page.dart';
import 'package:flutter_login_demo/pages/post_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BrowsePage extends StatefulWidget {
  static String routeName = "/browsePage";
  BrowsePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() {
    return new _BrowsePageState();
  }
}

class _BrowsePageState extends State<BrowsePage> {
  var _browseScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _browseScaffoldKey,
      appBar: new AppBar(
        title: new Text("Clothing Sales",
            style: new TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginSignupPage.routeName, (Route<dynamic> route) => false);
            },
            child: Text(
              "Log out",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: GetPosts(),
      floatingActionButton: ToPostAddPage(),
    );
  }
}

class ToPostAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ToPostAddPageState();
  }
}

class _ToPostAddPageState extends State<ToPostAddPage> {
  @override
  Widget build(BuildContext context) {
    const showNewPost = const MethodChannel('browse.plugin');

    return new FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        elevation: 7.0,
        highlightElevation: 14.0,
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new PostAddPage()),
          );
        });
  }
}
