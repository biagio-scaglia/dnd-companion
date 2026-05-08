import '../domain/models/calendar_event.dart';
import '../domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  List<CalendarEvent> _events = [];
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    
    // Dati mock
    _events = [
      CalendarEvent(
        id: 'event-1',
        title: 'Prossima Sessione',
        date: DateTime.now().add(const Duration(days: 3)),
        hasSession: true,
        hasReminder: true,
        isImportant: true,
      ),
      CalendarEvent(
        id: 'event-2',
        title: 'Festa al Villaggio',
        date: DateTime.now().add(const Duration(days: 5)),
        isImportant: false,
      ),
    ];
    _initialized = true;
  }

  @override
  Future<List<CalendarEvent>> getEvents() async {
    await _init();
    return List.unmodifiable(_events);
  }

  @override
  Future<CalendarEvent> addEvent(CalendarEvent event) async {
    await _init();
    _events.add(event);
    return event;
  }

  @override
  Future<CalendarEvent> updateEvent(CalendarEvent event) async {
    await _init();
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
    }
    return event;
  }

  @override
  Future<void> deleteEvent(String id) async {
    await _init();
    _events.removeWhere((e) => e.id == id);
  }
}
