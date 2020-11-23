import 'package:flutter/material.dart';
import 'package:psyclog_app/service/ClientServerService.dart';
import 'package:psyclog_app/service/util/ServiceErrorHandling.dart';
import 'package:psyclog_app/src/models/Appointment.dart';
import 'package:psyclog_app/src/models/PatientSchedule.dart';

class ClientAppointmentListViewModel extends ChangeNotifier {
  ClientServerService _serverService;

  List<Appointment> _appointmentList;
  List<DateTime> _dateTimeList;

  ClientAppointmentListViewModel() {
    _appointmentList = List<Appointment>();
    _dateTimeList = List<DateTime>();

    initializeService();
  }

  Appointment getAppointmentByIndex(int index) {
    return _appointmentList[index];
  }

  DateTime getDateTimeByIndex(int index) {
    return _dateTimeList[index];
  }

  int getAppointmentListLength() {
    if (_appointmentList.isNotEmpty)
      return _appointmentList.length;
    else
      return 0;
  }

  int getDateTimeListLength() {
    if (_dateTimeList.isNotEmpty)
      return _dateTimeList.length;
    else
      return 0;
  }

  initializeService() async {
    _serverService = await ClientServerService.getClientServerService();

    try {
      PatientSchedule _schedule = await _serverService.getAppointmentList();

      _appointmentList = _schedule.getAppointmentList as List<Appointment>;
      _dateTimeList = _schedule.getDateTimeList as List<DateTime>;

      print(_dateTimeList);

      if (_appointmentList.isNotEmpty) {
        print("Appointments are fetched successfully.");
        notifyListeners();
      } else {
        print("Appointment List is empty.");
      }
    } catch (error) {
      print(error);
      print(ServiceErrorHandling.serverNotRespondingError);
    }
  }
}
