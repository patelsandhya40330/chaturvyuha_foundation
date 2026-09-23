import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/Widgats/app_button.dart';
import 'package:chaturvyuha_foundation/Widgats/section_label.dart';
import 'package:chaturvyuha_foundation/Widgats/app_footer.dart';
import 'package:chaturvyuha_foundation/Widgats/app_card_container.dart';
import '../../dataProvider/media_provider.dart';
import '../../models/media_item.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _activeFilter = 'All Media';
  String? _currentlyPlayingAudioTitle;

  final List<String> _filters = [
    'All Media',
    'Photos',
    'Videos',
    'Bhajans & Chants',
    'Treatises & PDFs',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Image Preview Dialog
  void _showImagePreview(String imagePath, String title) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog.fullscreen(
        backgroundColor: Colors.black.withAlpha(220),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 64,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(ctx),
                  tooltip: 'Close Preview',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Video / Audio Playback Dialog
  void _showMediaPlaybackDialog(MediaItem item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFF1A1A1A),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        item.assetPath,
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaProvider = context.watch<MediaProvider>();

    final bool showAll = _activeFilter == 'All Media';
    final bool showPhotos = showAll || _activeFilter == 'Photos';
    final bool showVideos = showAll || _activeFilter == 'Videos';
    final bool showAudio = showAll || _activeFilter == 'Bhajans & Chants';
    final bool showDocs = showAll || _activeFilter == 'Treatises & PDFs';

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 1100;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 1. HERO SECTION
                _buildHeroSection(isDesktop, mediaProvider),

                const SizedBox(height: 60),

                // 2. SEARCH & FILTERS
                _buildSearchSection(isDesktop),

                const SizedBox(height: 60),

                // 3. FEATURED VIDEO & VIDEOS
                if (showVideos) ...[
                  _buildFeaturedVideo(isDesktop, mediaProvider),
                  const SizedBox(height: 80),
                  _buildVideoSlider(isDesktop, mediaProvider),
                  const SizedBox(height: 80),
                ],

                // 4. PHOTO GRID
                if (showPhotos) ...[
                  _buildPhotoGrid(isDesktop, mediaProvider),
                  const SizedBox(height: 80),
                ],

                // 5. AUDIO LIST
                if (showAudio) ...[
                  _buildAudioList(isDesktop, mediaProvider),
                  const SizedBox(height: 80),
                ],

                // 6. DOCUMENT GRID
                if (showDocs) ...[
                  _buildDocumentGrid(isDesktop, mediaProvider),
                  const SizedBox(height: 80),
                ],

                const SizedBox(height: 40),

                // FOOTER
                AppFooter(isDesktop: isDesktop),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- 1. HERO SECTION ---
  Widget _buildHeroSection(bool isDesktop, MediaProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumbs(),
          const SizedBox(height: 48),
          const SectionLabel(text: "SONIC & VISUAL ARCHIVE"),
          const SizedBox(height: 24),
          Text(
            'Preserving the Sonic & Visual\nHeritage of Sanātana Dharma',
            style: AppTextStyles.heroHeading.copyWith(
              fontSize: isDesktop ? 54 : 36,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: const Text(
              'A digital repository of high-fidelity Vedic recitations, archival photography, and scholarly documentaries designed to protect and propagate the primordial oral and visual lineages.',
              style: AppTextStyles.bodyLarge,
            ),
          ),
          const SizedBox(height: 48),
          _buildStatsBar(isDesktop, provider),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Row(
      children: [
        Text(
          "Home",
          style: AppTextStyles.bodySmall.copyWith(color: AppColor.grey),
        ),
        const Icon(Icons.chevron_right, size: 14, color: AppColor.grey),
        Text(
          "Media Library",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBar(bool isDesktop, MediaProvider provider) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: provider.mediaStats.entries.map((e) {
        return Container(
          width: isDesktop ? 200 : (MediaQuery.of(context).size.width - 60) / 2,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F6F1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                e.key.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- 2. SEARCH & FILTERS ---
  Widget _buildSearchSection(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Column(
                  children: [
                    _searchField(),
                    const SizedBox(height: 16),
                    SizedBox(width: double.infinity, child: _searchButton()),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: _searchField()),
                  const SizedBox(width: 16),
                  _searchButton(),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: _filters.map((filter) {
              final bool isActive = _activeFilter == filter;
              return ChoiceChip(
                label: Text(filter),
                selected: isActive,
                onSelected: (val) {
                  if (val) setState(() => _activeFilter = filter);
                },
                selectedColor: AppColor.primary,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isActive ? Colors.white : Colors.black87,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: AppColor.border),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() => _searchQuery = val),
      decoration: InputDecoration(
        hintText: 'Search recitations, chants, archives...',
        prefixIcon: const Icon(Icons.search, color: AppColor.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _searchButton() {
    return AppButton(
      text: "Search",
      onPressed: () {
        final q = _searchController.text.trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              q.isEmpty
                  ? 'Showing all media entries'
                  : 'Filtered archives by "$q"',
            ),
          ),
        );
      },
      isPrimary: true,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
    );
  }

  // --- 3. FEATURED VIDEO ---
  Widget _buildFeaturedVideo(bool isDesktop, MediaProvider provider) {
    final featured = provider.allMedia.firstWhere(
      (m) => m.type == MediaType.video || m.category == "Master Recitations",
      orElse: () => provider.allMedia.first,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "FEATURED MASTERCLASS"),
          const SizedBox(height: 24),
          const Text(
            "Curated Master Recitations & Visual Documents",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          AppCardContainer(
            padding: EdgeInsets.zero,
            borderRadius: 32,
            clipBehavior: Clip.antiAlias,
            onTap: () => _showMediaPlaybackDialog(featured),
            child: isDesktop
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 5, child: _videoThumbnail(featured)),
                        Expanded(flex: 5, child: _videoInfo(featured)),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      _videoThumbnail(featured, isMobile: true),
                      _videoInfo(featured),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _videoThumbnail(MediaItem item, {bool isMobile = false}) {
    return InkWell(
      onTap: () => _showMediaPlaybackDialog(item),
      child: Container(
        height: isMobile ? 250 : 500,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(item.assetPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }

  Widget _videoInfo(MediaItem item) {
    return Container(
      color: const Color(0xFFF9F6F1),
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E6D9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "VIDEO DOCUMENTARY",
              style: AppTextStyles.bulletLabel.copyWith(fontSize: 10),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            item.title,
            style: AppTextStyles.title.copyWith(
              fontSize: 28,
              fontFamily: 'Georgia',
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          Text(item.description, style: AppTextStyles.body),
          const SizedBox(height: 40),
          AppButton(
            text: "Watch Masterclass",
            onPressed: () => _showMediaPlaybackDialog(item),
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  // --- 4. PHOTO GRID ---
  Widget _buildPhotoGrid(bool isDesktop, MediaProvider provider) {
    final photos = provider.allMedia
        .where(
          (m) =>
              (m.type == MediaType.photo || m.category == "Sacred Moments") &&
              (_searchQuery.isEmpty ||
                  m.title.toLowerCase().contains(_searchQuery.toLowerCase())),
        )
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sacred Moments in Frame: Gurukula, Ghats & Sacred Fires",
                style: AppTextStyles.heading2,
              ),
              if (isDesktop)
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Displaying full high-resolution photographic gallery...',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "View All Gallery →",
                    style: AppTextStyles.link,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, box) {
              int count = isDesktop ? 3 : 1;
              double width = (box.maxWidth - (count - 1) * 24) / count;
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: photos.map((p) => _photoCard(width, p)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _photoCard(double width, MediaItem p) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCardContainer(
            height: 250,
            width: double.infinity,
            padding: EdgeInsets.zero,
            borderRadius: 20,
            onTap: () => _showImagePreview(p.assetPath, p.title),
            image: DecorationImage(
              image: AssetImage(p.assetPath),
              fit: BoxFit.cover,
            ),
            child: const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),
          Text(
            p.title,
            style: AppTextStyles.title.copyWith(
              fontSize: 18,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            p.description,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- 5. VIDEO SLIDER ---
  Widget _buildVideoSlider(bool isDesktop, MediaProvider provider) {
    final videos = provider.allMedia
        .where(
          (m) =>
              m.type == MediaType.video || m.category == "Cinematic Chronicles",
        )
        .toList();

    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F6F1),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
        vertical: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "CINEMATIC CHRONICLES"),
          const SizedBox(height: 24),
          const Text(
            "Cinematic Chronicles & Acharya Discourses",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, box) {
              int count = isDesktop ? 3 : 1;
              double width = (box.maxWidth - (count - 1) * 24) / count;
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: videos.map((v) => _videoGridCard(width, v)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _videoGridCard(double width, MediaItem v) {
    return AppCardContainer(
      width: width,
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      backgroundColor: Colors.white,
      onTap: () => _showMediaPlaybackDialog(v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  v.assetPath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            v.title,
            style: AppTextStyles.title.copyWith(
              fontSize: 17,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            v.description,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // --- 6. AUDIO LIST ---
  Widget _buildAudioList(bool isDesktop, MediaProvider provider) {
    final audio = provider.allMedia
        .where(
          (m) =>
              m.type == MediaType.audio || m.category == "Canonical Chanting",
        )
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "SHRAVANA VIDYĀ"),
          const SizedBox(height: 24),
          const Text(
            "Canonical Chanting, Bhajans & Lineage Discourses",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          Column(
            children: audio.map((a) {
              final bool isPlaying = _currentlyPlayingAudioTitle == a.title;
              return AppCardContainer(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                borderRadius: 20,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isCompact = constraints.maxWidth < 500;

                    if (isCompact) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _playIcon(isPlaying),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  a.title,
                                  style: AppTextStyles.title.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              _playButton(isPlaying, a.title),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            a.description,
                            style: AppTextStyles.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        _playIcon(isPlaying),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.title,
                                style: AppTextStyles.title.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                a.description,
                                style: AppTextStyles.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isDesktop) ...[
                          const SizedBox(width: 40),
                          const Text(
                            "12:45",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                        const SizedBox(width: 20),
                        _playButton(isPlaying, a.title),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _playIcon(bool isPlaying) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColor.lightPrimary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPlaying ? Icons.graphic_eq : Icons.headset_outlined,
        color: AppColor.primary,
        size: 20,
      ),
    );
  }

  Widget _playButton(bool isPlaying, String title) {
    return IconButton(
      onPressed: () {
        setState(() {
          _currentlyPlayingAudioTitle = isPlaying ? null : title;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPlaying
                  ? 'Audio paused: $title'
                  : 'Playing audio stream: $title',
            ),
          ),
        );
      },
      icon: Icon(
        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
        color: AppColor.primary,
        size: 36,
      ),
    );
  }

  // --- 7. DOCUMENT GRID ---
  Widget _buildDocumentGrid(bool isDesktop, MediaProvider provider) {
    final docs = provider.allMedia
        .where(
          (m) =>
              m.type == MediaType.document ||
              m.category == "Canonical Treatises",
        )
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "WRITTEN KNOWLEDGE"),
          const SizedBox(height: 24),
          const Text(
            "Canonical Treatises, Transliterations & Research Monograph PDFs",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, box) {
              int count = isDesktop ? 2 : 1;
              double width = (box.maxWidth - (count - 1) * 24) / count;
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: docs.map((d) {
                  return AppCardContainer(
                    width: width,
                    padding: const EdgeInsets.all(32),
                    borderRadius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ARCHIVAL PDF",
                              style: AppTextStyles.bulletLabel.copyWith(
                                fontSize: 10,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.file_download_outlined,
                                color: AppColor.primary,
                                size: 20,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Downloading treatise PDF: ${d.title}...',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          d.title,
                          style: AppTextStyles.title.copyWith(
                            fontSize: 19,
                            fontFamily: 'Georgia',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          d.description,
                          style: AppTextStyles.bodySmall.copyWith(height: 1.6),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            AppButton(
                              text: "Download PDF",
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Downloading treatise PDF: ${d.title}...',
                                    ),
                                  ),
                                );
                              },
                              isPrimary: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                            const SizedBox(width: 24),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Viewing abstract for ${d.title}',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "View Abstract →",
                                style: AppTextStyles.link,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
