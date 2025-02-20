import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import '../../app/utils/constants/strings.dart';

@Entity(tableName: categoryBookEntity)
class CategoryBook extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final int categoryId;
  final int shelfId;
  final int sort;

  const CategoryBook({
    required this.id,
    required this.categoryId,
    required this.shelfId,
    required this.sort,
  });

  factory CategoryBook.fromMap(Map<String, dynamic> map) {
    return CategoryBook(
      id             : map['id']             != null ? map['id'] as int : 0,
      categoryId     : map['category_book']  != null ? map['category_book'] as int : 0,
      shelfId        : map['shelf_id']       != null ? map['shelf_id'] as int : 0,
      sort           : map['sort']           != null ? map['sort'] as int : 0,

    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      categoryId,
      shelfId,
    ];
  }
}
