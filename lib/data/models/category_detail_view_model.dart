import 'book_view_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'category_detail_view_model.g.dart';

@JsonSerializable()
class CategoryDetailViewModel {
  @JsonKey(name: 'cate_nm')
  final String categoryName;
  @JsonKey(name: 'cate_seq')
  final String categoryId;
  @JsonKey(name: 'sort_sn')
  final int    sort;
  @JsonKey(name: 'sub_cnt')
  final int    sub;
  @JsonKey(name: 'listbook')
  final List<BookViewModel>? bookInCate;

  CategoryDetailViewModel({
    required this.categoryName,
    required this.categoryId,
    required this.sort,
    required this.sub,
    this.bookInCate
  });

  factory CategoryDetailViewModel.fromJson(Map<String, dynamic> json)  => _$CategoryDetailViewModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryDetailViewModelToJson(this);
}