import 'package:flutter/material.dart';
import 'package:todobloc/shared/todo.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

final class ShowTodo extends TodoState {
   final List<Todo> todolist;
   
   final int total;

   final int submit;


  ShowTodo({required this.todolist, required this.submit , required this.total});
}

class LoadingState extends TodoState {}

