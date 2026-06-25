import 'dart:convert';
import 'package:freshora_mobile/helpers/api.dart';
import 'package:freshora_mobile/helpers/api_url.dart';
import 'package:freshora_mobile/model/login.dart';

class LoginBloc {
  static Future<Login> login({
    String? username,
    String? password,
  }) async {
    var body = {
      "username": username ?? "",
      "password": password ?? "",
    };
    var response = await Api().post(ApiUrl.login, body);
    var jsonObj  = json.decode(response.body);
    return Login.fromJson(jsonObj);
  }
}