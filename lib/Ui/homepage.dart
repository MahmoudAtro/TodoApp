import 'package:flutter/material.dart';
import 'package:todobloc/Ui/layouts/pagelayout.dart';
import 'package:todobloc/Ui/todolist.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Pagelayout(title: "My ToDo", 
    body: Listtodo(),
    
    );
  }
}