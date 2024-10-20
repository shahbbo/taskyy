class TaskModel {
  String? id;
  String? image;
  String? title;
  String? desc;
  String? priority;
  String? status;
  String? user;
  String? createdAt;
  String? updatedAt;
  int? v;

  TaskModel({
      this.id, 
      this.image, 
      this.title, 
      this.desc, 
      this.priority, 
      this.status, 
      this.user, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  TaskModel.fromJson(dynamic json) {
    id = json['_id'];
    image = json['image'];
    title = json['title'];
    desc = json['desc'];
    priority = json['priority'];
    status = json['status'];
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['image'] = image;
    map['title'] = title;
    map['desc'] = desc;
    map['priority'] = priority;
    map['status'] = status;
    map['user'] = user;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}