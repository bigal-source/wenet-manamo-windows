
class BookContentModel {
  String? name;
  String? info;
  BookContentModel({
    this.name,
    this.info,

  });

  BookContentModel.fromJson(Map<String, dynamic> json) {
    name     = json['name'];
    info     = json['info'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['info'] = info;
    data['name'] = name;
    return data;
  }
}
