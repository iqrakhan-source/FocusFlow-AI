import 'package:flutter/material.dart';

import '../model/calendar_event_model.dart';
import '../repository/calendar_repository.dart';

class CalendarViewModel extends ChangeNotifier {
  final CalendarRepository _repository = CalendarRepository();

  List<CalendarEventModel> _events = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<CalendarEventModel> get events =>
      List.unmodifiable(_events);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> loadEvents(int userId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _events = await _repository.getEvents(userId);

      debugPrint('========== CALENDAR EVENTS ==========');
      debugPrint('Total events: ${_events.length}');

      for (final event in _events) {
        debugPrint(
          'title=${event.title} | '
              'type=${event.eventType} | '
              'date=${event.date} | '
              'subject=${event.subject}',
        );
      }

      debugPrint('=====================================');
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Calendar error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CalendarEventModel> eventsForDate(DateTime date) {
    final result = _events.where((event) {
      final matches =
          event.date.year == date.year &&
              event.date.month == date.month &&
              event.date.day == date.day;

      debugPrint(
        'Calendar check: '
            'event=${event.title}, '
            'eventDate=${event.date}, '
            'calendarDate=$date, '
            'matches=$matches',
      );

      return matches;
    }).toList();

    debugPrint(
      'Events for $date: ${result.map((e) => e.title).toList()}',
    );

    return result;
  }

}