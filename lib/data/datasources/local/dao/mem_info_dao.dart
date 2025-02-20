import 'package:floor/floor.dart';
import '/domain/entities/mem_Info.dart';
import '../../../../app/utils/constants/strings.dart';

@dao
abstract class MemInfoDao {
  @Query('SELECT * FROM $memberInfoEntity')
  Future<List<MemInfo>> getAllMemInfos();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMemInfo(MemInfo item);

  @delete
  Future<void> deleteMemInfo(MemInfo item);
}
