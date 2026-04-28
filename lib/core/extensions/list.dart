extension ListExtension<T> on List<T> {
  void addOrReplace(T newItem, bool Function(T element) finder) {
    final index = indexWhere(finder);
    if (index != -1) {
      this[index] = newItem;
    } else {
      add(newItem);
    }
  }
}
