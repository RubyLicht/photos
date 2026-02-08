# Photo Gallery App

A Flutter application that fetches and displays photos from the [Picsum Photos API](https://picsum.photos/) with infinite scroll pagination. Built using **Clean Architecture**, **BLoC** pattern for state management, and **Freezed** for immutable data classes.

![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.7+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Features

- Browse photos from Picsum Photos API
- Infinite scroll pagination (loads more at 80% scroll)
- Image caching for optimal performance
- Loading, Error, and Data states
- Clean Architecture with separation of concerns
- Immutable state management with Freezed

---

## Architecture Overview

This project follows **Clean Architecture** principles, separating the codebase into distinct layers with clear responsibilities. This ensures the code is:

- **Testable** - Each layer can be tested independently
- **Maintainable** - Changes in one layer don't affect others
- **Scalable** - Easy to add new features
- **Readable** - Clear separation of concerns

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Pages     │  │   Widgets   │  │        BLoC         │  │
│  │             │  │             │  │  Events → States    │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │  Use Cases  │  │ Repository Interface│  │
│  │             │  │             │  │     (Abstract)      │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└────────────────────────────┬────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Models    │  │ Data Sources│  │ Repository Impl     │  │
│  │ (fromJson)  │  │   (API)     │  │   (Concrete)        │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
lib/
├── main.dart                          # App entry point & DI setup
│
└── features/
    └── photos/
        │
        ├── domain/                    # DOMAIN LAYER
        │   ├── entities/
        │   │   └── photo.dart         # Photo entity (Freezed)
        │   ├── repositories/
        │   │   └── photo_repository.dart   # Abstract repository interface
        │   └── usecases/
        │       └── get_photos_usecase.dart # Business logic
        │
        ├── data/                      # DATA LAYER
        │   ├── models/
        │   │   └── photo_model.dart   # Photo model with JSON serialization
        │   ├── datasources/
        │   │   └── photo_remote_datasource.dart  # API calls
        │   └── repositories/
        │       └── photo_repository_impl.dart    # Repository implementation
        │
        └── presentation/              # PRESENTATION LAYER
            ├── bloc/
            │   ├── photo_bloc.dart    # BLoC logic
            │   ├── photo_event.dart   # Events (Freezed)
            │   └── photo_state.dart   # States (Freezed)
            ├── pages/
            │   └── photo_list_page.dart   # Main page
            └── widgets/
                └── photo_card.dart    # Photo card widget
```

---

## State Management (BLoC)

The app uses **BLoC (Business Logic Component)** pattern with **Freezed** union types for type-safe state management.

### Events

```dart
@freezed
class PhotoEvent with _$PhotoEvent {
  const factory PhotoEvent.loadRequested() = PhotosLoadRequested;
  const factory PhotoEvent.loadMoreRequested() = PhotosLoadMoreRequested;
}
```

### States

```dart
@freezed
class PhotoState with _$PhotoState {
  const factory PhotoState.initial() = PhotoInitial;
  const factory PhotoState.loading() = PhotoLoading;
  const factory PhotoState.loaded({
    required List<Photo> photos,
    required int currentPage,
    required bool hasReachedMax,
  }) = PhotoLoaded;
  const factory PhotoState.loadingMore({
    required List<Photo> photos,
    required int currentPage,
  }) = PhotoLoadingMore;
  const factory PhotoState.error({required String message}) = PhotoError;
}
```

### State Flow Diagram

```
                    ┌─────────────┐
                    │   Initial   │
                    └──────┬──────┘
                           │ loadRequested
                           ▼
                    ┌─────────────┐
                    │   Loading   │
                    └──────┬──────┘
                           │
              ┌────────────┴────────────┐
              │ success                 │ error
              ▼                         ▼
       ┌─────────────┐           ┌─────────────┐
       │   Loaded    │           │    Error    │
       └──────┬──────┘           └─────────────┘
              │ loadMoreRequested
              ▼
       ┌─────────────┐
       │ LoadingMore │
       └──────┬──────┘
              │ success
              ▼
       ┌─────────────┐
       │   Loaded    │ (with more photos)
       └─────────────┘
```

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | ^9.1.1 | State management |
| `http` | ^1.6.0 | HTTP client for API calls |
| `cached_network_image` | ^3.4.1 | Image loading & caching |
| `freezed_annotation` | ^2.4.1 | Immutable data classes |
| `json_annotation` | ^4.9.0 | JSON serialization |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `freezed` | ^2.5.7 | Code generation for Freezed |
| `build_runner` | ^2.4.13 | Code generation runner |
| `json_serializable` | ^6.8.0 | JSON serialization code generation |

---

## Getting Started

### Prerequisites

- Flutter SDK 3.7+
- Dart SDK 3.7+

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:RubyLicht/photos.git
   cd photos
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code** (Freezed & JSON serialization)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

