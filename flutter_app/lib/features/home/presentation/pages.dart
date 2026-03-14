import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_navigation.dart';
import '../../../app/section_page.dart';
import '../../auth/application/auth_controller.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final role = auth.role ?? 'member';
    final isMobile = MediaQuery.of(context).size.width < 900;

    final quickActions = [
      _HomeActionData(
        title: 'Notice Board',
        subtitle: 'Announcements and read tracking',
        icon: Icons.notifications_none,
        path: '/app/notices',
      ),
      _HomeActionData(
        title: 'Calendar',
        subtitle: 'Schedules and plans',
        icon: Icons.calendar_month_outlined,
        path: '/app/calendar',
      ),
      if (role != 'member')
        _HomeActionData(
          title: 'Recruitment',
          subtitle: 'Posts and applicants',
          icon: Icons.how_to_reg_outlined,
          path: '/app/recruitment',
        ),
      if (role != 'member')
        _HomeActionData(
          title: 'Members',
          subtitle: 'Profiles and roles',
          icon: Icons.groups_outlined,
          path: '/app/members',
        ),
    ];

    final managementLinks = [
      _HomeLinkData(
        title: 'Club Operations',
        path: '/app/club',
        icon: Icons.apartment_outlined,
      ),
      _HomeLinkData(
        title: 'Activities',
        path: '/app/activities',
        icon: Icons.event_note_outlined,
      ),
      if (role != 'member')
        _HomeLinkData(
          title: 'Inventory',
          path: '/app/inventory',
          icon: Icons.inventory_2_outlined,
        ),
      if (role != 'member')
        _HomeLinkData(
          title: 'Finance',
          path: '/app/finance',
          icon: Icons.receipt_long_outlined,
        ),
    ];

    final flowLinks = navigationItemsForRole(role)
        .where((item) => item.section != AppSection.dashboard)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Home',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  if (isMobile)
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.menu),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Icon(Icons.spa_outlined, size: 44),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.role == 'admin'
                                  ? 'Administrator'
                                  : auth.role == 'officer'
                                      ? 'Officer'
                                      : 'Member',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Perfume club service home. Use the widgets below to move through the flow-based sub pages.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    children: [
                      const Icon(Icons.stars_outlined),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Current access scope',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        role.toUpperCase(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                itemCount: quickActions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  final item = quickActions[index];
                  return _QuickActionCard(data: item);
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Operational Sections',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                itemCount: managementLinks.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                ),
                itemBuilder: (context, index) {
                  final item = managementLinks[index];
                  return _ManagementCard(data: item);
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Flow-linked Pages',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    for (var i = 0; i < flowLinks.length; i++) ...[
                      ListTile(
                        leading: Icon(flowLinks[i].icon),
                        title: Text(flowLinks[i].label),
                        subtitle: Text('Route: ${flowLinks[i].path}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go(flowLinks[i].path),
                      ),
                      if (i != flowLinks.length - 1) const Divider(height: 1),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPage(
      title: 'Notices',
      description: 'Notice board for announcements, role-specific delivery, and publish state.',
      children: [
        SummaryCards(
          cards: [
            SummaryCardData(label: 'Pinned', value: '2', caption: 'Top notices displayed first'),
            SummaryCardData(label: 'Unread', value: '4', caption: 'Unread items for current user'),
            SummaryCardData(label: 'Drafts', value: '3', caption: 'Officer/admin working drafts'),
          ],
        ),
        SizedBox(height: 20),
        ContentSection(
          title: 'API Flow',
          subtitle: 'Expected backend use for notice board',
          children: [
            ListTile(title: Text('GET /notices'), subtitle: Text('Fetch paged notice list')),
            ListTile(title: Text('GET /notices/:id'), subtitle: Text('Fetch detail and attachments')),
            ListTile(title: Text('POST /notices'), subtitle: Text('Create new notice')),
            ListTile(title: Text('POST /notices/:id/read'), subtitle: Text('Track read state for current user')),
          ],
        ),
      ],
    );
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPage(
      title: 'Calendar',
      description: 'Monthly and weekly schedule view for club plans, meetings, and event execution.',
      children: [
        SummaryCards(
          cards: [
            SummaryCardData(label: 'This Week', value: '3', caption: 'Events scheduled this week'),
            SummaryCardData(label: 'This Month', value: '11', caption: 'Planned calendar entries'),
            SummaryCardData(label: 'Conflicts', value: '1', caption: 'Detected overlapping sessions'),
          ],
        ),
        SizedBox(height: 20),
        ContentSection(
          title: 'Sample Schedule',
          subtitle: 'Implementation-first list structure before a full calendar widget',
          children: [
            ListTile(title: Text('Club orientation'), subtitle: Text('Mon 19:00 - Main hall')),
            ListTile(title: Text('Executive meeting'), subtitle: Text('Wed 18:30 - Room B102')),
            ListTile(title: Text('Perfume workshop'), subtitle: Text('Sat 14:00 - Lab room')),
          ],
        ),
      ],
    );
  }
}

class RecruitmentPage extends StatelessWidget {
  const RecruitmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPage(
      title: 'Recruitment',
      description: 'Manage recruitment posts, applications, interview stages, and decisions.',
      children: [
        SummaryCards(
          cards: [
            SummaryCardData(label: 'Open Posts', value: '1', caption: 'Active recruitment campaigns'),
            SummaryCardData(label: 'Applicants', value: '18', caption: 'Submitted application count'),
            SummaryCardData(label: 'Interviews', value: '6', caption: 'Pending interview-stage reviews'),
          ],
        ),
        SizedBox(height: 20),
        ContentSection(
          title: 'Workflow',
          subtitle: 'Post -> Application -> Review -> Interview -> Decision',
          children: [
            ListTile(title: Text('Create recruitment notice'), subtitle: Text('Configure dates, questions, and target groups')),
            ListTile(title: Text('Review applications'), subtitle: Text('Filter by status and score')),
            ListTile(title: Text('Track interview results'), subtitle: Text('Store comments, score, and final decision')),
          ],
        ),
      ],
    );
  }
}

