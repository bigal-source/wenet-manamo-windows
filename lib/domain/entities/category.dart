import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import '../../app/utils/constants/strings.dart';

@Entity(tableName: categoryEntity)
class Category extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String? name;
  final int open;
  final int sort;

  const Category({
    required this.id,
    required this.name,
    required this.open,
    required this.sort,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id       : map['id']            != null ? map['id'] as int : 0,
      name     : map['name']          != null ? map['name'] as String : null,
      open     : map['open']          != null ? map['open'] as int : 0,
      sort     : map['sort']          != null ? map['sort'] as int : 0,

    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      sort,
    ];
  }
}
