import '../repositories/rating_repository.dart';

class AddCommentUseCase {
  final RatingRepository repository;

  AddCommentUseCase(this.repository);

  Future<void> call(String text, bool isPositive) async {
    return await repository.addComment(text, isPositive);
  }
}