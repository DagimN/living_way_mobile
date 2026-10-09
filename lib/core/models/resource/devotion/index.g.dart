// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DevotionAdapter extends TypeAdapter<Devotion> {
  @override
  final int typeId = 6;

  @override
  Devotion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Devotion(
      index: fields[0] as int,
      topic: fields[1] as String,
      description: fields[2] as String,
      items: (fields[4] as List).cast<DevotionItem>(),
      tags: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Devotion obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.topic)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DevotionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
