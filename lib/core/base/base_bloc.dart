import 'package:ptecpos_mobile/core/base/base_subject_manager.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final subscription = CompositeSubscription();
  final SubjectManager subjectManager = SubjectManager();

  void dispose() {
    subscription.clear();
    subjectManager.dispose();
  }
}
