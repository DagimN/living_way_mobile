// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryAdapter extends TypeAdapter<Story> {
  @override
  final int typeId = 1;

  @override
  Story read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Story(
      id: fields[0] as String,
      sourceUrl: fields[1] as String,
      timestamp: fields[2] as DateTime,
      metadata: fields[4] as StoryMetadata?,
    )..isViewed = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, Story obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceUrl)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.isViewed)
      ..writeByte(4)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoryMetadataAdapter extends TypeAdapter<StoryMetadata> {
  @override
  final int typeId = 12;

  @override
  StoryMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryMetadata(
      title: fields[0] as String?,
      description: fields[1] as String?,
      image: fields[2] as String?,
      timeline: (fields[3] as List).cast<TimelineItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, StoryMetadata obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.timeline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimelineItemAdapter extends TypeAdapter<TimelineItem> {
  @override
  final int typeId = 13;

  @override
  TimelineItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimelineItem(
      timestamp: fields[0] as String?,
      reference: fields[1] as String?,
      type: fields[2] as TimelineItemType?,
    );
  }

  @override
  void write(BinaryWriter writer, TimelineItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.reference)
      ..writeByte(2)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimelineItemTypeAdapter extends TypeAdapter<TimelineItemType> {
  @override
  final int typeId = 14;

  @override
  TimelineItemType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TimelineItemType.link;
      case 1:
        return TimelineItemType.passage;
      case 2:
        return TimelineItemType.route;
      case 3:
        return TimelineItemType.undefined;
      default:
        return TimelineItemType.link;
    }
  }

  @override
  void write(BinaryWriter writer, TimelineItemType obj) {
    switch (obj) {
      case TimelineItemType.link:
        writer.writeByte(0);
        break;
      case TimelineItemType.passage:
        writer.writeByte(1);
        break;
      case TimelineItemType.route:
        writer.writeByte(2);
        break;
      case TimelineItemType.undefined:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimelineItemTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
