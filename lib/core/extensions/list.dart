extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  void addOrReplace(T newItem, bool Function(T element) finder) {
    final index = indexWhere(finder);
    if (index != -1) {
      this[index] = newItem;
    } else {
      add(newItem);
    }
  }

  void addOrReplaceAll(
      Iterable<T> newItems, bool Function(T existing, T newItem) finder) {
    for (final newItem in newItems) {
      final index = indexWhere((element) => finder(element, newItem));
      if (index != -1) {
        this[index] = newItem;
      } else {
        add(newItem);
      }
    }
  }
}
