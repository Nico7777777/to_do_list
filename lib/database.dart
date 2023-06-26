import 'package:hive/hive.dart';

class ToDoDataBase{
  List toDoList = [];
  final _myBox = Hive.box('mybox');

  /// first time run
  void createInitialData(){
    toDoList = [
      ["You can add", false],
      ["a new task", false],
      ["by pressing the", false],
      ["right-bottom button", false],
    ];
  }

  /// load database
  void loadData(){
    toDoList = _myBox.get("TODOLIST");
  }

  /// update database
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}