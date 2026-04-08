import 'dart:convert';

import '../models/catering_models.dart';
import 'key_value_store_factory.dart';

class StorageService {
  static const _venuesKey = 'venues_data';
  final _store = createKeyValueStore();

  Future<void> saveVenues(List<Venue> venues) async {
    final jsonData = venues.map((venue) => venue.toJson()).toList();
    final encoded = jsonEncode(jsonData);
    await _store.setString(_venuesKey, encoded);
  }

  Future<List<Venue>> loadVenues() async {
    final contents = await _store.getString(_venuesKey);
    if (contents == null || contents.trim().isEmpty) {
      return [];
    }

    final decoded = jsonDecode(contents) as List<dynamic>;
    return decoded
        .map((venue) => Venue.fromJson(venue as Map<String, dynamic>))
        .toList();
  }
}