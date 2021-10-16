import '../cache_stats.dart';

class DefaultCacheStats implements CacheStats {
  @override
  int gets = 0;

  @override
  void increaseGets({int number = 1}) {
    gets += number;
  }

  @override
  double get getPercentage {
    if (gets == 0) {
      return 0;
    }

    return gets / requests * 100.0;
  }

  @override
  int misses = 0;

  @override
  void increaseMisses({int number = 1}) {
    misses += number;
  }

  @override
  double get missPercentage {
    if (misses == 0) {
      return 0;
    }

    return misses / requests * 100.0;
  }

  @override
  int get requests => gets + misses;

  @override
  int puts = 0;

  @override
  void increasePuts({int number = 1}) {
    puts += number;
  }

  @override
  int removals = 0;

  @override
  void increaseRemovals({int number = 1}) {
    removals += number;
  }

  @override
  int evictions = 0;

  @override
  void increaseEvictions({int number = 1}) {
    evictions += number;
  }

  @override
  int expiries = 0;

  @override
  void increaseExpiries({int number = 1}) {
    expiries += number;
  }

  int getTimeTaken = 0;

  @override
  void addGetTime(int duration) {
    getTimeTaken += duration;
  }

  @override
  double get averageGetTime {
    final millis = getTimeTaken;
    if (requests == 0 || millis == 0) {
      return 0.0;
    }

    return millis / requests;
  }

  int putTimeTaken = 0;

  @override
  void addPutTime(int duration) {
    putTimeTaken += duration;
  }

  @override
  double get averagePutTime {
    final millis = putTimeTaken;
    if (puts == 0 || millis == 0) {
      return 0.0;
    }

    return millis / puts;
  }

  int removeTimeTaken = 0;

  @override
  void addRemoveTime(int duration) {
    removeTimeTaken += duration;
  }

  @override
  double get averageRemoveTime {
    final millis = removeTimeTaken;
    if (removals == 0 || millis == 0) {
      return 0.0;
    }

    return millis / removals;
  }

  @override
  void clear() {
    gets = 0;
    misses = 0;
    puts = 0;
    removals = 0;
    expiries = 0;
    evictions = 0;
    getTimeTaken = 0;
    putTimeTaken = 0;
    removeTimeTaken = 0;
  }
}
