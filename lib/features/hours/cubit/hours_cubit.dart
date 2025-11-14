import 'package:flutter_bloc/flutter_bloc.dart';

class HourRecord {
  final String projectName;
  final String task;
  final int hours;
  final int minutes;
  final String date;

  const HourRecord({
    required this.projectName,
    required this.task,
    required this.hours,
    required this.minutes,
    required this.date,
  });

  HourRecord copyWith({
    String? projectName,
    String? task,
    int? hours,
    int? minutes,
    String? date,
  }) {
    return HourRecord(
      projectName: projectName ?? this.projectName,
      task: task ?? this.task,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      date: date ?? this.date,
    );
  }
}

class HoursState {
  final List<HourRecord> hours;

  const HoursState({required this.hours});

  HoursState copyWith({List<HourRecord>? hours}) {
    return HoursState(hours: hours ?? this.hours);
  }
}

class HoursCubit extends Cubit<HoursState> {
  HoursCubit() : super(const HoursState(hours: [
    HourRecord(
      projectName: 'Мобильное приложение',
      task: 'Разработка интерфейса',
      hours: 3,
      minutes: 30,
      date: '15.01.2024',
    ),
    HourRecord(
      projectName: 'Веб-сайт',
      task: 'Интеграция API',
      hours: 2,
      minutes: 0,
      date: '14.01.2024',
    ),
    HourRecord(
      projectName: 'Документация',
      task: 'Написание руководства',
      hours: 1,
      minutes: 45,
      date: '13.01.2024',
    ),
    HourRecord(
      projectName: 'Тестирование',
      task: 'Функциональное тестирование',
      hours: 4,
      minutes: 15,
      date: '12.01.2024',
    ),
    HourRecord(
      projectName: 'Дизайн',
      task: 'Создание макетов',
      hours: 2,
      minutes: 30,
      date: '11.01.2024',
    ),
    HourRecord(
      projectName: 'Совещание',
      task: 'Планирование спринта',
      hours: 1,
      minutes: 0,
      date: '10.01.2024',
    ),
    HourRecord(
      projectName: 'База данных',
      task: 'Оптимизация запросов',
      hours: 3,
      minutes: 0,
      date: '09.01.2024',
    ),
    HourRecord(
      projectName: 'Code Review',
      task: 'Проверка кода команды',
      hours: 2,
      minutes: 20,
      date: '08.01.2024',
    ),
  ]));

  void addHourRecord(String projectName, String task, int hours, int minutes, String date) {
    final newRecord = HourRecord(
      projectName: projectName,
      task: task,
      hours: hours,
      minutes: minutes,
      date: date,
    );
    final updatedHours = [...state.hours, newRecord];
    emit(state.copyWith(hours: updatedHours));
  }

  void deleteHourRecord(int index) {
    final updatedHours = List<HourRecord>.from(state.hours);
    updatedHours.removeAt(index);
    emit(state.copyWith(hours: updatedHours));
  }

  int get totalMinutes {
    return state.hours.fold(0, (sum, record) => sum + record.hours * 60 + record.minutes);
  }

  String formatTotalTime() {
    final total = totalMinutes;
    final h = total ~/ 60;
    final m = total % 60;
    if (h == 0) return '${m}м';
    if (m == 0) return '${h}ч';
    return '${h}ч ${m}м';
  }
}