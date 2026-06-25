import 'dart:convert';
import 'package:freshora_mobile/helpers/api.dart';
import 'package:freshora_mobile/helpers/api_url.dart';
import 'package:freshora_mobile/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    String? username,
    String? fullname,
    String? password,
  }) async {
    var body = {
      "username": username ?? "",
      "fullname": fullname ?? "",
      "password": password ?? "",
    };
    var response = await Api().post(ApiUrl.register, body);
    var jsonObj  = json.decode(response.body);
    return Registrasi.fromJson(jsonObj);
  }
}