import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';
import 'commState.dart';
import 'package:chat_app/models/message.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chat_app/database/messages.dart';

class TalkingScreen extends StatefulWidget {
  @override
  State<TalkingScreen> createState() => _TalkingScreenState();
}

class _TalkingScreenState extends State<TalkingScreen> {
  @override
  Widget build(BuildContext context) {
    final CommState commState = Provider.of<CommState>(context);
    final textEditing = TextEditingController();
    final ScrollController _scrollController = ScrollController();

    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: Hive.box<Messages>("messages").listenable(),
              builder: (context, Box<Messages> messagesDB, _) {
                var messagesWith = messagesDB.get(commState.idTalkTo);
                List<Message> messages = messagesWith != null ? messagesWith.messages : [];
                SchedulerBinding.instance!.addPostFrameCallback((_) {
                  if (_scrollController.hasClients == true) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
                });
                return ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: messages.length, // messages.count
                    itemBuilder: (BuildContext context, int index) {
                      final bool isMe = messages[index].idSender == commState.idMe;
                      return Align(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isMe ? Colors.lightGreen : Colors.white,
                            border: Border.all(color: Colors.black38),
                            borderRadius: isMe
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(15.0),
                                  )
                                : BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0),
                                  ),
                          ),
                          margin: isMe ? EdgeInsets.only(top: 5, bottom: 5, left: 60) : EdgeInsets.only(top: 5, bottom: 5, right: 60),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          isMe ? 'Me' : messages[index].idSender,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Text(
                                          DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) == DateTime(messages[index].time.year, messages[index].time.month, messages[index].time.day)
                                              ? " at " +
                                                  (messages[index].time.hour <= 9 ? '0' + messages[index].time.hour.toString() : messages[index].time.hour.toString()) +
                                                  ":" +
                                                  (messages[index].time.minute <= 9 ? '0' + messages[index].time.minute.toString() : messages[index].time.minute.toString())
                                              : " at " + messages[index].time.day.toString() + "/" + messages[index].time.month.toString() + "/" + messages[index].time.year.toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(messages[index].text,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      ); // sau messages[index].text( alte chestii: time,user,idk)
                    });
              }),
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
                    commState.sendMessageToUser(commState.idTalkTo, Message(commState.idTalkTo, commState.idMe, DateTime.now(), textEditing.text));
                    textEditing.clear();
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            )),
      ],
    );
  }
}
