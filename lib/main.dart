import 'package:chat_app/talkingScreen.dart';
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
  String currentScreen = 'start';

  void callback(String currentScreen) {
    setState(() {
      this.currentScreen = currentScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final commState = Provider.of<CommState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      drawer: this.currentScreen == 'start'
          ? Drawer(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Connection Settings'),
                    onTap: () {
                      setState(() {
                        this.currentScreen = 'connectionSettings';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          : IconButton(
              onPressed: () {
                setState(() {
                  this.currentScreen = 'start';
                  Navigator.pop(context);
                });
              },
              icon: Icon(Icons.arrow_back)),
      body: this.currentScreen == 'start' ? TalkingScreen() : Options(this.callback),
    );
  }
}
