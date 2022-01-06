import 'package:chat_app/models/message.dart';
import 'package:hive/hive.dart';
part 'messages.g.dart';

@HiveType(typeId: 1)
class Messages extends HiveObject {
  @HiveField(0)
  List<Message> messages;

  Messages(this.messages);
}
