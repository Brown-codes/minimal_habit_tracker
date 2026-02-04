# Minimal Habit Tracker

A clean, minimalist Flutter application designed to help users build and maintain daily habits through visual tracking and a simple user interface.

## 🚀 Features

- **Habit Management**: Easily create, edit, and delete daily habits.
- **Completion Tracking**: Toggle habit completion with a simple checkbox or tap.
- **Visual Progress**: Integrated Heat Map calendar to visualize your consistency over time.
- **Dark & Light Mode**: Seamlessly switch between themes to suit your preference.
- **Local Persistence**: Powered by Isar Database for fast, reliable, and offline-first data storage.
- **Swipe Actions**: Quickly edit or delete habits using intuitive swipe gestures.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Database**: [Isar](https://isar.dev/) (NoSQL database for Flutter/Dart)
- **UI Components**:
    - `flutter_heatmap_calendar` for the contribution-style progress view.
    - `flutter_slidable` for interactive list items.


## 📦 Getting Started

### Prerequisites

- Flutter SDK (v3.10.1 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/minimal_habit_tracker.git
   cd minimal_habit_tracker
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Isar models:**
   This project uses `isar_generator`. Run the build runner to generate the necessary code:
   ```bash
   dart run build_runner build
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 📂 Project Structure

- `lib/database/`: Contains `HabitDatabase` for Isar initialization and CRUD operations.
- `lib/model/`: Defines the Isar schemas for `Habit` and `AppSettings`.
- `lib/pages/`: Main application screens (e.g., `HomePage`).
- `lib/components/`: Reusable UI widgets like `MyHabitTile`, `MyHeatMap`, and `MyDrawer`.
- `lib/theme/`: Theme configuration and `ThemeProvider` for dynamic styling.
- `lib/utils/`: Helper functions for date normalization and heat map data preparation.

## 🤝 Contributing

Contributions are welcome! If you have suggestions for improvements or new features, feel free to open an issue or submit a pull request.

## 📝 License

This project is for educational purposes. Feel free to use it as a base for your own tracker!
