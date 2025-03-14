import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/components/components.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/cubit/todo_cubit.dart';

class TodoLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  TodoLayout({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDB(),
      child: BlocConsumer<TodoCubit, TodoState>(
        listener: (BuildContext context, state) {
          if (state is TodoInsertDataBaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, Object? state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.names[cubit.currentIndex],
              ),
            ),
            body: state is! TodoGetDataBaseLoadingState ? cubit.screens[cubit.currentIndex] : const Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate()){
                    cubit.insertInDB(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text
                    );
                  }
                }else{
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (String value){
                                  if(value.isEmpty){
                                    return 'title must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Title',
                                prefix: Icons.title
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                                controller: timeController,
                                type: TextInputType.datetime,
                                validate: (String value){
                                  if(value.isEmpty){
                                    return 'Time must not be empty';
                                  }
                                  return null;
                                },
                                onTap: (){
                                  showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now()
                                  ).then((value){
                                    timeController.text = value!.format(context).toString();
                                  });
                                },
                                label: 'Time',
                                prefix: Icons.watch_later_outlined
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                                controller: dateController,
                                type: TextInputType.datetime,
                                validate: (String value){
                                  if(value.isEmpty){
                                    return 'Date must not be empty';
                                  }
                                  return null;
                                },
                                onTap: (){
                                  showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse("2025-03-14"),
                                  ).then((value) {
                                    dateController.text = DateFormat().add_yMMMd().format(value!);
                                  });
                                },
                                label: 'Date',
                                prefix: Icons.calendar_today_outlined
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 30.0,
                  ).closed.then((value) {
                   cubit.changeBottomSheetState(isShown: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 50.0,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.menu
                  ),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.check_circle_outline
                  ),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                      Icons.archive_outlined
                  ),
                  label: "Archived",
                ),
              ],
            ),
          );
        },

      ),
    );
  }

}
