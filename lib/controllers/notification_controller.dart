import 'dart:async';

import 'package:flutter/material.dart' hide Notification;
import 'package:living_way/core/core.dart';

class NotificationController extends ChangeNotifier {
  final NotificationCache _cache = NotificationCache();

  List<Notification> _notifications = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Notification>>? _cacheSubscription;

  NotificationController() {
    _init();
  }

  List<Notification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmpty => _notifications.isEmpty && !_isLoading;

  void _init() async {
    await _cache.init();
    _loadFromCache();
    _subscribeToCache();
    _cache.purgeOlderThan(const Duration(days: 30));
  }

  Future<void> _loadFromCache() async {
    _setLoading(true);
    try {
      _notifications = _cache.getAllSorted();
      _error = null;
    } catch (e) {
      _error = 'Failed to load notifications: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _subscribeToCache() {
    _cacheSubscription = _cache.watchAll().listen(
      (updatedList) {
        _notifications = updatedList
          ..sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
          );
        _error = null;
        notifyListeners();
      },
      onError: (Object e) {
        _error = 'Cache stream error: $e';
        notifyListeners();
      },
    );
  }

  Future<void> refresh() => _loadFromCache();

  Future<void> deleteNotification(String id) async {
    try {
      _notifications = _notifications.where((n) => n.id != id).toList();
      notifyListeners();

      await _cache.deleteByKey(id);
    } catch (e) {
      _error = 'Failed to delete notification: $e';
      await _loadFromCache();
    }
  }

  Future<void> clearAll() async {
    try {
      _notifications = [];
      notifyListeners();

      await _cache.clear();
    } catch (e) {
      _error = 'Failed to clear notifications: $e';
      await _loadFromCache();
    }
  }

  Future<void> markAsRead(String id) async {
    final notification = _cache.getByKey(id);
    if (notification == null || notification.isRead) return;

    notification.isRead = true;
    await notification.save();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _cacheSubscription?.cancel();
    super.dispose();
  }
}
