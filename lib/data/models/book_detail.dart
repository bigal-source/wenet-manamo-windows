
import 'cate_info.dart';

class BookDetailModel {
  String? bookId;
  String? title;
  List<CateBookDetail>? category;
  String? pages;
  String? fileSize;
  String? catchCopy;
  String? script;
  String? date;
  String? viewerUrl;
  String? viewerLoadKey;
  String? imageUrl;

  BookDetailModel({
    this.bookId,
    this.title,
    this.category,
    this.pages,
    this.fileSize,
    this.catchCopy,
    this.script,
    this.date,
    this.viewerUrl,
    this.viewerLoadKey,
    this.imageUrl
  });

  BookDetailModel.fromJson(Map<String, dynamic> json) {
    bookId     = json['book_id'];
    title      = json["title"];
    pages      = json["pages"];
    fileSize   = json["file_size"];
    catchCopy  = json["catch_copy"];
    script     = json["desc_html"];
    date       = json["created_date"];
    viewerUrl  = json["viewerUrl"];
    viewerLoadKey      = json["viewerLoadKey"];
    category   = List<CateBookDetail>.from(json["category"].map((x) => CateBookDetail.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["book_id"]      = bookId;
    data["title"]        = title;
    data["pages"]        = pages;
    data["file_size"]    = fileSize;
    data["catch_copy"]   = catchCopy;
    data["desc_html"]    = script;
    data["created_date"] = date;
    data["viewerUrl"]    = viewerUrl;
    data["viewerLoadKey"]= viewerLoadKey;
    data['bookinfo']     = category;
    return data;
  }
}
