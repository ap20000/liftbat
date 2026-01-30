import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injection/injection_container.dart';
import '../../../../core/utils/fade_in_up.dart';
import '../bloc/manual_escalation_bloc.dart';
import '../../domain/entities/escalation_rule.dart';

class ManualEscalationPage extends StatefulWidget {
  const ManualEscalationPage({super.key});

  @override
  State<ManualEscalationPage> createState() => _ManualEscalationPageState();
}

class _ManualEscalationPageState extends State<ManualEscalationPage> {
  final TextEditingController _commentController = TextEditingController();
  late ManualEscalationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<ManualEscalationBloc>();
    _bloc.add(LoadEscalationRules());
  }

  @override
  void dispose() {
    _commentController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onSubmit() {
    final state = _bloc.state;
    if (state.selectedRule != null) {
      _bloc.add(
        SubmitManualEscalation({
          'rule_id': state.selectedRule!.id,
          'comment': _commentController.text,
          // 'image': ... // Handle image upload later
        }),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a rule')));
    }
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
            'Trigger Escalation',
            style: TextStyle(
              color: Color(0xFF1A1C3D),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        body: BlocConsumer<ManualEscalationBloc, ManualEscalationState>(
          listener: (context, state) {
            if (state.status == ManualEscalationStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Escalation Triggered Successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop(); // Go back to dashboard
            } else if (state.status == ManualEscalationStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Unknown Error'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == ManualEscalationStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show content even if submitting or error (with snackbar)
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Incident Rule',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C3D),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...state.rules.map((rule) {
                        final isSelected = rule == state.selectedRule;
                        return FadeInUp(
                          delay: const Duration(milliseconds: 100),
                          child: GestureDetector(
                            onTap: () {
                              _bloc.add(SelectEscalationRule(rule));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFE3F2FD)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF2196F3)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  if (!isSelected)
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Radio<EscalationRule>(
                                    value: rule,
                                    groupValue: state.selectedRule,
                                    onChanged: (val) {
                                      if (val != null) {
                                        _bloc.add(SelectEscalationRule(val));
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rule.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          rule.description,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: rule.tier >= 3
                                          ? Colors.red.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      rule.tierName.toUpperCase(),
                                      style: TextStyle(
                                        color: rule.tier >= 3
                                            ? Colors.red
                                            : Colors.orange,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      const Text(
                        'Additional Comments',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C3D),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _commentController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Describe the situation...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              state.status == ManualEscalationStatus.submitting
                              ? null
                              : _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: const Color(
                              0xFFD32F2F,
                            ).withOpacity(0.4),
                          ),
                          child:
                              state.status == ManualEscalationStatus.submitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'TRIGGER ALERT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.status == ManualEscalationStatus.submitting)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
