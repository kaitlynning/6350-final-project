import 'package:flutter_login_demo/components/authentication.dart';
import 'package:flutter_login_demo/pages/login_signup_page.dart';
import 'package:flutter_login_demo/pages/post_add_page.dart';
import 'package:flutter_login_demo/pages/postdetail_record.dart';
import 'package:flutter_login_demo/pages/style.dart';
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
      floatingActionButton: ToPostPage(),
    );
  }
}

class ToPostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ToPostPageState();
  }
}

class _ToPostPageState extends State<ToPostPage> {
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
          //showNewPost.invokeMethod('browse_to_new');
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new PostAddPage()),
          );
        });
  }
}

class GetPosts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _GetPostsState();
  }
}

class _GetPostsState extends State<GetPosts> {
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('clothing_items').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return new ListView(
      padding: const EdgeInsets.all(16.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    PostDetail postItem = new PostDetail(
        record.title, record.price, record.description, record.photos);
    MyTextStyle textStyle = new MyTextStyle();

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Image.network('${record.photos[0]}'),
              title: new Text(
                '${record.title}',
                style: textStyle.get('title'),
              ),
              subtitle: new Text(
                '${record.description}',
                maxLines: 2,
                style: textStyle.get('description'),
              ),
            ),
            ButtonBarTheme(
              data: ButtonBarThemeData(buttonTextTheme: ButtonTextTheme.accent),
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('View detail'),
                    onPressed: () {
                      //TODO: see details of browse_page
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) {
                        return DetailPage(
                          postDetail: postItem,
                        );
                      }));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}

class DetailPage extends StatefulWidget {
  final PostDetail postDetail;
  static String routeName = "/detailPage";

  const DetailPage({
    Key key,
    @required this.postDetail,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DetailPageState(postDetail);
  }
}

class _DetailPageState extends State<DetailPage> {
  PostDetail postDetail;
  MyTextStyle textStyle = new MyTextStyle();

  _DetailPageState(PostDetail postDetail) {
    this.postDetail = postDetail;
  }

  Widget titleSection() {
    return new Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*1*/
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /*2*/
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${postDetail.title}',
                  style: textStyle.get('price'),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '\$${postDetail.price}',
                  style: textStyle.get('price'),
                ),
              ),
            ],
          ),
          /*3*/

          new Text(
            '${postDetail.description}',
            style: textStyle.get('description'),
          ),
//          new Container(
//            height: 100,
//            child: new ListView(
//              children: <Widget>[
//                new Text(
//                  '${postDetail.description}',
//                  style: textStyle.get('description'),
//                ),
//              ],
//            ),
//          ),
        ],
      ),
    );
  }

//  Widget titleSection () {
//    return new Container(
//      padding: const EdgeInsets.all(32),
//      child: Row(
//        children: [
//          Expanded(
//            /*1*/
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                /*2*/
//                Container(
//                  padding: const EdgeInsets.only(bottom: 8),
//                  child: Text(
//                    '${postDetail.title}',
//                    style: textStyle.get('title'),
//                  ),
//                ),
//                Text(
//                  '${postDetail.description}',
//                  style: textStyle.get('description'),
//                ),
//              ],
//            ),
//          ),
//          /*3*/
//          new Text(
//            '\$${postDetial.price}',
//            style: textStyle.get('price'),
//          ),
//        ],
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title:
            new Text("PostDetail", style: new TextStyle(color: Colors.white)),
      ),
      body: new Column(
        children: <Widget>[
          titleSection(),
          Expanded(
            child: new Container(
              margin: new EdgeInsets.symmetric(vertical: 10),
              height: 500,
              child: photoSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget photoSection() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 5,
      primary: false,
      children: _getGrid(),
      shrinkWrap: true,
    );
  }

  List<Widget> _getGrid() {
    List<Widget> gridList = new List();
    List<String> photoList = postDetail.pathList;
    for (int i = 0; i < photoList.length && i < 4; i++) {
      gridList.add(photoGridItem(photoList[i]));
    }
    return gridList;
  }

  Widget photoGridItem(String path) {
    return Container(
      child: PhotoHero(
        photo: path,
        //width: 100.0,
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Photo'),
              ),
              body: Container(
                // Set background to blue to emphasize that it's a new route.
                color: Colors.transparent,
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: PhotoHero(
                  photo: path,
                  //width: 300.0,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          }));
        },
      ),
    );
    //return Text("test");
  }
}

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.photo, this.onTap, this.width})
      : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.network(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
