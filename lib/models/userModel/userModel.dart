class UserModel {
  String? id;
  String? displayName;
  String? username;
  List<String>? roles;
  bool? active;
  int? experienceYears;
  String? address;
  String? level;
  String? createdAt;
  String? updatedAt;
  int? v;

  UserModel({
      this.id,
      this.displayName,
      this.username,
      this.roles,
      this.active,
      this.experienceYears,
      this.address,
      this.level,
      this.createdAt,
      this.updatedAt,
      this.v,});

  UserModel.fromJson(dynamic json) {
    id = json['_id'];
    displayName = json['displayName'];
    username = json['username'];
    roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    active = json['active'];
    experienceYears = json['experienceYears'];
    address = json['address'];
    level = json['level'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['displayName'] = displayName;
    map['username'] = username;
    map['roles'] = roles;
    map['active'] = active;
    map['experienceYears'] = experienceYears;
    map['address'] = address;
    map['level'] = level;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}