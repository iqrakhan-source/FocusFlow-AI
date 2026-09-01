import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:proviers/main.dart';
import 'package:proviers/core/theme/theme_provider.dart';
import 'package:proviers/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:proviers/features/calendar/viewmodel/calendar_viewmodel.dart';
import 'package:proviers/features/reflection/viewmodel/reflection_viewmodel.dart';

void main() {
  testWidgets('App renders StudentTracker', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => CalendarViewModel()),
          ChangeNotifierProvider(create: (_) => ReflectionViewModel()),
        ],
        child: const StudentTracker(),
      ),
    );
    expect(find.byType(StudentTracker), findsOneWidget);
  });
}

