import '../../domain/repositories/hour_records_repository.dart';
import '../datasources/hour_records/hour_record_local_data_source.dart';
import '../datasources/hour_records/hour_record_mapper.dart';
import '../../core/models/hour_record_model.dart';

class HourRecordsRepositoryImpl implements HourRecordsRepository {
  final HourRecordLocalDataSource _localDataSource;

  HourRecordsRepositoryImpl(this._localDataSource);

  @override
  Future<List<HourRecordModel>> getAllHourRecords() async {
    final dtos = await _localDataSource.getAllHourRecords();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> saveHourRecord(HourRecordModel hourRecord) async {
    final dto = hourRecord.toDto();
    await _localDataSource.saveHourRecord(dto);
  }

  @override
  Future<void> deleteHourRecord(String id) async {
    await _localDataSource.deleteHourRecord(id);
  }
}