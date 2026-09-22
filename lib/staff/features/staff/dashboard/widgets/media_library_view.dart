import 'package:cfoundation/core/auth/permission_service.dart';
import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/core/utils/ui_utils.dart';
import 'package:cfoundation/widgets/common/buttons.dart';
import 'package:cfoundation/widgets/common/dialogs.dart';
import 'package:cfoundation/widgets/common/form_widgets.dart';
import 'package:cfoundation/widgets/common/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

enum MediaType { image, video, audio, document }

class MediaModel {
  final String id;
  String name;
  final String url;
  final MediaType type;
  final String size;
  final String dimensions;
  final DateTime uploadedAt;
  String folder;
  String altText;
  String caption;
  String description;
  String tags;
  final Map<String, String> metadata;

  MediaModel({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.size,
    required this.dimensions,
    required this.uploadedAt,
    required this.folder,
    this.altText = '',
    this.caption = '',
    this.description = '',
    this.tags = '',
    required this.metadata,
  });
}

class FolderModel {
  final String id;
  final String name;
  final int itemCount;
  final DateTime updatedAt;

  FolderModel({
    required this.id,
    required this.name,
    required this.itemCount,
    required this.updatedAt,
  });
}

class MediaLibraryView extends StatefulWidget {
  const MediaLibraryView({super.key});

  @override
  State<MediaLibraryView> createState() => _MediaLibraryViewState();
}

class _MediaLibraryViewState extends State<MediaLibraryView> {
  final List<MediaModel> _allMedia = [];
  final List<FolderModel> _allFolders = [];
  List<MediaModel> _filteredMedia = [];

