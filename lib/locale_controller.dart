import 'package:flutter/material.dart';

/// Quản lý ngôn ngữ hiện tại của app.
/// Học: ChangeNotifier + notifyListeners → MaterialApp rebuild với locale mới.
class LocaleController extends ChangeNotifier {
  LocaleController({Locale? initialLocale})
      : _locale = initialLocale ?? const Locale('vi');

  Locale _locale;

  Locale get locale => _locale;

  bool get isVietnamese => _locale.languageCode == 'vi';

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  void toggle() {
    setLocale(
      isVietnamese ? const Locale('en') : const Locale('vi'),
    );
  }
}

/// Cho phép màn hình con lấy LocaleController qua context.
class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope not found');
    return scope!.notifier!;
  }
}
