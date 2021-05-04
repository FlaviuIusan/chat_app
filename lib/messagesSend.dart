import 'package:chat_app/commState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MessageSend extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final commState = Provider.of<CommState>(context);
    return Row(
      children: [
        Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'Aa'),
            ),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(Icons.accessible_forward_rounded),
        ),
      ],
    );
  }

}