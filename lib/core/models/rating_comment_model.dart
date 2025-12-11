class RatingModel {
  final String id;
  final double rating;
  final List<RatingCommentModel> positiveComments;
  final List<RatingCommentModel> negativeComments;

  const RatingModel({
    required this.id,
    required this.rating,
    required this.positiveComments,
    required this.negativeComments,
  });

  RatingModel copyWith({
    String? id,
    double? rating,
    List<RatingCommentModel>? positiveComments,
    List<RatingCommentModel>? negativeComments,
  }) {
    return RatingModel(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      positiveComments: positiveComments ?? this.positiveComments,
      negativeComments: negativeComments ?? this.negativeComments,
    );
  }

  static RatingModel initial() {
    return const RatingModel(
      id: 'rating_1',
      rating: 4.2,
      positiveComments: [
        RatingCommentModel(
          id: 'positive_1',
          text: 'Хорошая организация рабочего процесса',
          isPositive: true,
        ),
        RatingCommentModel(
          id: 'positive_2',
          text: 'Своевременное выполнение задач',
          isPositive: true,
        ),
      ],
      negativeComments: [
        RatingCommentModel(
          id: 'negative_1',
          text: 'Иногда задерживаются дедлайны',
          isPositive: false,
        ),
      ],
    );
  }
}

class RatingCommentModel {
  final String id;
  final String text;
  final bool isPositive;

  const RatingCommentModel({
    required this.id,
    required this.text,
    required this.isPositive,
  });

  RatingCommentModel copyWith({
    String? id,
    String? text,
    bool? isPositive,
  }) {
    return RatingCommentModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isPositive: isPositive ?? this.isPositive,
    );
  }
}