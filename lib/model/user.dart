class User {
  int? id;
  String? username;
  String? fullname;
  String? role;
  String? phone;
  String? address;
  String? profileImage;
  String? profileImageUrl;

  User({
    this.id,
    this.username,
    this.fullname,
    this.role,
    this.phone,
    this.address,
    this.profileImage,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> obj) {
    return User(
      id:              obj['id'],
      username:        obj['username'],
      fullname:        obj['fullname'],
      role:            obj['role'],
      phone:           obj['phone'],
      address:         obj['address'],
      profileImage:    obj['profile_image'],
      profileImageUrl: obj['profile_image_url'],
    );
  }
}