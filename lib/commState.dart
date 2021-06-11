import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app/models/userAddress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/userRoute.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';

class CommState with ChangeNotifier {
  Socket? socket; // vezi SecureSocket
  List<RawDatagramSocket> socketsSendMulticast = <RawDatagramSocket>[];
  RawDatagramSocket? socketListenMulticast;
  InternetAddress multicastGroupAddress = InternetAddress("239.255.27.99");
  int multicastGroupPort = 27399;
  Map<String, UserRoute> networkUsers = {};

  List<Message> messages = []; //pe viitor in alt state, sunt necesare doar in screen-urile cu chat
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

  //multicast_dns package iterate over network interfaces ex: You can see an example of how to enumerate the interfaces and listen on the first address the interface uses and make sure you're joining multicast on that interface here: https://github.com/flutter/packages/blob/master/packages/multicast_dns/lib/multicast_dns.dart#L121-L152
  //wlan0 e interfata network pe android care se conecteaza la hotSpots(network prin wireless) sau care creeaza hotSpot
  //p2p-p2p0p0 e interfata network pe android care o foloseste pentru a creea hotSpot cand este deja conectat la un network prin wlan0
  //la windows Wi-Fi e interfata cu care se conecteaza, Local Area Connection* 3 pe care face hotSpot si Ethernet cu care se conecteaza prin cablu eth.
  //la lenovo wp0 la hotspot si wlan0 cand e conectat la wi-fi || wlan0 si p2p0 cand ambele activate
  // rezolvare: creez socket pentru toate interfetele , joinMulticast, send Datagram Hello si daca primesc raspuns inapoi atunci pastrez socket-ul altfel il inchid.

  //nu merge oricum, nu se adauga ruta, can trimit mesajul la multicast group device-ul nu stie unde sa trimita ? // de incercat cu openVPN addroute (Api Android)
  //-> ???? https://stackoverflow.com/questions/13221736/android-device-not-receiving-multicast-package IPv4 multicast support in android is poorely implemented. There are bugs from cupcake era still present.

  //de verificat pachetele cu wireshark

  //de incercat cu IPv6

  //fiecare client sa aiba un serverUDPsocket si sa primeasca acolo de la oricine mesaje, fiecare client face public port si ip la serveru sau (ce?)

  //pai daca nu ascult pe acelasi port pe care se trimit mesajele atunci cum sa le primesc... ggwp

  //la prima lansare a aplicatiei e nevoie de internet pentru a creea un ID unic, baza de date la un server cu toate id-urile create

  //ethernet/networkInterface nu functioneaza sa dea join multicast daca nu are enable IPv6??

  //adaugat de ales ID manual pana implementez firebase pentru alocare ID

  static const platform = const MethodChannel('first.flaviu.dev/multicastLock');

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

  Future<Iterable<NetworkInterface>> allInterfacesFactory(InternetAddressType type) {
    return NetworkInterface.list(
      includeLinkLocal: true,
      type: type,
      includeLoopback: true,
    );
  }

