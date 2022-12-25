class VolunteerModel {
  String? name;
  String? email;
  String? dept;
  int? batch;
  String? vid;
  String? uid;
  String? image;
  String? cardImage;

  VolunteerModel({
    this.name,
    this.email,
    this.dept,
    this.batch,
    this.vid,
    this.uid,
    this.image,
    this.cardImage
  });

  VolunteerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    dept = json['dept'];
    batch = json['batch'];
    uid = json['uid'];
    vid = json['vid'];
    image = json['image'];
    cardImage = json['cardImage'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['batch'] = batch;
    data['image'] = image;
    data['cardImage'] = cardImage;
    return data;
  }
}
