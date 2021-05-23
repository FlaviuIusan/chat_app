import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/commState.dart';

class Options extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final commState = Provider.of<CommState>(context);
    final textControllerIp = TextEditingController();
    final textControllerPort = TextEditingController();
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: 'Ip'),
          controller: textControllerIp,
        ),
        TextField(
          decoration: InputDecoration(hintText: 'Port'),
          controller: textControllerPort,
        ),
        IconButton(
          onPressed: () async {
            /*commState.stateSecureSocket = await Socket.connect(
                textControllerIp.text, int.parse(textControllerPort.text));
            commState.listenMessage();
            */
            commState.stateDatagramSocket =
                await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
            commState.listenDatagramSocket();
          },
          icon: Icon(Icons.connect_without_contact),
        ),
      ],
    );
  }
}
