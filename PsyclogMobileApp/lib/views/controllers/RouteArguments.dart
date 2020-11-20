import 'package:psyclog_app/src/models/Therapist.dart';

class TherapistRequestScreenArguments {
  final Therapist therapist;
  final bool currentUserApplied;

  TherapistRequestScreenArguments(this.therapist, this.currentUserApplied);
}