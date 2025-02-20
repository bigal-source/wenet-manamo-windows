import 'package:floor/floor.dart';
import '../../../../app/utils/constants/strings.dart';
import '../../../../domain/entities/option.dart';

@dao
abstract class OptionDao {
  @Query('SELECT * FROM $optionEntity')
  Future<List<Option>> getAllOptions();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOption(Option option);

  @delete
  Future<void> deleteOption(Option option);
}
