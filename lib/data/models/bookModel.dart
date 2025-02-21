import 'dart:convert';

import 'book_info.dart';


class Bshelf {
  int? id;
  String? bookAppId;
  String? bookPath;
  String? title;
  String? thumbPath;
  int? thumbW;
  int? thumbH;
  String? size;
  String? pages;
  String? selected;
  String? status;
  String? download;
  String? bookInfo;
  String? evenType;
  String? cateSeq;
  String? procQueuStatus;
  String? procWaitBusy;
  String? planType;
  int? sortNo;
  int? lastPage;
  int? isDownload;
  int? cateId;
  int? pdfId;
  String? deviceId;

  Bshelf({
    this.id,
    this.bookAppId,
    this.bookPath,
    this.title,
    this.thumbPath,
    this.thumbW,
    this.thumbH,
    this.size,
    this.pages,
    this.selected,
    this.status,
    this.download,
    this.bookInfo,
    this.evenType,
    this.cateSeq,
    this.procQueuStatus,
    this.procWaitBusy,
    this.planType,
    this.sortNo,
    this.lastPage,
    this.isDownload,
    this.cateId,
    this.pdfId,
    this.deviceId,
  });

  Bshelf.fromJson(Map<String, dynamic> json) {
    id             = json["id"];
    bookAppId      = json["app_book_id"];
    bookPath       = json["book_path"];
    title          = json["title"];
    thumbPath      = json["thumb_path"];
    thumbW         = json["thumb_w"];
    thumbH         = json["thumb_h"];
    pages          = json["pages"];
    size           = json["size"];
    selected       = json["selected"];
    status         = json["status"];
    download       = json["download"];
    bookInfo       = json["book_info"];
    evenType       = json["even_type"];
    cateSeq        = json["cate_seq"];
    procQueuStatus = json["procqueu_status"];
    procWaitBusy   = json["procwait_busy"];
    planType       = json["plan_type"];
    sortNo         = json["sort_no"];
    lastPage       = json["last_page"];
    isDownload     = json["is_download"];
    cateId         = json["cate_id"];
    pdfId          = json["pdf_id"];
    deviceId       = json["device_id"];
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data["id"]               = id;
    data["app_book_id"]      = bookAppId;
    data["book_path"]        = bookPath;
    data["title"]            = title;
    data["thumb_path"]       = thumbPath;
    data["thumb_w"]          = thumbW;
    data["thumb_h"]          = thumbH;
    data["pages"]            = pages;
    data["size"]             = size;
    data["selected"]         = selected;
    data["status"]           = status;
    data["download"]         = download;
    data["book_info"]        = bookInfo;
    data["even_type"]        = evenType;
    data["cate_seq"]         = cateSeq;
    data["procqueu_status"]  = procQueuStatus;
    data["procwait_busy"]    = procWaitBusy;
    data["plan_type"]        = procQueuStatus;
    data["sort_no"]          = sortNo;
    data["last_page"]        = lastPage;
    data["is_download"]      = isDownload;
    data["cate_id"]          = cateId;
    data["pdf_id"]           = pdfId;
    data["device_id"]        = deviceId;
    return data;
  }
}
class BookOption {
  String ?bookAppId;
  String ?setting;
  String ?lastPage;

  BookOption({required this.bookAppId,this.setting, this.lastPage});

  factory BookOption.fromMap(Map<String, dynamic> json) => BookOption(
    bookAppId     : json["app_book_id"],
    setting       : json["setting"],
    lastPage      : json["lastpage"],
  );
  Map<String, dynamic> toMap() => {
    "app_book_id"        : bookAppId,
    "setting"            : setting,
    "lastpage"           : lastPage,
  };
}
class Bviewer {
  String bookAppId;
  int ?updateDate;
  String ?module;
  int ?page;
  String ?dataObj;

  Bviewer({required this.bookAppId,this.updateDate,this.module, this.page, this.dataObj});

