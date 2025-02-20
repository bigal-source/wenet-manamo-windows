import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import '../../app/utils/constants/strings.dart';

@Entity(tableName: optionEntity)
class Option extends Equatable {
  @PrimaryKey(autoGenerate: false)
  final String? appBookAppId;
  final String? setting;
  final String? lastPage;

  const Option({
    this.appBookAppId,
    this.setting,
    this.lastPage,
  });

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      appBookAppId: map['app_bookapp_id'] != null ? map['app_bookapp_id'] as String : null,
      setting     : map['setting']        != null ? map['setting'] as String : null,
      lastPage    : map['last_page']      != null ? map['last_page'] as String : null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      appBookAppId,
      setting,
      lastPage,
    ];
  }
}
