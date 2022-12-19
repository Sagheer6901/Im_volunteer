enum Role { admin, user }

class UserModel {
  String? cardImage;
  String? dept;
  String? email;
  String? image;
  String? name;
  int? phoneNumber;
  Role? role;
  String? uid;
  String? token;
  int? batch;
  List? events;
  bool? volunteer;

  UserModel({
    this.cardImage,
    this.dept,
    this.email,
    this.image,
    this.name,
    this.phoneNumber,
    this.role,
    this.uid,
    this.token,
    this.batch,
    this.events,
    this.volunteer,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    cardImage = json['cardImage'];
    dept = json['dept'];
    email = json['email'];
    image = json['image'];
    name = json['name'];
    batch = json['batch'];
    phoneNumber = json['phoneNumber'];
    role = json['role'] != null ? Role.values.byName(json['role']) : null;
    uid = json['uid'];
    events = json['events'] as List?;
    token = json['token'];
    volunteer = json['volunteer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cardImage'] = cardImage;
    data['dept'] = dept;
    data['email'] = email;
    data['image'] = image;
    data['name'] = name;
    data['batch'] = batch;
    data['phoneNumber'] = phoneNumber;
    data['role'] = role?.name;
    data['uid'] = uid;
    data['events'] =events;
    data['token'] = token;
    data['volunteer'] = volunteer;
    return data;
  }

  bool isAdmin() => role == Role.admin;
}
