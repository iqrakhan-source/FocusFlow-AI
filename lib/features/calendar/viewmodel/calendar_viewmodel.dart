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
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }

  List<CalendarEventModel> eventsForDate(DateTime date) {
    return _events.where((event) {
      return event.date.year == date.year &&
          event.date.month == date.month &&
          event.date.day == date.day;
    }).toList();
  }
}