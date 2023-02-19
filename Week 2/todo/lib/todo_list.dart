import 'package:flutter/material.dart';
import 'package:todo/TODO.dart';
import 'package:todo/data.dart';

class TODOScreen extends StatefulWidget {
  const TODOScreen({super.key});

  @override
  State<TODOScreen> createState() => _TODOScreenState();
}

class _TODOScreenState extends State<TODOScreen> {
  DateTime? _date;
  late TODO newTodo;
  bool _tasksArrowDown = true;
  bool _completedArrowDown = true;

  var _todoList = <TODO>[];
  final _completedTodoList = <TODO>[];
  final _todoController = TextEditingController();

  _openModel() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Add Todo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 5,
                minLines: 1,
                controller: _todoController,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black45, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black45, width: 2.0))),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                      onPressed: _openDatePicker,
                      child: const Text(
                        'Select Date',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ))),
              Container(
                  padding: const EdgeInsets.only(top: 15),
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                      onPressed: _addTodo,
                      child: const Text(
                        'ADD',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ))),
            ]),
          );
        });
  }

  _closeDialogBox() {
    Navigator.of(context).pop();
  }

  _deleteTODO(TODO todo, list) {
    setState(() {
      list.remove(todo);
    });
    Navigator.of(context).pop();
  }

  _deleteDialog(int index, var list) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 16,
            // ignore: avoid_unnecessary_containers
            child: Container(
              decoration: const BoxDecoration(color: Colors.white54),
              padding: const EdgeInsets.all(4),
              width: MediaQuery.of(context).size.width * .5,
              height: MediaQuery.of(context).size.height * .15,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Delete?",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      TextButton(
                          onPressed: _closeDialogBox,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                        child: Container(),
                      ),
                      TextButton(
                          onPressed: () {
                            _deleteTODO(list[index], list);
                          },
                          child: const Text(
                            'Remove',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          )),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  _openDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        _date = value!;
      });
    });
  }

  _addTodo() {
    if (_todoController.text == '' || _date == null) {
      Navigator.of(context).pop();
    } else {
      newTodo = TODO(todo: _todoController.text, deadline: _date);
      setState(() {
        _todoList.add(newTodo);
      });
      _todoController.text = '';
      _date = null;
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _todoList = todoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "TODO APP",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: _openModel,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[400],
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(children: [
            InkWell(
              onTap: () {
                setState(() {
                  _tasksArrowDown = !_tasksArrowDown;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  border: !_tasksArrowDown
                      ? const Border()
                      : const Border(
                          bottom: BorderSide(color: Colors.black26, width: 1),
                        ),
                ),
                child: Row(children: [
                  RichText(
                    text: TextSpan(
                        text: "TODO",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15),
                        children: [
                          TextSpan(
                            text: " (${_todoList.length})",
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      _tasksArrowDown
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      size: 35,
                    ),
                  )
                ]),
              ),
            ),
            //todo list
            SizedBox(
              child: _todoList.isEmpty
                  ? _tasksArrowDown
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.all(15),
                          child: const Text("No TODO",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold)),
                        )
                  : _tasksArrowDown
                      ? Container()
                      : ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 7),
                              child: InkWell(
                                onLongPress: () {
                                  _deleteDialog(index, _todoList);
                                },
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.black12,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: ListTile(
                                      splashColor: Colors.black38,
                                      leading: const Icon(
                                        Icons.list_alt_rounded,
                                        color: Colors.black54,
                                        size: 30,
                                      ),
                                      contentPadding: const EdgeInsets.all(0),
                                      trailing: Checkbox(
                                        activeColor: Colors.black87,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0))),
                                        onChanged: (val) {
                                          setState(() {
                                            _todoList[index].setCompleted =
                                                val!;
                                            TODO temp = _todoList[index];
                                            _todoList.remove(temp);
                                            _completedTodoList.add(temp);
                                          });
                                        },
                                        value: _todoList[index].getCompleted,
                                      ),
                                      subtitle: Text(
                                        '${_todoList[index].deadline.day.toString()}-${_todoList[index].deadline.month.toString()}-${_todoList[index].deadline.year.toString()}',
                                        style: const TextStyle(
                                            color: Colors.black38),
                                      ),
                                      title: Text(
                                          '${_todoList[index].todo[0].toUpperCase()}${_todoList[index].todo.substring(1).toLowerCase()}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ))),
                                ),
                              ),
                            );
                          },
                          itemCount: _todoList.length,
                        ),
            ),

            //completed
            InkWell(
              onTap: () {
                setState(() {
                  _completedArrowDown = !_completedArrowDown;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                ),
                child: Row(children: [
                  RichText(
                    text: TextSpan(
                        text: "COMPLETED",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15),
                        children: [
                          TextSpan(
                            text: " (${_completedTodoList.length})",
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      _completedArrowDown
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      size: 35,
                    ),
                  )
                ]),
              ),
            ),
            //completed list
            SizedBox(
              child: _completedTodoList.isEmpty
                  ? _completedArrowDown
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.all(15),
                          child: const Text("No TODO",
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold)),
                        )
                  : _completedArrowDown
                      ? Container()
                      : ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 7),
                              child: InkWell(
                                onLongPress: () {
                                  _deleteDialog(index, _completedTodoList);
                                },
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.black12,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  child: ListTile(
                                      splashColor: Colors.black38,
                                      leading: const Icon(
                                        Icons.done_rounded,
                                        color: Colors.black54,
                                        size: 30,
                                      ),
                                      contentPadding: const EdgeInsets.all(0),
                                      trailing: Checkbox(
                                        activeColor: Colors.black87,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0))),
                                        onChanged: (val) {
                                          setState(() {
                                            _completedTodoList[index]
                                                .setCompleted = val!;
                                            TODO temp =
                                                _completedTodoList[index];
                                            _completedTodoList.remove(temp);
                                            _todoList.add(temp);
                                          });
                                        },
                                        value: _completedTodoList[index]
                                            .getCompleted,
                                      ),
                                      subtitle: Text(
                                          '${_completedTodoList[index].deadline.day.toString()}-${_completedTodoList[index].deadline.month.toString()}-${_completedTodoList[index].deadline.year.toString()}'),
                                      title: Text(
                                        '${_completedTodoList[index].todo[0].toUpperCase()}${_completedTodoList[index].todo.substring(1).toLowerCase()}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      )),
                                ),
                              ),
                            );
                          },
                          itemCount: _completedTodoList.length,
                        ),
            ),
          ]),
        ),
      ),
    );
  }
}
