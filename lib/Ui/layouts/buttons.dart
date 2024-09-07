import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todobloc/bloc/todo_bloc.dart';
import 'package:todobloc/bloc/todo_event.dart';
import 'package:todobloc/shared/todo.dart';
import 'package:intl/intl.dart';

class FloatButton extends StatefulWidget {
  FloatButton({super.key});

  @override
  State<FloatButton> createState() => _FloatButtonState();
}

class _FloatButtonState extends State<FloatButton> {
  final title = TextEditingController();
  final description = TextEditingController();
  final time = TextEditingController();
  final _key = GlobalKey<FormState>();

  Color _colorchange = Colors.blue; // افتراضي
  final ValueNotifier<Color> _colorNotifier = ValueNotifier<Color>(Colors.blue);

  final ValueNotifier<IconData> iconvalue =
      ValueNotifier<IconData>(Icons.check_box_outline_blank_sharp);

  TimeOfDay? todotime;
  Duration? deffirence;

  List<IconData> icons = [
    Icons.check_box_outline_blank_sharp,
    Icons.person,
    Icons.chat,
    Icons.mark_chat_read,
    Icons.book,
    Icons.sports_gymnastics,
    Icons.photo_library,
    Icons.camera,
    Icons.alarm,
    Icons.timer,
    Icons.food_bank,
    Icons.monetization_on,
    Icons.insert_link_sharp,
    Icons.play_arrow,
    Icons.add_box_rounded,
    Icons.today_outlined,
    Icons.account_balance_wallet_rounded,
    Icons.add_call,
    Icons.add_shopping_cart_sharp,
    Icons.ads_click_rounded
  ];

  Future<void> _selectedtime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context, initialTime: todotime ?? TimeOfDay.now());
    if (picked != null && picked != todotime) {
      print(picked);
      setState(() {
        todotime = picked;
      });
      final now = DateTime.now();
      final selectedtime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      deffirence = selectedtime.difference(now);
      final format = DateFormat("hh:mm a").format(
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute));
      time.text = format;
    }
  }

  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _colorchange,
              onColorChanged: (Color color) {
                setState(() {
                  _colorchange = color; // تحديث اللون
                });
                _colorNotifier.value = color; // تحديث ValueNotifier
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _pickIcon() async {
    return await showDialog<IconData>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick an Icon'),
          content: Container(
            width: double.maxFinite,
            height: 400, // يمكنك تعديل الارتفاع حسب الحاجة
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: icons.length,
              itemBuilder: (context, index) {
                return IconButton(
                  icon: Icon(icons[index]),
                  onPressed: () {
                    iconvalue.value = icons[index];
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  _showMyDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new ToDo'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: title,
                      autofocus: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        label: Text("Title"),
                      ),
                    ),
                    const SizedBox(height: 3),
                    TextFormField(
                      controller: time,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter time';
                        }
                        return null;
                      },
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        label: Text("Time"),
                      ),
                      onTap: () {
                        _selectedtime(context);
                      },
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "Color",
                          style: TextStyle(fontSize: 15),
                        ),
                        ValueListenableBuilder<Color>(
                          valueListenable: _colorNotifier,
                          builder: (context, color, child) {
                            return InkWell(
                              onTap: () {
                                pickColor(context);
                              },
                              child: Container(
                                width: 40,
                                height: 20,
                                color: color, // عرض اللون المحدد
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "icon",
                          style: TextStyle(fontSize: 15),
                        ),
                        ValueListenableBuilder<IconData>(
                          valueListenable: iconvalue,
                          builder: (context, color, child) {
                            return InkWell(
                              onTap: () {
                                _pickIcon();
                              },
                              child: Container(
                                width: 40,
                                height: 20,
                                child: Icon(iconvalue.value),
                              ),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق النافذة
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                if (_key.currentState!.validate()) {
                  context.read<TodoBloc>().add(AddToDoEvent(
                      todotime: deffirence!,
                      todo: Todo(
                        title: title.text,
                        date: time.text,
                        color: _colorNotifier.value, // استخدام اللون المحدد
                        icon: iconvalue.value,
                        check: false,
                      )));
                  Navigator.pop(context);
                  clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showMyDialog(context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      backgroundColor: Colors.blue[900],
    );
  }

  void clear() {
    title.clear();
    description.clear();
    time.clear();
    iconvalue.value = Icons.check_box_outline_blank_sharp;
    _colorNotifier.value = Colors.blue;
  }
}
