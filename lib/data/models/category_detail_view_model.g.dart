// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_detail_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDetailViewModel _$CategoryDetailViewModelFromJson(
        Map<String, dynamic> json) =>
    CategoryDetailViewModel(
      categoryName: json['cate_nm'] as String,
      categoryId: json['cate_seq'] as String,
      sort: json['sort_sn'] as int,
      sub: json['sub_cnt'] as int,
      bookInCate: (json['listbook'] as List<dynamic>?)
          ?.map((e) => BookViewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryDetailViewModelToJson(
        CategoryDetailViewModel instance) =>
    <String, dynamic>{
      'cate_nm': instance.categoryName,
      'cate_seq': instance.categoryId,
      'sort_sn': instance.sort,
      'sub_cnt': instance.sub,
      'listbook': instance.bookInCate,
    };
