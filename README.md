# Catering Manager

A Flutter app designed for catering and event operations teams to manage venue readiness with fast, visual room checklists.

## Why I Built This

Event preparation can get chaotic when teams are juggling multiple venues, rooms, and setup tasks. This project focuses on clarity and speed:

- Quick venue and room navigation
- Color-coded room status at a glance
- Tap-friendly checklist workflow for tablet use
- Automatic local persistence so progress is not lost

## Core Features

- Venue management
	- Add and delete venues
	- Sidebar with clear active selection state
- Room management
	- Add and delete rooms per venue
	- Progress-driven room cards with visual status gradients
- Checklist workflow
	- Add, check/uncheck, clear, and delete tasks
	- Checked tasks are dimmed with strikethrough for readability
- Persistence
	- Automatic save/load loop
	- Works across app restarts

## Status Color Logic

Room cards communicate status instantly:

- Gray: room is inactive
- Red: active room with 0% progress
- Yellow: active room with partial progress
- Green: active room with 100% completion

## UI/UX Highlights

- Material 3 theme with high-contrast indigo app shell
- Sidebar optimized for scanning venues quickly
- Ripple interactions and large touch targets for tablet-friendly use
- Consistent layout spacing with SafeArea + 16px structure

## Tech Stack

- Flutter
- Dart
- Local persistence:
	- `shared_preferences` on mobile/desktop
	- Browser local storage on web

## Project Structure

```text
lib/
	main.dart
	models/
		catering_models.dart
	screens/
		home_screen.dart
		room_detail_screen.dart
	services/
		storage_service.dart
		key_value_store.dart
		key_value_store_factory.dart
		key_value_store_shared_prefs.dart
		key_value_store_web.dart
	widgets/
		room_card.dart
```

## Getting Started

1. Clone the repository
2. Install dependencies:

```bash
flutter pub get
```

3. Run on Chrome (quick preview):

```bash
flutter run -d chrome
```

4. Run on Android device/emulator:

```bash
flutter run -d android
```

## Demo Content (Suggested for LinkedIn Post)

If you want this to look great on LinkedIn, include 2 to 4 screenshots or a short GIF:

- Sidebar venue navigation
- Room status card grid
- Checklist detail screen with task completion flow
- Add/delete operations in action

## Roadmap

- Search/filter for venues and rooms
- Role-based views for staff vs manager
- Export/import JSON backups
- Cloud sync and multi-device collaboration

## Author

Built by TdrEka.
