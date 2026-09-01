import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/calendar_viewmodel.dart';
import '../wigets/calendar_legend.dart';
import '../wigets/calendar_toggle.dart';
import '../wigets/month_calendar.dart';
import '../wigets/week_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool isMonthView = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthViewModel>().currentUser!.id!;

      context.read<CalendarViewModel>().loadEvents(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final calendar = context.watch<CalendarViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Text(
                'Calendar',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'September 2026',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 20),

              // MONTH / WEEK TOGGLE
              CalendarToggle(
                isMonthView: isMonthView,
                onChanged: (value) {
                  setState(() {
                    isMonthView = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // CALENDAR
              if (calendar.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isMonthView
                      ? MonthCalendar(
                    key: const ValueKey('month'),
                    events: calendar.events,
                  )
                      : WeekCalendar(
                    key: const ValueKey('week'),
                    events: calendar.events,
                  ),
                ),

              const SizedBox(height: 16),

              // LEGEND
              const CalendarLegend(),
            ],
          ),
        ),
      ),
    );
  }
}