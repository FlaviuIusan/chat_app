import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/commState.dart';

class Options extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final commState = Provider.of<CommState>(context);
    final textControllerId = TextEditingController();
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: 'Id'),
          controller: textControllerId,
        ),
        Expanded(
            child: Container(
                child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: commState.networkUsers.length,
          itemBuilder: (BuildContext context, int index) {
            String key = commState.networkUsers.keys.elementAt(index);
            return Text(commState.networkUsers[key]!.destinationIp);
          },
        ))),
        IconButton(
          onPressed: () async {
            /*commState.stateSecureSocket = await Socket.connect(
                textControllerIp.text, int.parse(textControllerPort.text));
            commState.listenMessage();
            */
            commState.connectToMulticastGroup(textControllerId.text);
          },
          icon: Icon(Icons.connect_without_contact),
        ),
      ],
    );
  }
}
