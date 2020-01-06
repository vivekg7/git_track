import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommitsPage extends StatefulWidget {
  final String url;
  CommitsPage(this.url);
  CommitsPageState createState() => CommitsPageState();
}

class CommitsPageState extends State<CommitsPage> {
  String user;
  String repo;
  dynamic commits;
  @override
  void initState() {
    var s = widget.url.split('/');
    user = s[s.length-2];
    repo = s[s.length-1];
    _fetchdata();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(repo+' <'+user+'>'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchdata,
          )
        ],
      ),
      body: commits == null
            ? Container()
            : showCommits(),
    );
  }

  _fetchdata() async {
    String url = 'https://api.github.com/repos/'+user+'/'+repo+'/commits';
    var response = await http.get(url);
    setState(() {
      commits = jsonDecode(response.body);
    });
  }

  showCommits() {
    return ListView.builder(
      itemCount: commits.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: Text(commits[position]["commit"]["committer"]["date"]),
            title: Text(commits[position]["commit"]["message"]),
          ),
        );
      },
    );
  }

}