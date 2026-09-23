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

class EventEditorView extends StatefulWidget {
  final String? eventId;

  const EventEditorView({super.key, this.eventId});

  @override
  State<EventEditorView> createState() => _EventEditorViewState();
}

class _EventEditorViewState extends State<EventEditorView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _startTimeController = TextEditingController(text: '08:00 AM');
  final _endTimeController = TextEditingController(text: '11:00 AM');
  final _capacityController = TextEditingController(text: '150');
  final _galleryUrlsController = TextEditingController();

  // Local state
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isRegistrationEnabled = true;
  String _selectedStatus = 'Upcoming';

  final List<String> _statuses = ['Upcoming', 'Live', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTitleChanged);
    if (widget.eventId != null) {
      _loadMockData();
    } else {
      _startDate = DateTime.now().add(const Duration(days: 14));
      _endDate = DateTime.now().add(const Duration(days: 14));
    }
  }

  void _onTitleChanged() {
    if (widget.eventId == null) {
      final title = _titleController.text;
      _slugController.text = title
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
          .replaceAll(RegExp(r'\s+'), '-');
    }
  }

  void _loadMockData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _titleController.text = 'Global Peace Meditation Gathering';
        _slugController.text = 'global-peace-meditation';
        _descriptionController.text = 'A worldwide synchronized meditation conference fostering global harmony and spiritual consciousness.';
        _locationController.text = 'Main Ashram Hall';
        _startTimeController.text = '08:00 AM';
        _endTimeController.text = '11:00 AM';
        _capacityController.text = '200';
        _galleryUrlsController.text = 'https://cfoundation.org/images/evt1-1.jpg\nhttps://cfoundation.org/images/evt1-2.jpg';
        _selectedStatus = 'Upcoming';
        _isRegistrationEnabled = true;
        _startDate = DateTime(2024, 10, 15);
        _endDate = DateTime(2024, 10, 15);
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _capacityController.dispose();
    _galleryUrlsController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() => _endDate = picked);
    }
  }

  void _handleSave(String targetStatus) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() => _isLoading = false);
        UIUtils.showSuccessMessage(context, 'Event saved successfully as $targetStatus!');
        Navigator.pop(context);
      }
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete Event',
        confirmLabel: 'Delete',
        confirmColor: AppColors.error,
        onConfirm: () {
          Navigator.pop(context); // Pop dialog
          Navigator.pop(context); // Pop editor
          UIUtils.showSuccessMessage(context, 'Event deleted successfully.');
        },
        content: const Text('Are you sure you want to delete this event? This action cannot be undone.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: LoadingState(message: 'Loading Event Details...'));
    if (_hasError) {
      return Scaffold(
        body: ErrorState(
          message: 'Error loading event details from server.',
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
    final isEdit = widget.eventId != null;
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Events List',
        ),
        const SizedBox(width: AppSizes.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Breadcrumb(
                items: [
                  BreadcrumbItem(label: 'Events', onTap: () => Navigator.pop(context)),
                  BreadcrumbItem(label: isEdit ? 'Edit Event' : 'New Event'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isEdit ? 'Edit Event' : 'Create Event',
                style: TextStyle(
                  fontSize: context.responsive<double>(mobile: 20, tablet: 22, desktop: 24),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                isEdit ? 'Update event schedule, venue location, and capacity.' : 'Schedule and publish a new cultural gathering or conference.',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
        if (context.isDesktop) ...[
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
              _buildMainDetailsCard(),
              const SizedBox(height: AppSizes.s24),
              _buildScheduleVenueCard(),
              const SizedBox(height: AppSizes.s24),
              _buildMediaGalleryCard(),
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

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildMainDetailsCard(),
        const SizedBox(height: AppSizes.s24),
        _buildScheduleVenueCard(),
        const SizedBox(height: AppSizes.s24),
        _buildMediaGalleryCard(),
        const SizedBox(height: AppSizes.s24),
        _buildPublishingControlsCard(),
      ],
    );
  }

  Widget _buildMainDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Event Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s24),
            _buildTextField(_titleController, 'Event Title', hint: 'e.g. Global Peace Meditation Gathering', isRequired: true),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(_slugController, 'URL Path Slug', hint: 'e.g. global-peace-meditation', isRequired: true),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(_descriptionController, 'Event Description', hint: 'Detailed description for public view...', maxLines: 5, isRequired: true),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleVenueCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Schedule & Venue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s24),
            _buildTextField(_locationController, 'Venue / Location', hint: 'e.g. Main Ashram Hall / Conference Room A', isRequired: true),
            const SizedBox(height: AppSizes.s16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectStartDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Start Date', prefixIcon: Icon(Icons.calendar_today, size: 18)),
                      child: Text(_startDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(_startDate!)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectEndDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'End Date', prefixIcon: Icon(Icons.calendar_today, size: 18)),
                      child: Text(_endDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(_endDate!)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.s16),
            Row(
              children: [
                Expanded(child: _buildTextField(_startTimeController, 'Start Time', hint: '08:00 AM')),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(_endTimeController, 'End Time', hint: '11:00 AM')),
              ],
            ),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(_capacityController, 'Maximum Participant Capacity', hint: 'e.g. 150', keyboardType: TextInputType.number),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaGalleryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Media & Photo Gallery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s24),
            _buildTextField(_galleryUrlsController, 'Gallery Image URLs (One per line)', hint: 'https://cfoundation.org/images/photo1.jpg\nhttps://cfoundation.org/images/photo2.jpg', maxLines: 4),
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
            const Text('Status & Registration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s16),
            _buildDropdown('Event Status', _selectedStatus, _statuses, (v) => setState(() => _selectedStatus = v!)),
            const SizedBox(height: AppSizes.s16),
            SwitchListTile(
              title: const Text('Registration Enabled', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('Allow public participants to register for this event.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              value: _isRegistrationEnabled,
              onChanged: (v) => setState(() => _isRegistrationEnabled = v),
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppColors.primary,
            ),
            const SizedBox(height: AppSizes.s24),
            PrimaryButton(
              onPressed: () => _handleSave('Upcoming'),
              backgroundColor: AppColors.success,
              label: 'Publish / Activate Event',
            ),
            const SizedBox(height: AppSizes.s12),
            SecondaryButton(
              onPressed: () => _handleSave('Draft'),
              label: 'Save Draft',
            ),
            const Divider(height: 32),
            if (widget.eventId != null) ...[
              TextButton.icon(
                onPressed: _showDeleteConfirmation,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Delete Event'),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
              const SizedBox(height: 8),
            ],
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    title: 'Discard Event Changes?',
                    confirmLabel: 'Discard',
                    confirmColor: AppColors.error,
                    onConfirm: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    content: const Text('Are you sure you want to discard unsaved event changes?'),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
              child: const Text('Cancel & Discard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {required String hint, bool isRequired = false, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
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
          keyboardType: keyboardType,
          validator: isRequired ? (v) => (v == null || v.isEmpty) ? 'This field is required' : null : null,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
    );
  }
}
