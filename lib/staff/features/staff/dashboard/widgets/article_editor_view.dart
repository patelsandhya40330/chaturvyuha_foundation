import 'package:chaturvyuha_foundation/staff/core/constants/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_sizes.dart';
import 'package:chaturvyuha_foundation/staff/core/responsive/responsive_layout.dart';
import 'package:chaturvyuha_foundation/staff/core/utils/ui_utils.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/buttons.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/dialogs.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/navigation_widgets.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleEditorView extends StatefulWidget {
  final String? articleId;

  const ArticleEditorView({super.key, this.articleId});

  @override
  State<ArticleEditorView> createState() => _ArticleEditorViewState();
}

class _ArticleEditorViewState extends State<ArticleEditorView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _slugController = TextEditingController();
  final _excerptController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _seoTitleController = TextEditingController();
  final _seoDescriptionController = TextEditingController();
  final _canonicalUrlController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _hasError = false;
  bool _isFeatured = false;
  bool _isPreviewMode = false;
  String _selectedStatus = 'Draft';
  String _selectedCategory = 'Vedic Studies';
  DateTime? _publishedDate;

  final List<String> _categories = ['Vedic Studies', 'Meditation', 'Community', 'History'];
  final List<String> _statuses = ['Draft', 'Pending Review', 'Published', 'Unpublished'];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTitleChanged);
    if (widget.articleId != null) {
      _loadArticleData();
    } else {
      _contentController.text = '## Section 1: Overview\n\nWelcome to this foundational article on Vedic philosophy and heritage. Write your content here using markdown or rich text tools above.\n\n> "Truth is One, the Wise call It by many names." — Rigveda\n\n### Key Concepts\n- Systematic exploration of consciousness\n- Ethical frameworks and cosmic order\n- Digital manuscript preservation';
    }
  }

  void _onTitleChanged() {
    if (widget.articleId == null) {
      final title = _titleController.text;
      _slugController.text = title
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
          .replaceAll(RegExp(r'\s+'), '-');
    }
  }

  void _loadArticleData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));

    if (mounted) {
      setState(() {
        _titleController.text = 'Introduction to Vedic Studies and Philosophy';
        _slugController.text = 'intro-to-vedic-studies';
        _excerptController.text = 'A comprehensive guide to understanding the roots of Vedic philosophy and scriptural heritage.';
        _contentController.text = '## Introduction to Vedic Studies\n\nVedic philosophy represents one of humanity\'s oldest systematic explorations of consciousness, cosmic order, and ethical living.\n\n> "Let noble thoughts come to us from every direction." — Rigveda 1.89.1\n\n### Core Pillars\n1. **Samhitas**: Core hymnal citations and mantras.\n2. **Brahmanas**: Procedural guidelines for rituals and chants.\n3. **Upanishads**: Philosophical dialogues exploring the Self.\n\n![Vedic Manuscripts](https://cfoundation.org/images/manuscript.jpg)\n\nFor additional manuscript citations, explore our digital repository catalog.';
        _tagsController.text = 'vedic, philosophy, ancient, heritage';
        _selectedCategory = 'Vedic Studies';
        _selectedStatus = 'Published';
        _isFeatured = true;
        _publishedDate = DateTime(2024, 1, 10);
        _seoTitleController.text = 'Vedic Studies & Philosophy Guide | Chaturvyuha';
        _seoDescriptionController.text = 'Learn the fundamentals of Vedic philosophy and manuscript preservation in this detailed foundation guide.';
        _canonicalUrlController.text = 'https://cfoundation.org/articles/intro-to-vedic-studies';
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
    _contentController.dispose();
    _tagsController.dispose();
    _seoTitleController.dispose();
    _seoDescriptionController.dispose();
    _canonicalUrlController.dispose();
    super.dispose();
  }

  void _insertFormatting(String prefix, [String suffix = '']) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (selection.isValid && !selection.isCollapsed) {
      final selectedText = text.substring(selection.start, selection.end);
      final newText = text.replaceRange(selection.start, selection.end, '$prefix$selectedText$suffix');
      _contentController.text = newText;
      _contentController.selection = TextSelection(
        baseOffset: selection.start + prefix.length,
        extentOffset: selection.start + prefix.length + selectedText.length,
      );
    } else {
      final cursor = selection.isValid ? selection.start : text.length;
      final newText = text.replaceRange(cursor, cursor, '$prefix$suffix');
      _contentController.text = newText;
      _contentController.selection = TextSelection.collapsed(offset: cursor + prefix.length);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _publishedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _publishedDate) {
      setState(() {
        _publishedDate = picked;
      });
    }
  }

  void _handleSave(String action) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) {
        setState(() => _isLoading = false);
        UIUtils.showSuccessMessage(context, 'Article successfully saved as $action!');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingState(message: 'Loading Article Workspace...'));
    }

    if (_hasError) {
      return Scaffold(
        body: ErrorState(
          message: 'Error loading article content from the repository server.',
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
            _buildHeader(),
            const SizedBox(height: AppSizes.s24),
            ResponsiveLayout(
              mobile: _buildMobileLayout(),
              desktop: _buildDesktopLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isEdit = widget.articleId != null;
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Articles List',
        ),
        const SizedBox(width: AppSizes.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Breadcrumb(
                items: [
                  BreadcrumbItem(label: 'Articles', onTap: () => Navigator.pop(context)),
                  BreadcrumbItem(label: isEdit ? 'Edit Article' : 'New Article'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isEdit ? 'Edit Article' : 'Create New Article',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                isEdit ? 'Refine and publish your foundation content.' : 'Draft and publish a new article to the repository.',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
        if (ResponsiveLayout.isDesktop(context)) ...[
          const SizedBox(width: AppSizes.s12),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Cancel'),
            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildMainFormFields(),
              const SizedBox(height: AppSizes.s24),
              _buildSeoSection(),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.s24),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildPublishingControls(),
              const SizedBox(height: AppSizes.s24),
              _buildSettingsSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildMainFormFields(),
        const SizedBox(height: AppSizes.s24),
        _buildSettingsSection(),
        const SizedBox(height: AppSizes.s24),
        _buildSeoSection(),
        const SizedBox(height: AppSizes.s24),
        _buildPublishingControls(),
      ],
    );
  }

  Widget _buildMainFormFields() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Article Content Editor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Editor'),
                      selected: !_isPreviewMode,
                      onSelected: (selected) {
                        if (selected) setState(() => _isPreviewMode = false);
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Live Preview'),
                      selected: _isPreviewMode,
                      onSelected: (selected) {
                        if (selected) setState(() => _isPreviewMode = true);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s24),
            _buildTextField(
              controller: _titleController,
              label: 'Article Title',
              hint: 'e.g. Introduction to Vedic Philosophy',
              isRequired: true,
            ),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(
              controller: _slugController,
              label: 'URL Slug',
              hint: 'e.g. intro-to-vedic-philosophy',
              isRequired: true,
            ),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(
              controller: _excerptController,
              label: 'Excerpt Summary',
              hint: 'A brief summary of the article for listings and search engines...',
              maxLines: 3,
            ),
            const SizedBox(height: AppSizes.s24),

            // Content Editor Area
            RichText(
              text: const TextSpan(
                text: 'Article Content',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textBody),
                children: [TextSpan(text: ' *', style: TextStyle(color: AppColors.error))],
              ),
            ),
            const SizedBox(height: AppSizes.s8),

            if (!_isPreviewMode) ...[
              _buildCmsFormattingToolbar(),
              TextFormField(
                controller: _contentController,
                maxLines: 12,
                validator: (val) => (val == null || val.isEmpty) ? 'Article content is required' : null,
                style: const TextStyle(fontSize: 14, fontFamily: 'monospace', height: 1.4),
                decoration: const InputDecoration(
                  hintText: 'Write or paste your article content here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSizes.radiusMedium),
                      bottomRight: Radius.circular(AppSizes.radiusMedium),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_titleController.text.isNotEmpty ? _titleController.text : 'Untitled Article', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text('Category: $_selectedCategory • Author: Acharya Dev', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Divider(height: 24),
                    Text(_contentController.text, style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textBody)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCmsFormattingToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusMedium),
          topRight: Radius.circular(AppSizes.radiusMedium),
        ),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildToolbarBtn('H1', () => _insertFormatting('# ')),
            _buildToolbarBtn('H2', () => _insertFormatting('## ')),
            _buildToolbarBtn('H3', () => _insertFormatting('### ')),
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.format_bold, size: 18), tooltip: 'Bold', onPressed: () => _insertFormatting('**', '**')),
            IconButton(icon: const Icon(Icons.format_italic, size: 18), tooltip: 'Italic', onPressed: () => _insertFormatting('*', '*')),
            IconButton(icon: const Icon(Icons.format_list_bulleted, size: 18), tooltip: 'Bullet List', onPressed: () => _insertFormatting('- ')),
            IconButton(icon: const Icon(Icons.format_list_numbered, size: 18), tooltip: 'Numbered List', onPressed: () => _insertFormatting('1. ')),
            IconButton(icon: const Icon(Icons.format_quote, size: 18), tooltip: 'Quote', onPressed: () => _insertFormatting('> ')),
            IconButton(icon: const Icon(Icons.link, size: 18), tooltip: 'Insert Link', onPressed: () => _insertFormatting('[', '](https://)')),
            IconButton(icon: const Icon(Icons.image_outlined, size: 18), tooltip: 'Insert Image', onPressed: () => _insertFormatting('![Image Alt Text](https://cfoundation.org/images/photo.jpg)\n')),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarBtn(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
    );
  }

  Widget _buildSeoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Search Engine Optimization (SEO)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s24),
            _buildTextField(
              controller: _seoTitleController,
              label: 'SEO Title',
              hint: 'Search engine friendly title',
            ),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(
              controller: _seoDescriptionController,
              label: 'Meta Description',
              hint: 'Short description for search engine results',
              maxLines: 3,
            ),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(
              controller: _canonicalUrlController,
              label: 'Canonical URL',
              hint: 'https://cfoundation.org/articles/canonical-path',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Classification & Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s24),
            _buildDropdown(
              label: 'Category',
              value: _selectedCategory,
              items: _categories,
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(
              controller: _tagsController,
              label: 'Tags',
              hint: 'vedic, philosophy, peace (comma separated)',
            ),
            const SizedBox(height: AppSizes.s16),
            SwitchListTile(
              title: const Text('Featured Article', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('Highlight article on home slider and portal features.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              value: _isFeatured,
              activeThumbColor: AppColors.primary,
              onChanged: (val) => setState(() => _isFeatured = val),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSizes.s16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Published Date',
                  prefixIcon: Icon(Icons.calendar_today, size: 20),
                ),
                child: Text(
                  _publishedDate == null ? 'Not Set (Auto on publish)' : DateFormat('yyyy-MM-dd').format(_publishedDate!),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublishingControls() {
    return Card(
      color: AppColors.primary.withOpacity(0.01),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Publishing Workflow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s16),
            _buildDropdown(
              label: 'Current Status',
              value: _selectedStatus,
              items: _statuses,
              onChanged: (val) => setState(() => _selectedStatus = val!),
            ),
            const SizedBox(height: AppSizes.s24),
            PrimaryButton(
              onPressed: () => _handleSave('Published'),
              backgroundColor: AppColors.success,
              label: 'Publish Now',
            ),
            const SizedBox(height: AppSizes.s12),
            SecondaryButton(
              onPressed: () => _handleSave('Pending Review'),
              label: 'Submit for Review',
            ),
            const SizedBox(height: AppSizes.s12),
            TextButton(
              onPressed: () => _handleSave('Draft'),
              child: const Text('Save as Draft'),
            ),
            const Divider(height: 32),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    title: 'Discard Article Changes?',
                    confirmLabel: 'Discard',
                    confirmColor: AppColors.error,
                    onConfirm: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    content: const Text('Are you sure you want to discard all unsaved changes?'),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Discard Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    bool isRequired = false,
  }) {
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
          validator: isRequired ? (value) => (value == null || value.isEmpty) ? 'This field is required' : null : null,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
    );
  }
}
