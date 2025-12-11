import '../repositories/rating_repository.dart';

class DeleteCommentUseCase {
  final RatingRepository repository;

  DeleteCommentUseCase(this.repository);

  Future<void> call(String commentId, bool isPositive) async {
    return await repository.deleteComment(commentId, isPositive);
  }
}