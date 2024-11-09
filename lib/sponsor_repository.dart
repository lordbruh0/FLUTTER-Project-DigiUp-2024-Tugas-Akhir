import 'package:hive/hive.dart';
import 'usaha_model.dart';

class UsahaRepository {
  final String _boxName = 'usahaBox';

  Future<Box<Usaha>> _getBox() async {
    return await Hive.openBox<Usaha>(_boxName);
  }

  // Create
  Future<void> addUsaha(Usaha report) async {
    final box = await _getBox();
    await box.put(report.id, report);
  }

  // Read
  Future<List<Usaha>> getUsaha() async {
    final box = await _getBox();
    return box.values.toList();
  }

  // Updatea
  Future<void> updateUsaha(Usaha report) async {
    final box = await _getBox();
    await box.put(report.id, report);
  }

  // Delete
  Future<void> deleteUsaha(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
