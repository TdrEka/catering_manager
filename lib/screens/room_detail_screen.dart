import 'package:flutter/material.dart';

import '../models/catering_models.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({
    super.key,
    required this.room,
    required this.onRoomChanged,
  });

  final Room room;
  final Future<void> Function() onRoomChanged;

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  final TextEditingController _itemNameController = TextEditingController();

  Future<bool> _confirmDeleteTask(String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Delete "$name"?'),
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

  @override
  void dispose() {
    _itemNameController.dispose();
    super.dispose();
  }

  Future<void> _showAddItemDialog() async {
    _itemNameController.clear();

    final itemName = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Add Checklist Item'),
          contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          children: [
            TextField(
              controller: _itemNameController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Item name',
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop(value);
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_itemNameController.text);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        );
      },
    );

    final trimmed = itemName?.trim() ?? '';
    if (trimmed.isEmpty) {
      return;
    }

    setState(() {
      widget.room.checklist.add(Item(name: trimmed));
    });

    await widget.onRoomChanged();
  }

  Future<void> _clearAll() async {
    setState(() {
      for (final item in widget.room.checklist) {
        item.isChecked = false;
      }
    });

    await widget.onRoomChanged();
  }

  Future<void> _deleteTask(int index) async {
    final item = widget.room.checklist[index];
    final confirmed = await _confirmDeleteTask(item.name);
    if (!confirmed) {
      return;
    }

    setState(() {
      widget.room.checklist.removeAt(index);
    });

    await widget.onRoomChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        actions: [
          IconButton(
            onPressed: _clearAll,
            tooltip: 'Clear All',
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Room Active'),
            value: widget.room.isActive,
            onChanged: (value) async {
              setState(() {
                widget.room.isActive = value;
              });

              await widget.onRoomChanged();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.room.checklist.length,
              itemBuilder: (context, index) {
                final item = widget.room.checklist[index];
                return Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: Text(item.name),
                        value: item.isChecked,
                        onChanged: (value) async {
                          setState(() {
                            item.isChecked = value ?? false;
                          });

                          await widget.onRoomChanged();
                        },
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete Task',
                      onPressed: () => _deleteTask(index),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}