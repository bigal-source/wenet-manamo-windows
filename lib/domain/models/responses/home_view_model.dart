import 'package:json_annotation/json_annotation.dart';
import '../../../data/models/category_detail_view_model.dart';
part 'home_view_model.g.dart';

@JsonSerializable()
class HomeViewModel{
  @JsonKey(name: 'result')
  final String status;
  @JsonKey(name: 'data')
  final List<CategoryDetailViewModel> catalogs;

  HomeViewModel({
    required this.status,
    required this.catalogs,
  });
  factory HomeViewModel.fromJson(Map<String, dynamic> json)  => _$HomeViewModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeViewModelToJson(this);

}
