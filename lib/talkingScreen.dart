import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';
import 'messagesBox.dart';
import 'messagesSend.dart';
import 'commState.dart';
import 'connectionOptions.dart';
import 'package:chat_app/models/message.dart';

class TalkingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CommState commState = Provider.of<CommState>(context);
    final textEditing = TextEditingController();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Text('Talking With(Id): ' + commState.idTalkTo),
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: commState.messages.length, // messages.count
                itemBuilder: (BuildContext context, int index) {
                  return Text(commState.messages[index].text); // sau messages[index].text( alte chestii: time,user,idk)
                }),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Aa'),
                    controller: textEditing,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    commState.sendMessageToUser(commState.idTalkTo, Message(commState.idTalkTo, commState.idMe, '00:00', textEditing.text));
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            )),
      ],
    );
  }
}
