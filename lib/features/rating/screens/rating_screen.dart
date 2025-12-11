import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/rating_comment_model.dart';
import '../cubit/rating_cubit.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  void _showAddCommentDialog(BuildContext context, bool isPositive) {
    final ratingCubit = context.read<RatingCubit>();
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isPositive ? 'Причина увеличения рейтинга' : 'Причина уменьшения рейтинга'),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Введите причину ${isPositive ? 'увеличения' : 'уменьшения'} рейтинга',
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = textController.text.trim();
                if (text.isNotEmpty) {
                  if (isPositive) {
                    ratingCubit.addPositiveComment(text);
                  } else {
                    ratingCubit.addNegativeComment(text);
                  }
                  Navigator.of(dialogContext).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isPositive ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, RatingCommentModel comment, bool isPositive) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Удалить комментарий?'),
          content: Text('Вы уверены, что хотите удалить комментарий:\n"${comment.text}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                context.read<RatingCubit>().deleteComment(comment.id, isPositive);
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatingCubit, RatingState>(
      builder: (context, state) {
        if (state.isLoading && state.rating.positiveComments.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text('Рейтинг'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, RatingState state) {
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ошибка: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<RatingCubit>().loadRating(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    final ratingCubit = context.read<RatingCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildImageSection(),
          const SizedBox(height: 24),
          _buildRatingScore(state.rating.rating),
          const SizedBox(height: 32),
          _buildPositiveCard(
            context: context,
            ratingCubit: ratingCubit,
            comments: state.rating.positiveComments,
          ),
          const SizedBox(height: 16),
          _buildNegativeCard(
            context: context,
            ratingCubit: ratingCubit,
            comments: state.rating.negativeComments,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    const String imageUrl = 'https://formulaznaniy.ru/images/20160823/57bc3523d002a.jpg';

    return Container(
      width: 350,
      height: 255,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          progressIndicatorBuilder: (context, url, progress) =>
              Container(
                color: Colors.grey[100],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[100],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 24),
                  SizedBox(height: 4),
                  Text('Ошибка', style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingScore(double rating) {
    return Column(
      children: [
        const Text(
          'Рабочий рейтинг:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
      ],
    );
  }

  Widget _buildPositiveCard({
    required BuildContext context,
    required RatingCubit ratingCubit,
    required List<RatingCommentModel> comments,
  }) {
    return GestureDetector(
      onTap: () => _showAddCommentDialog(context, true),
      child: _buildCommentCard(
        title: 'Увеличение рейтинга',
        color: Colors.green,
        comments: comments,
        isPositive: true,
        ratingCubit: ratingCubit,
        context: context,
      ),
    );
  }

  Widget _buildNegativeCard({
    required BuildContext context,
    required RatingCubit ratingCubit,
    required List<RatingCommentModel> comments,
  }) {
    return GestureDetector(
      onTap: () => _showAddCommentDialog(context, false),
      child: _buildCommentCard(
        title: 'Уменьшение рейтинга',
        color: Colors.red,
        comments: comments,
        isPositive: false,
        ratingCubit: ratingCubit,
        context: context,
      ),
    );
  }

  Widget _buildCommentCard({
    required String title,
    required Color color,
    required List<RatingCommentModel> comments,
    required bool isPositive,
    required RatingCubit ratingCubit,
    required BuildContext context,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: color,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (comments.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Нажмите чтобы добавить причину',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Добавленные причины:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...comments.map((comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: color,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            comment.text,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          color: Colors.grey,
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, comment, isPositive);
                          },
                        ),
                      ],
                    ),
                  )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}