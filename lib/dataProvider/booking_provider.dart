import 'package:flutter/material.dart';

enum BookingType { yoga, event }

enum BookingStatus { upcoming, completed, cancelled }

class BookingItem {
  final String id;
  final String title;
  final BookingType type;
  final String category;
  final String date;
  final String timeSlot;
  final String location;
  final String instructor;
  final String passCode;
  BookingStatus status;

  BookingItem({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.date,
    required this.timeSlot,
    required this.location,
    required this.instructor,
    required this.passCode,
    this.status = BookingStatus.upcoming,
  });
}

class BookingProvider extends ChangeNotifier {
  final List<BookingItem> _bookings = [
    BookingItem(
      id: "bk-101",
      title: "Vedic Hatha Yoga Flow",
      type: BookingType.yoga,
      category: "Morning Sadhana",
      date: "Mon, Wed, Fri",
      timeSlot: "06:00 AM - 07:30 AM",
      location: "Surya Mandapam & Online Stream",
      instructor: "Dr. Ananya Mishra",
      passCode: "PASS-YOGA-101",
      status: BookingStatus.upcoming,
    ),
    BookingItem(
      id: "bk-102",
      title: "Sharad Purnima 7-Day Silent Immersion",
      type: BookingType.event,
      category: "Sadhana Retreat",
      date: "Oct 12 - 18, 2024",
      timeSlot: "04:30 AM - 08:00 AM IST",
      location: "Ganga-front Hermitage, Rishikesh",
      instructor: "Acharya Shridhar",
      passCode: "PASS-EVT-204",
      status: BookingStatus.upcoming,
    ),
    BookingItem(
      id: "bk-103",
      title: "Pranayama & Energy Awakening",
      type: BookingType.yoga,
      category: "Breath Science",
      date: "Tue, Thu",
      timeSlot: "06:30 AM - 07:30 AM",
      location: "Tapovan Ghat Kutir",
      instructor: "Dr. Ananya Mishra",
      passCode: "PASS-YOGA-103",
      status: BookingStatus.upcoming,
    ),
    BookingItem(
      id: "bk-104",
      title: "Maha Shivaratri Satsang & Chanting",
      type: BookingType.event,
      category: "Spiritual Gathering",
      date: "March 8, 2024",
      timeSlot: "06:00 PM - 09:00 PM",
      location: "Main Sanctuary Hall",
      instructor: "Swami Vedananda",
      passCode: "PASS-EVT-098",
      status: BookingStatus.completed,
    ),
  ];

  List<BookingItem> get bookings => List.unmodifiable(_bookings);

  List<BookingItem> get upcomingBookings =>
      _bookings.where((b) => b.status == BookingStatus.upcoming).toList();

  List<BookingItem> get completedBookings =>
      _bookings.where((b) => b.status == BookingStatus.completed).toList();

  List<BookingItem> get cancelledBookings =>
      _bookings.where((b) => b.status == BookingStatus.cancelled).toList();

  void addBooking(BookingItem item) {
    _bookings.insert(0, item);
    notifyListeners();
  }

  void cancelBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index].status = BookingStatus.cancelled;
      notifyListeners();
    }
  }

  void rescheduleBooking(String id, String newDate, String newTimeSlot) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      _bookings[index] = BookingItem(
        id: _bookings[index].id,
        title: _bookings[index].title,
        type: _bookings[index].type,
        category: _bookings[index].category,
        date: newDate,
        timeSlot: newTimeSlot,
        location: _bookings[index].location,
        instructor: _bookings[index].instructor,
        passCode: _bookings[index].passCode,
        status: BookingStatus.upcoming,
      );
      notifyListeners();
    }
  }
}
