part of 'todo_cubit.dart';

@immutable
sealed class TodoState {}

final class TodoInitial extends TodoState {}

class TodoChangeBottomNavState extends TodoState{}

class TodoCreateDataBaseState extends TodoState{}

class TodoGetDataBaseState extends TodoState{}

class TodoUpdateDataBaseState extends TodoState{}

class TodoDeleteDataBaseState extends TodoState{}

class TodoGetDataBaseLoadingState extends TodoState{}

class TodoInsertDataBaseState extends TodoState{}

class TodoChangeBottomSheetState extends TodoState{}