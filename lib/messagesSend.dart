import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/commState.dart';
import 'package:chat_app/models/message.dart';

class MessageSend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final commState = Provider.of<CommState>(context);
    final textEditing = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(hintText: 'Aa'),
            controller: textEditing,
          ),
        ),
        IconButton(
          onPressed: () {
            //commState.sendMessage(Message('Me', '00:00', textEditing.text));
            commState.sendMessageMulticastGroup(
                Message('Me', '00:00', textEditing.text));
          },
          icon: Icon(Icons.accessible_forward_rounded),
        ),
      ],
    );
  }
}
