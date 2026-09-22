import 'package:flutter/material.dart';
import '../models/media_item.dart';

class MediaProvider extends ChangeNotifier {
  final List<MediaItem> allMedia = [
    // Videos - Master Recitations
    MediaItem(
      title:
          "The Living Breath of the Rigveda: Oral Transmission along the Ganges",
      description:
          "A profound documentation of the Shakala Samhita lineage preservation in modern Rishikesh.",
      category: "Master Recitations",
      type: MediaType.video,
      assetPath: "assets/image_3.png",
    ),
    MediaItem(
      title: "The Architecture of Sanskrit: A Vision of Linguistic Resonance",
      description:
          "Visual exploration of the phonetic structures of the Sanskrit language.",
      category: "Cinematic Chronicles",
      type: MediaType.video,
      assetPath: "assets/image_2.png",
    ),
    MediaItem(
      title: "Soma Mandala: Dhyana for Moon Cycles",
      description:
          "A contemplative visual guide to the Soma Suktas of the Rigveda.",
      category: "Cinematic Chronicles",
      type: MediaType.video,
      assetPath: "assets/image_1.png",
    ),
    MediaItem(
      title: "Sandhyavandanam: A Scriptural Study of Morning Rituals",
      description:
          "Analyzing the Vedic dawn rituals through traditional performance.",
      category: "Cinematic Chronicles",
      type: MediaType.video,
      assetPath: "assets/image_3.png",
    ),

    // Photos - Sacred Moments
    MediaItem(
      title: "Dawn Sadhana at Triveni Ghat",
      description: "Scholars performing morning ablutions and prayers.",
      category: "Sacred Moments",
      type: MediaType.photo,
      assetPath: "assets/image_1.png",
    ),
    MediaItem(
      title: "Palm-Leaf Manuscript Conservation",
      description:
          "Behind the scenes at the archival grade vacuum seal facility.",
      category: "Sacred Moments",
      type: MediaType.photo,
      assetPath: "assets/image_2.png",
    ),
    MediaItem(
      title: "Evening Arpana at the Sanctuary",
      description: "The illumination of consciousness during dusk puja.",
      category: "Sacred Moments",
      type: MediaType.photo,
      assetPath: "assets/image_3.png",
    ),

    // Audio - Canonical Chanting
    MediaItem(
      title: "Purusha Sukta (432Hz) Shakala Recitation",
      description:
          "Authentic Vedic chanting recorded with high fidelity resonance.",
      category: "Canonical Chanting",
      type: MediaType.audio,
      assetPath: "assets/chaturvedal-logo.png",
    ),
    MediaItem(
      title: "Mantra Sadhana for Deep Meditative Focus",
      description: "A series of seed mantras guided by Acharya Shridhar.",
      category: "Canonical Chanting",
      type: MediaType.audio,
      assetPath: "assets/chaturvedal-logo.png",
    ),

    // Documents - Treatises
    MediaItem(
      title: "The Ganapati Atharvashirsha Manual: Annotated Edition",
      description:
          "A comprehensive guide to the text with phonetic transliterations.",
      category: "Canonical Treatises",
      type: MediaType.document,
      assetPath: "assets/chaturvedal-logo.png",
    ),
    MediaItem(
      title: "Vedic Panchanga Alignment for 2024",
      description:
          "A scholarly calendar tracking auspicious astronomical transits.",
      category: "Canonical Treatises",
      type: MediaType.document,
      assetPath: "assets/chaturvedal-logo.png",
    ),
  ];

  final Map<String, String> mediaStats = {
    "Audio": "450+",
    "Videos": "1,200",
    "Photos": "180+",
    "Manuscripts": "110+",
    "Open Access": "100%",
  };
}
