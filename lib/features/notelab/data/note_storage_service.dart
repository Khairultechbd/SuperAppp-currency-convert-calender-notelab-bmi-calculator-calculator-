import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class NoteStorageService {
  static const String _notesKey = 'notes';

  static Future<List<NoteModel>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey) ?? [];

    return notesJson.map((json) {
      final data = jsonDecode(json);
      return NoteModel.fromJson(data);
    }).toList();
  }

  static Future<void> saveNote(NoteModel note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();

    final existingIndex = notes.indexWhere((n) => n.id == note.id);
    if (existingIndex != -1) {
      notes[existingIndex] = note;
    } else {
      notes.add(note);
    }

    final encoded = notes.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notesKey, encoded);
  }

  static Future<void> deleteNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    notes.removeWhere((note) => note.id == id);

    final encoded = notes.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notesKey, encoded);
  }
}
