import 'package:chaturvyuha_foundation/staff/core/constants/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_sizes.dart';
import 'package:chaturvyuha_foundation/staff/core/responsive/responsive_layout.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/buttons.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/form_widgets.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/navigation_widgets.dart';
import 'package:chaturvyuha_foundation/staff/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime joinDate;
  final String status;

  MemberModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.joinDate,
    required this.status,
  });
}

class MembersView extends StatefulWidget {
  const MembersView({super.key});

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  final List<MemberModel> _members = [
    MemberModel(id: 'MEM-001', name: 'Rahul Verma', email: 'rahul.v@example.com', role: 'Premium Member', joinDate: DateTime(2023, 5, 12), status: 'Active'),
    MemberModel(id: 'MEM-002', name: 'Sarah Jenkins', email: 's.jenkins@test.org', role: 'Volunteer', joinDate: DateTime(2023, 8, 20), status: 'Active'),
    MemberModel(id: 'MEM-003', name: 'Amit Shah', email: 'amit@shah.in', role: 'Donor', joinDate: DateTime(2024, 1, 15), status: 'Active'),
    MemberModel(id: 'MEM-004', name: 'Priya Mani', email: 'p.mani@heritage.com', role: 'Student', joinDate: DateTime(2024, 2, 28), status: 'Pending'),
    MemberModel(id: 'MEM-005', name: 'David Wilson', email: 'david.w@university.edu', role: 'Researcher', joinDate: DateTime(2024, 3, 10), status: 'Active'),
    MemberModel(id: 'MEM-006', name: 'Elena Rossi', email: 'e.rossi@meditation.eu', role: 'Premium Member', joinDate: DateTime(2024, 4, 05), status: 'Inactive'),
  ];

  List<MemberModel> get _filteredMembers {
    if (_searchQuery.isEmpty) return _members;
    return _members.where((m) => 
      m.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
      m.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      m.id.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: AppSizes.s24),
        _buildFilterBar(),
        const SizedBox(height: AppSizes.s24),
        Expanded(child: _buildMainContent()),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Members Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text('Manage foundation members, volunteers, donors and staff profiles.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ],
        ),
        PrimaryButton(onPressed: () {}, icon: Icons.person_add_outlined, label: 'Add Member'),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SearchField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            hintText: 'Search by name, email or ID...',
          ),
        ),
        const SizedBox(width: 16),
        const Spacer(),
      ],
    );
  }

  Widget _buildMainContent() {
    final list = _filteredMembers;
    
    if (context.isMobile) {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => _buildMemberCard(list[index]),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(AppColors.background),
                columns: const [
                  DataColumn(label: Text('Member Name', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Joined Date', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: list.map((member) => DataRow(cells: [
                  DataCell(Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(member.email)),
                  DataCell(Text(member.role)),
                  DataCell(Text(DateFormat('MMM dd, yyyy').format(member.joinDate))),
                  DataCell(StatusBadge(
                    label: member.status,
                    type: member.status == 'Active' ? StatusType.success : (member.status == 'Pending' ? StatusType.warning : StatusType.error),
                  )),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () {}),
                      IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error), onPressed: () {}),
                    ],
                  )),
                ])).toList(),
              ),
            ),
          ),
          PaginationFooter(
            currentPage: 1,
            totalPages: 1,
            totalItems: 6,
            itemsPerPage: 10,
            onPrevious: () {},
            onNext: () {},
            itemLabel: 'members',
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(MemberModel member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${member.role} • ${member.email}'),
        trailing: StatusBadge(
          label: member.status,
          type: member.status == 'Active' ? StatusType.success : (member.status == 'Pending' ? StatusType.warning : StatusType.error),
        ),
      ),
    );
  }
}
