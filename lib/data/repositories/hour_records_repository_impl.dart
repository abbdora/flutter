import '../datasources/hour_records/hour_record_local_data_source.dart';
import '../datasources/hour_records/hour_record_mapper.dart';
import '../../core/models/hour_record_model.dart';
import '../../domain/repositories/hour_records_repository.dart';

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

  Future<HourRecordModel?> getHourRecordById(String id) async {
    final dto = await _localDataSource.getHourRecordById(id);
    return dto?.toModel();
  }

  Future<List<HourRecordModel>> searchHourRecords(String query) async {
    final dtos = await _localDataSource.searchHourRecords(query);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  Future<List<HourRecordModel>> getHourRecordsByProject(String projectName) async {
    final dtos = await _localDataSource.getHourRecordsByProject(projectName);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  Future<List<HourRecordModel>> getHourRecordsByDate(String date) async {
    final dtos = await _localDataSource.getHourRecordsByDate(date);
    return dtos.map((dto) => dto.toModel()).toList();
  }

  Future<int> getTotalHours() async {
    return await _localDataSource.getTotalHours();
  }
}