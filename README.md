# 🌟 Aura - Personal Wellness & Productivity App

A beautiful, feature-rich Flutter application designed to help you manage tasks, track habits, monitor your mood, boost productivity, and analyze your wellness journey.

![GitHub](https://img.shields.io/badge/flutter-v3.11+-blue)
![Dart](https://img.shields.io/badge/dart-3.0+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

---

## ✨ Features

### 🎯 Task Management
- Create and organize daily tasks
- Mark tasks as complete with visual feedback
- Delete tasks with long-press
- Category-based task organization
- Real-time task statistics

### 🎗️ Habit Tracking (Enhanced)
- Build and maintain positive habits
- Track completion streaks with 🔥 indicators
- **NEW:** Frequency options (Daily, Weekly, Monthly)
- **NEW:** Category-based organization (Health, Learning, Fitness, Mindfulness)
- **NEW:** Category badges with emoji indicators
- Historical data tracking
- Long-term habit insights

### 😊 Mood Tracking
- Log your emotional state 5 times a day
- 5-level mood scale: 😢 😟 😐 😊 😄
- Mood history with timestamps
- 7-day mood trend visualization
- Optional notes for each mood entry
- Emotional wellness insights

### ⏱️ Focus Timer (Pomodoro)
- 25-minute Pomodoro focus sessions
- Play/Pause/Reset controls
- Real-time countdown display (MM:SS)
- Session completion tracking
- Statistics dashboard:
  - Sessions completed today
  - Total sessions completed
  - Total minutes focused
- Recent session history
- Productivity insights

### 📊 Analytics Dashboard
- Task completion rate visualization
- Weekly activity charts
- Habit streak tracking
- Progress statistics
- Visual data representation with charts

### ⏰ Real-Time Features
- Live clock display (HH:mm:ss)
- Current date display
- **Dynamic time-based greetings:**
  - Good Morning (5 AM - 12 PM)
  - Good Afternoon (12 PM - 5 PM)
  - Good Evening (5 PM - 9 PM)
  - Good Night (9 PM - 5 AM)
- Daily motivational quotes (8 different quotes)
- Auto-updating every second

---

## 🏗️ Architecture

### Navigation Structure (5-Tab System)
1. **Tasks Tab** - Daily task management
2. **Habits Tab** - Habit tracking and streaks
3. **Mood Tab** - Emotional wellness tracking
4. **Focus Tab** - Pomodoro productivity timer
5. **Analytics Tab** - Statistics and insights

### Data Models
- **AuraTask** - Task management model
- **AuraHabit** - Enhanced habit tracking (with frequency & category)
- **AuraMood** - Mood logging model
- **AuraFocusSession** - Focus timer session model

### Data Persistence
- **SharedPreferences** for local storage
- JSON serialization for all models
- Automatic sync on data changes
- Separate storage keys per data type

---

## 📦 Dependencies

```yaml
flutter:
  sdk: flutter

google_fonts: ^8.0.2          # Beautiful typography
shared_preferences: ^2.2.2    # Local data persistence
fl_chart: ^0.63.0             # Charts and graphs
intl: ^0.19.0                 # Internationalization & date formatting
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.11.4+)
- Dart SDK (v3.0+)
- Android Studio / Xcode (for emulator/device testing)

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/Souvik-Dey-2029/Flutter.git
cd flutter_application_1
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**
```bash
flutter run
```

### For Web:
```bash
flutter run -d chrome
```

### For iOS:
```bash
flutter run -d iPhone
```

### For Android:
```bash
flutter run -d android
```

---

## 🎨 Design System

### Color Scheme
- **Primary:** Indigo Accent (#6366F1)
- **Secondary:** Green Accent (#4ADE80)
- **Accent:** Purple (#A855F7), Rose (#F43F5E)
- **Background:** Dark (#030310)
- **Cards:** Glass morphism with blur effects

### UI Components
- **Glass Cards** - Frosted glass effect with 10px blur
- **Smooth Animations** - 500ms TweenAnimationBuilder
- **Responsive Layout** - Adaptive to all screen sizes
- **Dark Theme** - Eye-friendly dark mode

---

## 📱 Supported Platforms

- ✅ Android (5.0+)
- ✅ iOS (11.0+)
- ✅ Web (Chrome, Firefox, Safari)
- ✅ macOS (10.11+)
- ✅ Windows (10+)
- ✅ Linux

---

## 💡 Usage Examples

### Adding a Task
1. Tap the "+" FAB button on the Tasks tab
2. Enter task title
3. Tap "Create Task"
4. Tap to mark complete, long-press to delete

### Logging a Mood
1. Navigate to the "Mood" tab
2. Tap an emoji button to log your mood
3. View today's mood history
4. Check 7-day trend

### Starting a Focus Session
1. Go to the "Focus" tab
2. Tap "Play" to start the 25-minute timer
3. Tap "Pause" to pause session
4. Tap "Reset" to restart
5. Timer auto-completes and records on finish

### Creating a Habit
1. Tap the "+" FAB button on the Habits tab
2. Enter habit name
3. Habit auto-assigns category and color
4. Tap daily to track completion
5. Watch your streak grow! 🔥

---

## 🔄 Real-Time Updates

The app updates in real-time for:
- ⏰ Clock display (every second)
- 🎉 Greeting messages (when hour changes)
- 📊 Statistics (on data changes)
- ⏱️ Countdown timer (every second during focus)
- 💾 Data persistence (automatic)

---

## 📊 Data Storage

All data is stored locally using **SharedPreferences**:
- **aura_tasks** - Task list
- **aura_habits** - Habit list
- **aura_moods** - Mood history
- **aura_focus_sessions** - Focus session history

No cloud sync (local-only for privacy)

---

## 🛠️ Project Structure

```
lib/
├── main.dart                          # Main app entry & state management
├── features/
│   ├── mood_feature.dart              # Mood tracking implementation
│   ├── focus_feature.dart             # Focus timer implementation
│   ├── habit_enhancement.dart         # Enhanced habit system
│   ├── data_persistence.dart          # Storage layer
│   └── ui_improvements.dart           # UI/UX enhancements
```

---

## 🚀 Recent Updates (v2.0)

### Phase 1: Real-Time Features
- ✅ Live clock display
- ✅ Dynamic time-based greetings
- ✅ Daily motivational quotes

### Phase 2: Mood Tracking
- ✅ 5-level mood system
- ✅ Emoji representations
- ✅ 7-day trend visualization

### Phase 3: Focus Timer
- ✅ Pomodoro (25-min) timer
- ✅ Session tracking
- ✅ Productivity statistics

### Phase 4: Habit Enhancements
- ✅ Frequency options
- ✅ Category organization
- ✅ Better visual indicators

### Phase 5: Data Persistence
- ✅ Extended storage layer
- ✅ All features persistent

### Phase 6: UI Improvements
- ✅ 5-tab navigation
- ✅ Enhanced design system
- ✅ Accessibility improvements

---

## 🐛 Known Issues

- Windows: Some animations may be smoother on higher refresh rate displays
- Web: Notifications not yet supported

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 Commit History

This project uses semantic commit messages:
- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation
- `chore:` Maintenance
- `refactor:` Code refactoring

View the [CHANGELOG_FEATURES.md](CHANGELOG_FEATURES.md) for detailed feature documentation.

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👤 Author

**Souvik Dey**
- GitHub: [@Souvik-Dey-2029](https://github.com/Souvik-Dey-2029)
- Project: [Flutter](https://github.com/Souvik-Dey-2029/Flutter)

---

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design Guide](https://material.io/design)
- [Pomodoro Technique](https://en.wikipedia.org/wiki/Pomodoro_Technique)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Fonts for beautiful typography
- fl_chart for data visualization
- All contributors and users

---

## 📞 Support

For issues, questions, or suggestions, please open an issue on GitHub or contact the author.

---

**Happy tracking! Stay productive, be mindful, and make every moment count! 🌟**
