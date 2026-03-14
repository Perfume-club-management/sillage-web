import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_controller.dart';
import 'app_navigation.dart';

class AppShell extends ConsumerWidget {
  final String location;
  final Widget child;

  const AppShell({
    super.key,
    required this.location,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final items = navigationItemsForRole(auth.role);
    final currentItem = navigationItemForLocation(auth.role, location);
    final selectedIndex = items.indexOf(currentItem);
    final mobileItems = items.take(4).toList();
    final mobileIndex = mobileItems.indexWhere((item) => item.section == currentItem.section);
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentItem.label),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Chip(
                label: Text((auth.role ?? 'member').toUpperCase()),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: isMobile ? _AppDrawer(items: items, location: location) : null,
      body: Row(
        children: [
          if (!isMobile)
            NavigationRail(
              selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
              labelType: NavigationRailLabelType.all,
              onDestinationSelected: (index) => context.go(items[index].path),
              destinations: [
                for (final item in items)
                  NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label),
                  ),
              ],
            ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: mobileIndex < 0 ? 0 : mobileIndex,
              onTap: (index) => context.go(mobileItems[index].path),
              items: [
                for (final item in mobileItems)
                  BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    label: item.label,
                  ),
              ],
            )
          : null,
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final List<AppNavigationItem> items;
  final String location;

  const _AppDrawer({
    required this.items,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const ListTile(
              title: Text(
                'Perfume Club Service',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text('Core navigation'),
            ),
            for (final item in items)
              ListTile(
                selected: location == item.path || location.startsWith('${item.path}/'),
                leading: Icon(item.icon),
                title: Text(item.label),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(item.path);
                },
              ),
          ],
        ),
      ),
    );
  }
}
