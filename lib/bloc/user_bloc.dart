import 'dart:convert';
import 'package:freshora_mobile/helpers/api.dart';
import 'package:freshora_mobile/helpers/api_url.dart';
import 'package:freshora_mobile/model/user.dart';

class UserBloc {
  static Future<User> getProfile() async {
    var response = await Api().get(ApiUrl.profile);
    var jsonObj  = json.decode(response.body);
    return User.fromJson(jsonObj['data']);
  }

  static Future<bool> updateProfile({
    String? fullname,
    String? phone,
    String? address,
  }) async {
    var body = <String, String>{};
    if (fullname != null && fullname.isNotEmpty) body['fullname'] = fullname;
    if (phone != null && phone.isNotEmpty) body['phone'] = phone;
    if (address != null && address.isNotEmpty) body['address'] = address;

    var response = await Api().post(ApiUrl.updateProfile, body);
    var jsonObj  = json.decode(response.body);
    return jsonObj['status'] == true;
  }
}