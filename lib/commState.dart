import 'dart:collection';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:chat_app/models/message.dart';


class CommState with ChangeNotifier {
  Socket? socket; // vezi SecureSocket
  
  List<Message> messages = []; //pe viitor in alt state, nu sunt necesare in meniuri
  //lista de conectiuni posibile(available users)
  
  set stateSecureSocket(Socket socket) {
    this.socket = socket;
    //notifyListeners();
  }

  void sendMessage(Message message) {
    this.socket?.writeln(message.text);
    messages.add(message);
    notifyListeners();
  }

  void listenMessage() {
    this.socket?.listen((var data) {
      messages.add(Message('SomeoneElse', '00:00', String.fromCharCodes(data)));
      notifyListeners();
    });
  }
}