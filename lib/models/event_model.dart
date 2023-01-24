class EventModel {
  String? adminImage;
  String? adminName;
  int? date;
  String? description;
  String? eventId;
  String? image;
  bool? openEvent;
  String? title;
  int? lastDate;
  List<String>? applied;
  List<String>? likes;



  EventModel({
    this.adminImage,
    this.adminName,
    this.date,
    this.description,
    this.eventId,
    this.image,
    this.lastDate,
    this.openEvent,
    this.title,
    this.likes,
    this.applied
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    adminImage = json['adminImage'];
    adminName = json['adminName'];
    date = json['date'];
    description = json['description'];
    eventId = json['eventId'];
    image = json['image'];
    openEvent = json['openEvent'];
    lastDate  = json['lastDateForReg'];
    title = json['title'];
    likes = json['likes'].cast<String>();
    applied = json['applied'].cast<String>();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adminImage'] = adminImage;
    data['adminName'] = adminName;
    data['date'] = date;
    data['description'] = description;
    data['eventId'] = eventId;
    data['image'] = image;
    data['openEvent'] = openEvent;
    data['lastDateForReg'] = lastDate;
    data['title'] = title;
    data['likes'] = likes;
    data['applied'] = applied;
    return data;
  }
}
