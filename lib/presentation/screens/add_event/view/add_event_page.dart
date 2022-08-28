import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/data/repositories/repositories.dart';
import 'package:flutter_calendar/domain/entities/entities.dart';
import 'package:flutter_calendar/domain/usecases/usecases.dart';
import 'package:flutter_calendar/presentation/screens/add_event/bloc/add_event_bloc.dart';
import 'package:flutter_calendar/presentation/utils/utils.dart';
import 'package:uuid/uuid.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../widgets/widgets.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => AddEventBloc(
          eventsUsecases: context.read<EventsUseCases>(),
        ),
        child: const AddTaskPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddEventBloc, AddEventState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == AddEventStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: AddTaskScreen(),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime _selectedDate = DateTime.now();

  String _endTime = "9:30 PM";

  int _selectedRemind = 5;

  int _selectedColor = 0;

  TimeOfDay _timeOfDay = TimeOfDay.now();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  String _selectedRepeat = "None";

  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  @override
  Widget build(BuildContext context) {
    /* final localizations = MaterialLocalizations.of(context);
    final formattedTimeOfDay = localizations.formatTimeOfDay(_timeOfDay); */
    return Scaffold(
      /* appBar: MyAppBar(
        widget: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ), */
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Task", style: headingStyle),
              InputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: InputField(
                    title: "Start Time",
                    hint: _timeOfDay.format(context),
                    widget: IconButton(
                      onPressed: () async {
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: const Icon(Icons.access_time_rounded),
                    ),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: InputField(
                    title: "End Time",
                    hint: _endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: const Icon(Icons.access_time_rounded),
                    ),
                  ))
                ],
              ),
              InputField(
                title: "Remind",
                hint: "Remind $_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 32,
                  elevation: 4,
                  style: subtitleStyle,
                  underline: Container(
                    height: 0,
                  ),
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? newRemindValue) {
                    setState(() {
                      _selectedRemind = int.parse(newRemindValue!);
                    });
                  },
                ),
              ),
              InputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconSize: 32,
                  elevation: 4,
                  style: subtitleStyle,
                  underline: Container(
                    height: 0,
                  ),
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(
                        value!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newRepeatValue) {
                    setState(() {
                      _selectedRepeat = newRepeatValue!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(
                    label: "Create Event",
                    onTap: () => _validateDate(),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      if (kDebugMode) {
        print("Please select Valid date or something went wrong");
      }
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    _timeOfDay = await _showTimePicker() ?? TimeOfDay.now();
    String _formattedTime = _timeOfDay.format(context);
    if (isStartTime == true) {
      setState(() {
        _timeOfDay;
      });
    } else if (isStartTime == false) {
      _timeOfDay;
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay.fromDateTime(
          DateTime.now().add(
            Duration(minutes: 1),
          ),
        ));
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: pinkClr,
          ),
          colorText: pinkClr);
    }
  }

  _addTaskToDb() async {
    print(_timeOfDay);
    var value = EventEntity(
      id: Uuid().v4(),
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: _selectedDate,
      startTime: _timeOfDay,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
    );
    context.read<AddEventBloc>().add(AddEventEvent(event: value));
  }
}
