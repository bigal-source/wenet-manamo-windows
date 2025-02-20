import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

import '../../app/utils/constants/strings.dart';

@Entity(tableName: memberInfoEntity)
class MemInfo extends Equatable {
  @PrimaryKey(autoGenerate: false)
  final String? author;
  final String? info;
  final String? loginAutoInfo;

  const MemInfo({
    this.author,
    this.info,
    this.loginAutoInfo,
  });

  factory MemInfo.fromMap(Map<String, dynamic> map) {
    return MemInfo(
      author        : map['author']          != null ? map['author'] as String : null,
      info          : map['info']            != null ? map['info'] as String : null,
      loginAutoInfo : map['login_auto_info'] != null ? map['login_auto_info'] as String : null,

    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      author,
      info,
      loginAutoInfo,
    ];
  }
}
