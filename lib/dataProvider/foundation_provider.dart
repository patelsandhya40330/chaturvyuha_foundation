import 'package:flutter/material.dart';
import '../models/team_member.dart';
import '../models/event_item.dart';
import '../models/media_item.dart';

import '../models/course_item.dart';
import '../models/article_item.dart';

class FoundationProvider extends ChangeNotifier {
  // Demo/Sample Data Flag Indicator
  final bool isDemoData = true;

  // 1. About Screen Sample Data
  final List<TeamMember> teamMembers = [
    TeamMember(
      name: "Acharya Shridhar Sharma",
      role: "Founder & Spiritual Director",
      bio:
          "Expert in Vedic scripture recitation, Sanskrit linguistics, and traditional philosophies with over 20 years of experience guidance.",
    ),
    TeamMember(
      name: "Dr. Ananya Mishra",
      role: "Head of Vedic Research & Yoga",
      bio:
          "Holds a doctorate in ancient Indian heritage and teaches classical pranayama techniques and contemplative practices.",
    ),
    TeamMember(
      name: "Swami Vedananda",
      role: "Senior Meditation Guide",
      bio:
          "Dedicated to sharing ancient non-dual philosophies and directing community outreach activities worldwide.",
    ),
  ];

  final String logoExplanation =
      "The official logo represents the ultimate absolute unity (Brahman). The circle symbolizes infinity and completeness, "
      "while the central sacred seal represents the four primary core aspects of creation, knowledge, and inner reflection.";

  // 2. Dharma & Sanskriti Sample Data
  final List<Map<String, String>> dharmaContents = [
    {
      "title": "Understanding Sanatana Dharma",
      "category": "Philosophy",
      "content":
          "An overview of eternal moral laws, duty, cosmic order, and living in alignment with natural guidelines.",
    },
    {
      "title": "The Pillars of Sanskrit Literature",
      "category": "Language",
      "content":
          "Discover how the structural composition and structural precision of Sanskrit terms preserves wisdom across centuries.",
    },
    {
      "title": "Traditional Indian Art Forms",
      "category": "Culture",
      "content":
          "Exploring how architecture, sacred paintings, and sound vibrations serve as spiritual mediums for celebration.",
    },
    {
      "title": "Preserving Indigenous Forest Values",
      "category": "Values",
      "content":
          "Vedic philosophy emphasizes a symbiotic, nurturing connection between human communities and ecosystems.",
    },
  ];

  final List<Map<String, String>> culturalCalendar = [
    {
      "event": "Maha Shivaratri Vrat",
      "date": "March 8, 2024",
      "significance":
          "Night of spiritual awakening and deep meditative stillness.",
    },
    {
      "event": "Vedic New Year / Chaitra Navaratri",
      "date": "April 9, 2024",
      "significance":
          "Celebrating natural renewal and invocation of creative energy.",
    },
    {
      "event": "Guru Purnima Celebrations",
      "date": "July 21, 2024",
      "significance": "Honoring the lineage of enlightened guides and masters.",
    },
  ];

  // 3. Vedic Education Sample Data
  final List<Map<String, String>> vedangas = [
    {
      "title": "Shiksha",
      "desc": "Phonetics and pronunciation of Vedic hymns.",
      "icon": "vocal_icon",
    },
    {
      "title": "Chandas",
      "desc": "Vedic prosody and poetic meters.",
      "icon": "meter_icon",
    },
    {
      "title": "Vyakarana",
      "desc": "Sanskrit grammar and linguistic analysis.",
      "icon": "grammar_icon",
    },
    {
      "title": "Nirukta",
      "desc": "Etymology and interpretation of words.",
      "icon": "etymology_icon",
    },
    {
      "title": "Jyotisha",
      "desc": "Vedic astronomy and time-keeping.",
      "icon": "astronomy_icon",
    },
    {
      "title": "Kalpa",
      "desc": "Ritual instructions and social ethics.",
      "icon": "ritual_icon",
    },
  ];

  final List<CourseItem> courses = [
    CourseItem(
      title: "Foundations of Upanishadic Wisdom",
      description:
          "An intensive introductory look into structural dialogues covering reality, consciousness, and freedom.",
      duration: "8 Weeks",
      schedule: "Sundays (8:00 AM - 10:00 AM)",
      instructor: "Acharya Shridhar Sharma",
      resources: ["Introduction to Upanishads PDF", "Weekly Audio Chant Guide"],
      topics: [
        "Nature of Consciousness",
        "The Concept of Self",
        "Karma and Freedom",
      ],
    ),
    CourseItem(
      title: "Sanskrit Grammar for Beginners",
      description:
          "Learn foundational phonetics, declensions, rules of conjugation, and conversational expressions.",
      duration: "12 Weeks",
      schedule: "Saturdays (10:00 AM - 12:00 PM)",
      instructor: "Acharya Shridhar Sharma",
      resources: ["Sanskrit Primer Workbook", "Audio Pronunciation Dictionary"],
      topics: [
        "Sanskrit Vowels & Consonants",
        "Noun Cases & Inflections",
        "Simple Sentence Creation",
      ],
    ),
    CourseItem(
      title: "Vedic Phonetics & Svara Patha",
      description:
          "Advanced training in the precise tonal recitation of the Rigveda Samhita.",
      duration: "6 Months",
      schedule: "Daily (5:00 AM - 7:00 AM)",
      instructor: "Acharya Devavrata Shastri",
      resources: ["Rigveda Svara Manual", "Phonetic Analysis Software"],
      topics: ["Udātta & Anudātta", "Svarita Variations", "Breath Modulation"],
    ),
  ];

