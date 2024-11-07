import 'package:flutter/material.dart';
import 'package:simplenote/models/note_model.dart';
import 'package:simplenote/screens/widgets/note_card.dart';
import 'add_note.dart';
import '../db_helper/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    notes = await dbHelper.getNotes();
    setState(() {});
  }

  void _deleteNoteFromDatabase(int noteId) async {
    await dbHelper.deleteNoteById(noteId);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Note"),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteCard(
            note: notes[index],
            index: index,
            onNoteDeleted: (index) => _deleteNoteFromDatabase(notes[index].id!),
            onNewNoteCreated: (note) async {
              await dbHelper.updateNote(note);
              _loadNotes();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNote(
                onNewNoteCreated: (note) async {
                  await dbHelper.insertNote(note);
                  _loadNotes();
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
