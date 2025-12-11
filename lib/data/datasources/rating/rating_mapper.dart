import '../../../core/models/rating_comment_model.dart';
import 'rating_dto.dart';

extension RatingDtoMapper on RatingDto {
  RatingModel toModel() {
    return RatingModel(
      id: id,
      rating: rating,
      positiveComments: positiveComments.map((dto) => dto.toModel()).toList(),
      negativeComments: negativeComments.map((dto) => dto.toModel()).toList(),
    );
  }
}

extension RatingCommentDtoMapper on RatingCommentDto {
  RatingCommentModel toModel() {
    return RatingCommentModel(
      id: id,
      text: text,
      isPositive: isPositive,
    );
  }
}

extension RatingModelMapper on RatingModel {
  RatingDto toDto() {
    return RatingDto(
      id: id,
      rating: rating,
      positiveComments: positiveComments.map((model) => model.toDto()).toList(),
      negativeComments: negativeComments.map((model) => model.toDto()).toList(),
    );
  }
}

extension RatingCommentModelMapper on RatingCommentModel {
  RatingCommentDto toDto() {
    return RatingCommentDto(
      id: id,
      text: text,
      isPositive: isPositive,
    );
  }
}