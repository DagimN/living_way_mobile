// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'devotion_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DevotionItemAdapter extends TypeAdapter<DevotionItem> {
  @override
  final int typeId = 7;

  @override
  DevotionItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DevotionItem(
      id: fields[0] as String,
      title: fields[1] as String,
      subTitle: fields[2] as String,
      passage: fields[3] as Passage,
      assignedDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DevotionItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subTitle)
      ..writeByte(3)
      ..write(obj.passage)
      ..writeByte(4)
      ..write(obj.assignedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DevotionItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
