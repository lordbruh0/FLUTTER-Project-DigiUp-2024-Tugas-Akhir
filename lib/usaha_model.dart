import 'package:hive/hive.dart';

part 'usaha_model.g.dart';

@HiveType(typeId: 0)
class Usaha extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String photoPath;

  @HiveField(3)
  final List<String> tags;

  @HiveField(4)
  final String title;

  Usaha({
    required this.id,
    required this.description,
    required this.photoPath,
    required this.tags,
    required this.title,
  });
}
