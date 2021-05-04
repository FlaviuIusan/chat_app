import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';
import 'messagesBox.dart';
import 'messagesSend.dart';
import 'commState.dart';
import 'connectionOptions.dart';

void main() {  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => CommState(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  String screen = 'start';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      drawer: this.screen == 'start' ? Drawer(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Connection Settings'),
              onTap: () {
                setState(() {
                  this.screen = 'connectionSettings';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ) : IconButton(onPressed: () { setState((){ this.screen = 'start'; Navigator.pop(context);  }); }, icon: Icon(Icons.arrow_back)),
      body: this.screen == 'start' ? Column(
        children: [
          Expanded(
              child: MessageBox(),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: MessageSend(),
          ),
      ],) : Options(),
    );
  }
}