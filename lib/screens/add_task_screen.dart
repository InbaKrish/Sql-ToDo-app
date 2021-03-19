import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/db_helper.dart';
import 'package:todo_app/models/tasks_model.dart';

class AddTask extends StatefulWidget {
  final Tasks task;
  final Function updateTasks;
  AddTask({this.updateTasks, this.task});
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  String title;
  String priority;
  DateTime date = DateTime.now();

  TextEditingController dateController = TextEditingController();

  final List<String> priorities = ['Low', 'Medium', 'High'];
  final DateFormat _dateFormatter = DateFormat('MMM dd , yyyy');

  datePicker() async {
    final DateTime _date = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_date != null && _date != date) {
      setState(() {
        date = _date;
      });
      dateController.text = _dateFormatter.format(date);
    }
  }

  submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$title , $date , $priority');

      Tasks task = Tasks(title: title, date: date, priority: priority);
      if (widget.task == null) {
        task.status = 0;
        DbHelper.instance.insertTask(task);
      } else {
        task.id = widget.task.id;
        task.status = widget.task.status;
        DbHelper.instance.updateTask(task);
      }
      widget.updateTasks();
      Navigator.pop(context);
    }
  }

  delete() {
    DbHelper.instance.deleteTask(widget.task.id);
    widget.updateTasks();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task.title;
      date = widget.task.date;
      priority = widget.task.priority;
    }
    dateController.text = _dateFormatter.format(date);
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: MediaQuery.of(context).padding.top + 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.task == null ? 'Add Task' : 'Update Task',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                  labelText: 'Title',
                                  labelStyle: TextStyle(
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (value) =>
                                  (value.isEmpty) ? 'Enter yours task' : null,
                              initialValue: title,
                              onSaved: (value) => title = value,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: dateController,
                              onTap: datePicker,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                  labelText: 'Date',
                                  labelStyle: TextStyle(
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            DropdownButtonFormField(
                              icon: Icon(Icons.arrow_drop_down_circle),
                              iconSize: 22.0,
                              iconEnabledColor: Theme.of(context).primaryColor,
                              items: priorities.map((String p) {
                                return DropdownMenuItem(
                                    value: p,
                                    child: Text(
                                      p,
                                      style: TextStyle(
                                          color:
                                              (Theme.of(context).brightness ==
                                                      Brightness.dark)
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontSize: 18.0),
                                    ));
                              }).toList(),
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                  labelText: 'Priority',
                                  labelStyle: TextStyle(
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (value) => (priority == null)
                                  ? 'Please select the priority level'
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  priority = value;
                                });
                              },
                              value: priority,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Container(
                              height: 57.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(29)),
                              child: TextButton(
                                child: Text(
                                  widget.task == null ? 'Add' : 'Update',
                                  style: TextStyle(
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                onPressed: submit,
                              ),
                            ),
                            SizedBox(
                              height: 19,
                            ),
                            (widget.task != null)
                                ? Container(
                                    height: 57.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(29)),
                                    child: TextButton(
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      onPressed: delete,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
