import '../../core/models/hour_record_model.dart';

abstract class HourRecordsRepository {
  Future<List<HourRecordModel>> getAllHourRecords();
  Future<void> saveHourRecord(HourRecordModel hourRecord);
  Future<void> deleteHourRecord(String id);
}