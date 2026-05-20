// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationAdapter extends TypeAdapter<Notification> {
  @override
  final int typeId = 0;

  @override
  Notification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Notification(
      id: fields[0] as String,
      title: fields[1] as String,
      body: fields[2] as String,
      payload: fields[3] as String?,
      imageUrl: fields[4] as String?,
      isRead: fields[6] as bool,
      createdAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Notification obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.payload)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
