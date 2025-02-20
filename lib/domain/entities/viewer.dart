import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import '../../app/utils/constants/strings.dart';

@Entity(tableName: viewerEntity)
class Viewer extends Equatable {
  @PrimaryKey(autoGenerate: false)
  final String? appBookId;
  final String? module;
  final String? page;
  final String? dataObj;

  const Viewer({
    this.appBookId,
    this.module,
    this.page,
    this.dataObj,
  });

  factory Viewer.fromMap(Map<String, dynamic> map) {
    return Viewer(
      appBookId  : map['app_book_Id']     != null ? map['app_book_Id'] as String : null,
      module     : map['module']          != null ? map['module'] as String : null,
      page       : map['page']            != null ? map['page'] as String : null,
      dataObj    : map['dataobj']         != null ? map['dataobj'] as String : null,

    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      appBookId,
      module,
      dataObj,
      page,
    ];
  }
}
