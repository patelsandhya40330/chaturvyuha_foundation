import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class AdminTopbar extends StatefulWidget {
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onCollapseSidebar;

  const AdminTopbar({
    super.key,
    required this.showMenuButton,
    this.onMenuPressed,
    this.onSearch,
    this.onCollapseSidebar,
  });

  @override
  State<AdminTopbar> createState() => _AdminTopbarState();
}

class _AdminTopbarState extends State<AdminTopbar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppConstants.border),
        ),
      ),
      child: Row(
        children: [
          if (widget.showMenuButton)
            IconButton(
              tooltip: 'Open menu',
              onPressed: widget.onMenuPressed,
              icon: const Icon(Icons.menu_rounded),
            )
          else
            IconButton(
              tooltip: 'Collapse sidebar',
              onPressed: widget.onCollapseSidebar,
              icon: const Icon(Icons.menu_rounded),
            ),
          const SizedBox(width: 8),
          SizedBox(
            width: MediaQuery.sizeOf(context).width < 700 ? 170 : 330,
            child: TextField(
              controller: _controller,
              onChanged: widget.onSearch,
              decoration: const InputDecoration(
                hintText: 'Search anything...',
                prefixIcon: Icon(Icons.search_rounded, size: 19),
              ),
            ),
          ),
          const Spacer(),
          _NotificationButton(),
          const SizedBox(width: 8),
          const _ProfileButton(),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Notifications',
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications_none_rounded),
          Positioned(
            right: -1,
            top: -2,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppConstants.primaryRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
      onSelected: (_) {},
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: '1',
          child: Text('3 new notifications'),
        ),
        PopupMenuItem(
          value: '2',
          child: Text('Registration received'),
        ),
        PopupMenuItem(
          value: '3',
          child: Text('New message from Ram'),
        ),
      ],
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Profile menu',
      onSelected: (value) {
        if (value == 'logout') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dummy logout action')),
          );
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('My profile'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout_rounded),
            title: Text('Logout'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      child: const Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppConstants.primaryRed,
            child: Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Sitaram Rokka',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }
}
