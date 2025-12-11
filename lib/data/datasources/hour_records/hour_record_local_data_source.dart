import 'dart:async';
import 'hour_record_dto.dart';

class HourRecordLocalDataSource {
  final List<HourRecordDto> _hourRecords = [
    HourRecordDto(
      id: '1',
      projectName: 'Мобильное приложение',
      task: 'Разработка интерфейса',
      hours: 3,
      minutes: 30,
      date: '15.01.2024',
    ),
    HourRecordDto(
      id: '2',
      projectName: 'Веб-сайт',
      task: 'Интеграция API',
      hours: 0,
      minutes: 0,
      date: '',
    ),
    HourRecordDto(
      id: '3',
      projectName: 'Документация',
      task: 'Написание руководства',
      hours: 1,
      minutes: 45,
      date: '13.01.2024',
    ),
    HourRecordDto(
      id: '4',
      projectName: 'Тестирование',
      task: 'Функциональное тестирование',
      hours: 4,
      minutes: 15,
      date: '12.01.2024',
    ),
    HourRecordDto(
      id: '5',
      projectName: 'Дизайн',
      task: 'Создание макетов',
      hours: 2,
      minutes: 30,
      date: '11.01.2024',
    ),
    HourRecordDto(
      id: '6',
      projectName: 'Совещание',
      task: 'Планирование спринта',
      hours: 1,
      minutes: 0,
      date: '10.01.2024',
    ),
    HourRecordDto(
      id: '7',
      projectName: 'База данных',
      task: 'Оптимизация запросов',
      hours: 3,
      minutes: 0,
      date: '09.01.2024',
    ),
    HourRecordDto(
      id: '8',
      projectName: 'Code Review',
      task: 'Проверка кода команды',
      hours: 2,
      minutes: 20,
      date: '08.01.2024',
    ),
  ];

  Future<List<HourRecordDto>> getAllHourRecords() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_hourRecords);
  }

  Future<void> saveHourRecord(HourRecordDto hourRecord) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final existingIndex = _hourRecords.indexWhere((hr) => hr.id == hourRecord.id);
    if (existingIndex >= 0) {
      _hourRecords[existingIndex] = hourRecord;
    } else {
      _hourRecords.add(hourRecord);
    }
  }

  Future<void> deleteHourRecord(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _hourRecords.removeWhere((hr) => hr.id == id);
  }
}