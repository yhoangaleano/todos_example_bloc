import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:todo_bloc/blocs/tab_bloc/tab_event.dart';
import 'package:todo_bloc/models/app_tab.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc() : super(AppTab.todos);

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is TabUpdated) {
      yield event.tab;
    }
  }
}