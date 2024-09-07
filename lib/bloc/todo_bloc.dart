import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todobloc/bloc/todo_event.dart';
import 'package:todobloc/bloc/todo_state.dart';
import 'package:todobloc/database/sqflite.dart';
import 'package:todobloc/shared/notification_helper.dart';
import 'package:todobloc/shared/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  List<Todo> todolist = [];

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

  SqlDb database = SqlDb();

  static int submit = 0;
  TodoBloc() : super(TodoInitial()) {
    on<TodoEvent>((event, emit) async {
      if (event is ShowtodoEvent) {
        emit(LoadingState());
        List<Map> response = await database.read();
        todolist = response.map((e) => Todo.fromJson(e)).toList();
        for (Todo item in todolist) {
          item.check ? submit += 1 : submit;
        }
        emit(ShowTodo(
            todolist: todolist, total: todolist.length, submit: submit));
      }

      if (event is ChangeStateTodo) {
        todolist[event.index].check = !todolist[event.index].check;
        todolist[event.index].check ? submit += 1 : submit -= 1;
        await database.update({
          'check': todolist[event.index].check,
        }, "id = ${todolist[event.index].id}");
        emit(ShowTodo(
            todolist: todolist, total: todolist.length, submit: submit));
      }

      if (event is TodoDelete) {
        todolist[event.index].check ? submit -= 1 : submit;
        NotificationHelper.cancelNotification(todolist[event.index].id!);
        await database.delete("id = ${todolist[event.index].id}");
        todolist.removeAt(event.index);
        emit(ShowTodo(
            todolist: todolist, submit: submit, total: todolist.length));
      }

      if (event is AddToDoEvent) {
        int response = await database.insert(event.todo.toJson());
        List<Map> responsevalue = await database.read();
        todolist = responsevalue.map((e) => Todo.fromJson(e)).toList();
        NotificationHelper.schedulNotification(
            "you must complate Todo", event.todo.title, event.todotime.inMinutes, response);
        emit(ShowTodo(
            todolist: todolist, submit: submit, total: todolist.length));
      }
    });
  }
}
