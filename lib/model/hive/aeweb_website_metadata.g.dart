// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aeweb_website_metadata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AEWebLocalWebsiteMetaDataAdapter
    extends TypeAdapter<AEWebLocalWebsiteMetaData> {
  @override
  final int typeId = 4;

  @override
  AEWebLocalWebsiteMetaData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AEWebLocalWebsiteMetaData(
      hash: fields[0] as String,
      size: fields[1] as int,
      encoding: fields[3] as String,
      addresses: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AEWebLocalWebsiteMetaData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.hash)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(3)
      ..write(obj.encoding)
      ..writeByte(4)
      ..write(obj.addresses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AEWebLocalWebsiteMetaDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
