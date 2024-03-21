import 'package:flutter/material.dart';

class GoalProvider extends ChangeNotifier {
  List<String> _goals = [];

  List<String> get goals => _goals;

  void addGoal(String goal) {
    _goals.add(goal);
    notifyListeners();
  }
}