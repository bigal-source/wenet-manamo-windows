import 'package:floor/floor.dart';

import '../../../../app/utils/constants/strings.dart';
import '../../../../domain/entities/viewer.dart';

@dao
abstract class ViewerDao {
  @Query('SELECT * FROM $viewerEntity')
  Future<List<Viewer>> getAllViewers();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertViewer(Viewer item);

  @delete
  Future<void> deleteViewer(Viewer item);
}
