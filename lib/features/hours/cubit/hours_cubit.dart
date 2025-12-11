// presentation/cubit/hours_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/hour_record_model.dart';
import '../../../domain/usecases/delete_hour_record_usecase.dart';
import '../../../domain/usecases/get_hour_records_usecase.dart';
import '../../../domain/usecases/save_hour_record_usecase.dart';

class HoursState {
  final List<HourRecordModel> hourRecords;
  final bool isLoading;
  final String? error;

  const HoursState({
    required this.hourRecords,
    this.isLoading = false,
    this.error,
  });

  factory HoursState.initial() => const HoursState(
    hourRecords: [],
    isLoading: false,
    error: null,
  );

  HoursState copyWith({
    List<HourRecordModel>? hourRecords,
    bool? isLoading,
    String? error,
  }) {
    return HoursState(
      hourRecords: hourRecords ?? this.hourRecords,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  int get totalMinutes {
    return hourRecords.fold(0, (sum, record) => sum + record.hours * 60 + record.minutes);
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

class HoursCubit extends Cubit<HoursState> {
  final GetHourRecordsUseCase _getHourRecordsUseCase;
  final SaveHourRecordUseCase _saveHourRecordUseCase;
  final DeleteHourRecordUseCase _deleteHourRecordUseCase;

  HoursCubit({
    required GetHourRecordsUseCase getHourRecordsUseCase,
    required SaveHourRecordUseCase saveHourRecordUseCase,
    required DeleteHourRecordUseCase deleteHourRecordUseCase,
  }) : _getHourRecordsUseCase = getHourRecordsUseCase,
        _saveHourRecordUseCase = saveHourRecordUseCase,
        _deleteHourRecordUseCase = deleteHourRecordUseCase,
        super(HoursState.initial()) {
    loadHourRecords(); // Теперь публичный метод
  }

  // Изменяем на публичный метод
  Future<void> loadHourRecords() async {
    emit(state.copyWith(isLoading: true));
    try {
      final hourRecords = await _getHourRecordsUseCase();
      emit(state.copyWith(
        hourRecords: hourRecords,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки: $e',
      ));
    }
  }

  Future<void> saveHourRecord(HourRecordModel hourRecord) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _saveHourRecordUseCase(hourRecord);
      await loadHourRecords(); // Используем публичный метод
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка сохранения: $e',
      ));
    }
  }

  Future<void> deleteHourRecord(String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _deleteHourRecordUseCase(id);
      final updatedList = state.hourRecords
          .where((hr) => hr.id != id)
          .toList();
      emit(state.copyWith(
        hourRecords: updatedList,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка удаления: $e',
      ));
    }
  }

  void updateHourRecordInList(HourRecordModel updated) {
    final updatedList = state.hourRecords
        .map((hr) => hr.id == updated.id ? updated : hr)
        .toList();
    emit(state.copyWith(hourRecords: updatedList));
  }
}