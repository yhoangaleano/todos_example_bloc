import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:todo_bloc/blocs/todos_bloc/todos_event.dart';
import 'package:todo_bloc/blocs/todos_bloc/todos_state.dart';
import 'package:todo_bloc/models/todo.dart';

import 'package:todos_repository_simple/todos_repository_simple.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepositoryFlutter todosRepository;

  TodosBloc({@required this.todosRepository})
      : super(TodosStateLoadInProgress());

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
    if (event is TodosEventLoadSuccess) {
      yield* _mapTodosLoadedToState();
    } else if (event is TodosEventAdded) {
      yield* _mapTodoAddedToState(event);
    } else if (event is TodosEventUpdated) {
      yield* _mapTodoUpdatedToState(event);
    } else if (event is TodosEventDeleted) {
      yield* _mapTodoDeletedToState(event);
    } else if (event is TodosEventToggleAll) {
      yield* _mapToggleAllToState();
    } else if (event is TodosEventClearCompleted) {
      yield* _mapClearCompletedToState();
    } 
  }

  Stream<TodosState> _mapTodosLoadedToState() async* {
    try {
      final todos = await this.todosRepository.loadTodos();
      yield TodosStateLoadSuccess(
        todos.map(Todo.fromEntity).toList(),
      );
    } catch (_) {
      yield TodosStateLoadFailure();
    }
  }

  Stream<TodosState> _mapTodoAddedToState(TodosEventAdded event) async* {
    if (state is TodosStateLoadSuccess) {
      final List<Todo> updatedTodos =
          List.from((state as TodosStateLoadSuccess).todos)..add(event.todo);
      yield TodosStateLoadSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapTodoUpdatedToState(TodosEventUpdated event) async* {
    if (state is TodosStateLoadSuccess) {
      final List<Todo> updatedTodos =
          (state as TodosStateLoadSuccess).todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      }).toList();
      yield TodosStateLoadSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapTodoDeletedToState(TodosEventDeleted event) async* {
    if (state is TodosStateLoadSuccess) {
      final updatedTodos = (state as TodosStateLoadSuccess)
          .todos
          .where((todo) => todo.id != event.todo.id)
          .toList();
      yield TodosStateLoadSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapToggleAllToState() async* {
    if (state is TodosStateLoadSuccess) {
      final allComplete =
          (state as TodosStateLoadSuccess).todos.every((todo) => todo.complete);
      final List<Todo> updatedTodos = (state as TodosStateLoadSuccess)
          .todos
          .map((todo) => todo.copyWith(complete: !allComplete))
          .toList();
      yield TodosStateLoadSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Stream<TodosState> _mapClearCompletedToState() async* {
    if (state is TodosStateLoadSuccess) {
      final List<Todo> updatedTodos = (state as TodosStateLoadSuccess)
          .todos
          .where((todo) => !todo.complete)
          .toList();
      yield TodosStateLoadSuccess(updatedTodos);
      _saveTodos(updatedTodos);
    }
  }

  Future _saveTodos(List<Todo> todos) {
    return todosRepository.saveTodos(
      todos.map((todo) => todo.toEntity()).toList(),
    );
  }
}
