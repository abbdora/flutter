import '../repositories/hour_records_repository.dart';

class DeleteHourRecordUseCase {
  final HourRecordsRepository repository;

  DeleteHourRecordUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteHourRecord(id);
  }
}