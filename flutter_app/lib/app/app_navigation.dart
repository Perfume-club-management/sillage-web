import 'package:flutter/material.dart';

enum AppSection {
  dashboard,
  notices,
  calendar,
  recruitment,
  club,
  members,
  activities,
  inventory,
  finance,
  myPage,
}

class AppNavigationItem {
  final AppSection section;
  final String label;
  final String path;
  final IconData icon;
  final Set<String> roles;

  const AppNavigationItem({
    required this.section,
    required this.label,
    required this.path,
    required this.icon,
    required this.roles,
  });
}

const appNavigationItems = <AppNavigationItem>[
  AppNavigationItem(
    section: AppSection.dashboard,
    label: 'Dashboard',
    path: '/app/dashboard',
    icon: Icons.dashboard_outlined,
    roles: {'admin', 'officer', 'member'},
  ),
  AppNavigationItem(
    section: AppSection.notices,
    label: 'Notices',
    path: '/app/notices',
    icon: Icons.notifications_none,
    roles: {'admin', 'officer', 'member'},
  ),
  AppNavigationItem(
    section: AppSection.calendar,
    label: 'Calendar',
    path: '/app/calendar',
    icon: Icons.calendar_month_outlined,
    roles: {'admin', 'officer', 'member'},
  ),
  AppNavigationItem(
    section: AppSection.recruitment,
    label: 'Recruitment',
    path: '/app/recruitment',
    icon: Icons.how_to_reg_outlined,
    roles: {'admin', 'officer'},
  ),
  AppNavigationItem(
    section: AppSection.club,
    label: 'Club Ops',
    path: '/app/club',
    icon: Icons.apartment_outlined,
    roles: {'admin', 'officer'},
  ),
  AppNavigationItem(
    section: AppSection.members,
    label: 'Members',
    path: '/app/members',
    icon: Icons.groups_outlined,
    roles: {'admin', 'officer'},
  ),
  AppNavigationItem(
    section: AppSection.activities,
    label: 'Activities',
    path: '/app/activities',
    icon: Icons.event_note_outlined,
    roles: {'admin', 'officer', 'member'},
  ),
  AppNavigationItem(
    section: AppSection.inventory,
    label: 'Inventory',
    path: '/app/inventory',
    icon: Icons.inventory_2_outlined,
    roles: {'admin', 'officer'},
  ),
  AppNavigationItem(
    section: AppSection.finance,
    label: 'Finance',
    path: '/app/finance',
    icon: Icons.receipt_long_outlined,
    roles: {'admin', 'officer'},
  ),
  AppNavigationItem(
    section: AppSection.myPage,
    label: 'My Page',
    path: '/app/my-page',
    icon: Icons.person_outline,
    roles: {'admin', 'officer', 'member'},
  ),
];

List<AppNavigationItem> navigationItemsForRole(String? role) {
  final normalizedRole = role ?? 'member';
  return appNavigationItems.where((item) => item.roles.contains(normalizedRole)).toList();
}

String defaultPathForRole(String? role) {
  final items = navigationItemsForRole(role);
  return items.isEmpty ? '/login' : items.first.path;
}

bool canAccessLocation(String? role, String location) {
  final items = navigationItemsForRole(role);
  return items.any((item) => location == item.path || location.startsWith('${item.path}/'));
}

AppNavigationItem navigationItemForLocation(String? role, String location) {
  final items = navigationItemsForRole(role);
  return items.firstWhere(
    (item) => location == item.path || location.startsWith('${item.path}/'),
    orElse: () => items.first,
  );
}
