import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/note_storage_service.dart';
import '../../models/note_model.dart';
import '../widgets/note_card.dart';

class NoteLabScreen extends StatefulWidget {
  const NoteLabScreen({super.key});

  @override
  State<NoteLabScreen> createState() => _NoteLabScreenState();
}

class _NoteLabScreenState extends State<NoteLabScreen> {
  List<NoteModel> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await NoteStorageService.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _showNoteDialog({NoteModel? note}) async {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? 'Add Note' : 'Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final id = note?.id ?? const Uuid().v4();
                final newNote = NoteModel(
                  id: id,
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                );
                await NoteStorageService.saveNote(newNote);
                await _loadNotes();
                Navigator.pop(context);
              },
              child: Text(note == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNote(String id) async {
    await NoteStorageService.deleteNote(id);
    await _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteLab'),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes yet.'))
          : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return NoteCard(
            note: note,
            onTap: () => _showNoteDialog(note: note),
            onDelete: () => _deleteNote(note.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
