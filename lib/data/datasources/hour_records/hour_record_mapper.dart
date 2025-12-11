import '../../../core/models/hour_record_model.dart';
import 'hour_record_dto.dart';

extension HourRecordDtoMapper on HourRecordDto {
  HourRecordModel toModel() {
    return HourRecordModel(
      id: id,
      projectName: projectName,
      task: task,
      hours: hours,
      minutes: minutes,
      date: date,
    );
  }
}

extension HourRecordModelMapper on HourRecordModel {
  HourRecordDto toDto() {
    return HourRecordDto(
      id: id,
      projectName: projectName,
      task: task,
      hours: hours,
      minutes: minutes,
      date: date,
    );
  }
}