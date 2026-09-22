import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/core/utils/ui_utils.dart';
import 'package:cfoundation/widgets/common/buttons.dart';
import 'package:cfoundation/widgets/common/dialogs.dart';
import 'package:cfoundation/widgets/common/navigation_widgets.dart';
import 'package:cfoundation/widgets/common/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgramEditorView extends StatefulWidget {
  final String? programId;

  const ProgramEditorView({super.key, this.programId});

  @override
  State<ProgramEditorView> createState() => _ProgramEditorViewState();
}

class _ProgramEditorViewState extends State<ProgramEditorView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instructorController = TextEditingController();
  final _scheduleController = TextEditingController();
  final _locationController = TextEditingController();
  final _startTimeController = TextEditingController(text: '10:00 AM');
  final _endTimeController = TextEditingController(text: '11:30 AM');
  final _capacityController = TextEditingController(text: '50');
  final _resourcesController = TextEditingController();

  // Dates & State
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isRegistrationOpen = true;
  String _selectedStatus = 'Draft';
  String _selectedType = 'Vedic Literature';

  final List<String> _types = [
    'Vedic Literature',
    'Meditation & Yoga',
    'Sanskrit Language',
    'Youth Heritage',
    'Community Seva',
  ];
  final List<String> _statuses = ['Draft', 'Active', 'Inactive', 'Completed'];

  @override
  void initState() {
    super.initState();
    if (widget.programId != null) {
      _loadMockData();
    } else {
      _startDate = DateTime.now().add(const Duration(days: 7));
      _endDate = DateTime.now().add(const Duration(days: 90));
    }
  }

  void _loadMockData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _titleController.text = 'Vedic Philosophy 101 Foundations';
        _descriptionController.text = 'An introductory course exploring the foundational principles of Vedic thought and scriptural hermeneutics.';
        _instructorController.text = 'Acharya Sharma';
        _scheduleController.text = 'Mon, Wed • 10:00 AM - 11:30 AM';
        _locationController.text = 'Main Ashram Hall';
        _startTimeController.text = '10:00 AM';
        _endTimeController.text = '11:30 AM';
        _capacityController.text = '50';
        _resourcesController.text = 'Vedic Grammar Guide, Audio Chants, Manuscript Notes';
        _selectedType = 'Vedic Literature';
        _selectedStatus = 'Active';
        _isRegistrationOpen = true;
        _startDate = DateTime(2024, 2, 1);
        _endDate = DateTime(2024, 5, 30);
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _instructorController.dispose();
    _scheduleController.dispose();
    _locationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _capacityController.dispose();
    _resourcesController.dispose();
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
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
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
        UIUtils.showSuccessMessage(context, 'Program saved successfully as $targetStatus!');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: LoadingState(message: 'Loading Program Details...'));
    if (_hasError) {
      return Scaffold(
        body: ErrorState(
          message: 'Error loading program details.',
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
    final isEdit = widget.programId != null;
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Programs',
        ),
        const SizedBox(width: AppSizes.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Breadcrumb(
                items: [
                  BreadcrumbItem(label: 'Programs', onTap: () => Navigator.pop(context)),
                  BreadcrumbItem(label: isEdit ? 'Edit Program' : 'New Program'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isEdit ? 'Edit Program' : 'Create Program',
                style: TextStyle(
                  fontSize: context.responsive<double>(mobile: 20, tablet: 22, desktop: 24),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                isEdit ? 'Refine course details, capacity, and schedule.' : 'Setup a new educational program or heritage workshop.',
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
              _buildScheduleCard(),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.s24),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildPublishingCard(),
              const SizedBox(height: AppSizes.s24),
              _buildCapacityCard(),
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
        _buildScheduleCard(),
        const SizedBox(height: AppSizes.s24),
        _buildCapacityCard(),
        const SizedBox(height: AppSizes.s24),
        _buildPublishingCard(),
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
            const Text('General Program Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s24),
            _buildTextField(_titleController, 'Program Title', hint: 'e.g. Sanskrit Grammar Foundations', isRequired: true),
            const SizedBox(height: AppSizes.s16),
            _buildDropdown('Program Type', _selectedType, _types, (v) => setState(() => _selectedType = v!)),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(_descriptionController, 'Program Description', hint: 'Detailed overview of topics covered...', maxLines: 4, isRequired: true),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(_instructorController, 'Instructor Name', hint: 'e.g. Acharya Sharma', isRequired: true),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Schedule & Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s24),
            _buildTextField(_scheduleController, 'Schedule Summary', hint: 'e.g. Mon, Wed • 10:00 AM - 11:30 AM', isRequired: true),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(_locationController, 'Location / Venue', hint: 'e.g. Main Ashram Hall / Virtual Workspace', isRequired: true),
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
                Expanded(child: _buildTextField(_startTimeController, 'Start Time', hint: '10:00 AM')),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(_endTimeController, 'End Time', hint: '11:30 AM')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Capacity & Resources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s24),
            _buildTextField(_capacityController, 'Maximum Capacity / Participants', hint: 'e.g. 50', keyboardType: TextInputType.number),
            const SizedBox(height: AppSizes.s16),
            _buildTextField(_resourcesController, 'Resources / Study Material', hint: 'e.g. Grammar Cards, Audio Chants, Manuscript Notes', maxLines: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildPublishingCard() {
    return Card(
      color: AppColors.primary.withOpacity(0.01),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Status & Availability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.s16),
            _buildDropdown('Program Status', _selectedStatus, _statuses, (v) => setState(() => _selectedStatus = v!)),
            const SizedBox(height: AppSizes.s16),
            SwitchListTile(
              title: const Text('Open for Registration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text('Allow public participants to register.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              value: _isRegistrationOpen,
              onChanged: (v) => setState(() => _isRegistrationOpen = v),
              contentPadding: EdgeInsets.zero,
              activeThumbColor: AppColors.primary,
            ),
            const SizedBox(height: AppSizes.s24),
            PrimaryButton(
              onPressed: () => _handleSave('Active'),
              backgroundColor: AppColors.success,
              label: 'Save & Activate Program',
            ),
            const SizedBox(height: AppSizes.s12),
            SecondaryButton(
              onPressed: () => _handleSave('Draft'),
              label: 'Save as Draft',
            ),
            const Divider(height: 32),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ConfirmationDialog(
                    title: 'Discard Program Changes?',
                    confirmLabel: 'Discard',
                    confirmColor: AppColors.error,
                    onConfirm: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    content: const Text('Are you sure you want to discard unsaved program changes?'),
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
