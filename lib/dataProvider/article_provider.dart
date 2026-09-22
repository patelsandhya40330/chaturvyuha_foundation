import 'package:flutter/material.dart';
import '../models/article_item.dart';

class ArticleProvider extends ChangeNotifier {
  final List<ArticleItem> articles = [
    ArticleItem(
      id: "art-1",
      title:
          "The Ontological Status of the Knower: An In-Depth Exegesis of the Maṇḍūkya Kārikā",
      excerpt:
          "This study examines the epistemological foundations of the Knower in the context of Advaita Shastra, analyzing the quaternary states of consciousness.",
      content:
          "The Maṇḍūkya Kārikā stands as one of the most profound philosophical treatises in the Vedic tradition. Gauḍapāda, the author, systematically deconstructs the conventional understanding of reality through the lens of the three states: waking (jāgrat), dreaming (svapna), and deep sleep (suṣupti), pointing towards the fourth, Turiya...",
      category: "Philosophy",
      tags: ["Advaita", "Mandukya", "Epistemology"],
      author: "Acharya Shridhar Sharma",
      publishedDate: DateTime(2024, 1, 10),
      updatedDate: DateTime(2024, 1, 12),
      relatedArticleIds: ["art-2", "art-4"],
      seoTitle: "Ontological Status of the Knower | Vedic Research",
      seoDescription:
          "Deep dive into the Maṇḍūkya Kārikā's analysis of consciousness and the Knower.",
      seoKeywords: "philosophy, consciousness, mandukya karika, advaita",
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
      author: "Dr. Ananya Mishra",
      publishedDate: DateTime(2024, 2, 5),
      updatedDate: DateTime(2024, 2, 5),
      relatedArticleIds: ["art-1"],
      seoTitle: "Sanskrit Chanting and Brain Plasticity | Research",
      seoDescription:
          "Neuroscientific exploration of vocal vibration benefits on cognitive clarity.",
      seoKeywords: "sanskrit, chanting, brain health, cognitive plasticity",
    ),
    ArticleItem(
      id: "art-3",
      title:
          "The Neuro-Acoustics of Vedic Recitation: Precision in Auditory Texture",
      excerpt:
          "Understanding the systematic tonal precision required for Rigveda preservation.",
      content:
          "The Rigveda has been preserved with zero variation for over three millennia. This article examines the phonetic markers that ensure this precision...",
      category: "Phonetics",
      tags: ["Rigveda", "Acoustics", "Memory"],
      author: "Acharya Devavrata Shastri",
      publishedDate: DateTime(2024, 3, 5),
      updatedDate: DateTime(2024, 3, 5),
      relatedArticleIds: ["art-2"],
      seoTitle: "Neuro-Acoustics of Vedic Recitation",
      seoDescription: "How Vedic chanting affects auditory memory and texture.",
      seoKeywords: "vedic recitation, acoustics, rigveda",
    ),
    ArticleItem(
      id: "art-4",
      title: "Beyond Postures: Why Patanjali Dedicated Only 3 Sutras to Asana",
      excerpt:
          "Understanding the true purpose of physical postures in the broader context of the Yoga Sutras.",
      content:
          "While modern yoga is often synonymous with physical poses, the Yoga Sutras of Patanjali offer a much more comprehensive framework where asana is just one limb...",
      category: "Practice",
      tags: ["Yoga", "Sutras", "Philosophy"],
      author: "Acharya Swami Brahmatejananda",
      publishedDate: DateTime(2024, 3, 1),
      updatedDate: DateTime(2024, 3, 1),
      relatedArticleIds: ["art-1"],
      seoTitle: "Patanjali's View on Asana | Chaturveda Yoga",
      seoDescription: "Exploring the role of asana in Patanjali's Yoga Sutras.",
      seoKeywords: "yoga sutras, asana, patanjali, philosophy",
    ),
    ArticleItem(
      id: "art-5",
      title: "Rhythm of the Cosmos: The Dinacharya Protocol in Charaka Samhita",
      excerpt:
          "Analyzing the circadian alignment of traditional Vedic daily routines.",
      content:
          "The Charaka Samhita provides a detailed framework for daily living (Dinacharya) that aligns human physiology with the rhythms of the sun and season...",
      category: "Ayurveda",
      tags: ["Health", "Rhythm", "Ayurveda"],
      author: "Dr. Ananya Mishra",
      publishedDate: DateTime(2024, 3, 10),
      updatedDate: DateTime(2024, 3, 10),
      relatedArticleIds: ["art-4"],
      seoTitle: "Vedic Dinacharya Protocol",
      seoDescription: "Traditional health routines from Charaka Samhita.",
      seoKeywords: "ayurveda, health, daily routine",
    ),
  ];
}
