import 'package:flutter_bloc/flutter_bloc.dart';

class RatingComment {
  final String text;
  final bool isPositive;

  const RatingComment({
    required this.text,
    required this.isPositive,
  });
}

class RatingState {
  final double rating;
  final List<RatingComment> positiveComments;
  final List<RatingComment> negativeComments;

  const RatingState({
    required this.rating,
    required this.positiveComments,
    required this.negativeComments,
  });

  RatingState copyWith({
    double? rating,
    List<RatingComment>? positiveComments,
    List<RatingComment>? negativeComments,
  }) {
    return RatingState(
      rating: rating ?? this.rating,
      positiveComments: positiveComments ?? this.positiveComments,
      negativeComments: negativeComments ?? this.negativeComments,
    );
  }
}

class RatingCubit extends Cubit<RatingState> {
  RatingCubit()
      : super(
    const RatingState(
      rating: 4.2,
      positiveComments: [
        RatingComment(
          text: 'Хорошая организация рабочего процесса',
          isPositive: true,
        ),
        RatingComment(
          text: 'Своевременное выполнение задач',
          isPositive: true,
        ),
      ],
      negativeComments: [
        RatingComment(
          text: 'Иногда задерживаются дедлайны',
          isPositive: false,
        ),
      ],
    ),
  );

  void addPositiveComment(String text) {
    if (text.trim().isNotEmpty) {
      final newComment = RatingComment(
        text: text.trim(),
        isPositive: true,
      );
      final updatedComments = [...state.positiveComments, newComment];
      emit(state.copyWith(positiveComments: updatedComments));
    }
  }

  void addNegativeComment(String text) {
    if (text.trim().isNotEmpty) {
      final newComment = RatingComment(
        text: text.trim(),
        isPositive: false,
      );
      final updatedComments = [...state.negativeComments, newComment];
      emit(state.copyWith(negativeComments: updatedComments));
    }
  }
}