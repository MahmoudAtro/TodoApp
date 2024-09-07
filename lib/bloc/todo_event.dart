import 'package:flutter/material.dart';
import 'package:todobloc/shared/todo.dart';

@immutable
sealed class TodoEvent {}

class ShowtodoEvent extends TodoEvent {}

class ChangeStateTodo extends TodoEvent {
  final int index;
  ChangeStateTodo({required this.index});
}

class TodoDelete extends TodoEvent {
  final int index;

  TodoDelete({required this.index});
}

class AddToDoEvent extends TodoEvent {
  final Todo todo;
  final Duration todotime;

  AddToDoEvent({required this.todo, required this.todotime});
}

class TodoLoading extends TodoEvent {}
