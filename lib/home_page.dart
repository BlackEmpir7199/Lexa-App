import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  DateTime selectedDate = DateTime.now();
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = DarwinInitializationSettings();  // Updated for iOS
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    localNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(Task task) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description', // Updated argument name
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();  // Updated for iOS
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await localNotificationsPlugin.zonedSchedule(
      0,
      task.title,
      task.description,
      tz.TZDateTime.from(task.time, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
      scheduleNotification(task);
    });
  }

  void _editTask(Task task, int index) {
    setState(() {
      tasks[index] = task;
      scheduleNotification(task);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan Your Day',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 20),
            CalendarWidget(
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: TaskTimeline(tasks: tasks),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Task? newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskForm()),
          );
          if (newTask != null) {
            _addTask(newTask);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Task {
  String title;
  DateTime time;
  String description;

  Task({required this.title, required this.time, required this.description});
}

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(Task) onEdit;
  final Function onDelete;

  TaskCard({required this.task, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              DateFormat('h:mm a').format(task.time),
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            SizedBox(height: 10),
            Text(
              task.description,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    onEdit(task);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    onDelete();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TaskForm extends StatefulWidget {
  final Task? task;

  TaskForm({this.task});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late DateTime _time;
  late String _description;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _time = widget.task!.time;
      _description = widget.task!.description;
    } else {
      _title = '';
      _time = DateTime.now();
      _description = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _time,
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _time = picked;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: DateFormat('yMMMd').format(_time),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Task task = Task(
                      title: _title,
                      time: _time,
                      description: _description,
                    );
                    Navigator.pop(context, task);
                  }
                },
                child: Text(widget.task != null ? 'Save' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  CalendarWidget({required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime.now().subtract(Duration(days: 365)),
      lastDay: DateTime.now().add(Duration(days: 365)),
      onDaySelected: (selectedDay, focusedDay) {
        onDateSelected(selectedDay);
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.white54,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(color: Colors.white),
        weekendTextStyle: TextStyle(color: Colors.white70),
      ),
    );
  }
}

class TaskTimeline extends StatelessWidget {
  final List<Task> tasks;

  TaskTimeline({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(
          task: tasks[index],
          onEdit: (task) async {
            Task? updatedTask = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskForm(task: task)),
            );
            if (updatedTask != null) {
              tasks[index] = updatedTask;
            }
          },
          onDelete: () {
            tasks.removeAt(index);
          },
        );
      },
    );
  }
}
