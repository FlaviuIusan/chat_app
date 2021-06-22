import 'dart:io';

import 'package:chat_app/main.dart';
import 'package:chat_app/talkingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/commState.dart';
import 'dart:async';

class Options extends StatefulWidget {
  Function? callback;

  Options(this.callback);

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    final commState = Provider.of<CommState>(context);
    final textControllerId = TextEditingController();
    Timer.periodic(Duration(seconds: 4), (timer) {
      setState(() {});
    });
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
            return TextButton(
                onPressed: () {
                  //commState.screen = 'start';
                  commState.idTalkTo = key;
                  this.widget.callback!('start');
                },
                child: Text('UserId: ' + key + '  UserIp: ' + commState.networkUsers[key]!.destinationIp));
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
