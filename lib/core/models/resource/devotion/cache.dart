import 'package:hive/hive.dart';

import '../../../services/hive_service.dart';
import '../passage/index.dart';
import '../translation/index.dart';
import '../book/index.dart';
import 'index.dart';
import 'devotion_item.dart';

class DevotionCache extends HiveService<Devotion> {
  DevotionCache() : super(boxName: 'devotions');

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(DevotionAdapter().typeId)) {
      Hive.registerAdapter(DevotionAdapter());
    }

    if (!Hive.isAdapterRegistered(DevotionItemAdapter().typeId)) {
      Hive.registerAdapter(DevotionItemAdapter());
    }

    if (!Hive.isAdapterRegistered(PassageAdapter().typeId)) {
      Hive.registerAdapter(PassageAdapter());
    }

    if (!Hive.isAdapterRegistered(TranslationAdapter().typeId)) {
      Hive.registerAdapter(TranslationAdapter());
    }

    if (!Hive.isAdapterRegistered(BookAdapter().typeId)) {
      Hive.registerAdapter(BookAdapter());
    }
  }
}
