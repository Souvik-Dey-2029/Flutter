import 'package:intl/intl.dart';
import 'constants.dart';

class AuraUtils {
  AuraUtils._();

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  static String getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return '☀️';
    } else if (hour >= 12 && hour < 17) {
      return '🌤️';
    } else if (hour >= 17 && hour < 21) {
      return '🌅';
    } else {
      return '🌙';
    }
  }

  static String getQuoteOfDay() {
    final now = DateTime.now();
    final dayOfYear = int.parse(DateFormat('D').format(now));
    return AppConstants.quotes[dayOfYear % AppConstants.quotes.length];
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatTimeWithSeconds(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }

  static String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d').format(date);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  static String formatTimestamp(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatDayOfWeek(DateTime date) {
    return DateFormat('E').format(date);
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatShortDate(date);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
