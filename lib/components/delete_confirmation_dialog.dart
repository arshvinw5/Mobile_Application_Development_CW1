import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  //making function to get the confirmation then execute the deleting query
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.info),
      title: const Text(
        'Are you sure you want to delete this note ?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Yes
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                onConfirm(); // Call the confirmation callback
              },
              child: const SizedBox(
                width: 60,
                child: Text(
                  "Yes",
                  textAlign: TextAlign.center,
                ),
              )),
          //No
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const SizedBox(
                width: 60,
                child: Text(
                  "No",
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      ),
    );
  }
}
