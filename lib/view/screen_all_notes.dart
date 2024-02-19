import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/data/data.dart';
import 'package:note_app/data/note_model/note_model.dart';
import 'package:note_app/view/screen_add_note.dart';
import 'package:note_app/view/screen_note_item.dart';

class ScreenAllNotes extends StatefulWidget {
  const ScreenAllNotes({super.key});

  @override
  State<ScreenAllNotes> createState() => _ScreenAllNotesState();
}

class _ScreenAllNotesState extends State<ScreenAllNotes> {
   @override
  void initState() {
    super.initState();
    NoteDB.instance.noteListNotifier.addListener(() {
      setState(() {}); 
    });
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NoteDB.instance.getAllNote();

       
      
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          title: Text(
            "All Notes",
            style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 25),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: NoteDB.instance.noteListNotifier,
          builder: (context, List<NoteModel> newNotes, _) {
            return newNotes.isEmpty?
              const Center(
                child: Text("Note List is Empty"),
              )
            :
             GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: const EdgeInsets.all(20),
              children: List.generate(newNotes.length, (index) {
                final note = NoteDB.instance.noteListNotifier.value[index];
                if (note.id == null) {
                  const SizedBox();
                }
                return NoteItems(
                  id: note.id!,
                  title: note.title??"No title",
                  content: note.content??"No content",
                );
              }),
            );
          },
        ),
          
        
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.8),
              borderRadius: BorderRadius.circular(19),
              shape: BoxShape.rectangle),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ScreenAddNotes(type: ActionType.addNote),
              ));
            },
            label: const Text('New'),
            icon: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
