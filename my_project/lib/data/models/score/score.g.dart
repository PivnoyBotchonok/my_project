// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScoreAdapter extends TypeAdapter<Score> {
  @override
  final int typeId = 1;

  @override
  Score read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Score(
      scoreEndlessGame: (fields[0] as num).toInt(),
      scoreCrosswordGame: (fields[1] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Score obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.scoreEndlessGame)
      ..writeByte(1)
      ..write(obj.scoreCrosswordGame);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
