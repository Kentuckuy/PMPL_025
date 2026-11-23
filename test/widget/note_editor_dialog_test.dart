import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pmpl_025/screens/note_editor_dialog.dart';

void main() {
  testWidgets(
    'keeps text controllers alive through the dialog exit animation',
    (tester) async {
      NoteEditorResult? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await showDialog<NoteEditorResult>(
                    context: context,
                    builder: (_) => const NoteEditorDialog(),
                  );
                },
                child: const Text('Buka dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Buka dialog'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('noteTitleField')),
        'Belanja',
      );
      await tester.enterText(
        find.byKey(const ValueKey('noteContentField')),
        'Beli buah',
      );

      await tester.tap(find.text('Simpan'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();

      expect(result?.title, 'Belanja');
      expect(result?.content, 'Beli buah');
      expect(tester.takeException(), isNull);
    },
  );
}
