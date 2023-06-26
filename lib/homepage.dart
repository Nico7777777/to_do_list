import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list/database.dart';
import 'dialoguebox.dart';
import 'tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  final _controller = TextEditingController();
  int index = 0;

  @override
  void initState(){
    if( _myBox.get("TODOLIST") == null){
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }
  void checkBoxChanged(bool? value, int index)
  {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
  }

  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }
  void createNewTask(){
    showDialog(
      context: context,
      builder: (context) {
        return DialogueBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      }
    );
  }

  void removeTickedTasks(){
    setState(() {
      for(var el in db.toDoList){
        if(el[1]) {
          db.toDoList.remove(el);
        }
      }
    });
  }

  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// AppBar
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        title: Title(
          color: Colors.redAccent,
          child: const Text(
            'ToDo List',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        elevation: 0,
      ),

      /// AddButton
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.black,
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),

      /// Body
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: db.toDoList.length,
        itemBuilder: (context, index){
          return ToDoTile(
            text: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        }
      ),

      /// BottomNavigationBar
      bottomNavigationBar: Container(
        color: Colors.greenAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42.0, vertical:12.0),
          child: GNav(
            backgroundColor: Colors.greenAccent,
            activeColor: Colors.redAccent,
            tabBackgroundGradient: const RadialGradient(
              center: Alignment(0, 0), // near the top right
              radius: 1.3,
              colors: <Color>[
                Colors.blueAccent,
                Colors.lightBlueAccent,
              ],
              //stops: <double>[0.4, 1.0],
            ),
            tabBorder: const Border(
              top: BorderSide(color: Colors.green),
              left: BorderSide(color: Colors.green),
              right: BorderSide(color: Colors.green),
              bottom: BorderSide(color: Colors.green),
            ),
            gap: 6,
            onTabChange: (index){
              print(index);
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
                iconSize: 28,
                padding: EdgeInsets.all(8),
              ),
              /*GButton(
                icon: Icons.folder_delete,
                text: "Empty",
                iconSize: 28,
                padding: EdgeInsets.all(8),
                //onPressed: removeTickedTasks(),
              ),*/
              GButton(
                icon: Icons.settings,
                text: "Settings",
                iconSize: 28,
                padding: EdgeInsets.all(8),
              )
            ],

          ),
        ),
      ),
    );
  }
}
