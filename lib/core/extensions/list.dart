extension ListExtension<T> on List<T> {
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
