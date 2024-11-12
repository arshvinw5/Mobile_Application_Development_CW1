import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';

class AddNote extends StatefulWidget {
  //making variable to add the existing note
  //getting this note from sampleNotes
  final Note? note;
  const AddNote({super.key, this.note});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: ListView(
              children: [
                //title input
                TextField(
                  controller: _titleController,
                  style: const TextStyle(fontSize: 30),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Title",
                      hintStyle:
                          TextStyle(color: Colors.grey.shade700, fontSize: 30)),
                ),
                const SizedBox(height: 10),
                //Content input
                TextField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type your note...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade700,
                      )),
                )
              ],
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //return some data after context
          Navigator.pop(
              context, [_titleController.text, _contentController.text]);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
