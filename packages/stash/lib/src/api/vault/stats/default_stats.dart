import '../vault_stats.dart';

class DefaultVaultStats implements VaultStats {
  @override
  int gets = 0;

  @override
  void increaseGets({int number = 1}) {
    gets += number;
  }

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

  int getTimeTaken = 0;

  @override
  void addGetTime(int duration) {
    getTimeTaken += duration;
  }

  @override
  double get averageGetTime {
    final timeTaken = getTimeTaken;
    if (gets == 0 || timeTaken == 0) {
      return 0.0;
    }

    return (timeTaken / gets) / 1000.0;
  }

  int putTimeTaken = 0;

  @override
  void addPutTime(int duration) {
    putTimeTaken += duration;
  }

  @override
  double get averagePutTime {
    final timeTaken = putTimeTaken;
    if (puts == 0 || timeTaken == 0) {
      return 0.0;
    }

    return (timeTaken / puts) / 1000.0;
  }

  int removeTimeTaken = 0;

  @override
  void addRemoveTime(int duration) {
    removeTimeTaken += duration;
  }

  @override
  double get averageRemoveTime {
    final timeTaken = removeTimeTaken;
    if (removals == 0 || timeTaken == 0) {
      return 0.0;
    }

    return (timeTaken / removals) / 1000.0;
  }

  @override
  void clear() {
    gets = 0;
    puts = 0;
    removals = 0;
    getTimeTaken = 0;
    putTimeTaken = 0;
    removeTimeTaken = 0;
  }
}
