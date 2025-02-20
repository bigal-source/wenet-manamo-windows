

class NoticeView {
  String? result;
  List<Notice>? infoList;

  NoticeView({
    this.result,
    this.infoList,
  });

  NoticeView.fromJson(Map<String, dynamic> json) {
    result         = json["result"];
    infoList       = json["data"] != null ? List<Notice>.from(json['data'].map((x) => Notice.fromJson(x))) : <Notice>[];

  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data["result"]          = result;
    data["data"]            = infoList;
    return data;
  }
}
class Notice {
  String? id;
  String? title;
  String? deleteFlag;
  String? startDate;
  String? stopDate;
  String? endDate;
  String? createDate;
  String? updateDate;
  String? stopDatetime;

  Notice({
    this.id,
    this.title,
    this.deleteFlag,
    this.startDate,
    this.stopDate,
    this.endDate,
    this.createDate,
    this.updateDate,
    this.stopDatetime
  });

  Notice.fromJson(Map<String, dynamic> json) {
    id             = json["information_seq"];
    title          = json["article"];
    deleteFlag     = json["delete_flag"];
    startDate      = json["start_date"];
    stopDate       = json["stop_date"];
    endDate        = json["stop_datetime"];
    createDate     = json["create_datetime"];
    updateDate     = json["update_datetime"];
    stopDatetime   = json["stop_datetime"];
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data["information_seq"] = id;
    data["article"]         = title;
    data["delete_flag"]     = deleteFlag;
    data["start_date"]      = startDate;
    data["stop_date"]       = stopDate;
    data["stop_datetime"]   = endDate;
    data["update_datetime"] = updateDate;
    data["create_datetime"] = createDate;
    data["stop_datetime"]   = stopDatetime;
    return data;
  }
}
