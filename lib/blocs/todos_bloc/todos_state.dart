import 'package:equatable/equatable.dart';
import 'package:todo_bloc/models/todo.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosStateLoadInProgress extends TodosState {}

class TodosStateLoadSuccess extends TodosState {
  final List<Todo> todos;

  const TodosStateLoadSuccess([this.todos = const []]);

  @override
  List<Object> get props => [todos];

  @override
  String toString() => 'TodosStateLoadSuccess { todos: $todos }';
}

class TodosStateLoadFailure extends TodosState {}