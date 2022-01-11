// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 2;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      fields[0] as String,
      fields[1] as String,
      fields[2] as DateTime,
      fields[3] as String,
    )..alreadySendToIds = (fields[4] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idRecipient)
      ..writeByte(1)
      ..write(obj.idSender)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.alreadySendToIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    json['idRecipient'] as String,
    json['idSender'] as String,
    DateTime.parse(json['time'] as String),
    json['text'] as String,
  )..alreadySendToIds = (json['alreadySendToIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList();
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'idRecipient': instance.idRecipient,
      'idSender': instance.idSender,
      'time': instance.time.toIso8601String(),
      'text': instance.text,
      'alreadySendToIds': instance.alreadySendToIds,
    };
