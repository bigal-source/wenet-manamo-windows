import '../../domain/entities/option.dart';

abstract class OptionRepository {

  Future<List<Option>> getAllOptions();

  Future<void> saveOption(Option item);

  Future<void> removeOption(Option item);
}
