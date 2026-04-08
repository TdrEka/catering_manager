class Item {
  Item({required this.name, this.isChecked = false});

  final String name;
  bool isChecked;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] as String? ?? '',
      isChecked: json['isChecked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isChecked': isChecked,
    };
  }
}

class Room {
  Room({
    required this.name,
    required this.checklist,
    this.isActive = true,
  });

  final String name;
  final List<Item> checklist;
  bool isActive;

  factory Room.fromJson(Map<String, dynamic> json) {
    final checklistJson = json['checklist'] as List<dynamic>? ?? const [];
    return Room(
      name: json['name'] as String? ?? '',
      checklist: checklistJson
          .map((item) => Item.fromJson(item as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'checklist': checklist.map((item) => item.toJson()).toList(),
      'isActive': isActive,
    };
  }

  double getProgress() {
    if (checklist.isEmpty) {
      return 0.0;
    }

    final checkedCount = checklist.where((item) => item.isChecked).length;
    return checkedCount / checklist.length;
  }
}

class Venue {
  Venue({required this.name, required this.rooms});

  final String name;
  final List<Room> rooms;

  factory Venue.fromJson(Map<String, dynamic> json) {
    final roomsJson = json['rooms'] as List<dynamic>? ?? const [];
    return Venue(
      name: json['name'] as String? ?? '',
      rooms: roomsJson
          .map((room) => Room.fromJson(room as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }
}