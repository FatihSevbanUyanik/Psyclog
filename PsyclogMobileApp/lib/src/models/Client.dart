import 'package:psyclog_app/src/models/User.dart';

class Client extends User {
  final List<dynamic> _registeredPsychologists;
  final int _cash;

  get clientRegisteredPsychologists => _registeredPsychologists;
  get currentBalance => _cash;

  Client.fromJson(Map<String, dynamic> parsedJson)
      : _registeredPsychologists = parsedJson["data"]["user"]
            ["registeredPsychologists"] as List<dynamic>,
        _cash = parsedJson["data"]["user"]["cash"] as int,
        super.fromJson(parsedJson);

  Client.fromJsonForToken(Map<String, dynamic> parsedJson)
      : _registeredPsychologists = parsedJson["data"]["profile"]
            ["registeredPsychologists"] as List<dynamic>,
        _cash = parsedJson["data"]["profile"]["cash"] as int,
        super.fromJsonForToken(parsedJson);

}
