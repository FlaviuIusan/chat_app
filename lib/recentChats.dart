import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'commState.dart';
import 'package:chat_app/models/message.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chat_app/database/messages.dart';
import 'dart:math' as math;

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
                chats.sort((a, b) => b.messages.last.time.compareTo(a.messages.last.time));
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: chats.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                commState.idTalkTo = chats[index].key;
                                this.callback!('talkingScreen');
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
                                      border: Border.all(color: Color((int.parse(chats[index].key, radix: 35) * 0xFFFFFF).toInt()).withOpacity(1.0)),
                                      borderRadius: BorderRadius.all(Radius.circular(35)),
                                      color: Color((int.parse(chats[index].key, radix: 35) * 0xFFFFFF).toInt()).withOpacity(1.0),
                                    ),
                                    child: Text(
                                      chats[index].key.substring(0, 2).toUpperCase(),
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
                                          chats[index].key,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        Container(
                                          child: Text(chats[index].messages.last.text,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) == DateTime(chats[index].messages.last.time.year, chats[index].messages.last.time.month, chats[index].messages.last.time.day)
                                            ? (chats[index].messages.last.time.hour <= 9 ? '0' + chats[index].messages.last.time.hour.toString() : chats[index].messages.last.time.hour.toString()) +
                                                ":" +
                                                (chats[index].messages.last.time.minute <= 9 ? '0' + chats[index].messages.last.time.minute.toString() : chats[index].messages.last.time.minute.toString())
                                            : chats[index].messages.last.time.day.toString() + "/" + chats[index].messages.last.time.month.toString() + "/" + chats[index].messages.last.time.year.toString(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(''),
                                    ],
                                  ),
                                ]),
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