  final List<Map<String, dynamic>> cohortSchedule = [
    {
      "course": "Vedic Philosophy 101",
      "start": "April 15, 2024",
      "seats": "12 Left",
      "status": "ENROLLING",
    },
    {
      "course": "Sanskrit Level 1",
      "start": "May 01, 2024",
      "seats": "05 Left",
      "status": "LAST CALL",
    },
    {
      "course": "Rigveda Phonetics",
      "start": "June 10, 2024",
      "seats": "20 Left",
      "status": "OPEN",
    },
  ];

  final List<ArticleItem> articles = [
    ArticleItem(
      id: "art-1",
      title: "The Role of Mindful Pauses in Modern Routines",
      excerpt:
          "How inserting brief moments of quiet reflection can dramatically alleviate workplace stress and clear cognitive overload.",
      content:
          "Vedic philosophy teaches that deep, unshakeable peace is not a distant goal, but our intrinsic baseline state. By deliberately structuring short, regular pauses during highly intense daily routines, we decouple our focus from continuous outward stimuli and reconnect with inner stability...",
      category: "Wellness",
      tags: ["Mindfulness", "Meditation", "Vedic living"],
      author: "Dr. Ananya Mishra",
      publishedDate: DateTime(2024, 1, 10),
      updatedDate: DateTime(2024, 1, 12),
      relatedArticleIds: ["art-2"],
      seoTitle: "Mindful Pauses in Modern Routines | Chaturvyuha Wisdom",
      seoDescription:
          "Learn how ancient Vedic mindfulness intervals help resolve modern daily cognitive pressure.",
      seoKeywords: "mindfulness, stress relief, vedic psychology, self care",
    ),
    ArticleItem(
      id: "art-2",
      title: "Sanskrit: Sound Vibrations and Brain Plasticity",
      excerpt:
          "Exploring modern neuroscientific discoveries validating the benefits of structured vocal chanting.",
      content:
          "Chanting sacred Sanskrit verses systematically exercises neural networks, improving overall memory retention and auditory focus. This article highlights recent scientific studies analyzing how precise phonetics shapes neuroplastic development over time...",
      category: "Language",
      tags: ["Sanskrit", "Neuroscience", "Chanting"],
      author: "Acharya Shridhar Sharma",
      publishedDate: DateTime(2024, 2, 5),
      updatedDate: DateTime(2024, 2, 5),
      relatedArticleIds: ["art-1"],
      seoTitle: "Sanskrit Chanting and Brain Plasticity | Research",
      seoDescription:
          "Neuroscientific exploration of vocal vibration benefits on cognitive clarity.",
      seoKeywords: "sanskrit, chanting, brain health, cognitive plasticity",
    ),
  ];

  // 4. Events & Programs Data
  final List<EventItem> events = [
    EventItem(
      title: "Global Peace Chant Gathering",
      description:
          "A community assembly focused on collective chanting for environmental harmony and universal wellness.",
      date: DateTime(2024, 3, 25),
      time: "4:00 PM",
      location: "Main Sanctuary Hall",
      status: EventStatus.upcoming,
      galleryImages: [],
    ),
    EventItem(
      title: "Residential Yoga Intensive",
      description:
          "A comprehensive immersion retreat covering advanced postures and scriptural analysis.",
      date: DateTime(2024, 4, 10),
      time: "6:00 AM",
      location: "Mountain Ridge Campus",
      status: EventStatus.upcoming,
      galleryImages: [],
    ),
    EventItem(
      title: "Winter Solstice Meditative Fire",
      description:
          "A silent meditative gathering celebrating seasonal transitions through sacred fireplace offerings.",
      date: DateTime(2023, 12, 21),
      time: "5:30 PM",
      location: "North Courtyard",
      status: EventStatus.completed,
      galleryImages: ["assets/image_1.png", "assets/image_2.png"],
    ),
    EventItem(
      title: "Sanskrit Youth Forum 2024",
      description:
          "An interactive grammar quiz and drama contest that was unfortunately called off due to scheduling conflicts.",
      date: DateTime(2024, 2, 15),
      time: "10:00 AM",
      location: "Auditorium Annex",
      status: EventStatus.cancelled,
      galleryImages: [],
    ),
  ];

  // 4. Media Sample Data
  final List<MediaItem> mediaItems = [
    MediaItem(
      title: "Chanting at Dusk Ceremony",
      description: "High-resolution portrait of a evening prayer invocation.",
      category: "Festivals",
      type: MediaType.photo,
      assetPath: "assets/image_1.png",
    ),
    MediaItem(
      title: "Inaugural Speech 2023",
      description:
          "Video record of the initial foundational introduction address.",
      category: "Discourses",
      type: MediaType.video,
      assetPath: "assets/image_2.png",
    ),
    MediaItem(
      title: "Guided Breath Meditation Audio Track",
      description: "A calming 15-minute voice guide for daily practice.",
      category: "Practice",
      type: MediaType.audio,
      assetPath: "assets/image_3.png",
    ),
    MediaItem(
      title: "Vedic Philosophy Study Guide",
      description:
          "Comprehensive outline of key text definitions and reading assignments.",
      category: "Education",
      type: MediaType.document,
      assetPath: "assets/image_1.png",
    ),
  ];
}
