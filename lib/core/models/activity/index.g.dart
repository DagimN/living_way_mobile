// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 2;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      title: fields[1] as String?,
      body: fields[2] as String?,
      images: (fields[3] as List).cast<String>(),
      content: (fields[4] as List).cast<String>(),
      minimumAllowedViewImages: fields[5] as int,
      pollOptions: (fields[6] as List).cast<PollOptions>(),
      externalLink: fields[11] as String?,
      locationUrl: fields[12] as String?,
      banner: fields[13] as ContentBanner?,
      isOngoing: fields[10] as bool,
      upcomingDate: fields[9] as DateTime?,
      isRecurring: fields[14] as bool,
      id: fields[0] as String,
      type: fields[7] as ContentType,
      timestamp: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.images)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.minimumAllowedViewImages)
      ..writeByte(6)
      ..write(obj.pollOptions)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.timestamp)
      ..writeByte(9)
      ..write(obj.upcomingDate)
      ..writeByte(10)
      ..write(obj.isOngoing)
      ..writeByte(11)
      ..write(obj.externalLink)
      ..writeByte(12)
      ..write(obj.locationUrl)
      ..writeByte(13)
      ..write(obj.banner)
      ..writeByte(14)
      ..write(obj.isRecurring);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentBannerAdapter extends TypeAdapter<ContentBanner> {
  @override
  final int typeId = 3;

  @override
  ContentBanner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContentBanner(
      position: fields[2] as String,
      thumbnail: fields[1] as String?,
      url: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContentBanner obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.thumbnail)
      ..writeByte(2)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentBannerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PollOptionsAdapter extends TypeAdapter<PollOptions> {
  @override
  final int typeId = 4;

  @override
  PollOptions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PollOptions(
      title: fields[0] as String,
      voters: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PollOptions obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.voters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PollOptionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentTypeAdapter extends TypeAdapter<ContentType> {
  @override
  final int typeId = 5;

  @override
  ContentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ContentType.gallery;
      case 1:
        return ContentType.poll;
      case 2:
        return ContentType.article;
      case 3:
        return ContentType.external;
      case 4:
        return ContentType.event;
      case 5:
        return ContentType.general;
      case 6:
        return ContentType.undefined;
      default:
        return ContentType.gallery;
    }
  }

  @override
  void write(BinaryWriter writer, ContentType obj) {
    switch (obj) {
      case ContentType.gallery:
        writer.writeByte(0);
        break;
      case ContentType.poll:
        writer.writeByte(1);
        break;
      case ContentType.article:
        writer.writeByte(2);
        break;
      case ContentType.external:
        writer.writeByte(3);
        break;
      case ContentType.event:
        writer.writeByte(4);
        break;
      case ContentType.general:
        writer.writeByte(5);
        break;
      case ContentType.undefined:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
