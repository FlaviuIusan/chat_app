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
              return Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        this.widget.subscription?.cancel();
                        commState.idTalkTo = key;
                        this.widget.callback!('talkingScreen');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Row(children: <Widget>[
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color((int.parse(key, radix: 35) * 0xFFFFFF).toInt()).withOpacity(1.0)),
                              borderRadius: BorderRadius.all(Radius.circular(35)),
                              color: Color((int.parse(key, radix: 35) * 0xFFFFFF).toInt()).withOpacity(1.0),
                            ),
                            child: Text(
                              key.substring(0, 2).toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            alignment: Alignment.center,
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  key,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              );
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
            FocusManager.instance.primaryFocus?.unfocus();
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
