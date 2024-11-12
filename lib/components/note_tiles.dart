import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:note_app/constants/colors.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/add_note.dart';
import 'package:note_app/services/database_helper.dart';

class NoteTiles extends StatefulWidget {
  //assigning  filter notes list to note
  Note note;
  Function(BuildContext)? deleteFunction;
  Function(Note)? editFunction;

  NoteTiles(
      {super.key,
      required this.note,
      required this.deleteFunction,
      required this.editFunction});

  @override
  State<NoteTiles> createState() => _NoteTilesState();
}

class _NoteTilesState extends State<NoteTiles> {
  get filteredNotes => null;

  //to get random color to cards
  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Slidable(
            endActionPane: ActionPane(motion: const StretchMotion(), children: [
              SlidableAction(
                onPressed: (context) {
                  widget.editFunction!(widget.note);
                },
                icon: Icons.edit,
                backgroundColor: Colors.blue.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              SlidableAction(
                onPressed: widget.deleteFunction,
                icon: Icons.delete,
                backgroundColor: Colors.red.shade300,
                borderRadius: BorderRadius.circular(12),
              )
            ]),
            child: Card(
              color: getRandomColor(),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListTile(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddNote(note: widget.note),
                        ),
                      );

                      if (result != null) {
                        // Assuming result contains updated title and content
                        final updatedNote = Note(
                          id: widget.note.id, // Use the existing id
                          title: result[0],
                          content: result[1],
                          modifiedTime:
                              DateTime.now(), // Update the modified time
                        );

                        await DatabaseHelper.instance
                            .updateNote(updatedNote); // Update the database

                        // Trigger a rebuild of the UI
                        setState(() {
                          widget.note =
                              updatedNote; // Update the note in the widget's state
                        });
                      }
                    },
                    title: RichText(
                      //limiting max line to 3
                      maxLines: 3,
                      //to get dons in the end
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: '${widget.note.title}\n',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              height: 1.5),
                          children: [
                            TextSpan(
                                text: widget.note.content,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    height: 1.5))
                          ]),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        //format is made by intel package
                        'Edited :${DateFormat('EEE MMM d, yyyy h:mm a').format(widget.note.modifiedTime)}',
                        style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade800),
                      ),
                    )),
              ),
            )));
  }
}

// ${noteModifiedDate.toLocal()}'.split(' ')[0]
