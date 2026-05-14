import 'package:flutter/material.dart';

import 'logging_service.dart';

class UIService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void showSnackbar(
      {required Color backgroundColor,
      String? message,
      Widget? child,
      Duration? duration}) {
    if (message == null && child == null) {
      logger.w('No message or child to display as a snackbar');
      return;
    }

    messengerKey.currentState?.hideCurrentSnackBar();
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: child ?? Text(message ?? ""),
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: duration ?? const Duration(milliseconds: 4000),
      ),
    );
  }

  static Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) return Future.value(null);

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  static Future<T?> showCustomBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    Color? backgroundColor,
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) return Future.value(null);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor ?? Colors.transparent,
      builder: (context) => child,
    );
  }

  static void push<T>(Widget page) {
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => page));
  }

  static void pop<T>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop(result);
    }
  }
}
