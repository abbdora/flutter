import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_rating_usecase.dart';
import '../../../../domain/usecases/add_comment_usecase.dart';
import '../../../../domain/usecases/save_rating_usecase.dart';
import '../../../core/models/rating_comment_model.dart';
import '../../../domain/usecases/delete_comment_usecase.dart';

class RatingState {
  final RatingModel rating;
  final bool isLoading;
  final String? error;

  const RatingState({
    required this.rating,
    this.isLoading = false,
    this.error,
  });

  factory RatingState.initial() => RatingState(
    rating: RatingModel.initial(),
    isLoading: false,
    error: null,
  );

  RatingState copyWith({
    RatingModel? rating,
    bool? isLoading,
    String? error,
  }) {
    return RatingState(
      rating: rating ?? this.rating,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class RatingCubit extends Cubit<RatingState> {
  final GetRatingUseCase _getRatingUseCase;
  final AddCommentUseCase _addCommentUseCase;
  final SaveRatingUseCase _saveRatingUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase; // Добавить

  RatingCubit({
    required GetRatingUseCase getRatingUseCase,
    required AddCommentUseCase addCommentUseCase,
    required SaveRatingUseCase saveRatingUseCase,
    required DeleteCommentUseCase deleteCommentUseCase, // Добавить
  }) : _getRatingUseCase = getRatingUseCase,
        _addCommentUseCase = addCommentUseCase,
        _saveRatingUseCase = saveRatingUseCase,
        _deleteCommentUseCase = deleteCommentUseCase, // Инициализировать
        super(RatingState.initial()) {
    loadRating();
  }

  Future<void> loadRating() async {
    emit(state.copyWith(isLoading: true));
    try {
      final rating = await _getRatingUseCase();
      emit(state.copyWith(
        rating: rating,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка загрузки рейтинга: $e',
      ));
    }
  }

  Future<void> addPositiveComment(String text) async {
    if (text.trim().isEmpty) return;

    emit(state.copyWith(isLoading: true));
    try {
      await _addCommentUseCase(text.trim(), true);
      final updatedRating = await _getRatingUseCase();
      emit(state.copyWith(
        rating: updatedRating,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка добавления комментария: $e',
      ));
    }
  }

  Future<void> addNegativeComment(String text) async {
    if (text.trim().isEmpty) return;

    emit(state.copyWith(isLoading: true));
    try {
      await _addCommentUseCase(text.trim(), false);
      final updatedRating = await _getRatingUseCase();
      emit(state.copyWith(
        rating: updatedRating,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка добавления комментария: $e',
      ));
    }
  }

  Future<void> deleteComment(String commentId, bool isPositive) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _deleteCommentUseCase(commentId, isPositive);
      final updatedRating = await _getRatingUseCase();
      emit(state.copyWith(
        rating: updatedRating,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Ошибка удаления комментария: $e',
      ));
    }
  }
}