import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit/todo_cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  bool isPassword = false,
  required Function? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool? isClickable,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      enabled: isClickable,
      obscureText: isPassword,
      onFieldSubmitted: (value) {
        return onSubmit!(value);
      },
      onChanged: (value) {
        return onChange!(value);
      },
      validator: (value) {
        return validate!(value);
      },
      onTap: () {
        return onTap!();
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget buildTasksItem(Map map, context) => Dismissible(
      key: Key(map['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                "${map['time']}",
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${map['title']}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  Text(
                    "${map['date']}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context).updateDB(status: 'done', id: map['id']);
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                TodoCubit.get(context)
                    .updateDB(status: 'archive', id: map['id']);
              },
              icon: const Icon(
                Icons.archive,
                color: Colors.black45,
              ),
            )
          ],
        ),
      ),
      onDismissed: (direction) {
        TodoCubit.get(context).deleteFromDB(id: map['id']);
      },
    );

Widget tasksBuilder({required List<Map> tasks}) {
  return ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (BuildContext context) => ListView.separated(
        itemBuilder: (context, index) => buildTasksItem(tasks[index], context),
        separatorBuilder: (context, index) => divider(),
        itemCount: tasks.length),
    fallback: (BuildContext context) => const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100.0,
            color: Colors.grey,
          ),
          Text(
            'No Tasks yet, Please Add some tasks',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget divider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey,
      ),
    );