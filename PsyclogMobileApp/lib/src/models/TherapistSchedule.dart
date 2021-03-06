import 'package:psyclog_app/src/models/TherapistAppointment.dart';

class TherapistSchedule {
  final List<TherapistAppointment> _appointments;
  final List<DateTime> _dateTimes;

  get getAppointmentList => _appointments;
  get getDateTimeList => _dateTimes;

  TherapistSchedule(this._appointments, this._dateTimes);
}