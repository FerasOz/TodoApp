import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/components/components.dart';
import 'package:todo_app/cubit/cubit/todo_cubit.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
      listener: (context, state){},
      builder: (context, state){
       var tasks = TodoCubit.get(context).newTasks;
        return  tasksBuilder(tasks: tasks);
      },
    );
  }
}
