class UserModel {
  String? firstname;
  String? lastname;
  bool? loggedIn;

  UserModel({
    this.loggedIn,
    this.firstname,
    this.lastname,
  });

  UserModel.fromJson(Map parsedJson) {
    firstname = parsedJson["firstname"] ?? "";
    lastname = parsedJson["lastname"] ?? "";
    loggedIn = parsedJson["loggedIn"] ?? false;
  }
 Map<String, dynamic> toMap() {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "logged": loggedIn,
    };
  }
}
