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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String currentScreen = 'start';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        // try {
        //   final CommState commState = Provider.of<CommState>(context, listen: false);
        //   commState.closing = true;
        //   print("INACTIVEEE:-------------------------------\n----------------------------------------\n Value: " + commState.idMe);
        // } catch (e) {
        //   print("ERROARE INACTIVEEE: " + e.toString());
        // }
        break;
      case AppLifecycleState.paused:
        try {
          final CommState commState = Provider.of<CommState>(context, listen: false);
          commState.closing = true;
          print("PAUSEDDDDDDD:-------------------------------\n----------------------------------------\n Value: " + commState.idMe);
        } catch (e) {
          print("ERROARE PAUSED: " + e.toString());
        }
        break;
      case AppLifecycleState.detached:
        try {
          final CommState commState = Provider.of<CommState>(context, listen: false);
          commState.closing = true;
          print("DETACHEDDDD:-------------------------------\n----------------------------------------\n Value: " + commState.idMe);
        } catch (e) {
          print("ERROARE DETACHEEEDD: " + e.toString());
        }
        break;
      case AppLifecycleState.resumed:
        try {
          final CommState commState = Provider.of<CommState>(context, listen: false);
          commState.closing = false;
          print("RESUMEEEED:-------------------------------\n----------------------------------------\n Value: " + commState.idMe);
        } catch (e) {
          print("ERROARE RESUMEEEEDD: " + e.toString());
        }
        break;
    }
  }

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
