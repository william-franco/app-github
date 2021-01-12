import 'dart:convert';

import 'package:app_github/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UserService {
  static final String apiUrl = "https://api.github.com/repositories";

  static Future<dynamic> getAllUsers() async {

    final url = "https://api.github.com/repositories";

    var response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable decoded = jsonDecode(response.body);
      List<UserModel> result = decoded.map((data) => UserModel.fromJson(data)).toList();

      return result;
    }

    return response;
  }

  static launchURL(String url, {bool forceSafariVC}) async {
    try {
      if (await canLaunch(url)) {
        if(forceSafariVC != null) await launch(url, forceSafariVC: forceSafariVC);
        else await launch(url);
      }
    } catch (e) {
      print(e);
    }
  }
}