  factory Bviewer.fromMap(Map<String, dynamic> json) => Bviewer(
    bookAppId     : json["app_book_id"],
    updateDate    : json["update_date"],
    module        : json["module"],
    page          : json["page"],
    dataObj       : json["dataobj"],
  );
  Map<String, dynamic> toMap() => {
    "app_book_id"        : bookAppId,
    "update_date"        : updateDate,
    "module"             : module,
    "page"               : page,
    "dataobj"            : dataObj,
  };
}
class CategoryShelf {
  int? id;
  String ?name;
  int ?open;
  int ?sort;

  CategoryShelf({this.id,this.name, this.open, this.sort});

  factory CategoryShelf.fromMap(Map<String, dynamic> json) => CategoryShelf(
    id        : json["id"],
    name      : json["name"],
    open      : json["open"],
    sort      : json["sort"],
  );
  Map<String, dynamic> toMap() => {
    "id"        : id,
    "name"      : name,
    "open"      : open,
    "sort"      : sort,
  };
}
class CategoryBook {
  int? id;
  int ?categoryId;
  int ?shelfId;
  int ?sort;

  CategoryBook({this.id,this.categoryId, this.shelfId, this.sort});

  factory CategoryBook.fromMap(Map<String, dynamic> json) => CategoryBook(
    id           : json["id"],
    categoryId   : json["category_id"],
    shelfId      : json["shelf_id"],
    sort         : json["sort"],
  );
  Map<String, dynamic> toMap() => {
    "id"          : id,
    "category_id" : categoryId,
    "shelf_id"    : shelfId,
    "sort"        : sort,
  };
}
class Memberinfo {

  String? author;
  String? info;
  String? loginAutoinfo;


  Memberinfo({
    this.author,
    this.info,
    this.loginAutoinfo,
  });

  factory Memberinfo.fromMap(Map<String, dynamic> json) => Memberinfo(
    author              : json["author"],
    info                : json["info"],
    loginAutoinfo       : json["loginAutoinfo"],
  );
  Map<String, dynamic> toMap() => {
    "author"               : author,
    "info"                 : info,
    "loginAutoinfo"        : loginAutoinfo,

  };
}

Books bookFromJson(String str) {
  final jsonData = json.decode(str);
  return Books.fromMap(jsonData);
}
class Books {
  String? bookid;
  String? title;
  String? category;
  String? image;
  int   ? imageW;
  int   ? imageH;
  String? download;
  String? author;
  String? pages;
  String? generator;
  String? filesize;
  String? objContent;

  Books({
    this.bookid,
    this.title,
    this.category,
    this.image,
    this.imageW,
    this.imageH,
    this.download,
    this.author,
    this.pages,
    this.generator,
    this.filesize,
    this.objContent,
  });

  factory Books.fromMap(Map<String, dynamic> json) => Books(
    bookid         : json["bookid"],
    title          : json["title"],
    category       : json["category"],
    image          : json["image"],
    imageW         : json["image_w"],
    imageH         : json["image_h"],
    download       : json["download"],
    author         : json["author"],
    pages          : json["pages"],
    generator      : json["generator"],
    filesize       : json["filesize"],
    objContent     : json["objContent"],

  );
  Map<String, dynamic> toMap() => {
    "bookid"           : bookid,
    "title"            : title,
    "category"         : category,
    "image"            : image,
    "image_w"          : imageW,
    "image_h"          : imageH,
    "download"         : download,
    "author"           : author,
    "pages"            : pages,
    "generator"        : generator,
    "filesize"         : filesize,
    "objContent"       : objContent,

  };
}
//todo: v2

class Book {
  int? id;
  String? bookAppId;
  String? bookPath;
  String? title;
  String? thumbPath;
  int? thumbW;
  int? thumbH;
  String? size;
  String? pages;
  String? selected;
  String? status;
  String? download;
  List<BookInfoModel>? bookInfo;
  String? evenType;
  String? cateSeq;
  String? procQueuStatus;
  String? procWaitBusy;
  String? planType;
  int? sortNo;
  int? lastPage;
  int? isDownload;
  int? cateId;
  int? pdfId;

