// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslationAdapter extends TypeAdapter<Translation> {
  @override
  final int typeId = 9;

  @override
  Translation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Translation(
      name: fields[0] as String,
      status: fields[1] as TranslationStatus,
      path: fields[2] as String?,
      isDefault: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Translation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranslationStatusAdapter extends TypeAdapter<TranslationStatus> {
  @override
  final int typeId = 10;

  @override
  TranslationStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TranslationStatus.ready;
      case 1:
        return TranslationStatus.pending;
      case 2:
        return TranslationStatus.available;
      case 3:
        return TranslationStatus.undefined;
      default:
        return TranslationStatus.ready;
    }
  }

  @override
  void write(BinaryWriter writer, TranslationStatus obj) {
    switch (obj) {
      case TranslationStatus.ready:
        writer.writeByte(0);
        break;
      case TranslationStatus.pending:
        writer.writeByte(1);
        break;
      case TranslationStatus.available:
        writer.writeByte(2);
        break;
      case TranslationStatus.undefined:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
