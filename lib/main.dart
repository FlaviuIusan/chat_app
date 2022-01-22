import 'package:chat_app/models/message.dart';
import 'package:chat_app/talkingScreen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';
import 'commState.dart';
import 'connectionOptions.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_app/database/messages.dart';
import 'package:chat_app/recentChats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(MessagesAdapter());
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Messages>("messages");
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
  String currentScreen = 'connectionOptions';

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
    final commState = Provider.of<CommState>(context);
    return Scaffold(
      appBar: AppBar(
        title: (() {
          switch (this.currentScreen) {
            case 'recentChats':
              return Text('Recent Chats');
            case 'connectionOptions':
              return Text('Connection Options');
            case 'talkingScreen':
              return Row(children: <Widget>[
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color((int.parse(commState.idTalkTo, radix: 35) * 0xFFFFFF).toInt()).withOpacity(1.0)),
                    borderRadius: BorderRadius.all(Radius.circular(35)),
                    color: Color((int.parse(commState.idTalkTo, radix: 35) * 0xFFFFFF).toInt()).withOpacity(1.0),
                  ),
                  child: Text(
                    commState.idTalkTo.substring(0, 2).toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                  ),
                  alignment: Alignment.center,
                ),
                SizedBox(width: 10.0),
                Text(
                  commState.idTalkTo,
                ),
              ]);
            default:
              return Text('Recent Chats');
          }
        })(),
        toolbarHeight: MediaQuery.of(context).size.height * 0.09,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.blue,
              child: Text('Chat App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white)),
              height: MediaQuery.of(context).size.height * 0.128,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment(-1, 0.45),
              padding: EdgeInsets.only(left: 16),
            ),
            ListTile(
              title: Text('Connection Options', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
              leading: Icon(Icons.settings_outlined),
              onTap: () {
                setState(() {
                  this.currentScreen = 'connectionOptions';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Recent Chats', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
              leading: Icon(Icons.message_outlined),
              onTap: () {
                setState(() {
                  this.currentScreen = 'recentChats';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: (() {
        switch (this.currentScreen) {
          case 'recentChats':
            return RecentChats(this.callback);
          case 'connectionOptions':
            return Options(this.callback);
          case 'talkingScreen':
            return TalkingScreen();
          default:
            return RecentChats(this.callback);
        }
      })(),
    );
  }
}
