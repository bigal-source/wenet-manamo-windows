import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

import '../../app/utils/constants/strings.dart';

@Entity(tableName: shelfEntity)
class Shelf extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? appBookId;
  final String? bookPath;
  final String? title;
  final String? thumbPath;
  final int? thumbH;
  final int? thumbW;
  final String? pages;
  final String? size;
  final String? selected;
  final String? status;
  final String? download;
  final String? bookInfo;
  final String? evenType;
  final String? cateSeq;
  final String? procqueuStatus;
  final String? procwaitBusy;
  final String? planType;
  final int? sortNo;
  final int? lastPage;
  final int? isDownload;
  final int? cateId;
  final int? pdfId;

  const Shelf({
    this.id,
    this.appBookId,
    this.bookPath,
    this.title,
    this.thumbPath,
    this.thumbH,
    this.thumbW,
    this.pages,
    this.size,
    this.selected,
    this.status,
    this.download,
    this.bookInfo,
    this.evenType,
    this.cateSeq,
    this.procqueuStatus,
    this.procwaitBusy,
    this.planType,
    this.sortNo,
    this.lastPage,
    this.isDownload,
    this.cateId,
    this.pdfId,
  });

  factory Shelf.fromMap(Map<String, dynamic> map) {
    return Shelf(
      id                : map['id'] != null ? map['id'] as int : null,
      appBookId         : map['app_book_id'] != null ? map['app_book_id'] as String : null,
      title             : map['book_path'] != null ? map['book_path'] as String : null,
      thumbW            : map['thumb_path'] != null ? map['thumb_path'] as int : null,
      thumbH            : map['thumb_h'] != null ? map['thumb_h'] as int : null,
      pages             : map['pages'] != null ? map['pages'] as String : null,
      size              : map['size'] != null ? map['size'] as String : null,
      selected          : map['selected'] != null ? map['selected'] as String : null,
      status            : map['status'] != null ? map['status'] as String : null,
      download          : map['download'] != null ? map['download'] as String : null,
      bookInfo          : map['book_info'] != null ? map['book_info'] as String : null,
      evenType          : map['even_type'] != null ? map['even_type'] as String : null,
      cateSeq           : map['cate_seq'] != null ? map['cate_seq'] as String : null,
      procqueuStatus    : map['procqueu_status'] != null ? map['procqueu_status'] as String : null,
      procwaitBusy: map['procwait_busy'] != null ? map['procwait_busy'] as String : null,
      planType    : map['plan_type'] != null ? map['plan_type'] as String : null,
      sortNo      : map['sort_no'] != null ? map['sort_no'] as int : null,
      lastPage    : map['last_page'] != null ? map['last_page'] as int : null,
      isDownload  : map['is_download'] != null ? map['is_download'] as int : null,
      cateId      : map['cate_id'] != null ? map['cate_id'] as int : null,
      pdfId       : map['pdf_id'] != null ? map['pdf_id'] as int : null,

    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      cateId,
      cateSeq,
      bookInfo,
      appBookId,
      bookPath,
    ];
  }
}
