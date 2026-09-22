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
  String _searchQuery = '';
  String _activeFilter = 'All Media';
  final List<String> _filters = [
    'All Media',
    'Master Recitations',
    'Sacred Moments',
    'Cinematic Chronicles',
    'Canonical Chanting',
    'Canonical Treatises',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaProvider = context.watch<MediaProvider>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 1100;

          return SingleChildScrollView(
            child: Column(
              children: [
                // 1. HERO SECTION
                _buildHeroSection(isDesktop, mediaProvider),

                const SizedBox(height: 60),

                // 2. SEARCH & FILTERS
                _buildSearchSection(isDesktop),

                const SizedBox(height: 80),

                // 3. FEATURED VIDEO (Master Recitations)
                _buildFeaturedVideo(isDesktop, mediaProvider),

                const SizedBox(height: 120),

                // 4. PHOTO GRID (Sacred Moments)
                _buildPhotoGrid(isDesktop, mediaProvider),

                const SizedBox(height: 120),

                // 5. VIDEO SLIDER (Cinematic Chronicles)
                _buildVideoSlider(isDesktop, mediaProvider),

                const SizedBox(height: 120),

                // 6. AUDIO LIST (Canonical Chanting)
                _buildAudioList(isDesktop, mediaProvider),

                const SizedBox(height: 120),

                // 7. DOCUMENT GRID (Canonical Treatises)
                _buildDocumentGrid(isDesktop, mediaProvider),

                const SizedBox(height: 100),

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
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search recitations, chants, archives...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColor.primary,
                    ),
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
                ),
              ),
              const SizedBox(width: 16),
              AppButton(
                text: "Search",
                onPressed: () {},
                isPrimary: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final bool isActive = _activeFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isActive,
                    onSelected: (val) {
                      if (val) setState(() => _activeFilter = filter);
                    },
                    selectedColor: AppColor.primary,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isActive ? Colors.white : Colors.black,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: AppColor.border),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // --- 3. FEATURED VIDEO ---
  Widget _buildFeaturedVideo(bool isDesktop, MediaProvider provider) {
    final featured = provider.allMedia.firstWhere(
      (m) => m.category == "Master Recitations",
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
            child: isDesktop
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 5,
                          child: _videoThumbnail(featured.assetPath),
                        ),
                        Expanded(flex: 5, child: _videoInfo(featured)),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      _videoThumbnail(featured.assetPath, isMobile: true),
                      _videoInfo(featured),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _videoThumbnail(String asset, {bool isMobile = false}) {
    return Container(
      height: isMobile ? 250 : 500,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover),
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
            onPressed: () {},
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  // --- 4. PHOTO GRID ---
  Widget _buildPhotoGrid(bool isDesktop, MediaProvider provider) {
    final photos = provider.allMedia
        .where((m) => m.category == "Sacred Moments")
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
                  onPressed: () {},
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
        .where((m) => m.category == "Cinematic Chronicles")
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
        .where((m) => m.category == "Canonical Chanting")
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: "SHRAVANA VIDYĀ"),
          const SizedBox(height: 24),
          const Text(
            "Canonical Chanting & Lineage Discourses",
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 48),
          Column(
            children: audio.map((a) {
              return AppCardContainer(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                borderRadius: 20,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.lightPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.headset_outlined,
                        color: AppColor.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.title,
                            style: AppTextStyles.title.copyWith(fontSize: 16),
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
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.play_circle_fill,
                        color: AppColor.primary,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- 7. DOCUMENT GRID ---
  Widget _buildDocumentGrid(bool isDesktop, MediaProvider provider) {
    final docs = provider.allMedia
        .where((m) => m.category == "Canonical Treatises")
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
                            const Icon(
                              Icons.file_download_outlined,
                              color: AppColor.primary,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
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
                              onPressed: () {},
                              isPrimary: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                            ),
                            const SizedBox(width: 24),
                            const Text(
                              "View Abstract →",
                              style: AppTextStyles.link,
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
