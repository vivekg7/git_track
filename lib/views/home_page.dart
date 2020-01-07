import 'package:flutter/material.dart';
import 'package:git_track/models/url.dart';
import 'package:git_track/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'commits_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  List<Url> urlList;
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    if (urlList == null) {
      urlList = List<Url> ();
      getSavedUrl();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Git Track"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                autofocus: true,
                controller: controller,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'repo url',
                  hintText: 'https://github.com/vivekg7/git_track',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(),
                textAlign: TextAlign.center,
                onSubmitted: (val) {
                  _onSubmit(controller.text);
                  controller.text = "";
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(child: Container(),),
                RaisedButton(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 30.0),
                  ),
                  onPressed: () {
                    _insertToDatabase(controller.text);
                    _onSubmit(controller.text);
                    controller.text = "";
                  },
                ),
                Expanded(child: Container(),),
              ],
            ),
            Expanded(
              child: showUrls(),
            ),
          ],
        ),
      ),
    );
  }

  _onSubmit(String text) {
    //NavigationUtil.showBlockingDialog(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommitsPage(text)));
  }

  getSavedUrl() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Url>> noteListFuture = databaseHelper.getUrlList();
      noteListFuture.then((urlList) {
        setState(() {
          this.urlList = urlList.reversed.toList();
          this.count = urlList.length;
        });
      });
    });
  }

  _insertToDatabase(String text) {
//    for (int i=0; i<count; i++) {
//      if (urlList[i].url == text) {
//        return;
//      }
//    }
    Url url = new Url(DateTime.now().toIso8601String(), text);
    databaseHelper.insertUrl(url).then((val) {
      getSavedUrl();
    });
  }

  _deleteUrl(int id) {
    databaseHelper.deleteUrl(id).then((val) {
      getSavedUrl();
    });
  }

  showUrls() {
    if (this.count < 1) {
      return Container();
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: 10.0),
      itemCount: this.count,
      itemBuilder: (BuildContext context, int position) {
        return Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                color: Colors.orange,
                textColor: Colors.white,
                child: Text(
                  urlList[position].url,
                  style: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  _onSubmit(urlList[position].url);
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteUrl(urlList[position].id);
              },
            )
          ],
        );
      },
    );
  }

}