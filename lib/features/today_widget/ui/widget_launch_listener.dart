import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/today_widget.dart';
import '../providers/today_widget_providers.dart';

/// Calls [onAddExpense] when the user taps the home-screen widget — both on
/// a cold start from the widget and while the app is already running.
class WidgetLaunchListener extends ConsumerStatefulWidget {
  const WidgetLaunchListener({super.key, required this.onAddExpense, required this.child});

  final VoidCallback onAddExpense;
  final Widget child;

  @override
  ConsumerState<WidgetLaunchListener> createState() => _WidgetLaunchListenerState();
}

class _WidgetLaunchListenerState extends ConsumerState<WidgetLaunchListener> {
  /// The cold-start URI stays readable for the whole process; handle it once.
  static bool _initialHandled = false;

  StreamSubscription<Uri?>? _sub;

  @override
  void initState() {
    super.initState();
    final bridge = ref.read(todayWidgetBridgeProvider);
    _sub = bridge.clicks.listen(_handle);
    if (!_initialHandled) {
      _initialHandled = true;
      unawaited(bridge.initialLaunch().then(_handle));
    }
  }

  void _handle(Uri? uri) {
    if (!isAddExpenseLink(uri) || !mounted) return;
    // Back to Home first (from Settings, Categories or an open sheet).
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) {
      Navigator.of(context).popUntil((r) => r == route);
    }
    widget.onAddExpense();
  }

  @override
  void dispose() {
    unawaited(_sub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
