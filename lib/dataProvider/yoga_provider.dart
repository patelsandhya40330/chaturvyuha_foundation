import 'package:flutter/material.dart';
import '../models/yoga_program.dart';

/// Provider managing Yoga, Meditation, and Sadhana curricula and timetable schedules.
class YogaProvider extends ChangeNotifier {
  /// Structured long-term yoga and meditation curricula programs.
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
      title: "Private Sadhana: Personalized One-on-One Mentorship",
      description:
          "Custom tailored yoga, pranayama, and meditation guidance designed for individual physiological and spiritual needs.",
      instructor: "Acharya Devavrata Shastri",
      schedule: "By Individual Appointment",
      type: ProgramType.yoga,
    ),
    YogaProgram(
      title: "Youth Vedic Yoga & Mind Focus Curriculum",
      description:
          "Engaging posture sequences, phonetic chanting, and mindfulness exercises tailored for young practitioners.",
      instructor: "Vidushi Meenakshi Sharma",
      schedule: "Saturdays & Sundays (4:00 PM - 5:15 PM)",
      type: ProgramType.yoga,
    ),
    YogaProgram(
      title: "Nada Yoga: Sound, Resonance & Yantra Meditation",
      description:
          "Exploring the spiritual power of sound vibrations and sacred geometry for deep meditative focus.",
      instructor: "Swami Vedananda",
      schedule: "Sundays (5:30 PM - 7:00 PM)",
      type: ProgramType.meditation,
    ),
  ];

  /// Daily sanctuary timetable sessions categorized by attendance mode.
  final List<Map<String, dynamic>> yogaTimetable = [
    // 1. IN-PERSON AT SANCTUARY
    {
      "time": "05:30 AM",
      "title": "Pratah Sandhya & Dawn Gayatri Meditation",
      "tag": "MEDITATION",
      "location": "Surya Mandapam",
      "mode": "In-person at Sanctuary",
    },
    {
      "time": "06:30 AM",
      "title": "Classical Ashtanga Asana & Surya Namaskar",
      "tag": "YOGA ASANA",
      "location": "Main Sadhana Hall",
      "mode": "In-person at Sanctuary",
    },
    {
      "time": "08:00 AM",
      "title": "Prana Vidya & Riverfront Breathwork",
      "tag": "PRANAYAMA",
      "location": "Ganga Ghat Deck",
      "mode": "In-person at Sanctuary",
    },
    {
      "time": "05:30 PM",
      "title": "Sunset Sandhyavandanam & Nada Sound Bath",
      "tag": "NADA YOGA",
      "location": "Temple Pavilion",
      "mode": "In-person at Sanctuary",
    },

    // 2. VIRTUAL CLASSES
    {
      "time": "07:00 AM",
      "title": "Global Online Prana Vidya & Mantra Chanting",
      "tag": "VIRTUAL CLASS",
      "location": "Virtual Sanctuary Zoom",
      "mode": "Virtual Classes",
    },
    {
      "time": "06:00 PM",
      "title": "Interactive Advaita Dhyana & Manuscript Inquiry",
      "tag": "VIRTUAL SANGHA",
      "location": "Online Live Portal",
      "mode": "Virtual Classes",
    },
    {
      "time": "08:00 PM",
      "title": "Atma Vicara & Guided Yoga Nidra",
      "tag": "RELAXATION",
      "location": "Virtual Sanctuary",
      "mode": "Virtual Classes",
    },

    // 3. PRIVATE SADHANA
    {
      "time": "09:30 AM",
      "title": "One-on-One Asana Alignment & Spine Alignment",
      "tag": "PRIVATE SADHANA",
      "location": "Private Gurukul Suite",
      "mode": "Private Sadhana",
    },
    {
      "time": "04:00 PM",
      "title": "Customized Therapeutic Pranayama & Kundalini Mentorship",
      "tag": "PRIVATE SADHANA",
      "location": "Acharya Consultation Room",
      "mode": "Private Sadhana",
    },

    // 4. YOUTH PROGRAMS
    {
      "time": "10:30 AM",
      "title": "Young Seekers Vedic Phonetics & Memory Asana",
      "tag": "YOUTH PROGRAM",
      "location": "Pathashala Lawn",
      "mode": "Youth Programs",
    },
    {
      "time": "04:30 PM",
      "title": "Youth Focus Building & Sanskrit Chanting Circle",
      "tag": "YOUTH PROGRAM",
      "location": "Vidya Mandapam",
      "mode": "Youth Programs",
    },
  ];
}
