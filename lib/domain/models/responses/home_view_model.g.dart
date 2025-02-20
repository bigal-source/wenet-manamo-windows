// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeViewModel _$HomeViewModelFromJson(Map<String, dynamic> json) =>
    HomeViewModel(
      status: json['result'] as String,
      catalogs: (json['data'] as List<dynamic>)
          .map((e) =>
              CategoryDetailViewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeViewModelToJson(HomeViewModel instance) =>
    <String, dynamic>{
      'result': instance.status,
      'data': instance.catalogs,
    };
