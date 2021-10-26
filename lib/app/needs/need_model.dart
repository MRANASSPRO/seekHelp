import 'dart:core';

class Need {
  Need({
    //@required this.auth,
    this.id,
    this.dateCreation,
    this.userId,
    this.userEmail,
    this.rubriqueId,
    this.userCity,
    this.title,
  });

  //final AuthBase auth;
  String id = "";
  var dateCreation;
  String userId = "";
  String userEmail = "";
  var rubriqueId = "";
  String userCity = "";
  String title = "";
}
