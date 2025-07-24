import 'package:flutter/material.dart';

class ReadingProgressWidget extends StatelessWidget {
  final double progress;

  const ReadingProgressWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          // Background circle
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
          ),
          // Progress circle
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 2,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          // Center icon
          Center(
            child: Icon(
              Icons.book,
              size: 12,
              color: progress > 0.5 
                  ? Colors.white 
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
} 