import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todobloc/bloc/todo_bloc.dart';
import 'package:todobloc/bloc/todo_event.dart';
import 'package:todobloc/bloc/todo_state.dart';

// ignore: must_be_immutable
class Listtodo extends StatefulWidget {
  Listtodo({super.key});

  @override
  State<Listtodo> createState() => _ListtodoState();
}

class _ListtodoState extends State<Listtodo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TodoBloc>().add(ShowtodoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
      if (state is LoadingState) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurple,
          ),
        );
      }
      if (state is ShowTodo) {
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "${state.submit} / ${state.total}",
              style: TextStyle(
                  color: state.submit == state.total
                      ? Colors.greenAccent
                      : state.submit == 0
                          ? Colors.red[600]
                          : Colors.white,
                  fontSize: 30),
            ),
          ),
          Container(
            height: 400,
            child: ListView.builder(
                itemCount: state.todolist.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: state.todolist[index].color,
                    child: ListTile(
                        leading: Icon(state.todolist[index].icon),
                        title: Text(state.todolist[index].title),
                        subtitle: Text(state.todolist[index].date),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                                onPressed: () {
                                  context
                                      .read<TodoBloc>()
                                      .add(TodoDelete(index: index));
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () {
                                  context
                                      .read<TodoBloc>()
                                      .add(ChangeStateTodo(index: index));
                                },
                                icon: Icon(
                                  state.todolist[index].check
                                      ? Icons.check
                                      : Icons.close,
                                  color: state.todolist[index].check
                                      ? Colors.green
                                      : Colors.red,
                                ))
                          ],
                        )),
                  );
                }),
          )
        ]);
      }
      return SizedBox();
    });
  }
}
