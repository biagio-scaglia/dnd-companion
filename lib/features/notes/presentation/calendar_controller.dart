import 'package:flutter/material.dart';
import '../domain/models/calendar_event.dart';
import '../domain/repositories/calendar_repository.dart';
import 'package:uuid/uuid.dart';

class CalendarController extends ChangeNotifier {
  final CalendarRepository repository;
  final _uuid = const Uuid();

  CalendarController({required this.repository}) {
    loadEvents();
  }

  List<CalendarEvent> _events = [];
  List<CalendarEvent> get events => _events;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = await repository.getEvents();
    } catch (e) {
      debugPrint('Error loading calendar events: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createEvent(String title, DateTime date, {bool isImportant = false, bool hasReminder = false, bool hasSession = false}) async {
    final event = CalendarEvent(
      id: _uuid.v4(),
      title: title,
      date: date,
      isImportant: isImportant,
      hasReminder: hasReminder,
      hasSession: hasSession,
    );
    await repository.addEvent(event);
    await loadEvents();
  }

  Future<void> deleteEvent(String id) async {
    await repository.deleteEvent(id);
    await loadEvents();
  }

  CalendarEvent? get nextEvent {
    final now = DateTime.now();
    try {
      final upcoming = _events.where((e) => e.date.isAfter(now) || e.date.isAtSameMomentAs(now)).toList();
      if (upcoming.isEmpty) return null;
      upcoming.sort((a, b) => a.date.compareTo(b.date));
      return upcoming.first;
    } catch (_) {
      return null;
    }
  }

  CalendarEvent? get nextReminder {
    final now = DateTime.now();
    try {
      final upcoming = _events.where((e) => e.hasReminder && (e.date.isAfter(now) || e.date.isAtSameMomentAs(now))).toList();
      if (upcoming.isEmpty) return null;
      upcoming.sort((a, b) => a.date.compareTo(b.date));
      return upcoming.first;
    } catch (_) {
      return null;
    }
  }
}
