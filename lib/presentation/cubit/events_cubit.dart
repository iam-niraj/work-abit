import 'package:bloc/bloc.dart';
import '../../data/models/tasks.dart';
import '../../data/repositories/task_repositories';

part 'events_state.dart';

class EventsCubit extends Cubit<TodoState> {
  final EventsRepository _eventsRepository;
  EventsCubit(this._eventsRepository) : super(TodoInitial());

  Future<void> getData() async {
    try {
      List<Task> data = await _eventsRepository.getAllTodos();
      emit(TodoLoaded(events: data));
    } on Exception {
      emit(TodoError(
          message: "Could not fetch the list, please try again later!"));
    }
  }

  Future<void> addData(Task task) async {
    try {
      final state = this.state;
      await _eventsRepository.insertTodo(task);
      if (state is TodoLoaded) {
        getData();
      }
    } on Exception {
      emit(TodoError(message: "Could`nt add todo"));
    }
  }

  Future deleteData(index) async {
    try {
      final state = this.state;
      await _eventsRepository.deleteTodo(index);
      if (state is TodoLoaded) {
        getData();
      }
    } on Exception {
      emit(TodoError(message: "Could'nt add todo"));
    }
  }

  Future updateData(index) async {
    try {
      final state = this.state;
      if (state is TodoLoaded) {
        await _eventsRepository.updateTodo(index);
        getData();
      }
    } on Exception {
      emit(TodoError(message: "Could'nt add todo"));
    }
  }
}
