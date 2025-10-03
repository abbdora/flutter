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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Рейтинг'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Рабочий рейтинг:', style: TextStyle(fontSize: 18)),
            Text(_rating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.pink)),
            const SizedBox(height: 30),
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
            const SizedBox(height: 20),
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}