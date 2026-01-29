import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/kpi_card.dart';
import '../widgets/live_escalation_card.dart';
import '../widgets/activity_list_item.dart';
import '../widgets/status_tag_card.dart';
import '../widgets/status_metric_widget.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = false;

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sentinel AI',
              style: TextStyle(
                color: Colors.indigo[900],
                fontWeight: FontWeight.w900,
                fontSize: 26,
                letterSpacing: -0.5,
              ),
            ),
            const Text(
              'SECURITY INTELLIGENCE HUB',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          const _ActionButton(icon: Icons.notifications_none_rounded, count: 3),
          const SizedBox(width: 12),
          _UserAvatar(),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.primary,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isLoading)
                    const LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      minHeight: 2,
                    ),
                  const SizedBox(height: 16),
                  // Global Filter / Role Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shield_rounded,
                            color: AppColors.primaryLight,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Access Level:',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'ADMINISTRATOR',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.tune_rounded,
                            color: AppColors.textTertiary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // KPI Grid (2x2)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.95,
                      children: [
                        KpiCard(
                          title: 'Active Tasks',
                          value: '4',
                          icon: Icons.assignment_rounded,
                          iconColor: Colors.redAccent,
                          footerText: '2 Priority',
                          footerTextColor: Colors.redAccent,
                          linkText: 'View All',
                          onLinkTap: () => context.go('/tasks'),
                        ),
                        KpiCard(
                          title: 'Reports Sent',
                          value: '12',
                          icon: Icons.description_outlined,
                          iconColor: Colors.blueAccent,
                          footerText: '3 This Week',
                          linkText: 'View Reports',
                          onLinkTap: () {},
                        ),
                        KpiCard(
                          title: 'Financial Loss',
                          value: '\$1,400',
                          icon: Icons.account_balance_wallet_outlined,
                          iconColor: Colors.purpleAccent,
                          footerText: 'High Alert',
                          footerTextColor: Colors.redAccent,
                          linkText: 'Details',
                          onLinkTap: () {},
                        ),
                        KpiCard(
                          title: 'System Uptime',
                          value: '99.8%',
                          icon: Icons.bolt_rounded,
                          iconColor: Colors.orangeAccent,
                          footerText: 'Optimized',
                          footerTextColor: Colors.green,
                          linkText: 'Settings',
                          onLinkTap: () {},
                        ),
                      ],
                    ),
                  ),

                  // Live Escalation
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: LiveEscalationCard(),
                  ),

                  const SizedBox(height: 40),

                  // Recent Activities
                  _sectionHeader(
                    'Intelligence Feed',
                    icon: Icons.auto_awesome_outlined,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ActivityListItem(
                            icon: Icons.sensors_rounded,
                            title: 'Weapon Detection Alert - Electronics Zone',
                            time: '5m ago',
                            linkText: 'RESPOND NOW',
                            markerColor: Colors.redAccent,
                            onLinkTap: () {},
                          ),
                          const _CustomDivider(),
                          ActivityListItem(
                            icon: Icons.task_alt_rounded,
                            title: 'Security Report Sent - Monthly Summary',
                            time: '2h ago',
                            linkText: 'VIEW ARCHIVE',
                            markerColor: Colors.indigoAccent,
                            onLinkTap: () {},
                          ),
                          const _CustomDivider(),
                          const ActivityListItem(
                            icon: Icons.history_rounded,
                            title: 'Task TASK-002 assigned to LP Manager',
                            time: '8m ago',
                            markerColor: Colors.orangeAccent,
                          ),
                          const _CustomDivider(),
                          const ActivityListItem(
                            icon: Icons.alternate_email_rounded,
                            title: 'New system-wide security patch deployed',
                            time: '12m ago',
                            markerColor: Colors.greenAccent,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Critical Reports
                  _sectionHeader(
                    'Critical Intelligence',
                    icon: Icons.report_problem_outlined,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        StatusTagCard(
                          title: 'Weapon Threat Intelligence',
                          subtitle: 'Confirmed hardware detection in Zone B',
                          tag: 'CRITICAL',
                          tagColor: Colors.redAccent,
                          footerText: 'Police Dispatched',
                          linkText: 'DETAILS',
                          onLinkTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // System Status
                  _sectionHeader(
                    'Core Operations',
                    icon: Icons.settings_input_component_rounded,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.darkPanelGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.slateDark.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        children: const [
                          StatusMetricWidget(
                            value: '99.8%',
                            label: 'STABILITY',
                            valueColor: Colors.greenAccent,
                          ),
                          StatusMetricWidget(
                            value: '22ms',
                            label: 'LATENCY',
                            valueColor: Colors.blueAccent,
                          ),
                          StatusMetricWidget(
                            value: '4',
                            label: 'ACTIVE TASKS',
                            valueColor: Colors.redAccent,
                          ),
                          StatusMetricWidget(
                            value: '1.2k',
                            label: 'EVENT/MIN',
                            valueColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          gradient: AppColors.actionGradient,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _sectionHeader(String title, {required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primaryLight),
          ),
          const SizedBox(width: 12),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.indigo[900],
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          const Text(
            'LIVE REFRESH',
            style: TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;

  const _ActionButton({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 22),
        ),
        Positioned(
          top: 10,
          right: 2,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.critical,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 2),
        shape: BoxShape.circle,
      ),
      child: const CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.divider,
        child: Icon(
          Icons.person_3_rounded,
          size: 20,
          color: AppColors.primaryLight,
        ),
      ),
    );
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: AppColors.divider, height: 1),
    );
  }
}
