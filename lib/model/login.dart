class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? username;
  String? fullname;
  String? role;

  Login({
    this.code,
    this.status,
    this.token,
    this.userID,
    this.username,
    this.fullname,
    this.role,
  });

  factory Login.fromJson(Map<String, dynamic> obj) {
    return Login(
      code:     obj['code'],
      status:   obj['status'],
      token:    obj['data']['token'],
      userID:   obj['data']['user']['id'],
      username: obj['data']['user']['username'],
      fullname: obj['data']['user']['fullname'],
      role:     obj['data']['user']['role'],
    );
  }
}