class ClubManagementPage extends StatelessWidget {
  const ClubManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPage(
      title: 'Club Operations',
      description: 'Operational pages for internal management, approvals, and coordination.',
      children: [
        SummaryCards(
          cards: [
            SummaryCardData(label: 'Open Requests', value: '5', caption: 'Pending operation or approval tasks'),
            SummaryCardData(label: 'Policies', value: '8', caption: 'Operational rules and templates'),
            SummaryCardData(label: 'Shared Docs', value: '13', caption: 'Linked outputs and attachments'),
          ],
        ),
        SizedBox(height: 20),
        ContentSection(
          title: 'Core modules',
          subtitle: 'Maps to the club-management area from the flow document',
          children: [
            ListTile(title: Text('Internal approval queue'), subtitle: Text('Approve or reject club operation items')),
            ListTile(title: Text('Document output'), subtitle: Text('Generate report and export-ready records')),
            ListTile(title: Text('Shared operation history'), subtitle: Text('Track changes with audit logs')),
          ],
        ),
      ],
    );
  }
}

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPage(
      title: 'Members',
      description: 'Member list, status management, role assignment, and onboarding/offboarding.',
      children: [
        SummaryCards(
          cards: [
            SummaryCardData(label: 'Active Members', value: '34', caption: 'Current active profile count'),
            SummaryCardData(label: 'Officers', value: '6', caption: 'Current executive members'),
            SummaryCardData(label: 'Leave Requests', value: '2', caption: 'Pending profile-state changes'),
          ],
        ),
        SizedBox(height: 20),
        ContentSection(
          title: 'Member management actions',
          subtitle: 'Profile CRUD and role flow for PostgreSQL-backed pages',
          children: [
            ListTile(title: Text('Search member'), subtitle: Text('Email, student number, department, phone')),
            ListTile(title: Text('Assign role'), subtitle: Text('Admin, officer, or member role mapping')),
            ListTile(title: Text('Change status'), subtitle: Text('Active, inactive, alumni, leave requested')),
          ],
        ),
      ],
    );
  }
}

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPage(
      title: 'Activities',
      description: 'Plan and archive activity records, participation, and result outputs.',
      children: [
        SummaryCards(
          cards: [
            SummaryCardData(label: 'Templates', value: '12', caption: 'Activity categories from the flow design'),
            SummaryCardData(label: 'Active Records', value: '9', caption: 'Activity records in progress'),
            SummaryCardData(label: 'Reports Due', value: '3', caption: 'Records waiting for final output'),
          ],
        ),
        SizedBox(height: 20),
        ContentSection(
          title: 'Activity categories',
          subtitle: 'Minimal implementation for the core categories from requirements',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Meeting')),
                Chip(label: Text('Seminar')),
                Chip(label: Text('Project')),
                Chip(label: Text('Workshop')),
                Chip(label: Text('Mentoring')),
                Chip(label: Text('MT')),
                Chip(label: Text('Internal event')),
                Chip(label: Text('External exchange')),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPage(
      title: 'Finance',
      description: 'Track income, expenses, approvals, evidence files, and audit-ready accounting.',
      children: [
        SummaryCards(
          cards: [
            SummaryCardData(label: 'This Month Income', value: '1,450,000', caption: 'KRW sample total'),
            SummaryCardData(label: 'This Month Expense', value: '890,000', caption: 'KRW sample total'),
            SummaryCardData(label: 'Approval Queue', value: '4', caption: 'Entries waiting for approval'),
          ],
        ),
        SizedBox(height: 20),
        ContentSection(
          title: 'Accounting and audit flow',
          subtitle: 'Entry -> Evidence -> Approval -> Audit log',
          children: [
            ListTile(title: Text('Income and expense ledger'), subtitle: Text('Maps to ledger_entries in PostgreSQL')),
            ListTile(title: Text('Attachment upload'), subtitle: Text('Receipt and evidence storage metadata')),
            ListTile(title: Text('Audit history'), subtitle: Text('Every change should be traceable in audit_logs')),
          ],
        ),
      ],
    );
  }
}

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionPage(
      title: 'Inventory',
      description: 'Equipment and item management page connected to the flow-based club operation area.',
      children: [
        SummaryCards(
          cards: [
            SummaryCardData(label: 'Tracked Items', value: '27', caption: 'Registered inventory assets'),
            SummaryCardData(label: 'Borrowed', value: '5', caption: 'Currently checked-out items'),
            SummaryCardData(label: 'Inspection Due', value: '3', caption: 'Items requiring review'),
          ],
        ),
        SizedBox(height: 20),
        ContentSection(
          title: 'Inventory flow',
          subtitle: 'Register -> Assign -> Return -> Inspect',
          children: [
            ListTile(title: Text('Item registry'), subtitle: Text('Name, category, owner, storage location')),
            ListTile(title: Text('Borrow and return records'), subtitle: Text('Who used it and when it returns')),
            ListTile(title: Text('Maintenance history'), subtitle: Text('Condition changes and audit trace')),
          ],
        ),
      ],
    );
  }
}

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return SectionPage(
      title: 'My Page',
      description: 'Personal account page for profile, role, and session state.',
      children: [
        SummaryCards(
          cards: [
            SummaryCardData(label: 'Role', value: (auth.role ?? 'member').toUpperCase(), caption: 'Current account role'),
            const SummaryCardData(label: 'Session', value: 'Active', caption: 'Stored local session state'),
            const SummaryCardData(label: 'Pending Reads', value: '4', caption: 'Unread notices and reminders'),
          ],
        ),
        const SizedBox(height: 20),
        ContentSection(
          title: 'Profile actions',
          subtitle: 'Basic entry points before the full profile editor is implemented',
          children: [
            ListTile(title: Text('Edit profile basics'), subtitle: Text('Name, department, phone, student number')),
            ListTile(title: Text('View role history'), subtitle: Text('Current and previous assignments')),
            ListTile(title: Text('Session settings'), subtitle: Text('Logout, token refresh, security checks')),
          ],
        ),
      ],
    );
  }
}

class _HomeActionData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String path;

  const _HomeActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.path,
  });
}

class _HomeLinkData {
  final String title;
  final String path;
  final IconData icon;

  const _HomeLinkData({
    required this.title,
    required this.path,
    required this.icon,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _HomeActionData data;

  const _QuickActionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.go(data.path),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(data.icon),
              const Spacer(),
              Text(
                data.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(data.subtitle),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManagementCard extends StatelessWidget {
  final _HomeLinkData data;

  const _ManagementCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.go(data.path),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(data.icon, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
