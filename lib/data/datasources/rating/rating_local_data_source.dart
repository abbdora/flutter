import 'package:sqflite/sqflite.dart';
import '../local/database_helper.dart';
import '../rating/rating_dto.dart';


class RatingLocalDataSource {
  final DatabaseHelper _databaseHelper;

  RatingLocalDataSource(this._databaseHelper);

  Future<RatingDto> getRating() async {
    final db = await _databaseHelper.database;

    final ratingRow = await db.query('rating', limit: 1);
    if (ratingRow.isEmpty) {
      await db.insert('rating', {'id': 'main_rating', 'value': 4.5});
      return RatingDto(
        id: 'main_rating',
        rating: 4.5,
        positiveComments: [],
        negativeComments: [],
      );
    }
    final ratingValue = ratingRow.first['value'] as double;

    final commentsRows = await db.query('rating_comments');
    final positive = <RatingCommentDto>[];
    final negative = <RatingCommentDto>[];

    for (var row in commentsRows) {
      final comment = RatingCommentDto(
        id: row['id'] as String,
        text: row['text'] as String,
        isPositive: row['type'] == 'positive',
      );
      if (comment.isPositive) {
        positive.add(comment);
      } else {
        negative.add(comment);
      }
    }

    return RatingDto(
      id: 'main_rating',
      rating: ratingValue,
      positiveComments: positive,
      negativeComments: negative,
    );
  }

  Future<void> saveRating(RatingDto rating) async {
    final db = await _databaseHelper.database;

    await db.update(
      'rating',
      {'value': rating.rating},
      where: 'id = ?',
      whereArgs: ['main_rating'],
    );

    await db.delete('rating_comments');

    final allComments = [
      ...rating.positiveComments.map((c) => RatingCommentDto(
        id: c.id,
        text: c.text,
        isPositive: true,
      )),
      ...rating.negativeComments.map((c) => RatingCommentDto(
        id: c.id,
        text: c.text,
        isPositive: false,
      )),
    ];

    for (var c in allComments) {
      await db.insert('rating_comments', {
        'id': c.id,
        'rating_id': 'main_rating',
        'text': c.text,
        'type': c.isPositive ? 'positive' : 'negative',
        'date': DateTime.now().toIso8601String().split('T').first,
      });
    }
  }

  Future<void> addComment(String text, bool isPositive) async {
    final db = await _databaseHelper.database;
    await db.insert('rating_comments', {
      'id': DateTime.now().microsecondsSinceEpoch.toString(),
      'rating_id': 'main_rating',
      'text': text.trim(),
      'type': isPositive ? 'positive' : 'negative',
      'date': DateTime.now().toIso8601String().split('T').first,
    });
  }

  Future<void> deleteComment(String commentId, bool isPositive) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'rating_comments',
      where: 'id = ?',
      whereArgs: [commentId],
    );
  }
}