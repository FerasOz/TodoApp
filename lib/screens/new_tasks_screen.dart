import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/components/components.dart';
import 'package:todo_app/cubit/cubit/todo_cubit.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) { return TodoCubit()..createDB(); },
      child: BlocConsumer<TodoCubit, TodoState>(
        listener: (BuildContext context, state) {
          if (state is TodoInsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, Object? state) {
          TodoCubit cubit = TodoCubit.get(context);
          return state is! TodoGetDataBaseLoadingState ? cubit.screens[cubit.currentIndex] : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
