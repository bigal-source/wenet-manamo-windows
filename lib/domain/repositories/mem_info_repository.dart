import '../entities/mem_Info.dart';

abstract class MemInfoRepository {

  Future<List<MemInfo>> getAllMemInfos();

  Future<void> saveMemInfo(MemInfo item);

  Future<void> removeMemInfo(MemInfo item);
}
