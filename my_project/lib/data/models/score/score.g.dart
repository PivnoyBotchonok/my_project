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
      score_endless_game: (fields[0] as num).toInt(),
      score_crossword_game: (fields[1] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Score obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.score_endless_game)
      ..writeByte(1)
      ..write(obj.score_crossword_game);
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
