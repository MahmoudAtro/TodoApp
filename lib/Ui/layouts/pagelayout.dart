import 'package:flutter/material.dart';
import 'package:todobloc/Ui/layouts/buttons.dart';

class Pagelayout extends StatelessWidget {
  const Pagelayout({super.key , required this.title, required this.body});
  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey[900],
        backgroundColor: Colors.teal,
        elevation: 1,
        title: Text(title , style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: body,
      backgroundColor: Colors.grey[700],
      // backgroundColor: Colors.white,

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           FloatButton(),
        ],
      ),
    ));
  }
}