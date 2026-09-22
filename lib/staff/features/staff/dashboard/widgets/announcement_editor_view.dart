import 'package:cfoundation/core/constants/app_colors.dart';
import 'package:cfoundation/core/constants/app_sizes.dart';
import 'package:cfoundation/core/responsive/responsive_layout.dart';
import 'package:cfoundation/core/utils/ui_utils.dart';
import 'package:cfoundation/features/staff/dashboard/widgets/announcements_list_view.dart';
import 'package:cfoundation/widgets/common/buttons.dart';
import 'package:cfoundation/widgets/common/dialogs.dart';
import 'package:cfoundation/widgets/common/navigation_widgets.dart';
import 'package:cfoundation/widgets/common/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnnouncementEditorView extends StatefulWidget {
  final String? announcementId;

  const AnnouncementEditorView({super.key, this.announcementId});

  @override
  State<AnnouncementEditorView> createState() => _AnnouncementEditorViewState();
}

class _AnnouncementEditorViewState extends State<AnnouncementEditorView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  // State
  bool _isLoading = false;
  AnnouncementPriority _selectedPriority = AnnouncementPriority.medium;
  String _selectedStatus = 'Draft';
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime? _expiryDate;
  TimeOfDay? _expiryTime;

  final List<String> _statuses = ['Draft', 'Published', 'Scheduled', 'Expired'];

  @override
  void initState() {
    super.initState();
    if (widget.announcementId != null) {
      _loadMockData();
    }
  }

  void _loadMockData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _titleController.text = 'System Maintenance Scheduled';
        _contentController.text = 'The staff portal will be down for maintenance on Sunday from 2 AM to 4 AM UTC.';
        _selectedPriority = AnnouncementPriority.high;
        _selectedStatus = 'Published';
        _startDate = DateTime.now().subtract(const Duration(days: 1));
        _startTime = TimeOfDay.fromDateTime(_startDate);
        _expiryDate = DateTime.now().add(const Duration(days: 2));
        _expiryTime = TimeOfDay.fromDateTime(_expiryDate!);
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : (_expiryDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _expiryDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : (_expiryTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _expiryTime = picked;
        }
      });
    }
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() => _isLoading = false);
        UIUtils.showSuccessMessage(context, 'Announcement saved successfully!');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: LoadingState(message: 'Loading Announcement...'));

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
              mobile: _buildFormFields(),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildFormFields()),
                  const SizedBox(width: AppSizes.s24),
                  Expanded(flex: 1, child: _buildSidebar()),
                ],
              ),
            ),
            if (ResponsiveLayout.isMobile(context)) ...[
              const SizedBox(height: AppSizes.s24),
              _buildSidebar(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isEdit = widget.announcementId != null;
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Announcements',
        ),
        const SizedBox(width: AppSizes.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Breadcrumb(
                items: [
                  BreadcrumbItem(label: 'Announcements', onTap: () => Navigator.pop(context)),
                  BreadcrumbItem(label: isEdit ? 'Edit Announcement' : 'New Announcement'),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isEdit ? 'Edit Announcement' : 'Create Announcement',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('General Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildTextField(_titleController, 'Announcement Title', hint: 'e.g. Scheduled Maintenance', isRequired: true),
            const SizedBox(height: 20),
            _buildTextField(_contentController, 'Content', hint: 'Describe the announcement in detail...', maxLines: 6, isRequired: true),
            const SizedBox(height: 24),
            const Text('Schedule & Timing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Builder(
              builder: (context) {
                final isMobile = ResponsiveLayout.isMobile(context);
                if (isMobile) {
                  return Column(
                    children: [
                      _buildDateTimePicker('Start Date', _startDate, _startTime, true),
                      const SizedBox(height: 16),
                      _buildDateTimePicker('Expiry Date (Optional)', _expiryDate, _expiryTime, false),
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: _buildDateTimePicker('Start Date', _startDate, _startTime, true),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateTimePicker('Expiry Date (Optional)', _expiryDate, _expiryTime, false),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _buildPrioritySelector(),
                const SizedBox(height: 20),
                _buildStatusDropdown(),
                const SizedBox(height: 32),
                PrimaryButton(
                  onPressed: _handleSave,
                  label: 'Save Announcement',
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  onPressed: () => Navigator.pop(context),
                  label: 'Cancel',
                  foregroundColor: AppColors.textSecondary,
                ),
                const Divider(height: 48),
                TextButton.icon(
                  onPressed: () {
                    if (widget.announcementId != null) {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                          title: 'Delete Announcement?',
                          confirmLabel: 'Delete',
                          confirmColor: AppColors.error,
                          onConfirm: () {
                            Navigator.pop(context); // Pop dialog
                            Navigator.pop(context); // Pop editor
                          },
                          content: const Text('Are you sure you want to delete this announcement?'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Delete Announcement'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {String? hint, bool isRequired = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: isRequired ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Priority Level', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: AnnouncementPriority.values.map((p) {
            final isSelected = _selectedPriority == p;
            Color color = AppColors.info;
            if (p == AnnouncementPriority.high) color = AppColors.error;
            if (p == AnnouncementPriority.medium) color = AppColors.warning;

            return ChoiceChip(
              label: Text(p.name.toUpperCase()),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedPriority = p),
              selectedColor: color.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Publish Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => setState(() => _selectedStatus = v!),
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(String label, DateTime? date, TimeOfDay? time, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context, isStart),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  date != null ? DateFormat('yyyy-MM-dd').format(date) : 'Pick Date',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context, isStart),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  time != null ? time.format(context) : 'Pick Time',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
