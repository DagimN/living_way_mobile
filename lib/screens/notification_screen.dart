import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    _checkVisibleItems();
  }

  void _checkVisibleItems() {
    final notificationController = context.read<NotificationController>();

    for (final notification in notificationController.notifications) {
      if (notification.isRead) continue;

      final key = _itemKeys[notification.id];
      if (key == null) continue;

      final context = key.currentContext;
      if (context == null) continue;

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) continue;

      final itemPosition = renderBox.localToGlobal(Offset.zero);
      final itemHeight = renderBox.size.height;
      final screenHeight = MediaQuery.of(this.context).size.height;

      final isVisible =
          itemPosition.dy < screenHeight && itemPosition.dy + itemHeight > 0;

      if (isVisible) {
        notificationController.markAsRead(notification.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationController = Provider.of<NotificationController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final notifications = notificationController.notifications;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibleItems();
    });

    Widget body = ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (_, index) {
          final notification = notifications[index];

          _itemKeys[notification.id] ??= GlobalKey();

          return ListTile(
              key: _itemKeys[notification.id],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(notification.title,
                      style: TextStyle(
                          color: theme.accentColor,
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.w600)),
                  // SizedBox(
                  //   height: 20,
                  //   child: IconButton(
                  //     icon: const Icon(Icons.delete),
                  //     onPressed: () => notificationController
                  //         .deleteNotification(notification.id),
                  //   ),
                  // )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(notification.body,
                      style: TextStyle(
                          color: theme.accentColor,
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.w600)),
                  if (notification.imageUrl?.isNotEmpty ?? false)
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                            imageUrl: notification.imageUrl ?? "")),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(formatDateTime(notification.createdAt),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.w600))),
                ],
              ));
        });

    if (notificationController.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    }

    if (notificationController.isEmpty) {
      body = Center(
          child: Text(
        Tr.t('emptyNotifications'),
        style: TextStyle(color: theme.accentColor),
      ));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(Tr.t('notifications')),
          backgroundColor: theme.appbarColor,
          foregroundColor: theme.primaryColor,
          systemOverlayStyle: themeController.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
        ),
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(gradient: theme.backgroundGradient),
            child: body));
  }
}
