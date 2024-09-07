import 'package:flutter/material.dart';

class Todo {
  int? id;
  String title;
  String date;
  bool check;
  Color color;
  IconData icon;

  Todo(
    {
    this.id,
    required this.title,
    required this.date,
    required this.check,
    required this.color,
    required this.icon,
  });

  // تحويل كائن Todo إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'check': check ? 1 : 0,
      'color': color.value, // تخزين اللون كـ int
      'icon': icon.codePoint.toString(), // تخزين اسم الأيقونة كـ String
    };
  }

  // إنشاء كائن Todo من JSON
  factory Todo.fromJson(Map json) {
    return Todo(
      id: json["id"],
      title: json['title'],
      date: json['date'],
      check: json['check'] == 1 ? true : false,
      color: Color(json['color']), // تحويل int إلى Color
      icon: IconData(
        int.parse(json['icon']),
        fontFamily: 'MaterialIcons', // استخدم العائلة الصحيحة هنا
      ),
    );
  }
}
