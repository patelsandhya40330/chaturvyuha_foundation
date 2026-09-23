import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/staff/member/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/member/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/staff/member/models/media_item.dart';

import '../../dataProvider/foundation_provider.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  String _search = '';
  MediaType? _selectedType;

  void _showPhotoPreview(MediaItem item) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item.assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.image, size: 100, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _onMediaTap(MediaItem item) {
    if (item.type == MediaType.photo) {
      _showPhotoPreview(item);
    } else {
      // REQUIREMENT: Media previews where suitable sample assets are available.
      // Otherwise clearly disable the action and add a TODO.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Playback for ${item.type.name} is a demo placeholder. // TODO: Integrate media player.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FoundationProvider>();
    final filtered = provider.mediaItems.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(
        _search.toLowerCase(),
      );
      final matchesType = _selectedType == null || item.type == _selectedType;
      return matchesSearch && matchesType;
    }).toList();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1320),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 48 : 24,
                      vertical: isDesktop ? 56 : 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page labels
                        Text(
                          'MEDIA LIBRARY',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Browse All Resources',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: isDesktop ? 36 : 28,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Search and Type Filters
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              onChanged: (v) => setState(() => _search = v),
                              decoration: InputDecoration(
                                hintText: 'Search by resource title...',
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              children: [
                                ChoiceChip(
                                  label: const Text('All'),
                                  selected: _selectedType == null,
                                  onSelected: (s) =>
                                      setState(() => _selectedType = null),
                                ),
                                ...MediaType.values.map(
                                  (type) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text(type.name.toUpperCase()),
                                      selected: _selectedType == type,
                                      onSelected: (s) => setState(
                                        () => _selectedType = s ? type : null,
                                      ),
                                      selectedColor: AppColor.primary,
                                      labelStyle: TextStyle(
                                        color: _selectedType == type
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // Media Grid looper
                        LayoutBuilder(
                          builder: (context, box) {
                            final double itemWidth = isDesktop
                                ? (box.maxWidth - 48) / 3
                                : (constraints.maxWidth > 600
                                      ? (box.maxWidth - 24) / 2
                                      : box.maxWidth);
                            return Wrap(
                              spacing: 24,
                              runSpacing: 24,
                              children: filtered
                                  .map(
                                    (item) => GestureDetector(
                                      onTap: () => _onMediaTap(item),
                                      child: Container(
                                        width: itemWidth,
                                        decoration: BoxDecoration(
                                          color: AppColor.surface,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: AppColor.primary.withAlpha(
                                              30,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Thumbnail stack with icon overlay
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                AspectRatio(
                                                  aspectRatio: 16 / 9,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                    child: Image.asset(
                                                      item.assetPath,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (c, e, s) =>
                                                          Container(
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                _getMediaIcon(item.type),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                20.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.category.toUpperCase(),
                                                    style: AppTextStyles
                                                        .bulletLabel
                                                        .copyWith(fontSize: 10),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    item.title,
                                                    style: AppTextStyles.title
                                                        .copyWith(fontSize: 18),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    item.description,
                                                    style:
                                                        AppTextStyles.bodySmall,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getMediaIcon(MediaType type) {
    IconData icon;
    switch (type) {
      case MediaType.photo:
        icon = Icons.photo_camera;
        break;
      case MediaType.video:
        icon = Icons.play_circle_filled;
        break;
      case MediaType.audio:
        icon = Icons.headset;
        break;
      case MediaType.document:
        icon = Icons.description;
        break;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(100),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
