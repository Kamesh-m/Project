import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';
import 'package:todo/helper/color_constants.dart';
import 'package:todo/util/dialog_box.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  // text controller
  final _controller = TextEditingController();
  final _textController = TextEditingController();

  //checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask({fromFloating = false}) {
    setState(() {
    if (fromFloating) {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
      Navigator.of(context).pop();
    }else{
      db.toDoList.add([_textController.text, false]);
      _textController.clear();
    }
    db.updateDataBase();
    });
  }

  //create a new task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: () {
              saveNewTask(fromFloating: true);
            },
            onCancel: () {
              _controller.clear();
              Navigator.of(context).pop();
            }
          );
        });
  }

  //delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: ColorConstants.white,
          appBar: AppBar(
            backgroundColor: ColorConstants.white,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task,color: ColorConstants.black),
                SizedBox(width: 5),
                Text(
                  'ToDo List',
                  style: TextStyle(color: ColorConstants.black),
                ),
              ],
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              backgroundColor: ColorConstants.white,
              onPressed: createNewTask,
              child: const Icon(
                Icons.add,
                color: ColorConstants.black,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: db.toDoList.length,
                    itemBuilder: (context, index) {
                      return ToDoTile(
                        taskName: db.toDoList[index][0],
                        taskCompleted: db.toDoList[index][1],
                        onChanged: (value) => checkBoxChanged(value, index),
                        deleteFunction: (context) => deleteTask(index),
                      );
                    }),
              ),
              const SizedBox(
                height: 65,
              )
            ],
          ),
          bottomSheet: Container(
            decoration: const BoxDecoration(
                // color: whiteColor,
                color: ColorConstants.primary),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 15, left: 15, top: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textDirection: TextDirection.ltr,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _textController,
                      textAlign: TextAlign.start,
                      minLines: 1,
                      maxLines: 4,
                      autofocus: false,
                      decoration: InputDecoration(
                          suffixIconConstraints:
                              const BoxConstraints(maxHeight: 30),
                          suffixIcon: InkWell(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              saveNewTask();
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_task,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                )),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          filled: true,
                          // prefixIcon: const Icon(Icons.add_circle),
                          fillColor: Colors.white,
                          hintText: "  Enter your task...",
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Color.fromARGB(255, 110, 109, 109),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            gapPadding: 0.0,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              width: 0,
                              // color: chatTextFieldColor,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            gapPadding: 0.0,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              width: 0,
                              // color: chatTextFieldColor,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          )),
                      onFieldSubmitted: (text) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                          saveNewTask();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
