// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    json['idRecipient'] as String,
    json['idSender'] as String,
    json['time'] as String,
    json['text'] as String,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'idRecipient': instance.idRecipient,
      'idSender': instance.idSender,
      'time': instance.time,
      'text': instance.text,
    };
