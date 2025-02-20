

class CateInfo {

  String? categoryName;
  String? categoryId;
  String? parentId;


  CateInfo({
    this.categoryName,
    this.categoryId,
    this.parentId
  });

  CateInfo.fromJson(Map<String, dynamic> json) {
    categoryName    = json['cate_nm'];
    categoryId      = json["cate_seq"];
    parentId        = json["parent_seq"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["cate_nm"]      = categoryName;
    data["cate_seq"]     = categoryId;
    data["parent_seq"]   = parentId;
    return data;
  }
}
class CateBookDetail {

  String? categoryName;
  String? categoryId;


  CateBookDetail({
    this.categoryName,
    this.categoryId,
  });

  CateBookDetail.fromJson(Map<String, dynamic> json) {
    categoryName    = json['cate_nm'];
    categoryId      = json["id"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["cate_nm"]      = categoryName;
    data["id"]           = categoryId;
    return data;
  }
}



