// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Cashflow';

  @override
  String get loginTagline => 'تحكّم في مصاريفك بكل بساطة';

  @override
  String get continueWithGoogle => 'المتابعة مع Google';

  @override
  String get termsPrefix => 'بالمتابعة، أنت توافق على';

  @override
  String get termsLink => 'شروط الاستخدام';

  @override
  String get termsAnd => 'و';

  @override
  String get privacyLink => 'سياسة الخصوصية';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get signInCancelled => 'تم إلغاء تسجيل الدخول.';

  @override
  String get signInNetworkError =>
      'لا يوجد اتصال. تحقّق من الإنترنت وحاول مجدداً.';

  @override
  String get signInConfigError =>
      'تسجيل الدخول عبر Google غير مُعدّ في هذا الإصدار بعد.';

  @override
  String get signInFailed => 'تعذّر تسجيل الدخول. حاول مرة أخرى.';

  @override
  String get dateLongPattern => 'EEEE، d MMMM';

  @override
  String get dateShortPattern => 'd MMM';

  @override
  String get monthChipPattern => 'MMMM y';

  @override
  String hello(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get helloNoName => 'مرحباً';

  @override
  String monthTotalLabel(String month) {
    return 'مجموع مصاريف $month';
  }

  @override
  String compareLess(String percent, String month) {
    return 'أقل بـ $percent% من $month';
  }

  @override
  String compareMore(String percent, String month) {
    return 'أكثر بـ $percent% من $month';
  }

  @override
  String compareSame(String month) {
    return 'مثل $month';
  }

  @override
  String get heroEmpty => 'سجّل أول مصروف لتبدأ المتابعة';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterLabel => 'تصفية حسب الفئة';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get emptyTitle => 'لا توجد مصاريف بعد';

  @override
  String get emptySubtitle =>
      'اضغط على زر + لتسجيل أول مصروف. خطوة صغيرة تصنع فرقاً كبيراً.';

  @override
  String emptyFilteredTitle(String category) {
    return 'لا شيء في «$category» هذا الشهر';
  }

  @override
  String get emptyFilteredSubtitle => 'اختر فئة أخرى أو أضف مصروفاً جديداً.';

  @override
  String get addExpense => 'إضافة مصروف';

  @override
  String get categoriesTooltip => 'الفئات';

  @override
  String get settingsTooltip => 'الإعدادات';

  @override
  String get delete => 'حذف';

  @override
  String expenseDeleted(String title) {
    return 'تم حذف «$title»';
  }

  @override
  String get undo => 'تراجع';

  @override
  String get errorLoading => 'تعذّر تحميل بياناتك.';

  @override
  String get errorNetwork => 'أنت غير متصل. نعرض ما تم حفظه على هذا الجهاز.';

  @override
  String get errorGeneric => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get newExpense => 'مصروف جديد';

  @override
  String get editExpense => 'تعديل المصروف';

  @override
  String get amount => 'المبلغ';

  @override
  String get category => 'الفئة';

  @override
  String get noteLabel => 'ملاحظة';

  @override
  String get notePlaceholder => 'أضف ملاحظة (اختياري)';

  @override
  String get add => 'إضافة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get deleteExpense => 'حذف المصروف';

  @override
  String get close => 'إغلاق';

  @override
  String get deleteDigit => 'مسح';

  @override
  String get decimalPoint => 'فاصلة عشرية';

  @override
  String get errorAmountRequired => 'أدخل مبلغاً أكبر من صفر.';

  @override
  String get errorCategoryRequired => 'اختر فئة.';

  @override
  String get chooseDate => 'اختر التاريخ';

  @override
  String get categoriesTitle => 'الفئات';

  @override
  String categoriesSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فئة',
      many: '$count فئة',
      few: '$count فئات',
      two: 'فئتان',
      one: 'فئة واحدة',
      zero: 'لا فئات',
    );
    return '$_temp0 · اسحب لإعادة الترتيب';
  }

  @override
  String categoryMeta(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مصروف',
      many: '$count مصروفاً',
      few: '$count مصاريف',
      two: 'مصروفان',
      one: 'مصروف واحد',
      zero: 'لا مصاريف',
    );
    return '$_temp0 · $amount';
  }

  @override
  String get addCategory => 'إضافة فئة';

  @override
  String get addNewCategory => 'إضافة فئة جديدة';

  @override
  String get categoryDeleteNote =>
      'حذف فئة ينقل مصاريفها إلى «أخرى» — لا شيء يضيع.';

  @override
  String reorderCategory(String name) {
    return 'إعادة ترتيب $name';
  }

  @override
  String get newCategory => 'فئة جديدة';

  @override
  String get editCategory => 'تعديل الفئة';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get categoryNameHint => 'مثلاً: رياضة';

  @override
  String get color => 'اللون';

  @override
  String get icon => 'الأيقونة';

  @override
  String get saveCategory => 'حفظ الفئة';

  @override
  String get deleteCategory => 'حذف الفئة';

  @override
  String get errorNameRequired => 'أدخل اسماً للفئة.';

  @override
  String deleteCategoryTitle(String name) {
    return 'حذف «$name»؟';
  }

  @override
  String deleteCategoryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سيُنقل $count مصروف إلى «أخرى».',
      many: 'سيُنقل $count مصروفاً إلى «أخرى».',
      few: 'ستُنقل $count مصاريف إلى «أخرى».',
      two: 'سيُنقل مصروفان إلى «أخرى».',
      one: 'سيُنقل مصروف واحد إلى «أخرى».',
      zero: 'لا توجد مصاريف في هذه الفئة.',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get catFood => 'طعام';

  @override
  String get catTransport => 'نقل';

  @override
  String get catShopping => 'تسوّق';

  @override
  String get catBills => 'فواتير';

  @override
  String get catHealth => 'صحة';

  @override
  String get catOther => 'أخرى';

  @override
  String get colorOrange => 'برتقالي';

  @override
  String get colorYellow => 'أصفر';

  @override
  String get colorGreen => 'أخضر';

  @override
  String get colorTeal => 'فيروزي';

  @override
  String get colorBlue => 'أزرق';

  @override
  String get colorViolet => 'بنفسجي';

  @override
  String get colorPink => 'وردي';

  @override
  String get colorRed => 'أحمر';

  @override
  String get iconDumbbell => 'رياضة';

  @override
  String get iconCoffee => 'قهوة';

  @override
  String get iconBook => 'تعليم';

  @override
  String get iconGift => 'هدايا';

  @override
  String get iconHome => 'منزل';

  @override
  String get iconPlane => 'سفر';

  @override
  String get iconMusic => 'ترفيه';

  @override
  String get iconPhone => 'هاتف';

  @override
  String get iconGrad => 'دراسة';

  @override
  String get iconHeart => 'عائلة';

  @override
  String get iconBag => 'تسوّق';

  @override
  String get iconStar => 'مميّز';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get back => 'رجوع';

  @override
  String get account => 'الحساب';

  @override
  String get connectedWithGoogle => 'متصل عبر Google';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeLight => 'فاتح';

  @override
  String get currency => 'العملة';

  @override
  String get chooseCurrency => 'اختر العملة';

  @override
  String get currencyNote =>
      'تغيير العملة يغيّر الرمز فقط — لا يتم تحويل المبالغ.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get footerTagline => 'صُنع بهدوء';

  @override
  String get currencyTND => 'الدينار التونسي';

  @override
  String get currencyEUR => 'اليورو';

  @override
  String get currencyUSD => 'الدولار الأمريكي';

  @override
  String get currencyMAD => 'الدرهم المغربي';

  @override
  String get currencyDZD => 'الدينار الجزائري';

  @override
  String get currencyLYD => 'الدينار الليبي';

  @override
  String widgetTodayA11y(String amount, String currency) {
    return 'مصاريف اليوم: $amount $currency';
  }

  @override
  String get periodThisWeek => 'هذا الأسبوع';

  @override
  String get periodThisMonth => 'هذا الشهر';

  @override
  String get changePeriod => 'تغيير الفترة';

  @override
  String get dayTotalLabel => 'مجموع مصاريف اليوم';

  @override
  String get weekTotalLabel => 'مجموع مصاريف هذا الأسبوع';

  @override
  String get heroEmptyDay => 'لم تُسجَّل مصاريف اليوم بعد';

  @override
  String get heroEmptyWeek => 'لم تُسجَّل مصاريف هذا الأسبوع بعد';

  @override
  String compareLessDay(String percent) {
    return 'أقل بـ $percent% من أمس';
  }

  @override
  String compareMoreDay(String percent) {
    return 'أكثر بـ $percent% من أمس';
  }

  @override
  String get compareSameDay => 'مثل أمس';

  @override
  String compareLessWeek(String percent) {
    return 'أقل بـ $percent% من الأسبوع الماضي';
  }

  @override
  String compareMoreWeek(String percent) {
    return 'أكثر بـ $percent% من الأسبوع الماضي';
  }

  @override
  String get compareSameWeek => 'مثل الأسبوع الماضي';
}
