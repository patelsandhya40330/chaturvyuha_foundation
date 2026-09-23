import 'package:chaturvyuha_foundation/staff/core/auth/permission_service.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/core/constants/app_sizes.dart';
import 'package:chaturvyuha_foundation/staff/core/responsive/responsive_layout.dart';
import 'package:chaturvyuha_foundation/staff/widgets/common/form_widgets.dart';
import 'package:chaturvyuha_foundation/staff/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MessagePriority { low, medium, high }
enum MessageStatus { newMsg, inProgress, resolved }

class MessageThreadItem {
  final String author;
  final String content;
  final DateTime timestamp;
  final bool isInternal;

  MessageThreadItem({
    required this.author,
    required this.content,
    required this.timestamp,
    required this.isInternal,
  });
}

class MessageModel {
  final String id;
  final String sender;
  final String email;
  final String subject;
  final DateTime date;
  MessageStatus status;
  final MessagePriority priority;
  bool isRead;
  final List<MessageThreadItem> thread;

  MessageModel({
    required this.id,
    required this.sender,
    required this.email,
    required this.subject,
    required this.date,
    required this.status,
    required this.priority,
    this.isRead = false,
    required this.thread,
  });
}

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _searchQuery = '';
  String _selectedStatus = 'All';
  MessageModel? _selectedMessage;
  
  late List<MessageModel> _messages;

  @override
  void initState() {
    super.initState();
    _resetMockData();
  }

  void _resetMockData() {
    final now = DateTime.now();
    _messages = [
      MessageModel(
        id: 'MSG-001',
        sender: 'Rahul Verma',
        email: 'rahul.v@example.com',
        subject: 'Inquiry about Vedic Course Certification',
        date: now.subtract(const Duration(hours: 2)),
        status: MessageStatus.newMsg,
        priority: MessagePriority.high,
        isRead: false,
        thread: [
          MessageThreadItem(
            author: 'Rahul Verma',
            content: 'Namaste, I am interested in the Vedic Philosophy 101 course. Do I get a certificate upon completion?',
            timestamp: now.subtract(const Duration(hours: 2)),
            isInternal: false,
          ),
        ],
      ),
      MessageModel(
        id: 'MSG-002',
        sender: 'Sarah Jenkins',
        email: 's.jenkins@test.org',
        subject: 'Volunteer Application - Digital Media',
        date: now.subtract(const Duration(days: 1)),
        status: MessageStatus.inProgress,
        priority: MessagePriority.medium,
        isRead: true,
        thread: [
          MessageThreadItem(
            author: 'Sarah Jenkins',
            content: 'Hello, I would like to volunteer for the digital media team. I have 5 years of experience in video editing.',
            timestamp: now.subtract(const Duration(days: 1)),
            isInternal: false,
          ),
          MessageThreadItem(
            author: 'Acharya Dev',
            content: 'Assigning to Manning D. for portfolio review.',
            timestamp: now.subtract(const Duration(hours: 5)),
            isInternal: true,
          ),
        ],
      ),
      MessageModel(
        id: 'MSG-003',
        sender: 'Amit Shah',
        email: 'amit@shah.in',
        subject: 'Donation Receipt Request',
        date: now.subtract(const Duration(days: 3)),
        status: MessageStatus.resolved,
        priority: MessagePriority.low,
        isRead: true,
        thread: [
          MessageThreadItem(
            author: 'Amit Shah',
            content: 'I made a donation last week but haven\'t received the 80G receipt yet.',
            timestamp: now.subtract(const Duration(days: 3)),
            isInternal: false,
          ),
          MessageThreadItem(
            author: 'Admin User',
            content: 'Sent receipt via email on Oct 10.',
            timestamp: now.subtract(const Duration(days: 1)),
            isInternal: false,
          ),
        ],
      ),
      MessageModel(
        id: 'MSG-004',
        sender: 'Priya Mani',
        email: 'p.mani@heritage.com',
        subject: 'Manuscript Scanning Partnership',
        date: now.subtract(const Duration(hours: 4)),
        status: MessageStatus.newMsg,
        priority: MessagePriority.medium,
        isRead: false,
        thread: [
          MessageThreadItem(
            author: 'Priya Mani',
            content: 'We have a collection of palm leaf manuscripts that need digitization. Would Chaturvyuha be interested in a partnership?',
            timestamp: now.subtract(const Duration(hours: 4)),
            isInternal: false,
          ),
        ],
      ),
      MessageModel(
        id: 'MSG-005',
        sender: 'David Wilson',
        email: 'david.w@university.edu',
        subject: 'Research Citation Query',
        date: now.subtract(const Duration(days: 2)),
        status: MessageStatus.inProgress,
        priority: MessagePriority.low,
        isRead: true,
        thread: [
          MessageThreadItem(
            author: 'David Wilson',
            content: 'I am citing the "Vedic Studies" article in my thesis. Could you provide the exact publication date?',
            timestamp: now.subtract(const Duration(days: 2)),
            isInternal: false,
          ),
          MessageThreadItem(
            author: 'Admin User',
            content: 'Checking archives for the specific revision date.',
            timestamp: now.subtract(const Duration(days: 1)),
            isInternal: true,
          ),
        ],
      ),
      MessageModel(
        id: 'MSG-006',
        sender: 'Karthik Raja',
        email: 'k.raja@outlook.com',
        subject: 'Sanskrit Grammar App Bug Report',
        date: now.subtract(const Duration(hours: 12)),
        status: MessageStatus.newMsg,
        priority: MessagePriority.high,
        isRead: false,
        thread: [
          MessageThreadItem(
            author: 'Karthik Raja',
            content: 'The quiz section in the Sanskrit app crashes when I select "Verb Roots". Please fix this ASAP.',
            timestamp: now.subtract(const Duration(hours: 12)),
            isInternal: false,
          ),
        ],
      ),
      MessageModel(
        id: 'MSG-007',
        sender: 'Elena Rossi',
        email: 'e.rossi@meditation.eu',
        subject: 'Yoga Workshop Booking - Group of 10',
        date: now.subtract(const Duration(days: 4)),
        status: MessageStatus.resolved,
        priority: MessagePriority.medium,
        isRead: true,
        thread: [
          MessageThreadItem(
            author: 'Elena Rossi',
            content: 'We are a group of 10 practitioners from Italy. Do you have availability for a private workshop in December?',
            timestamp: now.subtract(const Duration(days: 4)),
            isInternal: false,
          ),
          MessageThreadItem(
            author: 'Acharya Dev',
            content: 'Confirmed availability for Dec 15-20. Sending invoice now.',
            timestamp: now.subtract(const Duration(days: 2)),
            isInternal: false,
          ),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _replyController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<MessageModel> get _filteredMessages {
    return _messages.where((msg) {
      final matchesSearch = msg.sender.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          msg.subject.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final String statusStr = _getStatusLabel(msg.status);
      final matchesStatus = _selectedStatus == 'All' || statusStr == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  String _getStatusLabel(MessageStatus status) {
    switch (status) {
      case MessageStatus.newMsg: return 'New';
      case MessageStatus.inProgress: return 'In Progress';
      case MessageStatus.resolved: return 'Resolved';
    }
  }

  StatusType _getStatusBadgeType(MessageStatus status) {
    switch (status) {
      case MessageStatus.newMsg: return StatusType.error;
      case MessageStatus.inProgress: return StatusType.warning;
      case MessageStatus.resolved: return StatusType.success;
    }
  }

  void _handleReply() {
    if (_replyController.text.isEmpty) return;
    
    setState(() {
      _selectedMessage!.thread.add(MessageThreadItem(
        author: 'Acharya Dev',
        content: _replyController.text,
        timestamp: DateTime.now(),
        isInternal: false,
      ));
      _selectedMessage!.status = MessageStatus.inProgress;
      _replyController.clear();
    });
  }

  void _handleInternalNote() {
    if (_noteController.text.isEmpty) return;
    
    setState(() {
      _selectedMessage!.thread.add(MessageThreadItem(
        author: 'Acharya Dev',
        content: _noteController.text,
        timestamp: DateTime.now(),
        isInternal: true,
      ));
      _noteController.clear();
    });
  }

  void _markAsResolved() {
    setState(() {
      _selectedMessage!.status = MessageStatus.resolved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = context.isDesktop;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppSizes.s24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message List
                Expanded(
                  flex: isDesktop ? 2 : 1,
                  child: _buildMessageList(),
                ),
                // Message Detail (Desktop only, mobile handles via full screen overlay)
                if (isDesktop && _selectedMessage != null) ...[
                  const SizedBox(width: AppSizes.s24),
                  Expanded(
                    flex: 3,
                    child: _buildMessageDetail(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Messages & Inquiries',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        SizedBox(height: 4),
        Text(
          'Manage community inquiries, volunteer applications, and support tickets.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SearchField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  hintText: 'Search messages...',
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatusChip('All'),
                      _buildStatusChip('New'),
                      _buildStatusChip('In Progress'),
                      _buildStatusChip('Resolved'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredMessages.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final msg = _filteredMessages[index];
                final bool isSelected = _selectedMessage?.id == msg.id;
                
                return ListTile(
                  onTap: () {
                    setState(() {
                      _selectedMessage = msg;
                      msg.isRead = true;
                    });
                    if (!context.isDesktop) {
                      _showMobileDetail();
                    }
                  },
                  selected: isSelected,
                  selectedTileColor: AppColors.primary.withOpacity(0.05),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Row(
                    children: [
                      if (!msg.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        ),
                      Expanded(
                        child: Text(
                          msg.sender,
                          style: TextStyle(
                            fontWeight: msg.isRead ? FontWeight.w500 : FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd').format(msg.date),
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        msg.subject,
                        style: const TextStyle(fontSize: 13, color: AppColors.textBody),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          StatusBadge(
                            label: _getStatusLabel(msg.status),
                            type: _getStatusBadgeType(msg.status),
                          ),
                          const SizedBox(width: 8),
                          _buildPriorityIndicator(msg.priority),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    final bool isSelected = _selectedStatus == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: isSelected,
        onSelected: (val) => setState(() => _selectedStatus = label),
        selectedColor: AppColors.primary.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(MessagePriority priority) {
    Color color = AppColors.info;
    if (priority == MessagePriority.high) color = AppColors.error;
    if (priority == MessagePriority.medium) color = AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showMobileDetail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Message Thread'),
          actions: [
            if (_selectedMessage?.status != MessageStatus.resolved)
              TextButton(
                onPressed: () {
                  _markAsResolved();
                  Navigator.pop(context);
                },
                child: const Text('Resolve'),
              ),
          ],
        ),
        body: _buildMessageDetail(),
      ),
    );
  }

  Widget _buildMessageDetail() {
    final msg = _selectedMessage;
    if (msg == null) return const Center(child: Text('Select a message to view thread'));

    return Card(
      child: Column(
        children: [
          _buildDetailHeader(msg),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: msg.thread.length,
              itemBuilder: (context, index) {
                final item = msg.thread[index];
                return _buildThreadItem(item);
              },
            ),
          ),
          const Divider(height: 1),
          _buildActionTabs(),
        ],
      ),
    );
  }

  Widget _buildDetailHeader(MessageModel msg) {
    return Padding(
      padding: EdgeInsets.all(context.responsive(mobile: 16, desktop: 24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: context.responsive(mobile: 20, desktop: 24),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(msg.sender[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(msg.sender, style: TextStyle(fontSize: context.responsive(mobile: 16, desktop: 18), fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(msg.email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(DateFormat('MMM dd').format(msg.date), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  StatusBadge(label: _getStatusLabel(msg.status), type: _getStatusBadgeType(msg.status)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(msg.subject, style: TextStyle(fontSize: context.responsive(mobile: 18, desktop: 20), fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildThreadItem(MessageThreadItem item) {
    final bool isMobile = context.isMobile;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: item.isInternal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (item.isInternal)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade200),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lock_outline, size: 14, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text('INTERNAL NOTE • ${item.author}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.amber)),
                      const Spacer(),
                      Text(DateFormat('HH:mm').format(item.timestamp), style: TextStyle(fontSize: 10, color: Colors.amber.shade700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(item.content, style: const TextStyle(fontSize: 13, color: AppColors.textBody)),
                ],
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: isMobile ? 14 : 16,
                  backgroundColor: item.author == 'Acharya Dev' ? AppColors.primary : AppColors.secondary.withOpacity(0.2),
                  child: Text(item.author[0], style: TextStyle(color: item.author == 'Acharya Dev' ? Colors.white : AppColors.secondary, fontSize: isMobile ? 10 : 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(item.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 8),
                          Text(DateFormat('HH:mm').format(item.timestamp), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(item.content, style: TextStyle(fontSize: isMobile ? 13 : 14, height: 1.5, color: AppColors.textBody)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionTabs() {
    if (!PermissionService.hasPermission(AppPermissions.messagesReply)) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text('You do not have permission to reply to messages.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontStyle: FontStyle.italic)),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Public Reply'),
              Tab(text: 'Internal Note'),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
          ),
          SizedBox(
            height: 180,
            child: TabBarView(
              children: [
                _buildReplyInput(isInternal: false),
                _buildReplyInput(isInternal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput({required bool isInternal}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: isInternal ? _noteController : _replyController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: isInternal ? 'Add a private note for other staff members...' : 'Type your reply to the sender...',
                fillColor: isInternal ? Colors.amber.shade50.withOpacity(0.3) : AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  borderSide: BorderSide(color: isInternal ? Colors.amber.shade200 : AppColors.border),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isInternal && _selectedMessage?.status != MessageStatus.resolved && PermissionService.hasPermission(AppPermissions.messagesResolve))
                OutlinedButton(
                  onPressed: _markAsResolved,
                  child: const Text('Resolve Inquiry'),
                ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: isInternal ? _handleInternalNote : _handleReply,
                icon: Icon(isInternal ? Icons.lock_outline : Icons.send, size: 16),
                label: Text(isInternal ? 'Add Note' : 'Send Reply'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInternal ? Colors.amber.shade700 : AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
