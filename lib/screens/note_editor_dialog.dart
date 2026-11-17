import 'package:flutter/material.dart';

import '../models/note_model.dart';

class NoteEditorResult {
  const NoteEditorResult({required this.title, required this.content});

  final String title;
  final String content;
}

class NoteEditorDialog extends StatefulWidget {
  const NoteEditorDialog({super.key, this.note});

  final NoteModel? note;

  @override
  State<NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<NoteEditorDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Catatan' : 'Tambah Catatan'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const ValueKey('noteTitleField'),
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Judul',
                hintText: 'Contoh: Belanja',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('noteContentField'),
              controller: _contentController,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                hintText: 'Tuliskan detail catatan Anda...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(
              NoteEditorResult(
                title: _titleController.text.trim(),
                content: _contentController.text.trim(),
              ),
            );
          },
          child: Text(isEditing ? 'Update' : 'Simpan'),
        ),
      ],
    );
  }
}
