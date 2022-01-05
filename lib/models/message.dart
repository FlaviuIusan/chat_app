import 'dart:collection';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2)
class Message extends HiveObject {
  @HiveField(0)
  String idRecipient = '';

  @HiveField(1)
  String idSender = '';

  @HiveField(2)
  String time = '20:00';

  @HiveField(3)
  String text = '';

  Message(this.idRecipient, this.idSender, this.time, this.text);

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
