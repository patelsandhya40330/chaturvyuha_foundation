import 'package:flutter/material.dart';
import '../models/yoga_program.dart';

class YogaProvider extends ChangeNotifier {
  final List<YogaProgram> yogaPrograms = [
    YogaProgram(
      title: "Ashtanga Yoga Sadhana: Patanjali 8-Limb Immersion",
      description:
          "Systematic study and practice of the eight limbs of yoga, from ethical foundations to meditative absorption.",
      instructor: "Acharya Swami Brahmatejananda",
      schedule: "Mon, Wed, Fri (6:00 AM - 7:30 AM)",
      type: ProgramType.yoga,
    ),
    YogaProgram(
      title: "Pranayama & Prana Vidya: Breath Mastery",
      description:
          "Deep dive into classical breathing techniques designed to stabilize the nervous system and awaken vital energy.",
      instructor: "Vidushi Ananya Devi",
      schedule: "Tue, Thu (6:30 AM - 7:30 AM)",
      type: ProgramType.yoga,
    ),
    YogaProgram(
      title: "Vedic Kundalini & Chakra Shuddhi",
      description:
          "Purification practices focused on the subtle energy centers through mantra, visualization, and specialized postures.",
      instructor: "Acharya Devavrata Shastri",
      schedule: "Saturdays (5:00 PM - 6:30 PM)",
      type: ProgramType.yoga,
    ),
    YogaProgram(
      title: "Nada Yoga: Sound, Resonance & Yantra",
      description:
          "Exploring the spiritual power of sound vibrations and sacred geometry for deep meditative focus.",
      instructor: "Swami Vedananda",
      schedule: "Sundays (5:30 PM - 7:00 PM)",
      type: ProgramType.meditation,
    ),
  ];

  final List<Map<String, dynamic>> yogaTimetable = [
    {
      "time": "05:30 AM",
      "title": "Pratah Sandhya & Dawn Gayatri Meditation",
      "tag": "MEDITATION",
      "location": "Surya Mandapam & Live",
      "mode": "In-person & Online",
    },
    {
      "time": "06:30 AM",
      "title": "Classical Ashtanga Asana & Surya Namaskar",
      "tag": "YOGA ASANA",
      "location": "Main Sadhana Hall",
      "mode": "In-person Only",
    },
    {
      "time": "08:00 AM",
      "title": "Prana Vidya & Breath Restoration",
      "tag": "PRANAYAMA",
      "location": "Riverfront Deck",
      "mode": "In-person & Online",
    },
    {
      "time": "05:30 PM",
      "title": "Sunset Sandhyavandanam & Nada Sound Bath",
      "tag": "NADA YOGA",
      "location": "Temple Pavilion",
      "mode": "In-person Only",
    },
    {
      "time": "08:00 PM",
      "title": "Atma Vicara & Guided Yoga Nidra",
      "tag": "RELAXATION",
      "location": "Virtual Sanctuary",
      "mode": "Online Only",
    },
  ];
}
