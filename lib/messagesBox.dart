import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/commState.dart';

class MessageBox extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final commState = Provider.of<CommState>(context);
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: commState.messages.length, // messages.count
        itemBuilder: (BuildContext context, int index){
          return Text(commState.messages[index].text); // sau messages[index].text( alte chestii: time,user,idk)
        },
      ),
    );
  }

}

