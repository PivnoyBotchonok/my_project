import 'package:hive_ce/hive.dart';

part 'word.g.dart'; // Файл будет сгенерирован

@HiveType(typeId: 0)
class Word {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String en;
  
  @HiveField(2)
  final String ru;
  
  Word({
    required this.id,
    required this.en,
    required this.ru,
  });
  factory Word.empty() => Word(id: 0, en: '', ru: '');
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      en: json['en'],
      ru: json['ru'],
    );
  }
}