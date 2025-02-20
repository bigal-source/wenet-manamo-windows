// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookViewModel _$BookViewModelFromJson(Map<String, dynamic> json) =>
    BookViewModel(
      memId: json['mem_id'] as String,
      bookSeq: json['book_seq'] as String,
      bookId: json['bookid'] as String,
      title: json['title'] as String,
      detailFlag: json['detailinfo_flag'] as String,
      fileSize: json['file_size'] as String,
      pages: json['pages'] as String,
      date: json['w_date'] as String,
      leadFlag: json['lead_flag'] as String,
      memServer: json['mem_server'] as String,
      distType: json['dist_type_nm'] as String,
      categoryId: json['cate_seq'] as String,
      categoryName: json['cate_nm'] as String,
      sort: json['sort_sn'] as String,
      sub: json['sub_cnt'] as String,
      author: json['author'] as String,
      image: json['image'] as String,
      sum: json['pv_sum'] as String,
    );

Map<String, dynamic> _$BookViewModelToJson(BookViewModel instance) =>
    <String, dynamic>{
      'mem_id': instance.memId,
      'book_seq': instance.bookSeq,
      'bookid': instance.bookId,
      'title': instance.title,
      'detailinfo_flag': instance.detailFlag,
      'file_size': instance.fileSize,
      'pages': instance.pages,
      'w_date': instance.date,
      'lead_flag': instance.leadFlag,
      'mem_server': instance.memServer,
      'dist_type_nm': instance.distType,
      'cate_seq': instance.categoryId,
      'cate_nm': instance.categoryName,
      'sort_sn': instance.sort,
      'sub_cnt': instance.sub,
      'author': instance.author,
      'image': instance.image,
      'pv_sum': instance.sum,
    };
