# 🎨 Aura Productivity - Smart Task & Habit Tracker

A beautiful, **production-ready** Flutter application that combines task management with habit tracking and advanced analytics.

## ✨ Features

### 📋 **Task Management**
- Create, complete, and delete tasks
- Organize tasks by categories (Personal, Development, Study, etc.)
- Beautiful glassmorphism UI with smooth animations
- Real-time task completion tracking
- Persistent local storage (survives app restarts)

### 🔥 **Habit Tracking**
- Build and maintain daily habits
- Visual streak counter showing consecutive days completed
- Color-coded habits for quick identification
- Track completion history for each habit
- Mark habits complete/incomplete daily

### 📊 **Analytics Dashboard**
- **Completion Rate**: Visual progress indicator showing task completion percentage
- **Weekly Activity Chart**: Bar chart showing task distribution across the week
- **Habit Streaks**: Display of all habits with their current streak count using flame emoji 🔥
- **At-a-Glance Stats**: Quick stat cards showing daily performance

### 🎨 **Beautiful UI/UX**
- Dark theme with glassmorphism effects (frosted glass appearance)
- Animated background with gradient blobs
- Smooth transitions and micro-interactions
- Tab-based navigation (Tasks, Habits, Analytics)
- Elegant modal dialogs for creating tasks/habits
- Professional typography using Google Fonts (Outfit)

### 💾 **Data Persistence**
- All tasks and habits saved locally using SharedPreferences
- Automatic saving on every action
- Data persists between app sessions
- No internet required

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.11.4 or higher)
- Android emulator / iOS simulator or physical device
- Basic knowledge of Flutter

### Installation

1. **Clone or navigate to the project:**
   ```bash
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

---

## 📁 Project Structure

```
lib/
├── main.dart                 # Complete app implementation (single-file approach)
│   ├── AuraApp              # Root app widget
│   ├── Models:
│   │   ├── AuraTask         # Task model with serialization
│   │   └── AuraHabit        # Habit model with streak logic
│   ├── Data Service:
│   │   └── AuraDataService  # Local storage and data persistence
│   ├── UI:
│   │   ├── AuraHomePage     # Main home screen with tabs
│   │   ├── GlassTaskCard    # Task display component
│   │   ├── HabitCard        # Habit display component
│   │   ├── StatCard         # Quick stats display
│   │   ├── GlassCard        # Reusable glass effect container
│   │   └── AuraBackground   # Animated gradient background
│   └── Tabs:
│       ├── Tasks Tab        # Task management
│       ├── Habits Tab       # Habit tracking
│       └── Analytics Tab    # Performance charts

pubspec.yaml               # Project dependencies
```

---

## 🔧 Dependencies

```yaml
google_fonts: ^8.0.2         # Beautiful typography
shared_preferences: ^2.2.2   # Local data persistence
fl_chart: ^0.63.0            # Charts and graphs for analytics
intl: ^0.19.0                # Internationalization & date formatting
```

---

## 📱 Core Functionality

### Task Management
```dart
// Create a task
AuraTask(
  id: DateTime.now().toString(),
  title: "Complete project",
  category: "Development",
  createdAt: DateTime.now(),
)

// Toggle completion
_tasks[index].isCompleted = !_tasks[index].isCompleted;

// Save to persistent storage
AuraDataService.saveTasks(_tasks);
```

### Habit Tracking
```dart
// Create a habit
AuraHabit(
  id: DateTime.now().toString(),
  title: "Morning Run",
  color: Colors.greenAccent,
  createdAt: DateTime.now(),
)

// Check habit completion today
habit.isCompletedToday()

// Get current streak
int streak = habit.getStreak()

