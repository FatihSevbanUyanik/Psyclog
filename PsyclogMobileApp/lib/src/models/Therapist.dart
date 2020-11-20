import 'package:psyclog_app/src/models/User.dart';
import 'package:psyclog_app/views/util/CapExtension.dart';

class Therapist extends User {
  final List<dynamic> _patients;
  final bool _isPsychologistVerified;
  final bool _isActiveForClientRequest;
  final int _appointmentPrice;

  get patients => _patients;
  get isVerified => _isPsychologistVerified;
  get isActive => _isActiveForClientRequest;
  get appointmentPrice => _appointmentPrice;

  Therapist.fromJson(Map<String, dynamic> parsedJson)
      : _patients = parsedJson['data']['user']['patients'] as List<dynamic>,
        _isPsychologistVerified =
            parsedJson['data']['user']['isPsychologistVerified'] as bool,
        _isActiveForClientRequest =
            parsedJson['data']['user']['isActiveForClientRequest'] as bool,
        _appointmentPrice =
            parsedJson['data']['user']['appointmentPrice'] as int,
        super.fromJson(parsedJson);

  Therapist.fromJsonForList(Map<String, dynamic> parsedJson)
      : _patients = parsedJson['patients'] as List<dynamic>,
        _isPsychologistVerified = parsedJson['isPsychologistVerified'] as bool,
        _isActiveForClientRequest =
            parsedJson['isActiveForClientRequest'] as bool,
        _appointmentPrice = parsedJson['appointmentPrice'] as int,
        super.fromJsonForList(parsedJson);

  String getFullName() {
    return userFirstName.toString().inCaps +
        " " +
        userSurname.toString().inCaps;
  }
}