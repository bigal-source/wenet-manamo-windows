import 'dart:convert';

import 'book_content.dart';
import 'cate_info.dart';

class BookInfoModel {
  String? bookAppId;
  String? title;
  String? category;
  String? image;
  int   ? imageW;
  int   ? imageH;
  String? download;
  String? author;
  String? date;
  String? preview;
  String? pages;
  String? generator;
  String? price;
  String? priceText;
  String? filesize;
  int? pdfId;
  String? objcontents;
  List<BookContentModel>? bookInfo;

  BookInfoModel({
    this.bookAppId,
    this.title,
    this.category,
    this.image,
    this.imageW,
    this.imageH,
    this.download,
    this.author,
    this.date,
    this.preview,
    this.pages,
    this.generator,
    this.price,
    this.priceText,
    this.filesize,
    this.pdfId,
    this.objcontents,
    this.bookInfo
  });

  BookInfoModel.fromJson(Map<String, dynamic> json) {
    bookAppId  = json['bookid'];
    title      = json["title"];
    category   = json["category"];
    image      = json["image"];
    imageW     = json["image_w"];
    imageH     = json["image_h"];
    download   = json["download"];
    author     = json["author"];
    date       = json["date"];
    preview    = json["preview"];
    pages      = json["pages"];
    generator  = json["generator"];
    price      = json["price"];
    priceText  = json["pricetext"];
    filesize   = json["filesize"];
    pdfId      = json["pdf_id"];
    objcontents= jsonEncode(json);
    bookInfo   = List<BookContentModel>.from(json["bookinfo"].map((x) => BookContentModel.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["app_book_id"]      = bookAppId;
    data["title"]            = title;
    data["category"]         = category;
    data["image"]            = image;
    data["image_w"]          = imageW;
    data["image_h"]          = imageH;
    data["download"]         = download;
    data["author"]           = author;
    data["date"]             = date;
    data["preview"]          = preview;
    data["pages"]            = pages;
    data["generator"]        = generator;
    data["price"]            = price;
    data["pricetext"]        = priceText;
    data["filesize"]         = filesize;
    data["pdf_id"]           = pdfId;
    data["data"]             = objcontents;
    data['bookinfo']         = jsonEncode(bookInfo);
    return data;
  }
}
class BookCusInfoModel {
  String? bookAppId;
  String? title;
  String? category;
  int   ? imageW;
  int   ? imageH;
  String? author;
  int? pages;
  String? generator;

  BookCusInfoModel({
    this.bookAppId,
    this.title,
    this.category,
    this.imageW,
    this.imageH,
    this.author,
    this.pages,
    this.generator,
  });

  BookCusInfoModel.fromJson(Map<String, dynamic> json) {
    bookAppId  = json['bookid'];
    title      = json["title"];
    category   = json["category"];
    imageW     = json["image_w"];
    imageH     = json["image_h"];
    author     = json["author"];
    pages      = json["pages"];
    generator  = json["generator"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["app_book_id"]      = bookAppId;
    data["title"]            = title;
    data["category"]         = category;
    data["image_w"]          = imageW;
    data["image_h"]          = imageH;
    data["author"]           = author;
    data["pages"]            = pages;
    data["generator"]        = generator;
    return data;
  }
}
//todo: CATEGORY MODEL
class BookCate{
  String? categoryName;
  String? categoryId;
  int   ? sort;
  int   ? sub;
  int   ? count;
  List<CateInfo>? cate;
  List<Book>? listBook;

  BookCate({
    this.categoryName,
    this.categoryId,
    this.sort,
    this.sub,
    this.cate,
    this.listBook,
    this.count
  });

  BookCate.fromJson(Map<String, dynamic> json) {

    categoryName        = json['cate_nm'];
    categoryId          = json["cate_seq"];
    sort                = json["sert_sn"];
    sub                 = json["sub_cnt"];
    count               = json["cat_cnt"];
    cate                = json["nav_cate"] != null ? List<CateInfo>.from(json["nav_cate"].map((x) => CateInfo.fromJson(x))) : [];
    listBook            = List<Book>.from(json["listbook"].map((x) => Book.fromJson(x)));
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data["cate_nm"]             = categoryName;
    data["cate_seq"]            = categoryId;
    data["sort_sn"]             = sort;
    data["sub_cnt"]             = sub;
    data["cat_cnt"]             = count;
    data["nav_cate"]            = cate;
    data["listbook"]            = listBook;
    return data;
  }
}

//todo: BOOK MODEL
class Book{
  String? memId;
  String? bookSeq;
  String? bookId;
  String? title;
  String? detailFlag;
  String? fileSize;
  String? pages;
  String? date;
  String? leadFlag;
  String? memServer;
  String? distType;
  String? categoryId;
  String? categoryName;
  String? sort;
  String? sub;
  String? author;
  String? image;
  String? sum;

  Book({
    this.memId,
    this.bookSeq,
    this.bookId,
    this.title,
    this.detailFlag,
    this.fileSize,
    this.pages,
    this.date,
    this.leadFlag,
    this.memServer,
    this.distType,
    this.categoryId,
    this.categoryName,
    this.sort,
    this.sub,
    this.author,
    this.image,
    this.sum,

  });

  Book.fromJson(Map<String, dynamic> json) {

    memId           = json['mem_id'];
    bookSeq         = json['book_seq'];
    bookId          = json['bookid'];
    title           = json['title'];
    detailFlag      = json['detailinfo_flag'];
    fileSize        = json['file_size'];
    pages           = json["pages"];
    date            = json["w_date"];
    leadFlag        = json["lead_flag"];
    memServer       = json["mem_server"];
    distType        = json["dist_type_nm"];
    categoryId      = json["cate_seq"];
    categoryName    = json["cate_nm"];
    sort            = json["sort_sn"];
    sub             = json["sub_cnt"];
    author          = json["author"];
    image           = json["image"];
    sum             = json["pv_sum"];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data["mem_id"]             = memId;
    data["book_seq"]           = bookSeq;
    data["bookid"]             = bookId;
    data["title"]              = title;
    data["detailinfo_flag"]    = detailFlag;
    data["file_size"]          = fileSize;
    data["pages"]              = pages;
    data["date"]               = date;
    data["lead_flag"]          = leadFlag;
    data["mem_server"]         = memServer;
    data["dist_type_nm"]       = distType;
    data["cate_seq"]           = categoryId;
    data["cate_nm"]            = categoryName;
    data["sort_sn"]            = sort;
    data["sub_cnt"]            = sub;
    data["author"]             = author;
    data["image"]              = image;
    data["pv_sum"]             = sum;
    return data;
  }
}

//todo: BOOK DETAIL
class BookDetail{
  String? bookSeq;
  String? memId;
  String? bookId;
  String? appId;
  String? title;
  String? cateSeq;
  String? wDate;
  String? pages;
  String? preview;
  String? thumbnail;
  String? fileSize;
  String? fileName;
  String? descTp;
  String? descHtml;
  String? descSummary;
  String? detailInfoFlag;
  String? publicFlag;
  String? priceTp;
  String? generalPrice;
  String? salePrice;
  String? productCode;
  String? bookCode;
  String? catchCopy;
  String? publishDate;
  String? statusCd;
  String? kind;
  String? author;
  String? writer;
  String? mngCd;
  String? firstCateSeq;
  String? cate1Seq;
  String? cate2Seq;
  String? cate3Seq;
  String? distType;
  String? updateDate;
  String? updateDesc;
  String? osTp;
  String? newsStandFlag;
  String? newsStandCatchCopy;
  String? newsStandDescTp;
  String? newsStandDescHtml;
  String? newsStandPublishDate;
  String? newsStandKind;
  String? newsStandMngCd;
  String? srvTp;
  String? bookingOpenDate;
  String? bookingOpenHour;
  String? bookingCloseDate;
  String? bookingCloseHour;
  String? pdfDeleteDate;
  String? sortSn;
  String? leadFlag;
  String? cloudPublicFlag;
  String? urlShemaFlag;
  String? addr;
  String? zip;
  String? station;
  String? storeName;
  String? bookletFlag;
  String? storeBookId;
  String? mngCd2;
  String? mngCd3;
  String? product;
  String? subject;
  String? version;
  String? ebookVol;
  String? termFrom;
  String? termTo;
  String? category;
  String? image;
  int   ? imageW;
  int   ? imageH;
  String? html;
  String? viewer;
  int? downLimitCount;
  int? currentDownCount;
  bool? isLimitCount;

  BookDetail({
    this.bookSeq,
    this.memId,
    this.bookId,
    this.appId,
    this.title,
    this.cateSeq,
    this.wDate,
    this.pages,
    this.preview,
    this.thumbnail,
    this.fileSize,
    this.fileName,
    this.descTp,
    this.descHtml,
    this.descSummary,
    this.detailInfoFlag,
    this.publicFlag,
    this.priceTp,
    this.generalPrice,
    this.salePrice,
    this.productCode,
    this.bookCode,
    this.catchCopy,
    this.publishDate,
    this.statusCd,
    this.kind,
    this.author,
    this.writer,
    this.mngCd,
    this.firstCateSeq,
    this.cate1Seq,
    this.cate2Seq,
    this.cate3Seq,
    this.distType,
    this.updateDate,
    this.updateDesc,
    this.osTp,
    this.newsStandFlag,
    this.newsStandCatchCopy,
    this.newsStandDescTp,
    this.newsStandDescHtml,
    this.newsStandPublishDate,
    this.newsStandKind,
    this.newsStandMngCd,
    this.srvTp,
    this.bookingOpenDate,
    this.bookingOpenHour,
    this.bookingCloseDate,
    this.bookingCloseHour,
    this.pdfDeleteDate,
    this.sortSn,
    this.leadFlag,
    this.cloudPublicFlag,
    this.urlShemaFlag,
    this.addr,
    this.zip,
    this.station,
    this.storeName,
    this.bookletFlag,
    this.storeBookId,
    this.mngCd2,
    this.mngCd3,
    this.product,
    this.subject,
    this.version,
    this.ebookVol,
    this.termFrom,
    this.termTo,
    this.category,
    this.image,
    this.imageW,
    this.imageH,
    this.html,
    this.viewer,
    this.downLimitCount,
    this.currentDownCount,
    this.isLimitCount
  });

  BookDetail.fromJson(Map<String, dynamic> json) {

    bookId                      = json['bookid'];
    bookSeq                     = json['book_seq'];
    memId                       = json['mem_id'];
    bookId                      = json['bookid'];
    appId                       = json['appid'];
    title                       = json['title'];
    cateSeq                     = json['cate_seq'];
    wDate                       = json['w_date'];
    pages                       = json['pages'];
    preview                     = json['preview'];
    thumbnail                   = json['thumbnail'];
    fileSize                    = json['file_size'];
    fileName                    = json['file_name'];
    descTp                      = json['desc_tp'];
    descHtml                    = json['desc_html'];
    descSummary                 = json['desc_summary'];
    detailInfoFlag              = json['detailinfo_flag'];
    publicFlag                  = json['public_flag'];
    priceTp                     = json['price_tp'];
    generalPrice                = json['general_price'];
    salePrice                   = json['sale_price'];
    productCode                 = json['product_code'];
    bookCode                    = json['book_code'];
    catchCopy                   = json['catch_copy'];
    publishDate                 = json['publish_date'];
    statusCd                    = json['status_cd'];
    kind                        = json['kind'];
    author                      = json['author'];
    writer                      = json['writer'];
    mngCd                       = json['mng_cd'];
    firstCateSeq                = json['first_cate_seq'];
    cate1Seq                    = json['cate1_seq'];
    cate2Seq                    = json['cate2_seq'];
    cate3Seq                    = json['cate3_seq'];
    distType                    = json['dist_type'];
    updateDate                  = json['update_date'];
    updateDesc                  = json['update_desc'];
    osTp                        = json['os_tp'];
    newsStandFlag               = json['newsstand_flag'];
    newsStandCatchCopy          = json['newsstand_catch_copy'];
    newsStandDescTp             = json['newsstand_desc_tp'];
    newsStandDescHtml           = json['newsstand_date_html'];
    newsStandPublishDate        = json['newsstand_publish_date'];
    newsStandKind               = json['newsstand_kind'];
    newsStandMngCd              = json['newsstand_mng_cd'];
    srvTp                       = json['srv_tp'];
    bookingOpenDate             = json['booking_open_date'];
    bookingOpenHour             = json['booking_open_hour'];
    bookingCloseDate            = json['booking_close_date'];
    bookingCloseHour            = json['booking_close_hour'];
    pdfDeleteDate               = json['pdf_delete_date'];
    sortSn                      = json['sort_sn'];
    leadFlag                    = json['lead_flag'];
    cloudPublicFlag             = json['cloud_public_flag'];
    urlShemaFlag                = json['url_shema_flag'];
    addr                        = json['addr'];
    zip                         = json['zip'];
    station                     = json['station'];
    storeName                   = json['store_name'];
    bookletFlag                 = json['booklet_flag'];
    storeBookId                 = json['store_book_id'];
    mngCd2                      = json['mng_cd2'];
    mngCd3                      = json['mng_cd3'];
    product                     = json['product'];
    subject                     = json['subject'];
    version                     = json['version'];
    ebookVol                    = json['ebook_vol'];
    termFrom                    = json['termfrom'];
    termTo                      = json['termto'];
    category                    = json['category'];
    image                       = json['image'];
    imageW                      = json['image_w'];
    imageH                      = json['image_h'];
    html                        = json['html'];
    viewer                      = json['viewer'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['bookid']                          = bookId;
    data['book_seq']                        = bookSeq;
    data['mem_id']                          = memId;
    data['bookid']                          = bookId;
    data['appid']                           = appId;
    data['title']                           = title;
    data['cate_seq']                        = cateSeq;
    data['w_date']                          = wDate;
    data['pages']                           = pages;
    data['preview']                         = preview;
    data['thumbnail']                       = thumbnail;
    data['file_size']                       = fileSize;
    data['file_name']                       = fileName;
    data['desc_tp']                         = descHtml;
    data['desc_html']                       = descHtml;
    data['desc_summary']                    = descSummary;
    data['detailinfo_flag']                 = detailInfoFlag;
    data['public_flag']                     = publicFlag;
    data['price_tp']                        = priceTp;
    data['general_price']                   = generalPrice;
    data['sale_price']                      = salePrice;
    data['product_code']                    = product;
    data['book_code']                       = bookCode;
    data['catch_copy']                      = catchCopy;
    data['publish_date']                    = publishDate;
    data['status_cd']                       = statusCd;
    data['kind']                            = kind;
    data['author']                          = author;
    data['writer']                          = writer;
    data['mng_cd']                          = mngCd;
    data['first_cate_seq']                  = firstCateSeq;
    data['cate1_seq']                       = cate1Seq;
    data['cate2_seq']                       = cate2Seq;
    data['cate3_seq']                       = cate3Seq;
    data['dist_type']                       = distType;
    data['update_date']                     = updateDate;
    data['update_desc']                     = updateDesc;
    data['os_tp']                           = osTp;
    data['newsstand_flag']                  = newsStandFlag;
    data['newsstand_catch_copy']            = newsStandCatchCopy;
    data['newsstand_desc_tp']               = newsStandDescTp;
    data['newsstand_desc_html']             = newsStandDescHtml;
    data['newsstand_publish_date']          = newsStandPublishDate;
    data['newsstand_kind']                  = newsStandKind;
    data['newsstand_mng_cd']                = newsStandMngCd;
    data['srv_tp']                          = srvTp;
    data['booking_open_date']               = bookingOpenDate;
    data['booking_open_hour']               = bookingOpenDate;
    data['booking_close_date']              = bookingCloseDate;
    data['booking_close_hour']              = bookingCloseHour;
    data['pdf_delete_date']                 = pdfDeleteDate;
    data['sort_sn']                         = sortSn;
    data['lead_flag']                       = leadFlag;
    data['cloud_public_flag']               = cloudPublicFlag;
    data['url_shema_flag']                  = urlShemaFlag;
    data['addr']                            = addr;
    data['zip']                             = zip;
    data['station']                         = station;
    data['store_name']                      = station;
    data['booklet_flag']                    = bookletFlag;
    data['store_book_id']                   = storeBookId;
    data['mng_cd2']                         = mngCd2;
    data['mng_cd3']                         = mngCd3;
    data['product']                         = product;
    data['subject']                         = subject;
    data['version']                         = version;
    data['ebook_vol']                       = ebookVol;
    data['termfrom']                        = termFrom;
    data['termto']                          = termTo;
    data['category']                        = category;
    data['image']                           = image;
    data['image_w']                         = imageW;
    data['image_h']                         = imageH;
    data['html']                            = html;
    data['viewer']                          = viewer;
    return data;
  }
}

class BookInfo {
  String? name;
  String? info;
  BookInfo({
    this.name,
    this.info,

  });

  BookInfo.fromJson(Map<String, dynamic> json) {
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

class Book_Search_Model{
  String? bookId;
  String? pages;
  String? appId;

  String? highlight;
  String? searchpage;
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
  String? stream_url;
  List<BookInfo>? bookInfo;

  Book_Search_Model({
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
    this.bookInfo,
    this.stream_url
  });

  Book_Search_Model.fromJson(Map<String, dynamic> json) {
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
    stream_url           = json["stream_url"];
    bookInfo             = List<BookInfo>.from(json["bookinfo"].map((x) => BookInfo.fromJson(x)));
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
  data['bookinfo']           = bookInfo;
  data['stream_url']         = stream_url;
  return data;
  }
}

class One_Board {
  String? bb_subject;
  String? bc_content;
  String? bb_date;
  String? bc_index;
  One_Board({
    this.bb_subject,
    this.bc_content,
    this.bb_date,
    this.bc_index,
  });

  One_Board.fromJson(Map<String, dynamic> json) {
    bb_subject      = json['bb_subject'];
    bc_content      = json['bc_content'];
    bb_date         = json['bb_date'];
    bc_index        = json['bc_index'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["bb_subject"]         = bb_subject;
    data["bc_content"]         = bc_content;
    data["bb_date"]            = bb_date;
    data["bc_index"]           = bc_index;
    return data;
  }
}

class All_Board {
  String? bb_index;
  String? bb_subject;
  All_Board({
    this.bb_index,
    this.bb_subject,
  });

  All_Board.fromJson(Map<String, dynamic> json) {
    bb_index       = json['bb_index'];
    bb_subject     = json['bb_subject'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['bb_index'] = bb_index;
    data['bb_subject'] = bb_subject;
    return data;
  }
}

class Notice_Data{
  String? bb_subject;
  String? bc_content;
  String? bb_date;
  String? bc_index;
  List<All_Board>? allboards;

  Notice_Data({
    this.bb_subject,
    this.bc_content,
    this.bb_date,
    this.bc_index,
    this.allboards
  });

  Notice_Data.fromJson(Map<String, dynamic> json) {
    bb_subject      = json['oneboard']['bb_subject'];
    bc_content      = json['oneboard']['bc_content'];
    bb_date         = json['oneboard']['bb_date'];
    bc_index        = json['oneboard']['bc_index'];
    allboards       = List<All_Board>.from(json["allboards"].map((x) => All_Board.fromJson(x)));
  }
  Map<String, dynamic> toJson() {final data = <String, dynamic>{};
  data["oneboard"]['bb_subject']         = bb_subject;
  data["oneboard"]['bc_content']         = bc_content;
  data["oneboard"]['bb_date']            = bb_date;
  data["oneboard"]['bc_index']           = bc_index;
  data['allboards']                      = allboards;
  return data;
  }
}




