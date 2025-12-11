import 'dart:async';
import 'rating_dto.dart';

class RatingLocalDataSource {
  RatingDto? _rating;

  Future<RatingDto> getRating() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (_rating == null) {
      _rating = RatingDto(
        id: 'rating_1',
        rating: 4.2,
        positiveComments: [
          RatingCommentDto(
            id: 'positive_1',
            text: 'Хорошая организация рабочего процесса',
            isPositive: true,
          ),
          RatingCommentDto(
            id: 'positive_2',
            text: 'Своевременное выполнение задач',
            isPositive: true,
          ),
        ],
        negativeComments: [
          RatingCommentDto(
            id: 'negative_1',
            text: 'Иногда задерживаются дедлайны',
            isPositive: false,
          ),
        ],
      );
    }

    return _rating!;
  }

  Future<void> saveRating(RatingDto rating) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _rating = rating;
  }

  Future<void> addComment(String text, bool isPositive) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final newComment = RatingCommentDto(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text.trim(),
      isPositive: isPositive,
    );

    if (isPositive) {
      _rating = RatingDto(
        id: _rating!.id,
        rating: _rating!.rating,
        positiveComments: [..._rating!.positiveComments, newComment],
        negativeComments: _rating!.negativeComments,
      );
    } else {
      _rating = RatingDto(
        id: _rating!.id,
        rating: _rating!.rating,
        positiveComments: _rating!.positiveComments,
        negativeComments: [..._rating!.negativeComments, newComment],
      );
    }
  }

  Future<void> deleteComment(String commentId, bool isPositive) async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (isPositive) {
      final filteredComments = _rating!.positiveComments
          .where((comment) => comment.id != commentId)
          .toList();

      _rating = RatingDto(
        id: _rating!.id,
        rating: _rating!.rating,
        positiveComments: filteredComments,
        negativeComments: _rating!.negativeComments,
      );
    } else {
      final filteredComments = _rating!.negativeComments
          .where((comment) => comment.id != commentId)
          .toList();

      _rating = RatingDto(
        id: _rating!.id,
        rating: _rating!.rating,
        positiveComments: _rating!.positiveComments,
        negativeComments: filteredComments,
      );
    }
  }
}