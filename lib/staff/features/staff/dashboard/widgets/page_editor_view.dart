import 'package:chaturvyuha_foundation/staff/core/constants/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_sizes.dart';
import 'package:chaturvyuha_foundation/staff/core/responsive/responsive_layout.dart';
import 'package:chaturvyuha_foundation/staff/core/utils/ui_utils.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/buttons.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/dialogs.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/navigation_widgets.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/state_widgets.dart';
import 'package:flutter/material.dart';

enum PageSectionType { hero, text, image, gallery, cta, programEvent }

class PageSectionModel {
  final String id;
  PageSectionType type;
  String title;
  String subtitle;
  String content;
  String imageUrl;
  String buttonText;
  String buttonUrl;
  List<String> galleryUrls;

  PageSectionModel({
    required this.id,
    required this.type,
    this.title = '',
    this.subtitle = '',
    this.content = '',
    this.imageUrl = '',
    this.buttonText = '',
    this.buttonUrl = '',
    List<String>? galleryUrls,
  }) : galleryUrls = galleryUrls ?? [];
}

class PageEditorView extends StatefulWidget {
  final String? pageId;

  const PageEditorView({super.key, this.pageId});

  @override
  State<PageEditorView> createState() => _PageEditorViewState();
}

class _PageEditorViewState extends State<PageEditorView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _slugController = TextEditingController();
  final _excerptController = TextEditingController();
  final _seoTitleController = TextEditingController();
  final _seoDescriptionController = TextEditingController();
  final _canonicalUrlController = TextEditingController();

  // Local state
  bool _isLoading = false;
  bool _hasError = false;
  bool _isFeatured = false;
  String _selectedStatus = 'Draft';

  final List<String> _statuses = ['Draft', 'Review', 'Published'];

  // Page Sections
  late List<PageSectionModel> _sections;

  @override
  void initState() {
    super.initState();
    _sections = [];
    _titleController.addListener(_onTitleChanged);
    if (widget.pageId != null) {
      _loadPageLayoutData();
    } else {
      _initializeDefaultSections();
    }
  }

  void _onTitleChanged() {
    if (widget.pageId == null) {
      final title = _titleController.text;
      _slugController.text = title
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
          .replaceAll(RegExp(r'\s+'), '-');
    }
  }

  void _initializeDefaultSections() {
    _sections = [
      PageSectionModel(
        id: 'SEC-1',
        type: PageSectionType.hero,
        title: 'Welcome to Chaturvyuha Foundation',
        subtitle: 'Preserving Ancient Heritage and Scriptural Philosophy',
        imageUrl: 'https://cfoundation.org/images/hero-banner.jpg',
        buttonText: 'Explore Research',
        buttonUrl: '/research',
      ),
      PageSectionModel(
        id: 'SEC-2',
        type: PageSectionType.text,
        title: 'Institutional Overview',
        content: 'Our repository serves as a global hub for Sanskrit manuscripts, Vedic research guidelines, and authentic spiritual literature.',
      ),
      PageSectionModel(
        id: 'SEC-3',
        type: PageSectionType.cta,
        title: 'Join Our Volunteer Seva Program',
        subtitle: 'Participate in digital manuscript archiving and community education.',
        buttonText: 'Register as Volunteer',
        buttonUrl: '/volunteer-seva',
      ),
    ];
  }

  void _loadPageLayoutData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _titleController.text = 'Home Portal Interface';
        _slugController.text = 'home-portal';
        _excerptController.text = 'Main gateway interface for the institutional portal and research archives.';
        _selectedStatus = 'Published';
        _isFeatured = true;
        _seoTitleController.text = 'Foundation Home Workspace';
        _seoDescriptionController.text = 'Access real-time operational resources and content registries inside the foundation workspace.';
        _canonicalUrlController.text = 'https://cfoundation.org/portal/home-portal';

        _sections = [
          PageSectionModel(
            id: 'SEC-1',
            type: PageSectionType.hero,
            title: 'Welcome to Chaturvyuha Foundation',
            subtitle: 'Preserving Ancient Heritage and Scriptural Philosophy',
            imageUrl: 'https://cfoundation.org/images/hero-banner.jpg',
            buttonText: 'Explore Research',
            buttonUrl: '/research',
          ),
          PageSectionModel(
            id: 'SEC-2',
            type: PageSectionType.text,
            title: 'Institutional Overview',
            content: 'Our repository serves as a global hub for Sanskrit manuscripts, Vedic research guidelines, and authentic spiritual literature.',
          ),
          PageSectionModel(
            id: 'SEC-3',
            type: PageSectionType.gallery,
            title: 'Cultural Heritage Gallery',
            galleryUrls: [
              'https://cfoundation.org/images/gallery1.jpg',
              'https://cfoundation.org/images/gallery2.jpg',
            ],
          ),
          PageSectionModel(
            id: 'SEC-4',
            type: PageSectionType.programEvent,
            title: 'Upcoming Ashram Seminars',
            content: 'Featured conferences and community gatherings for this quarter.',
          ),
          PageSectionModel(
            id: 'SEC-5',
            type: PageSectionType.cta,
            title: 'Join Our Volunteer Seva Program',
            subtitle: 'Participate in digital manuscript archiving and community education.',
            buttonText: 'Register as Volunteer',
            buttonUrl: '/volunteer-seva',
          ),
        ];

        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _slugController.dispose();
    _excerptController.dispose();
    _seoTitleController.dispose();
    _seoDescriptionController.dispose();
    _canonicalUrlController.dispose();
    super.dispose();
  }

  void _addSection(PageSectionType type) {
    setState(() {
      final newId = 'SEC-${DateTime.now().millisecondsSinceEpoch}';
      String defaultTitle = '';
      switch (type) {
        case PageSectionType.hero:
          defaultTitle = 'Hero Banner Section';
          break;
        case PageSectionType.text:
          defaultTitle = 'Content Block Section';
          break;
        case PageSectionType.image:
          defaultTitle = 'Featured Image Section';
          break;
        case PageSectionType.gallery:
          defaultTitle = 'Photo Gallery Section';
          break;
        case PageSectionType.cta:
          defaultTitle = 'Call to Action Section';
          break;
        case PageSectionType.programEvent:
          defaultTitle = 'Featured Programs & Events';
          break;
      }

      _sections.add(
        PageSectionModel(
          id: newId,
          type: type,
          title: defaultTitle,
        ),
      );
    });

    UIUtils.showSuccessMessage(context, 'Added new ${type.name.toUpperCase()} section.');
  }

  void _moveSectionUp(int index) {
    if (index > 0) {
      setState(() {
        final item = _sections.removeAt(index);
        _sections.insert(index - 1, item);
      });
    }
  }

  void _moveSectionDown(int index) {
    if (index < _sections.length - 1) {
      setState(() {
        final item = _sections.removeAt(index);
        _sections.insert(index + 1, item);
      });
    }
  }

  void _removeSection(int index) {
    setState(() {
      final removed = _sections.removeAt(index);
      UIUtils.showSuccessMessage(context, 'Removed section "${removed.title}".');
    });
  }

  void _handleFormSubmit(String targetAction) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) {
        setState(() => _isLoading = false);
        UIUtils.showSuccessMessage(context, 'Page successfully saved as $targetAction!');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: LoadingState(message: 'Mapping Page Layout...'));
    if (_hasError) {
      return Scaffold(
        body: ErrorState(
          message: 'Error mapping structural templates.',
          onRetry: () => setState(() => _hasError = false),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.s24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditorHeader(),
            const SizedBox(height: AppSizes.s24),
            ResponsiveLayout(
              mobile: _buildMobileFormLayout(),
              desktop: _buildDesktopFormLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorHeader() {
    final isEdit = widget.pageId != null;
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Pages List',
        ),
        const SizedBox(width: AppSizes.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Breadcrumb(
                items: [
                  BreadcrumbItem(label: 'Pages', onTap: () => Navigator.pop(context)),
                  BreadcrumbItem(label: isEdit ? 'Edit Page' : 'New Page'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isEdit ? 'Modify Page' : 'Create New Page',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                isEdit ? 'Configure responsive layout sections and SEO indicators.' : 'Deploy a new static page layout across the portal.',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
        if (ResponsiveLayout.isDesktop(context)) ...[
          const SizedBox(width: AppSizes.s12),
          SecondaryButton(
            onPressed: () => Navigator.pop(context),
            icon: Icons.close,
            label: 'Cancel',
            foregroundColor: AppColors.textSecondary,
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopFormLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildCoreFieldsCard(),
              const SizedBox(height: AppSizes.s24),
              _buildSectionsBuilderCard(),
              const SizedBox(height: AppSizes.s24),
              _buildSeoFieldsCard(),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.s24),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildPublishingControlsCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFormLayout() {
    return Column(
      children: [
        _buildCoreFieldsCard(),
        const SizedBox(height: AppSizes.s24),
        _buildSectionsBuilderCard(),
        const SizedBox(height: AppSizes.s24),
        _buildSeoFieldsCard(),
        const SizedBox(height: AppSizes.s24),
        _buildPublishingControlsCard(),
      ],
    );
  }

  Widget _buildCoreFieldsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('General Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s24),
            _buildInputField(controller: _titleController, label: 'Page Title', hint: 'e.g. Sanskrit Resource Catalog', isRequired: true),
            const SizedBox(height: AppSizes.s16),
            _buildInputField(controller: _slugController, label: 'URL Slug Path', hint: 'e.g. sanskrit-catalog', isRequired: true),
            const SizedBox(height: AppSizes.s16),
            _buildInputField(controller: _excerptController, label: 'Page Summary / Excerpt', hint: 'Brief introductory overview for search listings...', maxLines: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionsBuilderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Page Sections Builder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Structure modular content blocks for your page.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                PopupMenuButton<PageSectionType>(
                  onSelected: _addSection,
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                  tooltip: 'Add Page Section',
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: PageSectionType.hero,
                      child: Row(children: [Icon(Icons.view_carousel, size: 18), SizedBox(width: 8), Text('Hero Section')]),
                    ),
                    PopupMenuItem(
                      value: PageSectionType.text,
                      child: Row(children: [Icon(Icons.article_outlined, size: 18), SizedBox(width: 8), Text('Text / Content Section')]),
                    ),
                    PopupMenuItem(
                      value: PageSectionType.image,
                      child: Row(children: [Icon(Icons.image_outlined, size: 18), SizedBox(width: 8), Text('Image Section')]),
                    ),
                    PopupMenuItem(
                      value: PageSectionType.gallery,
                      child: Row(children: [Icon(Icons.collections_outlined, size: 18), SizedBox(width: 8), Text('Gallery Section')]),
                    ),
                    PopupMenuItem(
                      value: PageSectionType.cta,
                      child: Row(children: [Icon(Icons.call_to_action_outlined, size: 18), SizedBox(width: 8), Text('Call-To-Action (CTA)')]),
                    ),
                    PopupMenuItem(
                      value: PageSectionType.programEvent,
                      child: Row(children: [Icon(Icons.event_outlined, size: 18), SizedBox(width: 8), Text('Program / Event Section')]),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            if (_sections.isEmpty) ...[
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.layers_clear_outlined, size: 36, color: AppColors.textDisabled),
                    const SizedBox(height: 8),
                    const Text('No content sections added yet.', style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _addSection(PageSectionType.hero),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Hero Section'),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _sections.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final section = _sections[index];
                  return _buildSectionCard(section, index);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(PageSectionModel section, int index) {
    IconData icon;
    String typeLabel;
    Color color;

    switch (section.type) {
      case PageSectionType.hero:
        icon = Icons.view_carousel;
        typeLabel = 'Hero Banner Section';
        color = AppColors.primary;
        break;
      case PageSectionType.text:
        icon = Icons.article_outlined;
        typeLabel = 'Text / Content Section';
        color = Colors.blue;
        break;
      case PageSectionType.image:
        icon = Icons.image_outlined;
        typeLabel = 'Image Section';
        color = Colors.green;
        break;
      case PageSectionType.gallery:
        icon = Icons.collections_outlined;
        typeLabel = 'Photo Gallery Section';
        color = Colors.purple;
        break;
      case PageSectionType.cta:
        icon = Icons.call_to_action_outlined;
        typeLabel = AppColors.secondary.value == 0 ? Colors.orange.toString() : 'CTA Section';
        typeLabel = 'Call To Action (CTA)';
        color = AppColors.secondary;
        break;
      case PageSectionType.programEvent:
        icon = Icons.event_outlined;
        typeLabel = 'Program / Event Section';
        color = Colors.teal;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        key: Key(section.id),
        initiallyExpanded: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          section.title.isNotEmpty ? section.title : typeLabel,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          typeLabel,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_upward, size: 16),
              tooltip: 'Move Up',
              onPressed: index > 0 ? () => _moveSectionUp(index) : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward, size: 16),
              tooltip: 'Move Down',
              onPressed: index < _sections.length - 1 ? () => _moveSectionDown(index) : null,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 18),
              tooltip: 'Delete Section',
              onPressed: () => _removeSection(index),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionSpecificFields(section),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionSpecificFields(PageSectionModel section) {
    switch (section.type) {
      case PageSectionType.hero:
        return Column(
          children: [
            TextFormField(
              initialValue: section.title,
              decoration: const InputDecoration(labelText: 'Hero Heading Title'),
              onChanged: (val) => setState(() => section.title = val),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: section.subtitle,
              decoration: const InputDecoration(labelText: 'Hero Subtitle / Tagline'),
              onChanged: (val) => section.subtitle = val,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: section.imageUrl,
              decoration: const InputDecoration(labelText: 'Background Image URL'),
              onChanged: (val) => section.imageUrl = val,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: section.buttonText,
                    decoration: const InputDecoration(labelText: 'Button Label'),
                    onChanged: (val) => section.buttonText = val,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: section.buttonUrl,
                    decoration: const InputDecoration(labelText: 'Button URL Target'),
                    onChanged: (val) => section.buttonUrl = val,
                  ),
                ),
              ],
            ),
          ],
        );

      case PageSectionType.text:
        return Column(
          children: [
            TextFormField(
              initialValue: section.title,
              decoration: const InputDecoration(labelText: 'Section Heading'),
              onChanged: (val) => setState(() => section.title = val),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: section.content,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Body Text / Markdown Content'),
              onChanged: (val) => section.content = val,
            ),
          ],
        );

      case PageSectionType.image:
        return Column(
          children: [
            TextFormField(
              initialValue: section.title,
              decoration: const InputDecoration(labelText: 'Image Caption / Heading'),
              onChanged: (val) => setState(() => section.title = val),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: section.imageUrl,
              decoration: const InputDecoration(labelText: 'Image URL'),
              onChanged: (val) => section.imageUrl = val,
            ),
          ],
        );

      case PageSectionType.gallery:
        return Column(
          children: [
            TextFormField(
              initialValue: section.title,
              decoration: const InputDecoration(labelText: 'Gallery Section Title'),
              onChanged: (val) => setState(() => section.title = val),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: section.galleryUrls.join('\n'),
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Gallery Image URLs (One per line)'),
              onChanged: (val) => section.galleryUrls = val.split('\n').where((s) => s.trim().isNotEmpty).toList(),
            ),
          ],
        );

      case PageSectionType.cta:
        return Column(
          children: [
            TextFormField(
              initialValue: section.title,
              decoration: const InputDecoration(labelText: 'CTA Box Title'),
              onChanged: (val) => setState(() => section.title = val),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: section.subtitle,
              decoration: const InputDecoration(labelText: 'CTA Description Text'),
              onChanged: (val) => section.subtitle = val,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: section.buttonText,
                    decoration: const InputDecoration(labelText: 'Primary Action Label'),
                    onChanged: (val) => section.buttonText = val,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: section.buttonUrl,
                    decoration: const InputDecoration(labelText: 'Action Target Link'),
                    onChanged: (val) => section.buttonUrl = val,
                  ),
                ),
              ],
            ),
          ],
        );

      case PageSectionType.programEvent:
        return Column(
          children: [
            TextFormField(
              initialValue: section.title,
              decoration: const InputDecoration(labelText: 'Section Title (e.g. Featured Events)'),
              onChanged: (val) => setState(() => section.title = val),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: section.content,
              decoration: const InputDecoration(labelText: 'Description / Filter Criteria'),
              onChanged: (val) => section.content = val,
            ),
          ],
        );
    }
  }

  Widget _buildSeoFieldsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Search Engine Optimization (SEO)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s24),
            _buildInputField(controller: _seoTitleController, label: 'SEO Meta Title', hint: 'Search engine snippet title'),
            const SizedBox(height: AppSizes.s16),
            _buildInputField(controller: _seoDescriptionController, label: 'Meta Description', hint: 'Brief index abstract summary matching crawler guidelines', maxLines: 3),
            const SizedBox(height: AppSizes.s16),
            _buildInputField(controller: _canonicalUrlController, label: 'Canonical URL Target', hint: 'https://cfoundation.org/preferred-path'),
          ],
        ),
      ),
    );
  }

  Widget _buildPublishingControlsCard() {
    return Card(
      color: AppColors.primary.withOpacity(0.01),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Page Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s16),
            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              items: _statuses.map((status) => DropdownMenuItem(value: status, child: Text(status, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: (val) => setState(() => _selectedStatus = val!),
              decoration: const InputDecoration(labelText: 'Lifecycle Status'),
            ),
            const SizedBox(height: AppSizes.s16),
            SwitchListTile(
              title: const Text('Featured Page', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('Highlight page on main navigation and portal index.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              value: _isFeatured,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _isFeatured = val),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSizes.s24),
            PrimaryButton(
              onPressed: () => _handleFormSubmit('Published'),
              backgroundColor: AppColors.success,
              label: 'Publish Page Now',
            ),
            const SizedBox(height: AppSizes.s12),
            SecondaryButton(
              onPressed: () => _handleFormSubmit('Review'),
              label: 'Submit for Peer Review',
            ),
            const SizedBox(height: AppSizes.s12),
            TextButton(
              onPressed: () => _handleFormSubmit('Draft'),
              child: const Text('Save Draft'),
            ),
            const Divider(height: 32),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    title: 'Discard Page Draft?',
                    confirmLabel: 'Discard Changes',
                    confirmColor: AppColors.error,
                    onConfirm: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    content: const Text('Are you sure you wish to discard your current page configurations?'),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Cancel & Discard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required TextEditingController controller, required String label, required String hint, int maxLines = 1, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textBody),
            children: isRequired ? [const TextSpan(text: ' *', style: TextStyle(color: AppColors.error))] : [],
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: isRequired ? (v) => (v == null || v.isEmpty) ? 'This field is required' : null : null,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
