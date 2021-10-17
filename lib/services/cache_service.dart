import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheService {
  final _manager = DefaultCacheManager();

  Future<File> download(String url) async {
    final cache = await _manager.getFileFromCache(url);

    if (cache != null && cache.validTill.isBefore(DateTime.now())) {
      return cache.file;
    }

    final file = await _manager.downloadFile(url, key: url);

    return file.file;
  }

  Future<void> clearCache() async {
    return _manager.emptyCache();
  }
}
