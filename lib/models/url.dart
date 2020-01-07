class Url {
  int _id;
  String _time;
  String _url;

  Url(this._time, this._url);
  Url.withId(this._id, this._time, this._url);

  int get id => _id;

  String get time => _time;

  String get url => _url;

  set url(newUrl) {
    url = newUrl;
  }

  set time(newTime) {
    time = newTime;
  }

  // Convert a note object to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic> ();
    if ( _id == null ) {
      map['id'] = _id;
    }
    map["time"] = _time;
    map["url"] = _url;
    return map;
  }

  // Extract a note object from a map object
  Url.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._time = map["time"];
    this._url = map["url"];
  }
}