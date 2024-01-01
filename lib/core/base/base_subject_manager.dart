import 'package:rxdart/rxdart.dart';

class SubjectManager {
  final Map<String, BehaviorSubject<dynamic>> _subject = {};

  BehaviorSubject<T> createSubject<T>({required String key, T? seedValue}) {
    if (!_subject.containsKey(key)) {
      if (seedValue != null) {
        return _subject[key] = BehaviorSubject<T>.seeded(seedValue);
      } else {
        return _subject[key] = BehaviorSubject<T>();
      }
    }
    return _subject[key] as BehaviorSubject<T>;
  }
  BehaviorSubject<T?> createNullableSubject<T>({required String key, T? seedValue}) {
    if (!_subject.containsKey(key)) {
      if (seedValue != null) {
        return _subject[key] = BehaviorSubject<T?>.seeded(seedValue);
      } else {
        return _subject[key] = BehaviorSubject<T?>();
      }
    }
    return _subject[key] as BehaviorSubject<T?>;
  }

  void dispose() {
    for (var subject in _subject.values) {
      subject.close();
    }
    _subject.clear();
  }
}
