import 'package:flutter/material.dart';
import 'package:todo/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DialogBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.add_circle),
          SizedBox(
            width: 5,
          ),
          Text(
            "Add Task",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
      content: SizedBox(
        height: 180,
        child: Column(
          children: [
            //get user input
            TextField(
              controller: controller,
              maxLines: 3,
              minLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //button => save + cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //cancel button
                MyButton(text: "Cancel", onPressed: onCancel),
                const SizedBox(
                  width: 8,
                ),
                //save button
                MyButton(text: "Save", onPressed: onSave),
              ],
            )
          ],
        ),
      ),
    );
  }
}

