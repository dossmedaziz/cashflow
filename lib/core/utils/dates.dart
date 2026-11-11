import 'package:intl/intl.dart';

import '../l10n/generated/app_localizations.dart';

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime startOfMonth(DateTime d) => DateTime(d.year, d.month);

DateTime startOfPreviousMonth(DateTime d) => DateTime(d.year, d.month - 1);

DateTime startOfNextMonth(DateTime d) => DateTime(d.year, d.month + 1);

bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

bool isSameMonth(DateTime a, DateTime b) => a.year == b.year && a.month == b.month;

/// Localized, Western-digit date labels.
class DateLabels {
  DateLabels(this.l10n, this.languageCode);

  final AppLocalizations l10n;
  final String languageCode;

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  /// "Wednesday, 11 November" · "الأربعاء، 11 نوفمبر" · "Mercredi 11 novembre".
  String long(DateTime d) => _capitalize(DateFormat(l10n.dateLongPattern, languageCode).format(d));

  /// Day-group header: Today / Yesterday / long date.
  String day(DateTime d, DateTime now) {
    if (isSameDay(d, now)) return l10n.today;
    if (isSameDay(d, now.subtract(const Duration(days: 1)))) return l10n.yesterday;
    return long(d);
  }

  /// Date button in the expense sheet: Today / Yesterday / "9 Nov".
  String short(DateTime d, DateTime now) {
    if (isSameDay(d, now)) return l10n.today;
    if (isSameDay(d, now.subtract(const Duration(days: 1)))) return l10n.yesterday;
    final pattern = d.year == now.year ? l10n.dateShortPattern : '${l10n.dateShortPattern} y';
    return DateFormat(pattern, languageCode).format(d);
  }

  /// "Nov 2026" · "نوفمبر 2026" · "nov. 2026".
  String monthChip(DateTime d) => DateFormat(l10n.monthChipPattern, languageCode).format(d);

  /// Month name used inside sentences ("than October", "من أكتوبر").
  String monthName(DateTime d) => DateFormat.MMMM(languageCode).format(d);

  /// 24-hour time, Western digits: "13:05".
  String time(DateTime d) => DateFormat('HH:mm', 'en').format(d);
}
