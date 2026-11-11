import 'dart:async';

/// Holds the latest value and replays it to every new listener
/// (a tiny BehaviorSubject). Used by repositories to expose cached data.
class ValueStore<T> {
  ValueStore([T? initial]) : _value = initial;

  final _controller = StreamController<T>.broadcast();
  T? _value;
  Object? _error;

  T? get value => _value;
  bool get hasValue => _value != null;

  set value(T next) {
    _value = next;
    _error = null;
    _controller.add(next);
  }

  void addError(Object error, [StackTrace? stack]) {
    _error = error;
    _controller.addError(error, stack);
  }

  Stream<T> get stream async* {
    final current = _value;
    if (current != null) {
      yield current;
    } else if (_error != null) {
      throw _error!;
    }
    yield* _controller.stream;
  }

  Future<void> close() => _controller.close();
}
