import 'dart:async';
import 'dart:ui';

class Debouncer {
  Debouncer({
    this.duration = const Duration(milliseconds: 300),
  });
  Timer? _timer;
  Duration duration;

  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(
      duration,
      action,
    );
  }
}
