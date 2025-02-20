import '../../domain/entities/mem_Info.dart';
import '../../domain/repositories/mem_info_repository.dart';
import '../datasources/local/app_database.dart';

class MemInfoRepositoryImpl implements MemInfoRepository {
  final AppDatabase _appDatabase;

  MemInfoRepositoryImpl(this._appDatabase);

  @override
  Future<List<MemInfo>> getAllMemInfos() {
    // TODO: implement getAllMemInfos
    return _appDatabase.memInfoDao.getAllMemInfos();
  }

  @override
  Future<void> removeMemInfo(MemInfo item) {
    // TODO: implement removeMemInfo
    return _appDatabase.memInfoDao.insertMemInfo(item);
    throw UnimplementedError();
  }

  @override
  Future<void> saveMemInfo(MemInfo item) {
    // TODO: implement saveMemInfo
    return _appDatabase.memInfoDao.deleteMemInfo(item);
    throw UnimplementedError();
  }
  

}
