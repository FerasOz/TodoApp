import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:todo_app/screens/new_tasks_screen.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());

   static TodoCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;


  List<Widget> screens = [
    NewTasksScreen(),
    // const DoneTasksScreen(),
    
    // const ArchivedTasksScreen(),
  ];

  List<String> names = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  late Database db;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  void changeIndex(int index){
    currentIndex = index;
    emit(TodoChangeBottomNavState());
  }

  //CREATE
  void createDB() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version){
        print('DataBase Created');
        db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)").then((value) {
          print('Table Created');
        }).catchError((error){
          print('Error when creating table : ${error.toString()}');
        });
      },
      onOpen: (db){
        getFromDB(db);
        print('DataBaseOpened');
      },
    ).then((value) {
      db = value;
      emit(TodoCreateDataBaseState());
    });
  }


  //INSERT
   insertInDB({
    required String title,
    required String date,
    required String time,
  }) async
  {
    await db.transaction((txn) {
      txn.rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      ).then((value){
        print('$value inserted successfully');
        emit(TodoInsertDataBaseState());

        getFromDB(db);
      }).catchError((error){
        print('Error When inserting new Record : ${error.toString()}');
      });
      return Future(() => null);
    });
  }

  void getFromDB(db) {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(TodoGetDataBaseLoadingState());

    db.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element){

        // print(element['status']);
        if(element['status'] == 'new') {
          newTasks.add(element);
        } else if(element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });

      emit(TodoGetDataBaseState());
    });
  }

  void updateDB({
  required String status,
  required int id,
}) async {
    await db.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id],
    ).then((value) {
      getFromDB(db);
      emit(TodoUpdateDataBaseState());
    });
}

  void deleteFromDB({
    required int id,
  }) async {
    await db.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value) {
      getFromDB(db);
      emit(TodoDeleteDataBaseState());
    });
  }

  void changeBottomSheetState({
    required bool isShown,
    required IconData icon
}){
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(TodoChangeBottomSheetState());
}


}
