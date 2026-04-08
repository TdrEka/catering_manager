import 'package:flutter/material.dart';

import '../models/catering_models.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room});

  final Room room;

  Color _backgroundColor(ColorScheme colorScheme, double progress) {
    if (!room.isActive) {
      return Colors.grey.shade300;
    }

    if (progress <= 0.0) {
      return Colors.red.shade200;
    }

    if (progress >= 1.0) {
      return Colors.green.shade300;
    }

    return Colors.yellow.shade300;
  }

  @override
  Widget build(BuildContext context) {
    final progress = room.getProgress();
    final percent = (progress * 100).round();
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: _backgroundColor(colorScheme, progress),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 140),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                room.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '$percent% Done',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}