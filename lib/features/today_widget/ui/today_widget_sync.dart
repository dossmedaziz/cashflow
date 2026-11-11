import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/today_widget_providers.dart';

/// Keeps the home-screen widget in sync with the app: pushes today's total
/// whenever expenses, currency, language or theme change, and again when the
/// app returns to the foreground (the day may have changed).
class TodayWidgetSync extends ConsumerStatefulWidget {
  const TodayWidgetSync({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<TodayWidgetSync> createState() => _TodayWidgetSyncState();
}

class _TodayWidgetSyncState extends ConsumerState<TodayWidgetSync> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final bridge = ref.read(todayWidgetBridgeProvider);
    unawaited(bridge.init());
    ref.listenManual(todayWidgetDataProvider, (prev, next) {
      if (next != null && next != prev) unawaited(bridge.push(next));
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(todayWidgetDataProvider);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
