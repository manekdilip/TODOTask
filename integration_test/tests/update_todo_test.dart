import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todoapp/main.dart' as todo_app;

import '../screens/todo/home_screen.dart';


void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('TODO :', () {
    testWidgets(
      'Validate Update Todo',
          (WidgetTester tester) async {
        // Initialing Application for Testing and waiting for it to launch
        todo_app.main();
        await tester.pump(const Duration(seconds: 5));

        final todoHomeScreen = TodoHomeScreen(tester);

        // Test Data Setup
        const title = 'Automation Test TODO';
        const titleUpdate = 'Updated Automation Test TODO';
        const description = 'This TODO is created by Flutter Integration Test Package.';
        const descriptionUpdate = 'Updated This TODO is created by Flutter Integration Test Package.';

        // Actions to Perform
        await todoHomeScreen.addTodo(title, description);
        final isTodoCreated = await todoHomeScreen.isTodoPresent(title);
        expect(isTodoCreated, true, reason: 'Expected TODO should be created and it should reflect on TODO Home Screen');

        await todoHomeScreen.updateTodo(titleUpdate, descriptionUpdate);
        final isTodoUpdated = await todoHomeScreen.isTodoUpdated(titleUpdate);
        expect(isTodoUpdated, true, reason: 'Expected TODO should be Updated and it should reflect on TODO Home Screen');


          },
      skip: false,
      timeout: const Timeout(Duration(minutes: 5)),
    );
  });
}
