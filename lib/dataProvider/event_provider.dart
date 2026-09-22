import 'package:flutter/material.dart';
import '../models/event_item.dart';

class EventProvider extends ChangeNotifier {
  final List<EventItem> upcomingEvents = [
    EventItem(
      title: "Rigveda Samhita Shakalya Chanting Mahayagna",
      description:
          "A monumental 10-day gathering focused on the complete recitation of the Rigveda with precise phonetic markers.",
      date: DateTime(2024, 4, 15),
      time: "05:00 AM - 12:00 PM",
      location: "Main Sanctuary Hall, Rishikesh",
      status: EventStatus.upcoming,
      galleryImages: [],
    ),
    EventItem(
      title: "Paninian Sanskrit Grammar & Vedic Chandas Intensive",
      description:
          "Deep dive into the structural precision of Panini's grammar and the rhythmic meters of Vedic prosody.",
      date: DateTime(2024, 5, 10),
      time: "09:00 AM - 04:00 PM",
      location: "Vidya Mandapam",
      status: EventStatus.upcoming,
      galleryImages: [],
    ),
    EventItem(
      title: "Soma Mandala Eclipse Dhyana & Mantra Sadhana",
      description:
          "Special meditative assembly during the lunar transition, focusing on the Soma Sukta and internal silence.",
      date: DateTime(2024, 6, 20),
      time: "08:00 PM - 11:30 PM",
      location: "Surya Ghat Pavilion",
      status: EventStatus.upcoming,
      galleryImages: [],
    ),
    EventItem(
      title: "Ayurveda Ritucharya & Spring Dinacharya Conclave",
      description:
          "Seasonal wellness retreat aligning daily routines with the spring transition according to Charaka Samhita.",
      date: DateTime(2024, 3, 25),
      time: "06:00 AM - 02:00 PM",
      location: "Dhanvantari Grove",
      status: EventStatus.upcoming,
      galleryImages: [],
    ),
  ];

  final List<Map<String, dynamic>> pastEvents = [
    {
      "year": "2023",
      "title": "International Veda Parayana Sangam 2023",
      "desc":
          "Global confluence of chanters representing various shakhas of the four Vedas.",
      "transcript": true,
    },
    {
      "year": "2023",
      "title": "Kashi Palm-Leaf Restoration Colloquium",
      "desc":
          "Academic gathering focused on advanced digitization and chemical preservation techniques.",
      "transcript": true,
    },
    {
      "year": "2022",
      "title": "Ganga Pradikshina Dawn Meditation of Atma-Bodha",
      "desc":
          "A series of dawn contemplations along the banks of the Bhagirathi.",
      "transcript": false,
    },
  ];
}
