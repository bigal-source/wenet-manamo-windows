import 'package:json_annotation/json_annotation.dart';
part 'book_view_model.g.dart';

@JsonSerializable()
class BookViewModel{
  @JsonKey(name: 'mem_id')
  final String memId;
  @JsonKey(name: 'book_seq')
  String bookSeq;
  @JsonKey(name: 'bookid')
  String bookId;
  String title;
  @JsonKey(name: 'detailinfo_flag')
  String detailFlag;
  @JsonKey(name: 'file_size')
  String fileSize;
  String pages;
  @JsonKey(name: 'w_date')
  String date;
  @JsonKey(name: 'lead_flag')
  String leadFlag;
  @JsonKey(name: 'mem_server')
  String memServer;
  @JsonKey(name: 'dist_type_nm')
  String distType;
  @JsonKey(name: 'cate_seq')
  String categoryId;
  @JsonKey(name: 'cate_nm')
  String categoryName;
  @JsonKey(name: 'sort_sn')
  String sort;
  @JsonKey(name: 'sub_cnt')
  String sub;
  String author;
  String image;
  @JsonKey(name: 'pv_sum')
  String sum;

  BookViewModel({
    required this.memId,
    required this.bookSeq,
    required this.bookId,
    required this.title,
    required this.detailFlag,
    required this.fileSize,
    required this.pages,
    required this.date,
    required this.leadFlag,
    required this.memServer,
    required this.distType,
    required this.categoryId,
    required this.categoryName,
    required this.sort,
    required this.sub,
    required this.author,
    required this.image,
    required this.sum,
  });
  factory BookViewModel.fromJson(Map<String, dynamic> json) => _$BookViewModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookViewModelToJson(this);
}