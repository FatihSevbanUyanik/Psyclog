import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:psyclog_app/service/SocketService.dart';
import 'package:psyclog_app/service/util/ServiceErrorHandling.dart';
import 'package:psyclog_app/src/models/Contact.dart';
import 'package:psyclog_app/src/models/Message.dart';
import 'package:psyclog_app/src/models/Patient.dart';
import 'package:psyclog_app/views/util/DateParser.dart';
import 'package:psyclog_app/views/util/ViewConstants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ClientMessageListViewModel extends ChangeNotifier {
  List<Contact> contactList;
  List chatList;
  BuildContext context;

  // List<Message> messages = List<Message>();
  SocketService _socketService;
  IO.Socket _socket;

  ClientMessageListViewModel(this.context);

  initializeService() async {
    contactList = List<Contact>();
    chatList = List<dynamic>();

    try {
      _socketService = await SocketService.getSocketService();
      _socket = _socketService.getSocket;
      await _activateUser();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _activateUser() async {
    final String userToken = await _socketService.getToken();

    if (userToken != null) {
      try {
        activateUser(userToken);
        _socket.clearListeners();
        setChat();
        setMessageSeenList();
        setLastMessagePerChat();
      } catch (e) {
        print(e);
      }
    } else {
      throw ServiceErrorHandling.noTokenError;
    }
  }

  void activateUser(String userToken) {
    _socket.emit("activateUser", {"accessToken": userToken});
    print("User is activated");
  }

  void setChat() {
    _socket.on("chats", (chats) {
      chatList = chats as List;

      contactList = List<Contact>();

      for (var value in chatList) {
        contactList.add(Contact(
            value["_id"],
            value["psychologist"]["isActive"],
            value["psychologist"]["_id"],
            value["psychologist"]["username"],
            value["psychologist"]["name"],
            value["psychologist"]["profileImage"],
            value["patient"],
            value["createdAt"],
            value["updateAt"],
            Message.message(
                value["lastMessage"]["isSeen"],
                value["lastMessage"]["_id"],
                value["lastMessage"]["message"],
                value["lastMessage"]["contact"],
                value["lastMessage"]["author"],
                value["lastMessage"]["chat"],
                value["lastMessage"]["createdAt"],
                value["lastMessage"]["updatedAt"],
                null)));
      }
      _socket.off("chats");

      // Listening events on userIDs
      for (Contact contact in contactList) {
        _socket.on(contact.getPsychologistID, (status) {
          contact.isActive = status;
          notifyListeners();
        });
      }

      sortContactList();
      notifyListeners();
      return;
    });
  }

  int getContactListLength() {
    return contactList.length;
  }

  Contact getContactByIndex(int index) {
    return contactList[index];
  }

  void sortContactList() {
    final String userID = (_socketService.currentUser as Patient).userID;

    contactList.sort((a, b) {
      if (a.lastMessage.isSeen == b.lastMessage.isSeen && a.lastMessage.getAuthorID != userID) {
        DateTime aDate = DateParser.jsonToDateTimeWithClock(a.lastMessage.createdAt);
        DateTime bDate = DateParser.jsonToDateTimeWithClock(b.lastMessage.createdAt);

        if (aDate.isAfter(bDate)) {
          return -1;
        } else if (bDate.isAfter(aDate)) {
          return 1;
        } else {
          return 0;
        }
      } else if (!a.lastMessage.isSeen && a.lastMessage.getAuthorID != userID) {
        return -1;
      } else {
        return 1;
      }
    });
  }

  void setMessageSeenList() {
    _socket.on("message-seen-list", (lastMessage) {
      print(lastMessage);
      final chatID = lastMessage["chat"];

      print("message seen list!!!!");

      //contactList.singleWhere((element) => element.getChatID == chatID).lastMessage = lastMessage["message"];
      notifyListeners();
    });
    print("Message Seen List socket listener is created");
  }

  bool isSeenByIndex(int index) {
    Contact indexedContact = contactList[index];

    return indexedContact.lastMessage != null &&
        indexedContact.lastMessage.getAuthorID != (_socketService.currentUser as Patient).userID &&
        !indexedContact.lastMessage.isSeen;
  }

  int getNotSeenCount() {
    int notSeenCount = 0;

    if (contactList != null)
      for (Contact contact in contactList) {
        if (!contact.lastMessage.isSeen && contact.lastMessage.getAuthorID != (_socketService.currentUser as Patient).userID)
          notSeenCount++;
      }

    return notSeenCount;
  }

  void setLastMessagePerChat() {
    _socket.on("message", (message) {
      Message newMessage = Message.messageWithOwner(
          message["isSeen"],
          message["_id"],
          message["message"],
          MessageOwner(message["author"]["_id"], message["author"]["username"], message["author"]["name"],
              message["author"]["profileImage"]),
          message["contact"],
          message["chat"],
          message["createdAt"],
          message["updatedAt"],
          null);

      Flushbar(
        margin: EdgeInsets.all(14),
        borderRadius: 8,
        leftBarIndicatorColor: ViewConstants.myLightBlue,
        icon: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: CircleAvatar(
            radius: 24,
            backgroundImage: (Image.network(newMessage.messageOwner.profileImage + "/people/1")).image,
          ),
        ),
        title: "",
        titleText: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: AutoSizeText(newMessage.messageOwner.name + " (@" + newMessage.messageOwner.username + ")"),
        ),
        messageText: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: AutoSizeText(newMessage.text),
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.decelerate,
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: ViewConstants.myBlack,
        duration: Duration(seconds: 3),
      )..show(context);

      contactList.singleWhere((element) => element.getChatID == message["chat"]).lastMessage = newMessage;
      sortContactList();
      notifyListeners();
    });
    print("Last Message socket listener is created.");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _socket.clearListeners();
  }
}
