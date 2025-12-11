class RatingDto {
  final String id;
  final double rating;
  final List<RatingCommentDto> positiveComments;
  final List<RatingCommentDto> negativeComments;

  RatingDto({
    required this.id,
    required this.rating,
    required this.positiveComments,
    required this.negativeComments,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'rating': rating,
    'positiveComments': positiveComments.map((c) => c.toJson()).toList(),
    'negativeComments': negativeComments.map((c) => c.toJson()).toList(),
  };

  static RatingDto fromJson(Map<String, dynamic> json) {
    return RatingDto(
      id: json['id'] as String,
      rating: json['rating'] as double,
      positiveComments: (json['positiveComments'] as List)
          .map((item) => RatingCommentDto.fromJson(item))
          .toList(),
      negativeComments: (json['negativeComments'] as List)
          .map((item) => RatingCommentDto.fromJson(item))
          .toList(),
    );
  }
}

class RatingCommentDto {
  final String id;
  final String text;
  final bool isPositive;

  RatingCommentDto({
    required this.id,
    required this.text,
    required this.isPositive,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isPositive': isPositive,
  };

  static RatingCommentDto fromJson(Map<String, dynamic> json) {
    return RatingCommentDto(
      id: json['id'] as String,
      text: json['text'] as String,
      isPositive: json['isPositive'] as bool,
    );
  }
}