  bool _isLoading = false;
  bool _hasError = false;
  bool _isEmptyStateSimulated = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  MediaType? _selectedType;
  String _selectedFolder = 'All Folders';
  String _sortBy = 'Newest';

  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadMockMedia();
  }

  void _loadMockMedia() {
    final now = DateTime.now();
    _allFolders.clear();
    _allFolders.addAll([
      FolderModel(id: 'FLD-001', name: 'Manuscripts', itemCount: 124, updatedAt: now.subtract(const Duration(days: 1))),
      FolderModel(id: 'FLD-002', name: 'Events', itemCount: 56, updatedAt: now.subtract(const Duration(days: 3))),
      FolderModel(id: 'FLD-003', name: 'Audio Chants', itemCount: 89, updatedAt: now.subtract(const Duration(hours: 4))),
      FolderModel(id: 'FLD-004', name: 'Banners', itemCount: 12, updatedAt: now.subtract(const Duration(days: 10))),
      FolderModel(id: 'FLD-005', name: 'General', itemCount: 45, updatedAt: now.subtract(const Duration(days: 5))),
    ]);

    _allMedia.clear();
    _allMedia.addAll([
      MediaModel(
        id: 'MED-001',
        name: 'Vedic-Temple-Sunrise.jpg',
        url: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=300&fit=crop',
        type: MediaType.image,
        size: '1.2 MB',
        dimensions: '1920 x 1080 px',
        uploadedAt: now.subtract(const Duration(days: 2)),
        folder: 'Manuscripts',
        altText: 'Sunrise over ancient Vedic temple hall',
        caption: 'Morning meditation and manuscript study session at main hall',
        description: 'High resolution asset for portal hero banners.',
        tags: 'vedic, temple, sunrise, heritage',
        metadata: {'Format': 'JPEG', 'Color Space': 'sRGB', 'Aspect Ratio': '16:9'},
      ),
      MediaModel(
        id: 'MED-002',
        name: 'Sanskrit-Grammar-Guide.pdf',
        url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        type: MediaType.document,
        size: '450 KB',
        dimensions: 'A4 Document',
        uploadedAt: now.subtract(const Duration(hours: 5)),
        folder: 'Manuscripts',
        altText: 'Sanskrit Grammar Beginner Guide PDF',
        caption: 'Reference handbook for beginner students',
        description: 'Downloadable PDF study guide for Panini verb roots.',
        tags: 'sanskrit, grammar, pdf, study',
        metadata: {'Format': 'PDF', 'Pages': '12', 'Version': '1.4'},
      ),
      MediaModel(
        id: 'MED-003',
        name: 'Yoga-Tutorial-Advanced.mp4',
        url: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        type: MediaType.video,
        size: '45.0 MB',
        dimensions: '1280 x 720 px',
        uploadedAt: now.subtract(const Duration(days: 1)),
        folder: 'Events',
        altText: 'Advanced Yoga Postures Video Tutorial',
        caption: 'Dr. K. Rao demonstrating breathing postures',
        description: 'HD video recording from autumn workshop.',
        tags: 'yoga, tutorial, video, wellness',
        metadata: {'Format': 'MP4', 'Duration': '15:20', 'Bitrate': '5000kbps'},
      ),
      MediaModel(
        id: 'MED-004',
        name: 'Evening-Vedic-Chants.mp3',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        type: MediaType.audio,
        size: '8.4 MB',
        dimensions: 'Audio Track',
        uploadedAt: now.subtract(const Duration(days: 5)),
        folder: 'Audio Chants',
        altText: 'Evening Vedic Chants Recitation',
        caption: 'Authentic chanting by ashram scholars',
        description: 'High fidelity audio recording of evening mantras.',
        tags: 'audio, chants, mantras, evening',
        metadata: {'Format': 'MP3', 'Bitrate': '320kbps', 'Sample Rate': '44.1kHz'},
      ),
      MediaModel(
        id: 'MED-005',
        name: 'Foundation-Logo-Dark.png',
        url: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400&h=400&fit=crop',
        type: MediaType.image,
        size: '120 KB',
        dimensions: '512 x 512 px',
        uploadedAt: now.subtract(const Duration(days: 10)),
        folder: 'Banners',
        altText: 'Chaturvyuha Foundation Brand Logo',
        caption: 'Official institutional logo icon',
        description: 'Brand logo for web headers and document footers.',
        tags: 'logo, brand, vector, png',
        metadata: {'Format': 'PNG', 'Transparent': 'Yes'},
      ),
      MediaModel(
        id: 'MED-006',
        name: 'Palmleaf-Manuscript-Scan.png',
        url: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400&h=300&fit=crop',
        type: MediaType.image,
        size: '3.4 MB',
        dimensions: '2400 x 1600 px',
        uploadedAt: now.subtract(const Duration(days: 12)),
        folder: 'Manuscripts',
        altText: 'Palm leaf manuscript scan sample',
        caption: 'Digitized 16th century Rigveda commentary',
        description: 'Archival scan from preservation lab.',
        tags: 'manuscript, scan, archival, palmleaf',
        metadata: {'Format': 'PNG', 'DPI': '300'},
      ),
      MediaModel(
        id: 'MED-007',
        name: 'Workshop-Group-Photo.jpg',
        url: 'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=400&h=300&fit=crop',
        type: MediaType.image,
        size: '2.1 MB',
        dimensions: '3000 x 2000 px',
        uploadedAt: now.subtract(const Duration(days: 4)),
        folder: 'Events',
        altText: 'Participants of the Vedic Philosophy workshop',
        caption: 'Closing ceremony group photo',
        description: 'Photo from the spring 2024 educational event.',
        tags: 'workshop, community, students, 2024',
        metadata: {'Format': 'JPEG', 'Color Space': 'sRGB'},
      ),
      MediaModel(
        id: 'MED-008',
        name: 'Introduction-to-Dharma.mp4',
        url: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_2mb.mp4',
        type: MediaType.video,
        size: '88.5 MB',
        dimensions: '1920 x 1080 px',
        uploadedAt: now.subtract(const Duration(days: 7)),
        folder: 'General',
        altText: 'Introduction to Dharma Lecture Video',
        caption: 'Foundation overview for new members',
        description: 'Introductory video explaining the core mission.',
        tags: 'dharma, intro, video, mission',
        metadata: {'Format': 'MP4', 'Duration': '05:45'},
      ),
      MediaModel(
        id: 'MED-009',
        name: 'Morning-Meditation-Raga.mp3',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        type: MediaType.audio,
        size: '12.4 MB',
        dimensions: 'Audio Track',
        uploadedAt: now.subtract(const Duration(days: 3)),
        folder: 'Audio Chants',
        altText: 'Morning Flute Raga for Meditation',
        caption: 'Instrumental raga for peaceful focus',
        description: 'Background audio for meditation sessions.',
        tags: 'audio, raga, meditation, flute',
        metadata: {'Format': 'MP3', 'Bitrate': '256kbps'},
      ),
      MediaModel(
        id: 'MED-010',
        name: 'Ashram-Architecture-Blueprints.pdf',
        url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        type: MediaType.document,
        size: '5.2 MB',
        dimensions: 'Architectural PDF',
        uploadedAt: now.subtract(const Duration(days: 20)),
        folder: 'General',
        altText: 'Main Ashram architectural blueprints',
        caption: 'Floor plans and structural layout',
        description: 'Archived blueprints of the foundation center.',
        tags: 'ashram, building, pdf, plans',
        metadata: {'Format': 'PDF', 'Pages': '8'},
      ),
      MediaModel(
        id: 'MED-011',
        name: 'Yoga-Banner-Social.jpg',
        url: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400&h=300&fit=crop',
        type: MediaType.image,
        size: '850 KB',
        dimensions: '1200 x 630 px',
        uploadedAt: now.subtract(const Duration(days: 6)),
        folder: 'Banners',
        altText: 'Yoga social media promotional banner',
        caption: 'Facebook and Instagram header',
        description: 'Marketing asset for International Yoga Day.',
        tags: 'yoga, banner, social, marketing',
        metadata: {'Format': 'JPEG', 'Target': 'Social Media'},
      ),
      MediaModel(
        id: 'MED-012',
        name: 'Meditation-App-Demo.mp4',
        url: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
        type: MediaType.video,
        size: '22.0 MB',
        dimensions: '1080 x 1920 px',
        uploadedAt: now.subtract(const Duration(hours: 12)),
        folder: 'General',
        altText: 'Mobile App User Experience Demo',
        caption: 'Demo of the new student portal app',
        description: 'Vertical video showing mobile app features.',
        tags: 'app, mobile, demo, ui',
        metadata: {'Format': 'MP4', 'Ratio': '9:16'},
      ),
      MediaModel(
        id: 'MED-013',
        name: 'Heritage-Report-2023.docx',
        url: 'https://file-examples.com/wp-content/uploads/2017/02/file-sample_100kB.docx',
        type: MediaType.document,
        size: '2.4 MB',
        dimensions: 'Word Document',
        uploadedAt: now.subtract(const Duration(days: 45)),
        folder: 'Manuscripts',
        altText: 'Annual Heritage Preservation Report 2023',
        caption: 'Consolidated report on digitized assets',
        description: 'Year-end summary of manuscript logging.',
        tags: 'report, heritage, docx, 2023',
        metadata: {'Format': 'DOCX', 'Author': 'Admin User'},
      ),
      MediaModel(
        id: 'MED-014',
        name: 'Vedic-Chanting-Workshop.mp3',
        url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        type: MediaType.audio,
        size: '15.8 MB',
        dimensions: 'Audio Recording',
        uploadedAt: now.subtract(const Duration(days: 8)),
        folder: 'Audio Chants',
        altText: 'Live recording of Vedic chanting workshop',
        caption: 'Session 3: Advanced Mantras',
        description: 'Raw audio from the winter seminar.',
        tags: 'audio, workshop, mantras, winter',
        metadata: {'Format': 'MP3', 'Mono/Stereo': 'Stereo'},
      ),
      MediaModel(
        id: 'MED-015',
        name: 'Himalayan-Landscape.jpg',
        url: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400&h=300&fit=crop',
        type: MediaType.image,
        size: '4.5 MB',
        dimensions: '4000 x 2600 px',
        uploadedAt: now.subtract(const Duration(days: 15)),
        folder: 'General',
        altText: 'Snow-capped Himalayan peaks',
        caption: 'Inspiration for meditation retreats',
        description: 'Landscape photography for website background.',
        tags: 'mountains, himalaya, snow, nature',
        metadata: {'Format': 'JPEG', 'Quality': '100'},
      ),
      MediaModel(
        id: 'MED-016',
        name: 'Volunteer-Guidelines.pdf',
        url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        type: MediaType.document,
        size: '1.1 MB',
        dimensions: 'A4 Document',
        uploadedAt: now.subtract(const Duration(days: 2)),
        folder: 'Events',
        altText: 'Volunteer Guidelines and Ethics PDF',
        caption: 'Mandatory reading for event volunteers',
        description: 'Document outlining behavior and responsibilities.',
        tags: 'volunteer, guidelines, pdf, ethics',
        metadata: {'Format': 'PDF', 'Version': '1.7'},
      ),
    ]);
    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> get _folders => ['All Folders', 'Manuscripts', 'Events', 'Audio Chants', 'Banners', 'General'];
  List<String> get _sortOptions => ['Newest', 'File Name (A-Z)', 'Size (Largest)'];

  void _applyFilters() {
    if (_isEmptyStateSimulated) {
      setState(() {
        _filteredMedia = [];
      });
      return;
    }

    setState(() {
      _filteredMedia = _allMedia.where((media) {
        final matchesSearch = media.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            media.tags.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            media.altText.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesType = _selectedType == null || media.type == _selectedType;
        final matchesFolder = _selectedFolder == 'All Folders' || media.folder == _selectedFolder;

        return matchesSearch && matchesType && matchesFolder;
      }).toList();

      if (_sortBy == 'File Name (A-Z)') {
        _filteredMedia.sort((a, b) => a.name.compareTo(b.name));
      } else if (_sortBy == 'Size (Largest)') {
        _filteredMedia.sort((a, b) => b.size.compareTo(a.size));
      } else {
        _filteredMedia.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
      }
    });
  }

  Future<void> _handleUploadDialog() async {
    showDialog(
      context: context,
      builder: (context) => _UploadMediaModal(
        selectedFolder: _selectedFolder == 'All Folders' ? 'General' : _selectedFolder,
        folders: _folders.where((f) => f != 'All Folders').toList(),
        onUploadComplete: (newMediaItem) {
          setState(() {
            _allMedia.insert(0, newMediaItem);
            _applyFilters();
          });
          UIUtils.showSuccessMessage(context, 'Media file "${newMediaItem.name}" uploaded successfully.');
        },
      ),
    );
  }

  Future<void> _handleCreateGallery() async {
    showDialog(
      context: context,
      builder: (context) => _CreateGalleryModal(
        onComplete: (name) {
          UIUtils.showSuccessMessage(context, 'New Media Gallery "$name" created successfully.');
        },
      ),
    );
  }

  void _showMediaDetailsDialog(MediaModel media) {
    showDialog(
      context: context,
      builder: (context) => _MediaDetailsDialog(
        media: media,
        folders: _folders.where((f) => f != 'All Folders').toList(),
        onDelete: () {
          setState(() {
            _allMedia.removeWhere((m) => m.id == media.id);
            _applyFilters();
          });
          UIUtils.showSuccessMessage(context, 'Media asset "${media.name}" deleted.');
        },
      ),
    );
  }

  void _copyMediaUrl(MediaModel media) {
    UIUtils.showSuccessMessage(context, 'Copied media reference URL to clipboard: ${media.url}');
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedType = null;
      _selectedFolder = 'All Folders';
      _sortBy = 'Newest';
      _isEmptyStateSimulated = false;
      _hasError = false;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background, // Ensure background is set
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSimulationRow(),
          const SizedBox(height: AppSizes.s12),
          _buildHeader(),
          const SizedBox(height: AppSizes.s24),
          _buildFilterBar(),
          const SizedBox(height: AppSizes.s24),
          Expanded(child: _buildMainContentState()),
        ],
      ),
    );
  }

  Widget _buildSimulationRow() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s8),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.secondary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.analytics_outlined, color: AppColors.secondary, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Media Library Simulators:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accent),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isEmptyStateSimulated = !_isEmptyStateSimulated;
                _hasError = false;
                _applyFilters();
              });
            },
            icon: Icon(_isEmptyStateSimulated ? Icons.check_box : Icons.check_box_outline_blank, size: 14),
            label: const Text('Empty State', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _hasError = !_hasError;
                _isEmptyStateSimulated = false;
              });
            },
            icon: Icon(_hasError ? Icons.check_box : Icons.check_box_outline_blank, size: 14),
            label: const Text('Error State', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: _simulateLoading,
            icon: const Icon(Icons.refresh, size: 14),
            label: const Text('Loading Spinner', style: TextStyle(fontSize: 11)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Media Library',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              SizedBox(height: 4),
              Text(
                'Manage digital assets, manuscript scans, video recordings, audio chants, and PDFs.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        if (PermissionService.hasPermission(AppPermissions.mediaUpload)) ...[
          const SizedBox(width: AppSizes.s12),
          SecondaryButton(
            onPressed: _handleCreateGallery,
            icon: Icons.collections_outlined,
            label: 'Create Gallery',
          ),
          const SizedBox(width: AppSizes.s12),
          PrimaryButton(
            onPressed: _handleUploadDialog,
            icon: Icons.upload_file,
            label: 'Upload Media',
          ),
        ],
      ],
    );
  }

  Widget _buildFilterBar() {
    if (context.isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SearchField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() => _searchQuery = val);
                    _applyFilters();
                  },
                  hintText: 'Search media name or tags...',
                ),
              ),
              const SizedBox(width: 8),
              ToggleButtons(
                isSelected: [_isGridView, !_isGridView],
                onPressed: (index) => setState(() => _isGridView = index == 0),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
                children: const [
                  Icon(Icons.grid_view, size: 18),
                  Icon(Icons.list, size: 18),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterDropdown<String>(
                label: 'Folder',
                value: _selectedFolder,
                items: _folders,
                onChanged: (val) {
                  setState(() => _selectedFolder = val!);
                  _applyFilters();
                },
                itemLabel: (val) => val,
              ),
              FilterDropdown<String>(
                label: 'Sort',
                value: _sortBy,
                items: _sortOptions,
                onChanged: (val) {
                  setState(() => _sortBy = val!);
                  _applyFilters();
                },
                itemLabel: (val) => val,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTypeChips(),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 4,
              child: SearchField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                  _applyFilters();
                },
                hintText: 'Search media assets by file name, alt text, or tags...',
              ),
            ),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              flex: 2,
              child: FilterDropdown<String>(
                label: 'Folder',
                value: _selectedFolder,
                items: _folders,
                onChanged: (val) {
                  setState(() => _selectedFolder = val!);
                  _applyFilters();
                },
                itemLabel: (val) => val,
              ),
            ),
            const SizedBox(width: AppSizes.s12),
            Expanded(
              flex: 2,
              child: FilterDropdown<String>(
                label: 'Sort By',
                value: _sortBy,
                items: _sortOptions,
                onChanged: (val) {
                  setState(() => _sortBy = val!);
                  _applyFilters();
                },
                itemLabel: (val) => val,
              ),
            ),
            const SizedBox(width: AppSizes.s12),
            ToggleButtons(
              isSelected: [_isGridView, !_isGridView],
              onPressed: (index) => setState(() => _isGridView = index == 0),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              constraints: const BoxConstraints(minHeight: 42, minWidth: 42),
              children: const [
                Icon(Icons.grid_view, size: 18),
                Icon(Icons.list, size: 18),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTypeChips(),
            if (_searchQuery.isNotEmpty || _selectedType != null || _selectedFolder != 'All Folders' || _sortBy != 'Newest') ...[
              const Spacer(),
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.filter_alt_off, size: 16),
                label: const Text('Reset Filters'),
                style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTypeChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All Asset Types', _selectedType == null, () {
            _selectedType = null;
            _applyFilters();
          }),
          _buildFilterChip('Images', _selectedType == MediaType.image, () {
            _selectedType = MediaType.image;
            _applyFilters();
          }),
          _buildFilterChip('Videos', _selectedType == MediaType.video, () {
            _selectedType = MediaType.video;
            _applyFilters();
          }),
          _buildFilterChip('Audio Chants', _selectedType == MediaType.audio, () {
            _selectedType = MediaType.audio;
            _applyFilters();
          }),
          _buildFilterChip('Documents / PDFs', _selectedType == MediaType.document, () {
            _selectedType = MediaType.document;
            _applyFilters();
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : AppColors.textBody)),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildMainContentState() {
    if (_isLoading) {
      return const LoadingState(message: 'Retrieving Media Repository Assets...');
    }
    if (_hasError) {
      return ErrorState(
        message: 'Failed to query media storage server.',
        onRetry: () => setState(() => _hasError = false),
      );
    }
    if (_filteredMedia.isEmpty) {
      return EmptyState(
        title: 'No Media Assets Found',
        message: 'No files correspond to your current search query or folder filter criteria.',
        icon: Icons.perm_media_outlined,
        onAction: _clearFilters,
        actionLabel: 'Reset Filters',
      );
    }

    if (_isGridView) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedFolder == 'All Folders' && _searchQuery.isEmpty && _selectedType == null) ...[
              const Text('Folders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              _buildFoldersGrid(),
              const SizedBox(height: 24),
              const Text('Recent Media', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 16),
            ],
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.responsive<int>(mobile: 2, tablet: 3, desktop: 5).clamp(1, 10),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: _filteredMedia.length,
              itemBuilder: (context, index) => _buildMediaGridCard(_filteredMedia[index]),
            ),
          ],
        ),
      );
    }

    return _buildDesktopListView();
  }

  Widget _buildFoldersGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsive<int>(mobile: 2, tablet: 4, desktop: 5).clamp(1, 10),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: _allFolders.length,
      itemBuilder: (context, index) {
        final folder = _allFolders[index];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            side: const BorderSide(color: AppColors.border),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedFolder = folder.name;
                _applyFilters();
              });
            },
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.folder, color: AppColors.secondary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(folder.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text('${folder.itemCount} files', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaGridCard(MediaModel media) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => _showMediaDetailsDialog(media),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildMediaPreview(media),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(_getTypeIcon(media.type), color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(media.size, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(media.folder, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopListView() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        itemCount: _filteredMedia.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final media = _filteredMedia[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: () => _showMediaDetailsDialog(media),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 48,
                height: 48,
                child: _buildMediaPreview(media),
              ),
            ),
            title: Text(media.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            subtitle: Text(
              '${media.type.name.toUpperCase()} • ${media.size} • Folder: ${media.folder} • Uploaded ${DateFormat('yyyy-MM-dd').format(media.uploadedAt)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.link, size: 18, color: AppColors.primary),
                  tooltip: 'Copy Reference URL',
                  onPressed: () => _copyMediaUrl(media),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 18, color: AppColors.info),
                  tooltip: 'View & Edit Details',
                  onPressed: () => _showMediaDetailsDialog(media),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaPreview(MediaModel media) {
    switch (media.type) {
      case MediaType.image:
        return Image.network(
          media.url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: AppColors.background,
            child: const Icon(Icons.image, color: AppColors.textDisabled),
          ),
        );
      case MediaType.video:
        return Container(
          color: Colors.black87,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle_outline, color: Colors.white, size: 28),
              SizedBox(height: 2),
              Text('VIDEO', style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      case MediaType.audio:
        return Container(
          color: AppColors.secondary.withOpacity(0.1),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.audiotrack, color: AppColors.secondary, size: 28),
              SizedBox(height: 2),
              Text('AUDIO', style: TextStyle(color: AppColors.secondary, fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      case MediaType.document:
        return Container(
          color: AppColors.info.withOpacity(0.1),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description, color: AppColors.info, size: 28),
              SizedBox(height: 2),
              Text('PDF / DOC', style: TextStyle(color: AppColors.info, fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
        );
    }
  }

  IconData _getTypeIcon(MediaType type) {
    switch (type) {
      case MediaType.image:
        return Icons.image;
      case MediaType.video:
        return Icons.videocam;
      case MediaType.audio:
        return Icons.audiotrack;
      case MediaType.document:
        return Icons.description;
    }
  }
}

// UPLOAD MEDIA MODAL
class _UploadMediaModal extends StatefulWidget {
  final String selectedFolder;
  final List<String> folders;
  final ValueChanged<MediaModel> onUploadComplete;

  const _UploadMediaModal({
    required this.selectedFolder,
    required this.folders,
    required this.onUploadComplete,
  });

  @override
  State<_UploadMediaModal> createState() => _UploadMediaModalState();
}

class _UploadMediaModalState extends State<_UploadMediaModal> {
  PlatformFile? _pickedFile;
  late String _targetFolder;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _targetFolder = widget.selectedFolder;
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  void _startUpload() async {
    if (_pickedFile == null) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.1;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) {
        setState(() {
          _uploadProgress = i / 10.0;
        });
      }
    }

    if (mounted) {
      final ext = _pickedFile!.extension ?? 'file';
      final type = _getMediaType(ext);

      final newMedia = MediaModel(
        id: 'MED-${DateTime.now().millisecondsSinceEpoch}',
        name: _pickedFile!.name,
        url: 'https://images.unsplash.com/photo-1548013146-72479768bbaa?w=400&h=300&fit=crop',
        type: type,
        size: '${(_pickedFile!.size / (1024 * 1024)).toStringAsFixed(1)} MB',
        dimensions: type == MediaType.image ? '1920 x 1080 px' : 'Document',
        uploadedAt: DateTime.now(),
        folder: _targetFolder,
        altText: _pickedFile!.name,
        caption: 'Uploaded asset',
        metadata: {'Format': ext.toUpperCase()},
      );

      widget.onUploadComplete(newMedia);
      Navigator.pop(context);
    }
  }

  MediaType _getMediaType(String ext) {
    final e = ext.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(e)) return MediaType.image;
    if (['mp4', 'mov', 'avi', 'mkv'].contains(e)) return MediaType.video;
    if (['mp3', 'wav', 'aac', 'ogg'].contains(e)) return MediaType.audio;
    return MediaType.document;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.upload_file, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Upload New Media Asset', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SizedBox(
        width: context.responsive<double>(mobile: double.maxFinite, tablet: 450, desktop: 550),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _targetFolder,
              items: widget.folders.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (val) => setState(() => _targetFolder = val!),
              decoration: const InputDecoration(labelText: 'Target Folder / Category'),
            ),
            const SizedBox(height: 16),

            // Drag and drop trigger box
            InkWell(
              onTap: _pickFile,
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, size: 48, color: AppColors.primary),
                    const SizedBox(height: 8),
                    const Text('Drag & Drop files here or Click to Browse', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text('Supports JPG, PNG, WEBP, MP4, MP3, and PDF files', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),

            if (_pickedFile != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_pickedFile!.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('${(_pickedFile!.size / 1024).toStringAsFixed(1)} KB', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (_isUploading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(value: _uploadProgress, color: AppColors.primary, backgroundColor: AppColors.border),
              const SizedBox(height: 4),
              Text('Uploading... ${(_uploadProgress * 100).toInt()}%', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        PrimaryButton(
          onPressed: _pickedFile == null || _isUploading ? null : _startUpload,
          label: 'Start Upload',
        ),
      ],
    );
  }
}

// CREATE GALLERY MODAL
class _CreateGalleryModal extends StatefulWidget {
  final Function(String) onComplete;

  const _CreateGalleryModal({required this.onComplete});

  @override
  State<_CreateGalleryModal> createState() => _CreateGalleryModalState();
}

class _CreateGalleryModalState extends State<_CreateGalleryModal> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _visibility = 'Public';

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.collections_outlined, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Create New Gallery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SizedBox(
        width: context.responsive<double>(mobile: double.maxFinite, tablet: 400, desktop: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Galleries allow you to group related media for display on the public website.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Gallery Name', hintText: 'e.g. Autumn Retreat 2023'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Short Description'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _visibility,
              items: ['Public', 'Private', 'Unlisted'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (val) => setState(() => _visibility = val!),
              decoration: const InputDecoration(labelText: 'Visibility'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        PrimaryButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onComplete(_nameController.text);
              Navigator.pop(context);
            }
          },
          label: 'Create Gallery',
        ),
      ],
    );
  }
}

// MEDIA DETAILS & EDIT DIALOG
class _MediaDetailsDialog extends StatefulWidget {
  final MediaModel media;
  final List<String> folders;
  final VoidCallback onDelete;

  const _MediaDetailsDialog({
    required this.media,
    required this.folders,
    required this.onDelete,
  });

  @override
  State<_MediaDetailsDialog> createState() => _MediaDetailsDialogState();
}

class _MediaDetailsDialogState extends State<_MediaDetailsDialog> {
  late TextEditingController _nameController;
  late TextEditingController _altController;
  late TextEditingController _captionController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  late String _selectedFolder;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.media.name);
    _altController = TextEditingController(text: widget.media.altText);
    _captionController = TextEditingController(text: widget.media.caption);
    _descriptionController = TextEditingController(text: widget.media.description);
    _tagsController = TextEditingController(text: widget.media.tags);
    _selectedFolder = widget.media.folder;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _altController.dispose();
    _captionController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _saveDetails() {
    setState(() {
      widget.media.name = _nameController.text;
      widget.media.altText = _altController.text;
      widget.media.caption = _captionController.text;
      widget.media.description = _descriptionController.text;
      widget.media.tags = _tagsController.text;
      widget.media.folder = _selectedFolder;
    });
    UIUtils.showSuccessMessage(context, 'Media asset metadata updated.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = context.isDesktop;

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(widget.media.name, style: TextStyle(fontSize: context.responsive<double>(mobile: 16, tablet: 18, desktop: 20), fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
        ],
      ),
      content: SizedBox(
        width: context.responsive<double>(mobile: double.maxFinite, tablet: 700, desktop: 900),
        child: SingleChildScrollView(
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildPreviewColumn()),
                    const SizedBox(width: 24),
                    Expanded(flex: 3, child: _buildEditingColumn()),
                  ],
                )
              : Column(
                  children: [
                    _buildPreviewColumn(),
                    const SizedBox(height: 24),
                    _buildEditingColumn(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildPreviewColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 300),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Center(child: _buildLargePreview()),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          child: Column(
            children: [
              _buildMetaRow('File Type', widget.media.type.name.toUpperCase()),
              _buildMetaRow('File Size', widget.media.size),
              _buildMetaRow('Dimensions', widget.media.dimensions),
              _buildMetaRow('Upload Date', DateFormat('yyyy-MM-dd').format(widget.media.uploadedAt)),
              ...widget.media.metadata.entries.map((e) => _buildMetaRow(e.key, e.value)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLargePreview() {
    switch (widget.media.type) {
      case MediaType.image:
        return Image.network(widget.media.url, fit: BoxFit.contain);
      case MediaType.video:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_fill, color: Colors.white, size: 64),
            SizedBox(height: 8),
            Text('Video Asset Preview', style: TextStyle(color: Colors.white70)),
          ],
        );
      case MediaType.audio:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.audiotrack, color: AppColors.secondary, size: 64),
            SizedBox(height: 8),
            Text('Audio Recording Asset', style: TextStyle(color: Colors.white70)),
          ],
        );
      case MediaType.document:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, color: AppColors.info, size: 64),
            SizedBox(height: 8),
            Text('PDF Document Asset', style: TextStyle(color: Colors.white70)),
          ],
        );
    }
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildEditingColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Edit Media Metadata', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'File Name'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: widget.folders.contains(_selectedFolder) ? _selectedFolder : widget.folders.first,
          items: widget.folders.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
          onChanged: (val) => setState(() => _selectedFolder = val!),
          decoration: const InputDecoration(labelText: 'Folder / Category'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _altController,
          decoration: const InputDecoration(labelText: 'Alt Text (for accessibility)'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _captionController,
          decoration: const InputDecoration(labelText: 'Caption'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _tagsController,
          decoration: const InputDecoration(labelText: 'Tags (comma separated)'),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                onPressed: _saveDetails,
                label: 'Save Details',
              ),
            ),
            if (PermissionService.hasPermission(AppPermissions.mediaDelete)) ...[
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => _showDeleteConfirm(context),
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                tooltip: 'Delete Asset',
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Delete Media Asset',
        confirmLabel: 'Delete Permanently',
        confirmColor: AppColors.error,
        onConfirm: () {
          Navigator.pop(ctx);
          widget.onDelete();
        },
        content: Text('Are you sure you want to permanently delete "${widget.media.name}"?'),
      ),
    );
  }
}
