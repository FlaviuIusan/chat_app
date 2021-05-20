import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:chat_app/models/message.dart';

class CommState with ChangeNotifier {
  Socket? socket; // vezi SecureSocket
  RawDatagramSocket? datagramSocket;
  final InternetAddress multicastAddress = InternetAddress("239.10.10.100");
  final int multicastPort = 4545;

  List<Message> messages =
      []; //pe viitor in alt state, sunt necesare doar in screen-urile cu chat
  //lista de conectiuni posibile(available users)| pot verifica si doar cu 3 device-uri: pc-ul connectat la hotSpo huawei -->(send hello) pe broadcastul network-ului
  //huawei, huawei e client in network-ul lui(prima adresa o are) si raspunde inapoi la PC(pc-ul vede huawei-ul)+ huawei connectat la hotSpo lenovo atunci transmite
  // hello-ul PC-ului si pe network-ul lenovo-lui unde lenovo e client in network-ul lui(prima adresa o are) si raspunde inapoi la huawei si huawei raspunde la PC

  //cel care e hotSpot si e connectat la inca un network are 2 IP-uri Ip-ul in network-ul lui e x.x.x.1 si unde e connectat primeste unul.

  //cel care detine hotSpot sa fie server sau doar un intermediar temporar?

  //Internet Protocol version 6 (IPv6) does not implement this method of broadcast, and therefore does not define broadcast addresses. Instead, IPv6 uses multicast addressing to the all-hosts multicast group. No IPv6 protocols are defined to use the all-hosts address, though; instead, they send and receive on particular link-local multicast addresses. This results in higher efficiency because network hosts can filter traffic based on multicast address and do not need to process all broadcasts or all-hosts multicasts.

  //Multicast posibil folositor fiindca exista sanse ca broadcast-ul sa fie blocat de unele dispositive(sau de gasit de setat broadcast enabled idk)

  //udp vs tcp

  //anycast fara server sau unicast prin server(cel cu hotSpo)

  //cu anycast este nevoie de o tabela de rutare la fiecare client? cum se diferentiaza Ip-urile dintre 2 hotSpo? cum se descopera clientii intre ei si intre hotSpo
  //diferite?

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

  set stateDatagramSocket(RawDatagramSocket datagramSocket) {
    this.datagramSocket = datagramSocket;
  }

  void listenDatagramSocket() {
    this.datagramSocket?.joinMulticast(this.multicastAddress);
    this.datagramSocket?.listen((RawSocketEvent e) {
      Datagram? datagram = this.datagramSocket?.receive();
      if (datagram == null) return;
      messages.add(
          Message('SomeoneElse', '00:00', String.fromCharCodes(datagram.data)));
      notifyListeners();
    });
  }

  void sendMessageDatagramSocket(Message message) {
    this.datagramSocket?.send(
        message.text.codeUnits, this.multicastAddress, this.multicastPort);
    messages.add(message);
    notifyListeners();
  }
}
