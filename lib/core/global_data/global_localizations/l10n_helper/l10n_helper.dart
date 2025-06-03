import 'package:finance_tracker/core/global_data/global_localizations/app_local/app_local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations get l10 {
  final context = navigatorKey.currentContext;
  assert(context != null, 'navigatorKey context is null. App not ready yet.');
  return AppLocalizations.of(context!)!;
}
