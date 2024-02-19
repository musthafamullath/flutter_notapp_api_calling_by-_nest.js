// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/data/data.dart';
import 'package:note_app/data/note_model/note_model.dart';

enum ActionType {
  addNote,
  editNote,
}

class ScreenAddNotes extends StatelessWidget {
  final ActionType type;
  String? id;
  ScreenAddNotes({
    super.key,
    required this.type,
    this.id,
  });

  Widget get saveButton => TextButton.icon(
        onPressed: () {
          switch (type) {
            case ActionType.addNote:
              saveNote();
              break;
            case ActionType.editNote:
              saveEditNote();
              break;
          }
        },
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          "Save",
          style: GoogleFonts.aBeeZee(color: Colors.white),
        ),
      );
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (type == ActionType.editNote) {
      if (id == null) {
        Navigator.of(context).pop();
      }
    }
    final note = NoteDB().getNoteByID(id!);
    if (note == null) {
      Navigator.of(context).pop();
    }
    titleController.text == note!.title ?? "No title";
    contentController.text == note.content ?? "No content";
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[800],
          title: Text(
            type.name.toUpperCase(),
            style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 25),
          ),
          actions: [saveButton],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Title",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: contentController,
                  maxLines: 24,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Content",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveNote() async {
    final title = titleController.text;
    final content = contentController.text;
    final newNote = NoteModel.create(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
    );
    final newNode = await NoteDB().createNote(newNote);
    if (newNode != null) {
      print("value added");
      Navigator.of(scaffoldKey.currentContext!).pop();
    } else {
      print("value not added");
    }
  }

  Future<void> saveEditNote() async {
    final title = titleController.text;
    final content = contentController.text;
    final editedNote = NoteModel.create(
      id: id,
      title: title,
      content: content,
    );
    final note = await NoteDB().updateNote(editedNote);
    if(note == null){
      print("Unable to update note");
    }else{
      Navigator.of(scaffoldKey.currentContext!).pop();
    }
  }
}
