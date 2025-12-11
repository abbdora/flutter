import '../../core/models/hour_record_model.dart';
import '../repositories/hour_records_repository.dart';

class GetHourRecordsUseCase {
  final HourRecordsRepository repository;

  GetHourRecordsUseCase(this.repository);

  Future<List<HourRecordModel>> call() async {
    return await repository.getAllHourRecords();
  }
}