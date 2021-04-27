import 'package:flutter_login_demo/components/authentication.dart';
import 'package:flutter_login_demo/pages/login_signup_page.dart';
import 'package:flutter_login_demo/pages/post_add_page.dart';
import 'package:flutter_login_demo/pages/post_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';

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
          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${postDetail.title}',
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '\$${postDetail.price}',
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          new Text(
            '${postDetail.description}',
            style: new TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Clothing Detail",
            style: new TextStyle(color: Colors.white)),
      ),
      body: new Column(
        children: <Widget>[
          titleSection(),
          Expanded(
            child: new Container(
              margin: new EdgeInsets.symmetric(vertical: 10),
              height: 500,
              child: new Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return new Image.network(
                    postDetail.pathList[index],
                    fit: BoxFit.cover,
                  );
                },
                onTap: (index) {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Photo'),
                      ),
                      body: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.center,
                        child: PhotoShowFromURL(
                          photo: postDetail.pathList[index],
                          //width: 300.0,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    );
                  }));
                },
                itemCount: postDetail.pathList.length,
                viewportFraction: 0.8,
                scale: 0.9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget photoGridItem(String path) {
    return Container(
      child: PhotoShowFromURL(
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
                color: Colors.transparent,
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: PhotoShowFromURL(
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

class PhotoShowFromURL extends StatelessWidget {
  const PhotoShowFromURL({Key key, this.photo, this.onTap, this.width})
      : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(imageUrl);
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

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

class PhotoShowFromFile extends StatelessWidget {
  const PhotoShowFromFile({Key key, this.photo, this.onTap, this.width})
      : super(key: key);

  final File photo;
  final VoidCallback onTap;
  final double width;

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(imageUrl);
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.file(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class GetPosts extends StatefulWidget {
  // @override
  // State<StatefulWidget> createState() {
  //   return new _GetPostsState();
  // }

  @override
  State<GetPosts> createState() => _GetPostsState();
}

class _GetPostsState extends State<GetPosts> {
  final _saved = <String>{};
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
    final alreadySaved = _saved.contains(record.photos[0].toString());

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Image.network('${record.photos[0]}'),
              title: new Text(
                '${record.title}',
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: new Text(
                '${record.description}',
                maxLines: 2,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
              ),
              onTap: () {
                // NEW lines from here...
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(record.photos[0].toString());
                  } else {
                    _saved.add(record.photos[0].toString());
                  }
                });
              },
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
