import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  final double currentRating;
  final Function(double) onRatingUpdated;

  const RatingScreen({
    super.key,
    required this.currentRating,
    required this.onRatingUpdated,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  late double _rating;
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _rating = widget.currentRating;
  }

  void _increaseRating() {
    setState(() {
      if (_rating < 5.0) _rating = double.parse((_rating + 0.1).toStringAsFixed(1));
    });
  }

  void _decreaseRating() {
    setState(() {
      if (_rating > 0.0) _rating = double.parse((_rating - 0.1).toStringAsFixed(1));
    });
  }

  void _addComment(bool isPositive) {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      setState(() {
        _comments.add({
          'text': comment,
          'isPositive': isPositive,
          'id': DateTime.now().millisecondsSinceEpoch,
        });
        _commentController.clear();
      });
    }
  }

  void _deleteComment(int index) {
    setState(() {
      _comments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Рейтинг'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text('Рабочий рейтинг:', style: TextStyle(fontSize: 18)),
                Text(_rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.pink)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _decreaseRating,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('-0.1'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _increaseRating,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('+0.1'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Введите плюс или минус',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _addComment(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Добавить плюс'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _addComment(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Добавить минус'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: ListView.separated(
              itemCount: _comments.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return ListTile(
                  key: ValueKey(comment['id']),
                  leading: Icon(
                    comment['isPositive'] ? Icons.thumb_up : Icons.thumb_down,
                    color: comment['isPositive'] ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    comment['text'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteComment(index);
                    },
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                widget.onRatingUpdated(_rating);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Назад'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}