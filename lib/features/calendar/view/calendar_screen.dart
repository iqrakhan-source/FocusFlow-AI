import'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isMonthView
                    ? const MonthCalendar(
                  key: ValueKey('month'),
                )
                    : const WeekCalendar(
                  key: ValueKey('week'),
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