import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/db_helper.dart';
import 'package:todo_app/models/tasks_model.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/screens/set_theme_screen.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  Future<List<Tasks>> tasksList;
  final DateFormat _dateFormatter = DateFormat('MMM dd , yyyy');

  @override
  void initState() {
    super.initState();
    updateTasksList();
  }

  updateTasksList() {
    setState(() {
      tasksList = DbHelper.instance.getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 12,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTask(updateTasks: updateTasksList))),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 8, vertical: MediaQuery.of(context).padding.top + 3),
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    iconSize: 30,
                    alignment: Alignment.topCenter,
                    icon: Icon(Icons.playlist_add),
                    onPressed: () {},
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 4,
                  // ),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      "2 Do's",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ),
                  IconButton(
                    iconSize: 25,
                    alignment: Alignment.topCenter,
                    icon: Icon(Icons.brush_outlined),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => setTheme()));
                    },
                  ),
                ],
              ),
            ),
            _displayTasks()
          ],
        ),
      ),
    );
  }

  Widget _displayTasks() {
    return Expanded(
      child: FutureBuilder(
          future: tasksList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //print(snapshot.data[0]);
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) {
                  return buildTasks(snapshot.data[index]);
                });
          }),
    );
  }

  Widget buildTasks(Tasks task) {
    print(task);
    return Column(
      children: [
        ListTile(
          title: Text(
            task.title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: (task.status == 0)
                    ? TextDecoration.none
                    : TextDecoration.lineThrough),
          ),
          subtitle: Text(
            '${_dateFormatter.format(task.date)} * ${task.priority}',
            style: TextStyle(
                fontSize: 12,
                decoration: (task.status == 0)
                    ? TextDecoration.none
                    : TextDecoration.lineThrough),
          ),
          trailing: Checkbox(
              value: (task.status == 0) ? false : true,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                task.status = value ? 1 : 0;
                DbHelper.instance.updateTask(task);
                updateTasksList();
              }),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        AddTask(task: task, updateTasks: updateTasksList)));
          },
        ),
        Divider()
      ],
    );
  }
}
