# Momentum - Habit Tracking App

A beautiful Flutter habit tracking application with modern UI, smooth animations, and Firebase integration.

## ✨ Features

### 🎨 Modern UI Design
- **Material Design 3** with custom color schemes
- **Google Fonts** (Inter) for beautiful typography
- **Gradient backgrounds** on auth screens
- **Card-based layouts** with elevation and shadows
- **Custom animations** throughout the app

### 🎭 Animations
- **Splash screen** with animated logo and fade-in effects
- **Page transitions** with Hero animations
- **List items** animate in with staggered delays
- **Interactive cards** with scale animations on press
- **Floating action button** with elastic animation
- **Success/error messages** with animated snackbars

### 📊 Statistics Dashboard
- **Total habits count** displayed in a stat card
- **Best streak tracker** showing your longest streak
- **Color-coded streak indicators**:
  - Blue: New habits (0-6 days)
  - Green: Weekly streak (7-13 days)
  - Orange: Bi-weekly streak (14-29 days)
  - Purple: Monthly streak (30+ days)

### 🔥 Habit Management
- **Create habits** with validation
- **Track streaks** with visual indicators
- **Complete habits** with celebration animations
- **Delete habits** with confirmation dialog
- **Long-press** to delete habits
- **Smart messaging** based on streak length

### 🔐 Authentication
- **Email/Password authentication** with Firebase
- **Form validation** for email and password
- **Password visibility toggle**
- **Password confirmation** on registration
- **Logout confirmation** dialog
- **Beautiful auth screens** with gradients

### 🎯 User Experience
- **Empty state** with helpful instructions
- **Loading states** with splash screen
- **Error handling** with retry options
- **Confirmation dialogs** for destructive actions
- **Success feedback** with animated snackbars
- **Responsive design** adapting to different screen sizes

## 🏗️ Architecture

### MVVM Pattern
- **Models**: Data structures for Habit
- **Views**: UI components (Login, Register, Home)
- **ViewModels**: Business logic (AuthViewModel, HabitViewModel)
- **Services**: Firebase integration (AuthService, HabitService)

### State Management
- **Provider** for state management
- **ChangeNotifier** for reactive updates
- **Consumer widgets** for rebuilding UI

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5           # State management
  firebase_core: ^3.0.0      # Firebase initialization
  firebase_auth: ^5.0.0      # Authentication
  cloud_firestore: ^5.0.0    # Database
  google_fonts: ^6.2.1       # Typography
  flutter_animate: ^4.5.0    # Animations

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0      # Linting rules
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase project set up
- Firebase CLI installed

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd momentum
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   flutterfire configure
   ```
   - Select your Firebase project
   - Choose the platforms you want to support

4. **Run the app**
   ```bash
   flutter run
   ```

## 🎨 UI Improvements Made

### Login Screen
- ✅ Gradient background
- ✅ Card-based form layout
- ✅ Animated logo with Hero animation
- ✅ Email/password validation
- ✅ Password visibility toggle
- ✅ Fade-in and slide animations
- ✅ Improved button styling

### Register Screen
- ✅ Matching gradient background
- ✅ Password confirmation field
- ✅ Form validation with helpful messages
- ✅ Smooth animations
- ✅ Back to login navigation

### Home Screen
- ✅ Statistics cards at the top
- ✅ Empty state with illustrations
- ✅ Staggered list animations
- ✅ Color-coded habit cards
- ✅ Logout confirmation dialog
- ✅ Extended FAB with icon and label

### Habit Cards
- ✅ Gradient streak indicators
- ✅ Dynamic colors based on streak length
- ✅ Interactive press animations
- ✅ Celebration on completion
- ✅ Delete confirmation
- ✅ Smart streak messages

## 🎬 Animation Details

### Splash Screen
- Logo scales in with elastic effect
- Title fades and slides up
- Subtitle follows with delay
- Loading spinner appears last

### List Items
- Staggered fade-in animations
- Slide-up effect with delay based on position
- Smooth transitions

### Interactive Elements
- Scale down on press
- Shadow reduction on press
- Color transitions
- Snackbar animations

## 📱 Screens

1. **Splash Screen** - Animated loading screen
2. **Login Screen** - Email/password authentication
3. **Register Screen** - New user registration
4. **Home Screen** - Habit list with statistics
5. **Dialogs** - Add habit, delete confirmation, logout

## 🔧 Customization

### Change Theme Colors
Edit `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF6366F1), // Change this color
  brightness: Brightness.light,
),
```

### Modify Animations
Adjust duration in respective view files:
```dart
duration: const Duration(milliseconds: 1000), // Modify timing
curve: Curves.easeOut, // Change curve
```

## 📝 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
