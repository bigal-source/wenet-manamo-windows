
class BookSearchModel{
  String? author;
  String? language;
  String? keyword;
  int? total;
  // List<int>? next;
  List<BookSearchViewModel>? books;

  BookSearchModel({
    this.author,
    this.language,
    this.keyword,
    this.total,
    // this.next,
    this.books
  });

  BookSearchModel.fromJson(Map<String, dynamic> json) {
    author          = json['author'];
    language        = json["language"];
    keyword         = json["keyword"];
    total           = int.tryParse(json["total"]?.toString() ?? "");
    // next            = List<int>.from(json['next'].map((x) => x));
    books           = List<BookSearchViewModel>.from(json["books"].map((x) => BookSearchViewModel.fromJson(x)));

  }
  Map<String, dynamic> toJson() {
      final data = <String, dynamic>{};
      data["author"]             = author;
      data["language"]           = language;
      data["keyword"]            = keyword;
      data["total"]              = total;
      // data["next"]               = next;
      data["books"]              = books;
      return data;
  }
}
class BookSearchViewModel{
  String? bookId;
  String? pages;
  String? appId;
  String? highlight;
  int? searchpage;
  String? pagedir;
  int? page;

  String? updateDate;
  String? statusCd;
  String? title;
  String? author;
  String? coverImage;
  String? image;
  String? imageL;
  String? date;
  String? preview;
  String? info;
  String? price;
  String? priceText;
  String? publishDate;
  String? genre;
  String? detailInfoFlag;
  String? download;
  String? accessUrl;
  String? distType;
  String? catchCopy;
  String? streaming;
  String? bookOrderStatus;
  String? termFrom;
  String? termTo;
  String? streamUrl;
  List<BookSearchInfo>? bookSearchInfo;

  BookSearchViewModel({
    this.bookId,
    this.pages,
    this.appId,

    this.highlight,
    this.searchpage,
    this.pagedir,
    this.page,

    this.updateDate,
    this.statusCd,
    this.title,
    this.author,
    this.coverImage,
    this.image,
    this.imageL,
    this.date,
    this.preview,
    this.info,
    this.price,
    this.priceText,
    this.publishDate,
    this.genre,
    this.detailInfoFlag,
    this.download,
    this.accessUrl,
    this.distType,
    this.catchCopy,
    this.streaming,
    this.bookOrderStatus,
    this.termFrom,
    this.termTo,
    this.bookSearchInfo,
    this.streamUrl
  });

  BookSearchViewModel.fromJson(Map<String, dynamic> json) {
    bookId          = json['bookid'];
    pages           = json["pages"];
    appId           = json["appid"];

    highlight       = json["highlight"];
    searchpage      = json["searchpage"];
    pagedir         = json["pagedir"];
    page            = json["page"];

    updateDate      = json["update_date"];
    statusCd        = json["status_cd"];
    title           = json["title"];
    author          = json["author"];
    coverImage      = json["coverimage"];
    image           = json["image"];
    imageL          = json["image_l"];
    date            = json["date"];
    preview         = json["preview"];
    info            = json["info"];
    price           = json["price"];
    priceText       = json["pricetext"];
    publishDate     = json["publishdate"];
    genre                = json["genre"];
    detailInfoFlag       = json["detailinfo_flag"];
    download             = json["download"];
    accessUrl            = json["access_url"];
    distType             = json["disttype"];
    catchCopy            = json["catchcopy"];
    streaming            = json["streaming"];
    bookOrderStatus      = json["bookorder_status"];
    termFrom             = json["termfrom"];
    termTo               = json["termto"];
    streamUrl            = json["stream_url"];
    bookSearchInfo       = List<BookSearchInfo>.from(json["bookinfo"].map((x) => BookSearchInfo.fromJson(x)));
  }
  Map<String, dynamic> toJson() {final data = <String, dynamic>{};
  data["bookid"]             = bookId;
  data["pages"]              = pages;
  data["appid"]              = appId;

  data["highlight"]          = highlight;
  data["searchpage"]         = searchpage;
  data["pagedir"]            = pagedir;
  data["page"]               = page;

  data["update_date"]        = updateDate;
  data["status_cd"]          = statusCd;
  data["title"]              = title;
  data["author"]             = author;
  data["coverimage"]         = coverImage;
  data["image"]              = image;
  data["image_b"]            = imageL;
  data["date"]               = date;
  data["preview"]            = preview;
  data["info"]               = info;
  data["price"]              = price;
  data["pricetext"]          = priceText;
  data["publishdate"]        = publishDate;
  data["genre"]              = genre;
  data["detailinfo_flag"]    = detailInfoFlag;
  data['download']           = download;
  data['access_url']         = accessUrl;
  data['disttype']           = distType;
  data['catchcopy']          = catchCopy;
  data['streaming']          = streaming;
  data['bookorder_status']   = bookOrderStatus;
  data['termfrom']           = termFrom;
  data['termto']             = termTo;
  data['bookinfo']           = bookSearchInfo;
  data['stream_url']         = streamUrl;
  return data;
  }
}
class BookSearchInfo {
  String? name;
  String? info;
  BookSearchInfo({
    this.name,
    this.info,

  });

  BookSearchInfo.fromJson(Map<String, dynamic> json) {
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