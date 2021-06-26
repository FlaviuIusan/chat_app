import 'dart:collection';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

@JsonSerializable(explicitToJson: true)
class Message {
  String idRecipient = '';
  String idSender = '';
  String time = '20:00';
  String text = '';

  Message(this.idRecipient, this.idSender, this.time, this.text);

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
