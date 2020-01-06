import 'package:flutter/material.dart';

import 'commits_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Git Track"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                autofocus: false,
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
                  _onSubmit();
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
                    _onSubmit();
                  },
                ),
                Expanded(child: Container(),),
              ],
            )
          ],
        ),
      ),
    );
  }

  _onSubmit() {
    //NavigationUtil.showBlockingDialog(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommitsPage(controller.text)));
  }

}