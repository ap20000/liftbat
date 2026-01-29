import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Critical', 'Scheduled', 'Pending'];

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
              'Security Reports',
              style: TextStyle(
                color: Colors.black.withOpacity(0.85),
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            const Text(
              'Manage and track incident reports',
              style: TextStyle(color: Colors.black45, fontSize: 13),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.black54),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() => selectedFilter = filter);
                      },
                      selectedColor: const Color(0xFF5C6BC0),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black54,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Reports List
            _buildReportCard(
              id: 'REP-2024-001',
              title: 'Weapon Threat Detection Analysis',
              subtitle: 'Electronics Zone - Detailed Forensics',
              date: 'Jan 29, 2024 • 10:45 AM',
              status: 'SENT',
              statusColor: Colors.green,
              recipients: 5,
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              id: 'REP-2024-002',
              title: 'Weekly Security Audit Summary',
              subtitle: 'All Zones - Performance Metrics',
              date: 'Scheduled: Feb 01, 2024',
              status: 'SCHEDULED',
              statusColor: Colors.blue,
              recipients: 12,
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              id: 'REP-2024-003',
              title: 'Inventory Loss Investigation',
              subtitle: 'Storage B - Ongoing Analysis',
              date: 'Draft created 2h ago',
              status: 'PENDING',
              statusColor: Colors.orange,
              recipients: 2,
            ),
            const SizedBox(height: 16),
            _buildReportCard(
              id: 'REP-2023-156',
              title: 'Monthly Incident Trend Report',
              subtitle: 'Entire Facility - December 2023',
              date: 'Dec 31, 2023',
              status: 'SENT',
              statusColor: Colors.green,
              recipients: 24,
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF5C6BC0),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Generate New',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String id,
    required String title,
    required String subtitle,
    required String date,
    required String status,
    required Color statusColor,
    required int recipients,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F3F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                id,
                style: const TextStyle(
                  color: Color(0xFF5C6BC0),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Color(0xFF1A1C3D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF5F5F5)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: Colors.black38,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  date,
                  style: const TextStyle(color: Colors.black38, fontSize: 12),
                ),
              ),
              const Icon(
                Icons.people_outline_rounded,
                size: 14,
                color: Colors.black38,
              ),
              const SizedBox(width: 4),
              Text(
                '$recipients',
                style: const TextStyle(color: Colors.black38, fontSize: 12),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.more_horiz_rounded, color: Colors.black45),
            ],
          ),
        ],
      ),
    );
  }
}
