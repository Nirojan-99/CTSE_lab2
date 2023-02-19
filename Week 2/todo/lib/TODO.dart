import 'package:flutter/cupertino.dart';

class TODO {
  late final todo;
  late final deadline;
  late final _steps = <String>[];
  bool _isCompleted = false;

  TODO({@required this.todo, @required this.deadline});

  set addStep(String step) {
    _steps.add(step);
  }

  bool removeStep(String step) => _steps.remove(step);

  set setCompleted(bool val) {
    _isCompleted = val;
  }

  bool get getCompleted => _isCompleted;

  List<String> get getSteps => _steps;
}
