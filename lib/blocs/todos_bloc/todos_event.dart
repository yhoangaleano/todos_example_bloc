import 'package:equatable/equatable.dart';
import 'package:todo_bloc/models/todo.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class TodosEventLoadSuccess extends TodosEvent {}

class TodosEventAdded extends TodosEvent {
  final Todo todo;

  const TodosEventAdded(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'TodosEventAdded { todo: $todo }';
}

class TodosEventUpdated extends TodosEvent {
  final Todo todo;

  const TodosEventUpdated(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'TodosEventUpdated { todo: $todo }';
}

class TodosEventDeleted extends TodosEvent {
  final Todo todo;

  const TodosEventDeleted(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'TodosEventDeleted { todo: $todo }';
}

class TodosEventClearCompleted extends TodosEvent {}

class TodosEventToggleAll extends TodosEvent {}
