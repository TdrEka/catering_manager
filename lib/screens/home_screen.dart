import 'package:flutter/material.dart';

import '../models/catering_models.dart';
import 'room_detail_screen.dart';
import '../widgets/room_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.venues,
    required this.onVenuesChanged,
  });

  final List<Venue> venues;
  final Future<void> Function(List<Venue> venues) onVenuesChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Venue? selectedVenue;

  Future<void> _notifySave() async {
    await widget.onVenuesChanged(widget.venues);
  }

  Future<bool> _confirmDelete({required String label}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Delete $label?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  Future<String?> _showNameDialog({
    required String title,
    required String hint,
  }) async {
    String inputValue = '';
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: hint),
            onChanged: (value) => inputValue = value,
            onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(inputValue),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    final trimmed = result?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }

  Future<void> _addVenue() async {
    final venueName = await _showNameDialog(
      title: 'Add Venue',
      hint: 'Venue name',
    );

    if (venueName == null) {
      return;
    }

    setState(() {
      final newVenue = Venue(name: venueName, rooms: []);
      widget.venues.add(newVenue);
      selectedVenue = newVenue;
    });

    await _notifySave();
  }

  Future<void> _addRoom() async {
    if (selectedVenue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a venue before adding a room.')),
      );
      return;
    }

    final roomName = await _showNameDialog(
      title: 'Add Room',
      hint: 'Room name',
    );

    if (roomName == null) {
      return;
    }

    setState(() {
      selectedVenue!.rooms.add(Room(name: roomName, checklist: []));
    });

    await _notifySave();
  }

  Future<void> _deleteVenue(Venue venue) async {
    final confirmed = await _confirmDelete(label: 'venue "${venue.name}"');
    if (!confirmed) {
      return;
    }

    setState(() {
      widget.venues.remove(venue);
      if (selectedVenue == venue) {
        selectedVenue = widget.venues.isNotEmpty ? widget.venues.first : null;
      }
    });

    await _notifySave();
  }

  Future<void> _deleteRoom(Room room) async {
    if (selectedVenue == null) {
      return;
    }

    final confirmed = await _confirmDelete(label: 'room "${room.name}"');
    if (!confirmed) {
      return;
    }

    setState(() {
      selectedVenue!.rooms.remove(room);
    });

    await _notifySave();
  }

  @override
  void initState() {
    super.initState();
    if (widget.venues.isNotEmpty) {
      selectedVenue = widget.venues.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catering Manager'),
        actions: [
          IconButton(
            onPressed: _addVenue,
            tooltip: 'Add Venue',
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: _addRoom,
            tooltip: 'Add Room',
            icon: const Icon(Icons.add_box_outlined),
          ),
          IconButton(
            onPressed:
                selectedVenue == null ? null : () => _deleteVenue(selectedVenue!),
            tooltip: 'Delete Venue',
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: ListView.builder(
              itemCount: widget.venues.length,
              itemBuilder: (context, index) {
                final venue = widget.venues[index];
                final isSelected = selectedVenue == venue;
                final isEvenRow = index.isEven;
                final rowColor = isSelected
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.14)
                    : isEvenRow
                    ? Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.45)
                    : Colors.transparent;

                return Column(
                  children: [
                    ListTile(
                      tileColor: rowColor,
                      selected: isSelected,
                      selectedTileColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      title: Text(venue.name),
                      trailing: IconButton(
                        tooltip: 'Delete Venue',
                        onPressed: () => _deleteVenue(venue),
                        icon: const Icon(Icons.delete_outline),
                      ),
                      onTap: () {
                        setState(() {
                          selectedVenue = venue;
                        });
                      },
                    ),
                    if (index < widget.venues.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 12,
                        endIndent: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.outlineVariant.withValues(alpha: 0.35),
                      ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: selectedVenue == null
                ? const Center(
                    child: Text('Select a venue to view its rooms.'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: selectedVenue!.rooms.length,
                    itemBuilder: (context, index) {
                      final room = selectedVenue!.rooms[index];
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (context) => RoomDetailScreen(
                                      room: room,
                                      onRoomChanged: _notifySave,
                                    ),
                                  ),
                                );

                                if (!mounted) {
                                  return;
                                }

                                setState(() {});
                              },
                              child: RoomCard(room: room),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Material(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: const CircleBorder(),
                              child: IconButton(
                                tooltip: 'Delete Room',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _deleteRoom(room),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}