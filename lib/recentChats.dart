import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'commState.dart';
import 'package:chat_app/models/message.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chat_app/database/messages.dart';

class RecentChats extends StatelessWidget {
  final Function? callback;

  RecentChats(this.callback);

  @override
  Widget build(BuildContext context) {
    final CommState commState = Provider.of<CommState>(context);
    return Column(children: <Widget>[
      Expanded(
        child: Container(
          child: ValueListenableBuilder(
              valueListenable: Hive.box<Messages>("messages").listenable(),
              builder: (context, Box<Messages> messagesDB, _) {
                var chats = messagesDB.values.toList();
                chats.sort((a, b) => a.lastMessageTime.compareTo(b.lastMessageTime));
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: chats.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                commState.idTalkTo = chats[index].key;
                                this.callback!('talkingScreen');
                              },
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      chats[index].key,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                      child: Text(
                                        chats[index].messages.last.text.substring(0, chats[index].messages.last.text.length > 20 ? 20 : chats[index].messages.last.text.length),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              }),
        ),
      ),
    ]);
  }
}