  void connectToMulticastGroup(String idManual) async {
    //listen cu un singur socket pe toate interfetele?
    //send trebuie pentru fiecare separat.
    //lock pentru android
    if (Platform.isAndroid) {
      var multicastLock = await platform.invokeMethod('multicastLock');
      print(multicastLock.toString());
    }

    socketListenMulticast = await RawDatagramSocket.bind(InternetAddress.anyIPv4, multicastGroupPort, reuseAddress: true, reusePort: false, ttl: 255);

    List<NetworkInterface> interfaces = (await allInterfacesFactory(InternetAddressType.IPv4)).toList();

    for (final NetworkInterface interface in interfaces) {
      try {
        InternetAddress interfaceAddress = interface.addresses[0];
        print(interfaceAddress.address.toString());
        RawDatagramSocket socket = await RawDatagramSocket.bind(
          interfaceAddress,
          0,
          reuseAddress: true,
          reusePort: false,
          ttl: 255,
        );
        socket.setRawOption(RawSocketOption(
          RawSocketOption.levelIPv4,
          RawSocketOption.IPv4MulticastInterface,
          interfaceAddress.rawAddress,
        ));
        socketsSendMulticast.add(socket);

        socketListenMulticast?.joinMulticast(this.multicastGroupAddress, interface);
      } catch (e) {
        print(e.toString());
      }
    }

    //socket.readEventsEnabled = true;
    // listenMulticastSocket.broadcastEnabled = true;
    socketListenMulticast?.listen((RawSocketEvent event) {
      log("listenBeforeEvent " + event.toString());
      if (event == RawSocketEvent.read) {
        final datagramPacket = socketListenMulticast?.receive();
        if (datagramPacket != null) {
          messages.add(Message('SomeoneElse', '00:00', String.fromCharCodes(datagramPacket.data)));
          print("Listened: " + String.fromCharCodes(datagramPacket.data));
          var dataObject;
          try {
            dataObject = jsonDecode(String.fromCharCodes(datagramPacket.data));
          } catch (e) {
            print(e.toString() + "Err jsonDecode");
          }
          if (dataObject != null) {
            //verifica daca id NU exista in networkUsers si atunci adauga la rute
            String idUser = dataObject['id'];
            String ipUser = dataObject['ip'];
            if (!networkUsers.containsKey(idUser)) {
              UserRoute userRoute = UserRoute.empty();

              userRoute.destinationIp = ipUser;
              userRoute.route.add(UserAddress(idUser, ipUser));

              networkUsers[idUser] = userRoute;
              inspect(userRoute);
              //nu mai trebuie ca astea sunt locale deci tot timpul lungime 1 |daca exista atunci verifica lungimea rutei primite, daca e mai scurta atunci update
              //daca nu exista atunci adaugi ruta
            }

            messages.add(Message('SomeoneElse', '00:00', dataObject['type'] + dataObject['text'] + dataObject['ip'] + dataObject['id']));
          }
          notifyListeners();
        }
      }
    });

    try {
      this.announcePresence(idManual);
    } catch (e) {
      print(e.toString() + 'Eroare ANOUNCE!!!');
    }
  }

  void sendMessageMulticastGroup(Message message) {
    for (final RawDatagramSocket socket in this.socketsSendMulticast) {
      socket.writeEventsEnabled = true;
      try {
        socket.send(message.text.codeUnits, this.multicastGroupAddress, this.multicastGroupPort);
      } catch (e) {
        print(e.toString());
      }
      print("Message send from" + socket.address.toString() + " : " + socket.port.toString() + "writeThisSocket:" + socket.writeEventsEnabled.toString() + " readListenSocket: ");
    }
    messages.add(message);
    notifyListeners();
  }

  void announcePresence(String idManual) {
    Message messageM = Message('Someone', '20:00', '');
    for (final RawDatagramSocket socket in this.socketsSendMulticast) {
      socket.writeEventsEnabled = true;
      String type = "announce";
      String text = "Hello network";
      String ip = socket.address.address.toString();
      final messageMap = {
        'type': type,
        'text': text,
        'ip': ip,
        'id': idManual,
      };
      final message = jsonEncode(messageMap);
      messageM.text = message;
      try {
        socket.send(message.codeUnits, this.multicastGroupAddress, this.multicastGroupPort);
      } catch (e) {
        print(e.toString() + "ERROARE inauntru ANNOUNCE");
      }
      print("Message send from" + socket.address.toString() + " : " + socket.port.toString() + "writeThisSocket:" + socket.writeEventsEnabled.toString() + " readListenSocket: ");
    }
    messages.add(messageM);
    notifyListeners();
  }

  // void handleListen(RawSocketEvent event, RawDatagramSocket listenMulticastSocket) {
  //   if (event == RawSocketEvent.read) {
  //     Datagram? datagram = listenMulticastSocket.receive();
  //     if (datagram == null) return;
  //     messages.add(Message('SomeoneElse', '00:00', String.fromCharCodes(datagram.data)));
  //     notifyListeners();
  //     log("ascult");
  //   }
  // }
}
