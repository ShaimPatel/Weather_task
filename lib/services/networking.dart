import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;

  Future getdata() async {
    http.Response response = await http.get(Uri.parse(url));
    developer.log(response.body);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
    }
  }
}
