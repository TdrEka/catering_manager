import 'package:flutter/material.dart';

import '../models/catering_models.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.room,
    this.onTap,
  });

  final Room room;
  final VoidCallback? onTap;

  ({Color start, Color end, Color textColor}) _statusStyle(double progress) {
    if (!room.isActive) {
      return (
        start: Colors.grey.shade200,
        end: Colors.grey.shade400,
        textColor: Colors.black87,
      );
    }

    if (progress <= 0.0) {
      return (
        start: Colors.red.shade400,
        end: Colors.red.shade700,
        textColor: Colors.white,
      );
    }

    if (progress >= 1.0) {
      return (
        start: Colors.green.shade400,
        end: Colors.green.shade700,
        textColor: Colors.white,
      );
    }

    return (
      start: Colors.yellow.shade500,
      end: Colors.yellow.shade700,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = room.getProgress();
    final percent = (progress * 100).round();
    final status = _statusStyle(progress);
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [status.start, status.end],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 140),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.meeting_room,
                        color: status.textColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          room.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: status.textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$percent%',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '$percent% Done',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: status.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}