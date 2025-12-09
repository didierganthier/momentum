# Momentum - Build Better Habits 🚀

A beautiful, feature-rich habit tracking app built with Flutter. Track your daily habits, build streaks, and achieve your goals with optional cloud sync and smart notifications.

## ✨ Features

### 🎯 Core Features
- **Habit Tracking**: Create and track unlimited habits
- **Streak Counter**: Visualize your progress with a powerful streak system
- **Smart Categories**: Organize habits by type (Health, Productivity, Learning, Mindfulness, Social, Finance, Creativity)
- **Category Filtering**: Filter habits by category to focus on specific areas

### 🔔 Smart Reminders
- **Daily Notifications**: Set custom reminder times for each habit
- **Never Miss a Day**: Get notified at your preferred time to complete your habits
- **Cross-Platform**: Works on both iOS and Android with native notification support
- **Exact Timing**: Notifications fire at precise times, even when the app is closed

### 💾 Flexible Storage
- **Local-First Architecture**: Start using immediately, no account required
- **Offline Support**: Full functionality without internet connection
- **Optional Cloud Sync**: Sign in to sync habits across devices
- **Automatic Migration**: Local habits automatically sync when you sign in

### 🎨 Beautiful UI
- **Material Design 3**: Modern, clean interface
- **Smooth Animations**: Delightful interactions throughout
- **Dark Mode Ready**: Easy on the eyes
- **Custom Gradients**: Visually appealing color schemes

## 📱 Screenshots

*(Screenshots coming soon)*

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Firebase account (optional, for cloud sync)
- iOS 10.0+ / Android API 21+ or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/momentum.git
   cd momentum
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase (Optional)**
   
   If you want cloud sync functionality:
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Login to Firebase
   firebase login
   
   # Configure Firebase for your project
   flutterfire configure
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔔 Notification Setup

The app uses `flutter_local_notifications` for daily habit reminders. The necessary configurations are already in place:

### Android
- Permissions are configured in `AndroidManifest.xml`
- Supports exact alarms for precise notification timing
- Notifications persist across device reboots

### iOS
- Notification permissions are requested on first launch
- Supports alert, badge, and sound notifications
- No additional configuration needed

## 📦 Dependencies

Key packages used in this project:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.0.5
  
  # Firebase
  firebase_core: ^3.15.2
  firebase_auth: ^5.7.0
  cloud_firestore: ^5.6.12
  
  # Local Storage
  shared_preferences: ^2.2.3
  
  # Notifications
  flutter_local_notifications: ^18.0.1
  timezone: ^0.9.4
  permission_handler: ^11.3.1
  
  # UI
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
```

## 🏗️ Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern:

```
lib/
├── models/           # Data models (Habit, HabitCategory)
├── services/         # Business logic (Firebase, Local Storage, Notifications)
├── viewmodels/       # State management (Provider)
├── views/            # UI screens
└── widgets/          # Reusable components
```

### Key Components

- **LocalStorageService**: Handles offline data with SharedPreferences
- **HabitService**: Manages Firebase Firestore operations
- **NotificationService**: Schedules and manages daily reminders
- **HabitViewModel**: Coordinates between services and UI

## 🎯 Usage

### Creating a Habit
1. Tap the **+** button
2. Enter habit name (e.g., "Read for 30 minutes")
3. Select a category
4. Optionally set a daily reminder time
5. Tap **Save**

### Completing a Habit
- Tap the checkmark on any habit card
- Your streak will automatically increase if completed daily
- Missing a day resets your streak to 1

### Setting Reminders
- When creating a habit, tap **"Set a reminder time"**
- Choose your preferred notification time
- You'll receive a daily notification at that time
- Clear the reminder by tapping the **X** icon

### Cloud Sync
- Tap the **login** icon in the app bar
- Sign in with email/password
- Your local habits will automatically sync to the cloud
- Sign in on another device to access the same habits

## 🔧 Customization

### Adding New Categories
Edit `lib/models/habit_category.dart`:

```dart
enum HabitCategory {
  health,
  productivity,
  learning,
  mindfulness,
  social,
  finance,
  creativity,
  other,
  yourNewCategory,  // Add here
}
```

### Changing Notification Channel
Edit `lib/services/notification_service.dart`:

```dart
AndroidNotificationDetails(
  'habit_reminders',      // Channel ID
  'Habit Reminders',      // Channel name
  channelDescription: 'Daily reminders for your habits',
  importance: Importance.high,
  // ... customize other properties
)
```

## 🐛 Troubleshooting

### Notifications not working on Android
1. Ensure the app has notification permissions
2. Check that "Exact alarm" permission is granted (Android 12+)
3. Verify battery optimization is disabled for the app

### Notifications not working on iOS
1. Check notification permissions in Settings > Notifications > Momentum
2. Ensure the app is not in Low Power Mode during testing

### Firebase sync issues
1. Ensure you're logged in (check for login icon in app bar)
2. Check internet connection
3. Verify Firebase project is configured correctly

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Icons from [Material Icons](https://fonts.google.com/icons)
- Fonts from [Google Fonts](https://fonts.google.com/)

---

Made with ❤️ by [Your Name]
