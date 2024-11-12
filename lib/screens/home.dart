import 'package:flutter/material.dart';
import 'package:note_app/components/delete_confirmation_dialog.dart';
import 'package:note_app/components/drawer.dart';
import 'package:note_app/components/note_tiles.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/add_note.dart';
import 'package:note_app/services/database_helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //to store filtered words in new list
  List<Note> filteredNotes = [];

  //for sort list function
  bool sorted = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    // _initializeNotes();
    DatabaseHelper.instance.addDummyNoteIfNeeded();
  }

  Future<void> _loadNotes() async {
    final notes = await DatabaseHelper.instance.getNotes();
    setState(() {
      filteredNotes = notes;
    });
  }

  //dummy date to initiate it once
  // Future<void> _initializeNotes() async {
  //   // Ensure the dummy note is added only once
  //   await DatabaseHelper.instance.addDummyNoteIfNeeded();
  //   // Load notes after ensuring dummy note is present
  //   await _loadNotes();
  // }

//updated search function with db
  void onSearchText(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        // If search text is empty, load the full notes list
        _loadNotes();
      } else {
        // Filter notes based on the search text
        filteredNotes = filteredNotes
            .where((note) =>
                note.content.toLowerCase().contains(searchText.toLowerCase()) ||
                note.title.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

//search function
  // void onSearchText(String searchText) {
  //   setState(() {
  //     filteredNotes = filteredNotes
  //         .where((note) =>
  //             note.content.toLowerCase().contains(searchText.toLowerCase()) ||
  //             note.title.toLowerCase().contains(searchText.toLowerCase()))
  //         .toList();

  //     //the content of the note (converted to lowercase) contains the search
  //     //text (also converted to lowercase). This makes
  //     //the search case-insensitive.

  //     //toList return it back to empty list again
  //   });
  // }

  //sort noted by modified time
  List<Note> sortNotes(List<Note> notes) {
    if (sorted) {
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;
    return notes;
  }

  //delete function
  // void deleteNote(int index) {
  //   setState(() {
  //     Note note = filteredNotes[index];
  //     sampleNotes.remove(note);
  //     filteredNotes.removeAt(index);
  //   });
  // }

  void deleteNoteById(int id) async {
    await DatabaseHelper.instance.deleteNoteById(id);
    _loadNotes(); // Refresh the list after deletion
  }

  // Edit callback function
  void editNoteCallback(Note updatedNote) async {
    await DatabaseHelper.instance.updateNote(updatedNote);
    _loadNotes(); // Reload notes after editing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      //passing the context to my drawer
      drawer: MyDrawer(parentContext: context),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Notes",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                //sorted button
                IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        filteredNotes = sortNotes(filteredNotes);
                      });
                    },
                    icon: const Icon(
                      Icons.sort,
                      size: 25,
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
                //to run that search function
                onChanged: onSearchText,
                decoration: InputDecoration(
                    hintText: "Search Note",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Colors.transparent)))),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  return NoteTiles(
                    //just passing enter filter notes list to note title component
                    note: filteredNotes[index],
                    deleteFunction: (context) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DeleteConfirmationDialog(
                              //made the function to execute delete function
                              onConfirm: () {
                                deleteNoteById(filteredNotes[index].id!);
                              },
                            );
                          });
                    },
                    editFunction: editNoteCallback, // Passing edit callback
                  );
                },
              ),
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const AddNote()));

          // if (result != null) {
          //   setState(() {
          //     sampleNotes.add(Note(
          //         id: sampleNotes.length,
          //         title: result[0],
          //         content: result[1],
          //         modifiedTime: DateTime.now()));
          //     filteredNotes = sampleNotes;
          //   });
          // }

          if (result != null) {
            final newNote = Note(
              title: result[0],
              content: result[1],
              modifiedTime: DateTime.now(),
              id: null,
            );
            //calling add note to save the note
            await DatabaseHelper.instance.addNote(newNote);
            _loadNotes();
          }
        },
        elevation: 10,
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}

//AppBar
AppBar _buildAppBar(context) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.surface,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // Use Builder to get a context that is under the Scaffold
      Builder(builder: (context) {
        return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              size: 35,
            ));
      }),
      SizedBox(
        height: 30,
        width: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('assets/img/UserImg.png'),
        ),
      ),
    ]),
  );
}

// Drawer
// Widget _buildDrawer(BuildContext context) {
//   return Drawer(
//     child: ListView(
//       padding: EdgeInsets.zero,
//       children: <Widget>[
//         const DrawerHeader(
//           decoration: BoxDecoration(
//             color: Colors.blue,
//           ),
//           child: Text(
//             'Drawer Header',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//             ),
//           ),
//         ),
//         ListTile(
//           title: const Text('Item 1'),
//           onTap: () {
//             // Handle item tap
//             Navigator.pop(context); // Close the drawer
//           },
//         ),
//         ListTile(
//           title: const Text('Item 2'),
//           onTap: () {
//             // Handle item tap
//             Navigator.pop(context); // Close the drawer
//           },
//         ),
//       ],
//     ),
//   );

// ListTile(
//           title: const Text('Item 1'),
//           onTap: () {
//             // Handle item tap
//             Navigator.pop(context); // Close the drawer
//           },
