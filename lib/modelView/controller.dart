import 'dart:convert';

import 'package:http/http.dart' as http;

class UserRequest {
  static Future<Map> getUser() async {
    Uri url =
        Uri.parse("https://secured-taxi.herokuapp.com/driver/onebycode/aaaa");
    try {
      var response = await http.get(url).timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      print(response.body);
      var info = json.decode(response.body);
      return {"error": false, "data": info};
    } catch (e) {
      print(e);
      return {"error": true, "data": e};
    }
  }
}
