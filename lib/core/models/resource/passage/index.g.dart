// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PassageAdapter extends TypeAdapter<Passage> {
  @override
  final int typeId = 8;

  @override
  Passage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Passage(
      book: fields[0] as Book,
    )
      ..bookIndex = fields[1] as int?
      ..translation = fields[2] as Translation?
      .._chapter = fields[3] as int?
      .._verse = fields[4] as int?
      .._toVerse = fields[5] as int?;
  }

  @override
  void write(BinaryWriter writer, Passage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.book)
      ..writeByte(1)
      ..write(obj.bookIndex)
      ..writeByte(2)
      ..write(obj.translation)
      ..writeByte(3)
      ..write(obj._chapter)
      ..writeByte(4)
      ..write(obj._verse)
      ..writeByte(5)
      ..write(obj._toVerse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PassageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