  Book({
    this.id,
    this.bookAppId,
    this.bookPath,
    this.title,
    this.thumbPath,
    this.thumbW,
    this.thumbH,
    this.size,
    this.pages,
    this.selected,
    this.status,
    this.download,
    this.bookInfo,
    this.evenType,
    this.cateSeq,
    this.procQueuStatus,
    this.procWaitBusy,
    this.planType,
    this.sortNo,
    this.lastPage,
    this.isDownload,
    this.cateId,
    this.pdfId,
  });
  Book.fromJson(Map<String, dynamic> json) {
    id             = json["id"];
    bookAppId      = json["app_book_id"];
    bookPath       = json["book_path"];
    title          = json["title"];
    thumbPath      = json["thumb_path"];
    thumbW         = json["thumb_w"];
    thumbH         = json["thumb_h"];
    pages          = json["pages"];
    size           = json["size"];
    selected       = json["selected"];
    status         = json["status"];
    download       = json["download"];
    bookInfo       = json['book_info'] != null ? List<BookInfoModel>.from(json['book_info'].map((x) => BookInfoModel.fromJson(x))):  <BookInfoModel>[];
    evenType       = json["even_type"];
    cateSeq        = json["cate_seq"];
    procQueuStatus = json["procqueu_status"];
    procWaitBusy   = json["procwait_busy"];
    planType       = json["plan_type"];
    sortNo         = json["sort_no"];
    lastPage       = json["last_page"];
    isDownload     = json["is_download"];
    cateId         = json["cate_id"];
    pdfId          = json["pdf_id"];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["id"]               = id;
    data["app_book_id"]      = bookAppId;
    data["book_path"]        = bookPath;
    data["title"]            = title;
    data["thumb_path"]       = thumbPath;
    data["thumb_w"]          = thumbW;
    data["thumb_h"]          = thumbH;
    data["pages"]            = pages;
    data["size"]             = size;
    data["selected"]         = selected;
    data["status"]           = status;
    data["download"]         = download;
    data["book_info"]        = bookInfo;
    data["even_type"]        = evenType;
    data["cate_seq"]         = cateSeq;
    data["procqueu_status"]  = procQueuStatus;
    data["procwait_busy"]    = procWaitBusy;
    data["plan_type"]        = procQueuStatus;
    data["sort_no"]          = sortNo;
    data["last_page"]        = lastPage;
    data["is_download"]      = isDownload;
    data["cate_id"]          = cateId;
    data["pdf_id" ]          = pdfId;
    return data;
  }
}
class CategoryDownLoad {
  int? id;
  String? name;
  int? open;
  int? sort;
  int? isDefault;
  List<Bshelf>? books;

  CategoryDownLoad({this.id, this.name, this.sort, this.open, this.books, this.isDefault});
  CategoryDownLoad.fromJson(Map<String, dynamic> json) {
    id          = json['id'];
    name        = json['name'];
    sort        = json['sort'];
    open        = json['open'];
    isDefault   = json['is_default'] ?? 0;
    books       = json["books"] != null? List<Bshelf>.from(json['books'].map((x) => Bshelf.fromJson(x))) : <Bshelf>[];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id']          = id;
    data['name']        = name;
    data['sort']        = sort;
    data['open']        = open;
    data['books']       = books;
    data['is_default']  = isDefault;
    return data;
  }
}

class LastSync {
  String? mem_id;
  String? user_idx;
  String? book_seq;
  String? synchro_at ;
  LastSync({this.mem_id, this.user_idx, this.book_seq, this.synchro_at });
  LastSync.fromJson(Map<String, dynamic> json) {
    mem_id      = json["mem_id"];
    user_idx      = json["user_idx"];
    book_seq      = json["book_seq"];
    synchro_at  = json["synchro_at"];
  }
  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
    data["mem_id"]      = mem_id;
    data["user_idx"]      = user_idx;
    data["book_seq"]      = book_seq;
    data["synchro_at"] = synchro_at ;
    return data;
  }
}