// Toggle habit for today
habit.completedDates.add(DateTime.now());
```

### Analytics
- **Completion Rate**: `(completedTasks / totalTasks) * 100%`
- **Weekly Activity**: Aggregates tasks created in the last 7 days
- **Habit Streaks**: Calculates consecutive days of completion

---

## 🎯 Use Cases & Problem It Solves

### 1. **Productivity Crisis**
**Problem**: People juggle multiple tasks without tracking progress
**Solution**: Aura provides a beautiful, organized task list with visual completion tracking

### 2. **Habit Formation Failure**
**Problem**: Hard to build consistent habits; no motivation tracking
**Solution**: Streak counter with visual fire emoji provides daily motivation and progress visibility

### 3. **No Performance Insights**
**Problem**: Users don't know their productivity patterns
**Solution**: Analytics dashboard shows weekly activity, completion rates, and habit consistency

### 4. **Distraction & Digital Overwhelm**
**Problem**: Existing apps are cluttered and distracting
**Solution**: Minimal, beautiful glassmorphic design with smooth animations keeps users focused

---

## 🎨 Design Highlights

### Glassmorphism Effect
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
    ),
  ),
)
```

### Animated Background
- Animated purple and indigo gradient blobs
- Smooth 10-second animation loop
- Creates immersive, professional atmosphere

### Color Scheme
- **Background**: Deep space black (#030310)
- **Accents**: Indigo, Green, Purple, Orange
- **Text**: White with transparency variations
- **Highlights**: ColorAccent shades for interactive elements

---

## 💡 Showcase Talking Points

1. **Complete Feature Set**: Not just a UI mockup—fully functional app with data persistence
2. **Beautiful Design**: Modern glassmorphic design that stands out
3. **Production Quality**: Proper architecture with models, services, and separation of concerns
4. **User Experience**: Smooth animations, intuitive interactions, and meaningful micro-interactions
5. **Real Problem Solver**: Addresses genuine productivity and habit-building challenges
6. **Data Visualization**: Charts and analytics to motivate users
7. **Offline-First**: Works without internet—great for privacy-conscious users

---

## 🔄 How to Showcase

### Live Demo Script:
1. **Launch the app** - Show beautiful dark theme with animated background
2. **Create a task** - Tap FAB, add "Complete Flutter Project", show glass card animation
3. **Complete a task** - Tap task card to mark complete, watch check animation
4. **Create a habit** - Add "Morning Workout", explain streak concept
5. **Complete habit** - Mark habit done, highlight streak counter
6. **Show analytics** - Switch to Analytics tab, show completion rate and weekly chart
7. **Add multiple items** - Demonstrate scale and performance
8. **Close and reopen** - Show data persistence from SharedPreferences

---

## 🚀 Future Enhancement Ideas

- [ ] Notification reminders for habits and tasks
- [ ] Cloud sync across devices
- [ ] Habit templates (exercise, meditation, reading, etc.)
- [ ] Custom color themes
- [ ] Export analytics as PDF/CSV
- [ ] Social sharing of streaks
- [ ] Gamification (badges, achievements)
- [ ] Dark/Light mode toggle
- [ ] Multiple habit view (calendar heatmap)
- [ ] Integration with calendar apps

---

## 📄 License

This project is part of a portfolio showcase. Feel free to use it as inspiration for your own projects.

---

## 👨‍💻 Author Notes

**Aura Productivity** demonstrates:
- Complete Flutter application architecture
- State management with StatefulWidget
- Local data persistence with SharedPreferences
- Advanced UI with glassmorphism and animations
- Tab navigation with TabController
- Chart integration with FL Chart
- JSON serialization for data models
- Clean code practices and separation of concerns

**Perfect for**: Portfolio projects, app store submissions, interviews, or personal productivity use.

---

## 🎓 Learning Resources Used

- Flutter documentation
- Google Fonts package
- SharedPreferences for local storage
- FL Chart for data visualization
- Material Design 3 guidelines

---

**Build Date**: March 2026  
**Status**: ✅ Production Ready  
**Platform**: Android & iOS (Universal)

---

*Ready to showcase! 🚀*
