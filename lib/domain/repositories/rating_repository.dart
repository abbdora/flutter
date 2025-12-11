import '../../core/models/rating_comment_model.dart';

abstract class RatingRepository {
  Future<RatingModel> getRating();
  Future<void> saveRating(RatingModel rating);
  Future<void> addComment(String text, bool isPositive);
  Future<void> deleteComment(String commentId, bool isPositive);
}