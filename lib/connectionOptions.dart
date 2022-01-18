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
  StreamSubscription? subscription;

  Options(this.callback);

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  void dispose() {
    this.widget.subscription?.cancel();
    print("DISPOSEEEEEEEEEEE");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commState = Provider.of<CommState>(context);
    final textControllerId = TextEditingController();
    this.widget.subscription = commState.streamChangesToNetworkUsers.stream.listen((event) {
      if (mounted) {
        setState(() {});
      }
      print("Subscription Running");
    });
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(hintText: commState.idMe != '' ? commState.idMe : 'Id'),
          controller: textControllerId,
        ),
        Expanded(
            child: Container(
                child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: commState.networkUsers.length,
          itemBuilder: (BuildContext context, int index) {
            String key = commState.networkUsers.keys.elementAt(index);
            if (commState.networkUsers[key]!.destinationIp.compareTo('disconnected') != 0) {
              return TextButton(
                  onPressed: () {
                    //commState.screen = 'start';
                    this.widget.subscription?.cancel();
                    commState.idTalkTo = key;
                    this.widget.callback!('talkingScreen');
                  },
                  child: Text('UserId: ' + key + '  UserIp: ' + commState.networkUsers[key]!.destinationIp));
            } else {
              return Container(
                color: Colors.white,
                width: 0,
                height: 0,
              );
            }
          },
        ))),
        TextButton(
          onPressed: () async {
            /*commState.stateSecureSocket = await Socket.connect(
                textControllerIp.text, int.parse(textControllerPort.text));
            commState.listenMessage();
            */
            commState.connectToMulticastGroup(textControllerId.text);
            commState.startListenningForMessages();
          },
          child: Text("Descopera utilizatori"),
        ),
        TextButton(
          onPressed: () {
            commState.addLocalService();
          },
          child: Text("Creeaza retea"),
        ),
        TextButton(
          onPressed: () {
            commState.addServiceRequest();
          },
          child: Text("Cauta retea"),
        ),
      ],
    );
  }
}
