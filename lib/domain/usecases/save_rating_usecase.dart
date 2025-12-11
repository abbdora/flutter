import '../../core/models/rating_comment_model.dart';
import '../repositories/rating_repository.dart';

class SaveRatingUseCase {
  final RatingRepository repository;

  SaveRatingUseCase(this.repository);

  Future<void> call(RatingModel rating) async {
    return await repository.saveRating(rating);
  }
}