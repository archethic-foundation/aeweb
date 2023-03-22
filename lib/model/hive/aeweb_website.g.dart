// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aeweb_website.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AEWebLocalWebsiteAdapter extends TypeAdapter<AEWebLocalWebsite> {
  @override
  final int typeId = 1;

  @override
  AEWebLocalWebsite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AEWebLocalWebsite(
      name: fields[0] as String,
      genesisAddress: fields[1] as String,
      lastSaving: fields[2] as int?,
      localPath: fields[3] as String?,
      aewebLocalWebsiteVersionList:
          (fields[4] as List?)?.cast<AEWebLocalWebsiteVersion>(),
    );
  }

  @override
  void write(BinaryWriter writer, AEWebLocalWebsite obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.genesisAddress)
      ..writeByte(2)
      ..write(obj.lastSaving)
      ..writeByte(3)
      ..write(obj.localPath)
      ..writeByte(4)
      ..write(obj.aewebLocalWebsiteVersionList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AEWebLocalWebsiteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
