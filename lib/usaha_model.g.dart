// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usaha_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsahaAdapter extends TypeAdapter<Usaha> {
  @override
  final int typeId = 0;

  @override
  Usaha read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Usaha(
      id: fields[0] as String,
      description: fields[1] as String,
      photoPath: fields[2] as String,
      tags: (fields[3] as List).cast<String>(),
      title: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Usaha obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.photoPath)
      ..writeByte(3)
      ..write(obj.tags)
      ..writeByte(4)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsahaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
