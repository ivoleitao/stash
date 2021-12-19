abstract class Stats {
  /// The number of get requests that were satisfied by the stash.
  ///
  /// Returns the number of get requests satisfied by the stash
  int get gets;

  /// Increases the counter by the number specified.
  ///
  /// * [number]: the number to increase the counter by
  void increaseGets({int number});

  /// The total number of puts to the stash
  ///
  /// Replaces, where a put occurs which overrides an existing mapping is
  /// counted as a put.
  ///
  /// Returns the number of puts
  ///
  int get puts;

  /// Increases the counter by the number specified.
  ///
  /// * [number]: the number to increase the counter by
  void increasePuts({int number = 1});

  /// The total number of removals from the stash.
  ///
  /// Returns the number of removals
  int get removals;

  /// Increases the counter by the number specified.
  ///
  /// [number]: the number to increase the counter by
  void increaseRemovals({int number = 1});

  /// Increments the get time accumulator
  ///
  /// * [duration] the time taken in milliseconds
  void addGetTime(int duration);

  /// The mean time to execute gets.
  ///
  /// Returns the time in milliseconds
  double get averageGetTime;

  /// Increments the put time accumulator
  ///
  /// [duration] the time taken in milliseconds
  void addPutTime(int duration);

  /// The mean time to execute puts.
  ///
  /// Returns the time in milliseconds
  double get averagePutTime;

  /// Increments the remove time accumulator
  ///
  /// * [duration]: the time taken in milliseconds
  void addRemoveTime(int duration);

  /// The mean time to execute removes.
  ///
  /// Returns the time in milliseconds
  double get averageRemoveTime;

  /// Clears the statistics counters to 0 for the associated stash.
  void clear();
}
