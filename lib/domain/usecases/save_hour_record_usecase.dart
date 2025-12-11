import '../../core/models/hour_record_model.dart';
import '../repositories/hour_records_repository.dart';

class SaveHourRecordUseCase {
  final HourRecordsRepository repository;

  SaveHourRecordUseCase(this.repository);

  Future<void> call(HourRecordModel hourRecord) async {
    return await repository.saveHourRecord(hourRecord);
  }
}