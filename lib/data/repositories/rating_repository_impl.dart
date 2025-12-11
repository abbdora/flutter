import '../../core/models/rating_comment_model.dart';
import '../../domain/repositories/rating_repository.dart';
import '../datasources/rating/rating_local_data_source.dart';
import '../datasources/rating/rating_mapper.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingLocalDataSource _localDataSource;

  RatingRepositoryImpl(this._localDataSource);

  @override
  Future<RatingModel> getRating() async {
    final dto = await _localDataSource.getRating();
    return dto.toModel();
  }

  @override
  Future<void> saveRating(RatingModel rating) async {
    final dto = rating.toDto();
    await _localDataSource.saveRating(dto);
  }

  @override
  Future<void> addComment(String text, bool isPositive) async {
    await _localDataSource.addComment(text, isPositive);
  }

  @override
  Future<void> deleteComment(String commentId, bool isPositive) async {
    await _localDataSource.deleteComment(commentId, isPositive);
  }
}