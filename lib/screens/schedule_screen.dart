import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
  Color _selectedColor = Colors.blue;

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) => _events[day] ?? [];

  void _addEvent() {
    if (_titleController.text.isNotEmpty && _selectedDay != null) {
      setState(() {
        _events[_selectedDay!] = [
          ...?_events[_selectedDay!],
          {
            'title': _titleController.text,
            'description': _descriptionController.text,
            'location': _locationController.text,
            'startTime': _startTime,
            'endTime': _endTime,
            'color': _selectedColor,
          },
        ];
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _showEventModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Event Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _selectTime(context, true),
                    child: Text('Start: ${_startTime.format(context)}'),
                  ),
                  TextButton(
                    onPressed: () => _selectTime(context, false),
                    child: Text('End: ${_endTime.format(context)}'),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Color:'),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => _selectedColor = Colors.blue),
                    child: CircleAvatar(backgroundColor: Colors.blue),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => _selectedColor = Colors.red),
                    child: CircleAvatar(backgroundColor: Colors.red),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => _selectedColor = Colors.green),
                    child: CircleAvatar(backgroundColor: Colors.green),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _addEvent();
                  Navigator.pop(context);
                },
                child: Text('Save Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) => setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            }),
            eventLoader: _getEventsForDay,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: _getEventsForDay(_selectedDay ?? _focusedDay).map((event) => Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: event['color']),
                  title: Text(event['title']),
                  subtitle: Text('${event['startTime'].format(context)} - ${event['endTime'].format(context)}\n${event['location']}'),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEventModal,
        child: Icon(Icons.add),
      ),
    );
  }
}