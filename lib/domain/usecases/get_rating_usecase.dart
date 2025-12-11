import '../../core/models/rating_comment_model.dart';
import '../repositories/rating_repository.dart';

class GetRatingUseCase {
  final RatingRepository repository;

  GetRatingUseCase(this.repository);

  Future<RatingModel> call() async {
    return await repository.getRating();
  }
}