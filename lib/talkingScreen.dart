import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';
import 'commState.dart';
import 'package:chat_app/models/message.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chat_app/database/messages.dart';

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
            child: ValueListenableBuilder(
                valueListenable: Hive.box<Messages>("messages").listenable(),
                builder: (context, Box<Messages> messagesDB, _) {
                  var messagesWith = messagesDB.get(commState.idTalkTo);
                  List<Message> messages = messagesWith != null ? messagesWith.messages : [];
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: messages.length, // messages.count
                      itemBuilder: (BuildContext context, int index) {
                        return Text(messages[index].text); // sau messages[index].text( alte chestii: time,user,idk)
                      });
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
