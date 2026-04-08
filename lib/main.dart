import 'package:flutter/material.dart';

import 'models/catering_models.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StorageService _storageService = StorageService();
  static const _loadTimeout = Duration(seconds: 4);
  List<Venue> _venues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  Future<void> _loadVenues() async {
    List<Venue> loaded = [];

    try {
      loaded = await _storageService.loadVenues().timeout(_loadTimeout);
    } catch (error) {
      debugPrint('Startup load failed, using empty venue list: $error');
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _venues = loaded;
      _isLoading = false;
    });
  }

  Future<void> _saveVenues(List<Venue> venues) async {
    try {
      await _storageService.saveVenues(venues);
    } catch (error) {
      debugPrint('Save failed: $error');
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _venues = List<Venue>.from(venues);
    });
  }

  @override
  Widget build(BuildContext context) {
    const fallbackFonts = <String>[
      'Roboto',
      'Noto Sans',
      'Noto Sans Symbols 2',
      'Arial Unicode MS',
      'sans-serif',
    ];

    return MaterialApp(
      title: 'Catering Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        textTheme: ThemeData.light().textTheme.apply(
          fontFamilyFallback: fallbackFonts,
        ),
      ),
      home: _isLoading
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : HomeScreen(
              venues: _venues,
              onVenuesChanged: _saveVenues,
            ),
    );
  }
}
