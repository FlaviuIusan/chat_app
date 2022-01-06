// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessagesAdapter extends TypeAdapter<Messages> {
  @override
  final int typeId = 1;

  @override
  Messages read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Messages(
      (fields[0] as List).cast<Message>(),
    );
  }

  @override
  void write(BinaryWriter writer, Messages obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
