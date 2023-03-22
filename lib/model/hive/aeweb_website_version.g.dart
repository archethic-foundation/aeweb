// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aeweb_website_version.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AEWebLocalWebsiteVersionAdapter
    extends TypeAdapter<AEWebLocalWebsiteVersion> {
  @override
  final int typeId = 2;

  @override
  AEWebLocalWebsiteVersion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AEWebLocalWebsiteVersion(
      transactionAddress: fields[0] as String,
      timestamp: fields[1] as int,
      filesCount: fields[2] as int?,
      size: fields[3] as int?,
      structureVersion: fields[4] as int?,
      hashFunction: fields[5] as String?,
      metaData: (fields[6] as Map?)?.cast<String, AEWebLocalWebsiteMetaData>(),
    );
  }

  @override
  void write(BinaryWriter writer, AEWebLocalWebsiteVersion obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.transactionAddress)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.filesCount)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.structureVersion)
      ..writeByte(5)
      ..write(obj.hashFunction)
      ..writeByte(6)
      ..write(obj.metaData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AEWebLocalWebsiteVersionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
