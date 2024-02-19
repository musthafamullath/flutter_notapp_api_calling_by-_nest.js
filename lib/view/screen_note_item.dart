import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note_app/data/data.dart';
import 'package:note_app/view/screen_add_note.dart';

class NoteItems extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  const NoteItems({
    super.key,
    required this.id,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScreenAddNotes(type: ActionType.editNote, id: id,), ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.aBeeZee(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey.withOpacity(0.15),
                  radius: 20,
                  child: IconButton(
                    onPressed: () {
                      NoteDB().deleteNote(id);
                    },
                    icon: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              content,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.k2d(
                color: Colors.black45,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
