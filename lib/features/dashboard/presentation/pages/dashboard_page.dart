import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../domain/models/escalation.dart';
import '../../domain/models/activity.dart';
import '../../domain/models/dashboard_stats.dart';
import '../../domain/models/performance_metrics.dart';
import '../../domain/models/incident.dart';
import '../../../../core/utils/fade_in_up.dart'; // Import FadeInUp

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<void> _handleRefresh() async {
    context.read<DashboardBloc>().add(LoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security Dashboard',
              style: TextStyle(
                color: Colors.black.withOpacity(0.85),
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            Row(
              children: [
                Text(
                  'Role: ',
                  style: TextStyle(color: Colors.black45, fontSize: 13),
                ),
                Text(
                  'Manager',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: Colors.black45,
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.grid_view_rounded,
                size: 20,
                color: Colors.black54,
              ),
              onPressed: () {},
            ),
          ),
          OutlinedButton.icon(
            onPressed: _handleRefresh,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Refresh Data'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            // Even on error, we show the dashboard with fallbacks
            return _buildDashboardContent(
              stats: const DashboardStats(active: 0, critical: 0, resolved: 0),
              incidents: [],
              activities: [],
              activeEscalations: [],
              analytics: PerformanceMetrics.empty(),
            );
          }

          if (state is DashboardLoaded) {
            return _buildDashboardContent(
              stats: state.stats,
              incidents: state.incidents,
              activities: state.activities,
              activeEscalations: state.activeEscalations,
              analytics: state.analytics,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7986CB), Color(0xFF5C6BC0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5C6BC0).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => _showEmergencyActions(context),
        ),
      ),
    );
  }

  Widget _buildDashboardContent({
    required DashboardStats stats,
    required List<Incident> incidents,
    required List<Activity> activities,
    required List<Escalation> activeEscalations,
    required PerformanceMetrics analytics,
  }) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Summary Cards Row
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _SummaryCard(
                      title: 'Active Incidents',
                      value: stats.active.toString(),
                      subtitle: '${stats.critical} Critical',
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppColors.critical,
                      onTap: () => context.go('/tasks'),
                    ),
                    _SummaryCard(
                      title: 'Reports Sent',
                      value: incidents.length.toString(),
                      subtitle: '3 This Week',
                      icon: Icons.description_outlined,
                      iconColor: Colors.blueAccent,
                      onTap: () {},
                    ),
                    const _SummaryCard(
                      title: 'Financial Impact',
                      value: r'$1,400',
                      subtitle: 'Loss This Month',
                      icon: Icons.monetization_on_outlined,
                      iconColor: Colors.pinkAccent,
                      onTap: null,
                    ),
                    _SummaryCard(
                      title: 'System Status',
                      value: analytics.systemUptime > 0
                          ? '${analytics.systemUptime.toStringAsFixed(1)}%'
                          : '99.8%',
                      subtitle: 'All Systems Online',
                      icon: Icons.bar_chart_rounded,
                      iconColor: Colors.grey,
                      onTap: null,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Live Escalation Banner
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: _buildEscalationBanner(activeEscalations),
            ),

            const SizedBox(height: 32),

            // Recent Activities
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Recent Activities', hasViewAll: true),
                    const SizedBox(height: 8),
                    _ActivitySection(activities: activities),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Critical Reports
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      'Critical Reports',
                      icon: Icons.assignment_outlined,
                    ),
                    const SizedBox(height: 12),
                    if (incidents.any(
                      (i) =>
                          i.priority.toUpperCase() == 'CRITICAL' ||
                          i.priority.toUpperCase() == 'HIGH',
                    ))
                      ...incidents
                          .where(
                            (i) =>
                                i.priority.toUpperCase() == 'CRITICAL' ||
                                i.priority.toUpperCase() == 'HIGH',
                          )
                          .take(2)
                          .map(
                            (incident) => Column(
                              children: [
                                _buildReportItem(
                                  title: incident.title,
                                  subtitle: incident.description,
                                  meta:
                                      '${incident.zone} • ${incident.status.replaceAll('_', ' ').toUpperCase()}',
                                  badge: incident.priority.toUpperCase(),
                                  badgeColor:
                                      incident.priority.toUpperCase() ==
                                          'CRITICAL'
                                      ? const Color(0xFFFFEBEE)
                                      : const Color(0xFFFFF3E0),
                                  textColor:
                                      incident.priority.toUpperCase() ==
                                          'CRITICAL'
                                      ? const Color(0xFFC62828)
                                      : const Color(0xFFEF6C00),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          )
                    else ...[
                      _buildReportItem(
                        title: 'Weapon Threat Report',
                        subtitle:
                            'Electronics zone weapon detection - sent to police',
                        meta: '2 recipients • Acknowledged',
                        badge: 'CRITICAL',
                        badgeColor: const Color(0xFFFFEBEE),
                        textColor: const Color(0xFFC62828),
                      ),
                      const SizedBox(height: 12),
                      _buildReportItem(
                        title: 'Theft Investigation',
                        subtitle: 'High-value theft report - insurance claim',
                        meta: '3 recipients • Pending',
                        badge: 'HIGH',
                        badgeColor: const Color(0xFFFFF3E0),
                        textColor: const Color(0xFFEF6C00),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Active Incidents List
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      'Active Incidents',
                      icon: Icons.warning_amber_rounded,
                    ),
                    const SizedBox(height: 12),
                    if (incidents.any(
                      (i) => i.status != 'resolved' && i.status != 'closed',
                    ))
                      ...incidents
                          .where(
                            (i) =>
                                i.status != 'resolved' && i.status != 'closed',
                          )
                          .take(3)
                          .map(
                            (incident) => Column(
                              children: [
                                _buildIncidentListItem(
                                  id: 'INC-${incident.id.padLeft(3, '0')}',
                                  title: incident.title,
                                  subtitle: incident.zone,
                                  time: _formatTime(incident.createdAt),
                                  badge: incident.status
                                      .replaceAll('_', ' ')
                                      .toUpperCase(),
                                  badgeColor: const Color(0xFFF1F3F9),
                                  textColor: Colors.black54,
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          )
                    else ...[
                      _buildIncidentListItem(
                        id: 'INC-001',
                        title: 'Weapon Threat Detection',
                        subtitle: 'Security Team Alpha',
                        time: '5m ago',
                        badge: 'CRITICAL',
                        badgeColor: const Color(0xFFFFEBEE),
                        textColor: const Color(0xFFC62828),
                      ),
                      const SizedBox(height: 12),
                      _buildIncidentListItem(
                        id: 'INC-002',
                        title: 'Theft Investigation',
                        subtitle: 'LP Manager',
                        time: '30m ago',
                        badge: 'HIGH',
                        badgeColor: const Color(0xFFFFF3E0),
                        textColor: const Color(0xFFEF6C00),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // System Status Grid
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      'System Status',
                      icon: Icons.print_outlined,
                    ),
                    const SizedBox(height: 12),
                    _SystemStatusGrid(metrics: analytics),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showEmergencyActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Security Emergency Center'.toUpperCase(),
              style: TextStyle(
                color: Colors.indigo[900],
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AUTHORIZED PERSONNEL ONLY',
              style: TextStyle(
                color: AppColors.critical,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 32),
            _EmergencyActionTile(
              title: 'Manual Trigger Escalation',
              subtitle: 'Initiate global security matrix override',
              icon: Icons.emergency_share_rounded,
              color: AppColors.primary,
              onTap: () {
                context.read<DashboardBloc>().add(
                  const TriggerEscalationRequested('MANUAL-001'),
                );
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            _EmergencyActionTile(
              title: 'Immediate Stop Escalation',
              subtitle: 'Suppress all active alert propagation',
              icon: Icons.stop_circle_rounded,
              color: AppColors.critical,
              onTap: () {
                context.read<DashboardBloc>().add(StopEscalationRequested());
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEscalationBanner(List<Escalation> activeEscalations) {
    final escalation = activeEscalations.isNotEmpty
        ? activeEscalations.first
        : Escalation(
            id: 'INC-001',
            title: 'Weapon Threat - Electronics Zone',
            severity: 'CRITICAL',
            status: 'ACTIVE',
            timestamp: DateTime.now(),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _LiveEscalationBanner(
        escalation: escalation,
        onAcknowledge: () {
          if (activeEscalations.isNotEmpty) {
            context.read<DashboardBloc>().add(
              AcknowledgeEscalationRequested(activeEscalations.first.id),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    IconData? icon,
    bool hasViewAll = true,
  }) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF5C6BC0),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        if (icon != null) ...[
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1C3D),
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        if (hasViewAll)
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF5C6BC0),
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReportItem({
    required String title,
    required String subtitle,
    required String meta,
    required String badge,
    required Color badgeColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                meta,
                style: const TextStyle(color: Colors.black26, fontSize: 11),
              ),
              const Spacer(),
              const Text(
                'View Report',
                style: TextStyle(
                  color: Color(0xFF5C6BC0),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentListItem({
    required String id,
    required String title,
    required String subtitle,
    required String time,
    required String badge,
    required Color badgeColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                id,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: const TextStyle(color: Colors.black38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.black45, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// Animations and Unused helpers removed to match flat design 1:1

// -----------------------------------------------------------------------------
// HELPER WIDGETS
// -----------------------------------------------------------------------------

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F3F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, const Color(0xFFF8F9FF).withOpacity(0.5)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: iconColor.withOpacity(0.8), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black38,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (onTap != null)
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF5C6BC0),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveEscalationBanner extends StatelessWidget {
  final dynamic escalation;
  final VoidCallback onAcknowledge;

  const _LiveEscalationBanner({
    required this.escalation,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'LIVE ALERT',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'CRITICAL INCIDENT ACTIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              _BannerBtn(label: 'View Incident', onTap: () {}),
              const SizedBox(width: 8),
              _BannerBtn(label: 'Open Panel', isOutline: false, onTap: () {}),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'INCIDENT ${escalation.id} - ${escalation.title}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Text(
                'Tier 4: Emergency',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                '0:20',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.65,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF42A5F5)),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAcknowledge,
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Acknowledge'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF5350).withOpacity(0.8),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone_rounded, size: 18),
                  label: const Text('Call 911 Dispatch'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC407A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerBtn extends StatelessWidget {
  final String label;
  final bool isOutline;
  final VoidCallback onTap;

  const _BannerBtn({
    required this.label,
    this.isOutline = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _ActivitySection extends StatelessWidget {
  final List<dynamic> activities;

  const _ActivitySection({required this.activities});

  @override
  Widget build(BuildContext context) {
    final displayActivities = activities.isNotEmpty
        ? activities
        : [
            Activity(
              id: '1',
              title: 'Weapon Detection Alert - Electronics Zone',
              type: 'sensor',
              timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            ),
            Activity(
              id: '2',
              title: 'Security Report Sent - Monthly Summary',
              type: 'report',
              timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            ),
            Activity(
              id: '3',
              title: 'Incident INC-002 assigned to LP Manager',
              type: 'security',
              timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
            ),
          ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F3F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: displayActivities
            .take(5)
            .map((a) => _ActivityItem(activity: a))
            .toList(),
      ),
    );
  }
}

class _SystemStatusGrid extends StatelessWidget {
  final dynamic metrics;
  const _SystemStatusGrid({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F3F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildMetricItem(
                '${metrics.systemUptime.toStringAsFixed(1)}%',
                'System Uptime',
                Colors.black87,
              ),
              _buildMetricItem(
                '${metrics.avgResponseTime.toStringAsFixed(1)}s',
                'Avg Response Time',
                Colors.black87,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildMetricItem(
                metrics.totalAlertsToday.toString(),
                'Active Incidents',
                const Color(0xFFEF5350),
              ),
              _buildMetricItem(
                '1,247',
                'Events Today',
                const Color(0xFF7E57C2),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildMetricItem(r'$2,400', 'Loss This Month', Colors.black87),
              _buildMetricItem('5', 'Open Tasks', const Color(0xFF5C6BC0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black38,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final dynamic activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4, left: 0),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getColor(activity.type),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getColor(activity.type).withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Color(0xFF1A1C3D),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${_formatTime(activity.timestamp)} ago',
                      style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (activity.alertId != null) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '•',
                          style: TextStyle(color: Colors.black12, fontSize: 10),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'View ${activity.type}',
                          style: TextStyle(
                            color: _getColor(activity.type),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(String type) {
    switch (type.toLowerCase()) {
      case 'sensor':
        return Colors.red;
      case 'report':
        return Colors.purple;
      case 'security':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  String _formatTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

class _EmergencyActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _EmergencyActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color.withOpacity(0.2),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
