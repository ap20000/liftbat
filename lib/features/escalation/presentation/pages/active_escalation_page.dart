import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injection/injection_container.dart';
import '../../../../core/utils/fade_in_up.dart'; // Reuse animation
import '../bloc/escalation_bloc.dart';
import '../bloc/escalation_event.dart';
import '../bloc/escalation_state.dart';

class ActiveEscalationPage extends StatefulWidget {
  const ActiveEscalationPage({super.key});

  @override
  State<ActiveEscalationPage> createState() => _ActiveEscalationPageState();
}

class _ActiveEscalationPageState extends State<ActiveEscalationPage> {
  late EscalationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<EscalationBloc>();
    _bloc.add(LoadEscalations());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F5F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Active Threats',
            style: TextStyle(
              color: Color(0xFF1A1C3D),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => _bloc.add(LoadEscalations()),
              icon: const Icon(Icons.refresh, color: Colors.black54),
            ),
          ],
        ),
        body: BlocBuilder<EscalationBloc, EscalationState>(
          builder: (context, state) {
            if (state is EscalationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EscalationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                    TextButton(
                      onPressed: () => _bloc.add(LoadEscalations()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is EscalationLoaded) {
              if (state.activeEscalations.isEmpty) {
                return const Center(
                  child: Text(
                    'No Active Threats',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.activeEscalations.length,
                itemBuilder: (context, index) {
                  final escalation = state.activeEscalations[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: _EscalationCard(
                      escalation: escalation,
                      onAcknowledge: () {
                        context.read<EscalationBloc>().add(
                          AcknowledgeEscalationEvent(escalation.id),
                        );
                      },
                      onStop: () {
                        context.read<EscalationBloc>().add(
                          StopEscalationEvent(escalation.id),
                        );
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _EscalationCard extends StatelessWidget {
  final dynamic escalation;
  final VoidCallback onAcknowledge;
  final VoidCallback onStop;

  const _EscalationCard({
    required this.escalation,
    required this.onAcknowledge,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = escalation.remainingSeconds;
    final progress = escalation.timeoutSeconds > 0
        ? remaining / escalation.timeoutSeconds
        : 0.0;

    // Determine color based on tier
    Color tierColor = const Color(0xFFEF6C00); // Orange default
    if (escalation.tier >= 3) tierColor = const Color(0xFFC62828); // Red

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tierColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'TIER ${escalation.tier} • ${escalation.tierName.toUpperCase()}',
                  style: TextStyle(
                    color: tierColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
              Text(
                _formatTime(escalation.remainingSeconds),
                style: TextStyle(
                  color: tierColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            escalation.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1C3D),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            escalation.description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF1F3F9),
              valueColor: AlwaysStoppedAnimation<Color>(tierColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Acknowledge',
                  color: const Color(0xFF5C6BC0),
                  icon: Icons.check_circle_outline,
                  onTap: onAcknowledge,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  label: 'Stop',
                  color: const Color(0xFFE53935),
                  icon: Icons.stop_circle_outlined,
                  isOutline: true,
                  onTap: onStop,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    if (seconds <= 0) return '00:00';
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final bool isOutline;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.icon,
    this.isOutline = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isOutline ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(12),
          border: isOutline ? Border.all(color: color, width: 1.5) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isOutline ? color : Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isOutline ? color : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
