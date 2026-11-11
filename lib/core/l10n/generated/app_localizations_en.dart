// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Cashflow';

  @override
  String get loginTagline => 'Take control of your spending, simply';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get termsPrefix => 'By continuing, you agree to the';

  @override
  String get termsLink => 'Terms';

  @override
  String get termsAnd => 'and';

  @override
  String get privacyLink => 'Privacy Policy';

  @override
  String get languageLabel => 'Language';

  @override
  String get signInCancelled => 'Sign-in was cancelled.';

  @override
  String get signInNetworkError =>
      'No connection. Check your internet and try again.';

  @override
  String get signInConfigError =>
      'Google sign-in isn\'t configured for this build yet.';

  @override
  String get signInFailed => 'Couldn\'t sign you in. Please try again.';

  @override
  String get dateLongPattern => 'EEEE, d MMMM';

  @override
  String get dateShortPattern => 'd MMM';

  @override
  String get monthChipPattern => 'MMM y';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String get helloNoName => 'Hello';

  @override
  String monthTotalLabel(String month) {
    return 'Spent this month';
  }

  @override
  String compareLess(String percent, String month) {
    return '$percent% less than $month';
  }

  @override
  String compareMore(String percent, String month) {
    return '$percent% more than $month';
  }

  @override
  String compareSame(String month) {
    return 'Same as $month';
  }

  @override
  String get heroEmpty => 'Log your first expense to get started';

  @override
  String get filterAll => 'All';

  @override
  String get filterLabel => 'Filter by category';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get emptyTitle => 'No expenses yet';

  @override
  String get emptySubtitle =>
      'Tap + to log your first expense. Small steps add up.';

  @override
  String emptyFilteredTitle(String category) {
    return 'Nothing in $category this month';
  }

  @override
  String get emptyFilteredSubtitle =>
      'Pick another category or add a new expense.';

  @override
  String get addExpense => 'Add expense';

  @override
  String get categoriesTooltip => 'Categories';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get delete => 'Delete';

  @override
  String expenseDeleted(String title) {
    return '“$title” deleted';
  }

  @override
  String get undo => 'Undo';

  @override
  String get errorLoading => 'Couldn\'t load your data.';

  @override
  String get errorNetwork =>
      'You\'re offline. Showing what was saved on this device.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get retry => 'Try again';

  @override
  String get newExpense => 'New expense';

  @override
  String get editExpense => 'Edit expense';

  @override
  String get amount => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get noteLabel => 'Note';

  @override
  String get notePlaceholder => 'Add a note (optional)';

  @override
  String get add => 'Add';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get deleteExpense => 'Delete expense';

  @override
  String get close => 'Close';

  @override
  String get deleteDigit => 'Delete digit';

  @override
  String get decimalPoint => 'Decimal point';

  @override
  String get errorAmountRequired => 'Enter an amount greater than zero.';

  @override
  String get errorCategoryRequired => 'Choose a category.';

  @override
  String get chooseDate => 'Choose date';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String categoriesSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count categories',
      one: '1 category',
    );
    return '$_temp0 · drag to reorder';
  }

  @override
  String categoryMeta(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expenses',
      one: '1 expense',
      zero: 'No expenses',
    );
    return '$_temp0 · $amount';
  }

  @override
  String get addCategory => 'Add category';

  @override
  String get addNewCategory => 'Add a new category';

  @override
  String get categoryDeleteNote =>
      'Deleting a category moves its expenses to “Other” — nothing is lost.';

  @override
  String reorderCategory(String name) {
    return 'Reorder $name';
  }

  @override
  String get newCategory => 'New category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get categoryName => 'Category name';

  @override
  String get categoryNameHint => 'e.g. Sport';

  @override
  String get color => 'Color';

  @override
  String get icon => 'Icon';

  @override
  String get saveCategory => 'Save category';

  @override
  String get deleteCategory => 'Delete category';

  @override
  String get errorNameRequired => 'Give the category a name.';

  @override
  String deleteCategoryTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String deleteCategoryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Its $count expenses will move to “Other”.',
      one: 'Its 1 expense will move to “Other”.',
      zero: 'This category has no expenses.',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get catFood => 'Food';

  @override
  String get catTransport => 'Transport';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catBills => 'Bills';

  @override
  String get catHealth => 'Health';

  @override
  String get catOther => 'Other';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorTeal => 'Teal';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorViolet => 'Violet';

  @override
  String get colorPink => 'Pink';

  @override
  String get colorRed => 'Red';

  @override
  String get iconDumbbell => 'Sport';

  @override
  String get iconCoffee => 'Coffee';

  @override
  String get iconBook => 'Education';

  @override
  String get iconGift => 'Gifts';

  @override
  String get iconHome => 'Home';

  @override
  String get iconPlane => 'Travel';

  @override
  String get iconMusic => 'Entertainment';

  @override
  String get iconPhone => 'Phone';

  @override
  String get iconGrad => 'Studies';

  @override
  String get iconHeart => 'Family';

  @override
  String get iconBag => 'Shopping';

  @override
  String get iconStar => 'Special';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get back => 'Back';

  @override
  String get account => 'Account';

  @override
  String get connectedWithGoogle => 'Connected with Google';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get currency => 'Currency';

  @override
  String get chooseCurrency => 'Choose currency';

  @override
  String get currencyNote =>
      'Changing the currency only changes the symbol — amounts aren\'t converted.';

  @override
  String get logout => 'Log out';

  @override
  String get footerTagline => 'made calmly';

  @override
  String get currencyTND => 'Tunisian dinar';

  @override
  String get currencyEUR => 'Euro';

  @override
  String get currencyUSD => 'US dollar';

  @override
  String get currencyMAD => 'Moroccan dirham';

  @override
  String get currencyDZD => 'Algerian dinar';

  @override
  String get currencyLYD => 'Libyan dinar';

  @override
  String widgetTodayA11y(String amount, String currency) {
    return 'Spent today: $amount $currency';
  }

  @override
  String get periodThisWeek => 'This week';

  @override
  String get periodThisMonth => 'This month';

  @override
  String get changePeriod => 'Change period';

  @override
  String get dayTotalLabel => 'Spent today';

  @override
  String get weekTotalLabel => 'Spent this week';

  @override
  String get heroEmptyDay => 'Nothing spent today yet';

  @override
  String get heroEmptyWeek => 'Nothing spent this week yet';

  @override
  String compareLessDay(String percent) {
    return '$percent% less than yesterday';
  }

  @override
  String compareMoreDay(String percent) {
    return '$percent% more than yesterday';
  }

  @override
  String get compareSameDay => 'Same as yesterday';

  @override
  String compareLessWeek(String percent) {
    return '$percent% less than last week';
  }

  @override
  String compareMoreWeek(String percent) {
    return '$percent% more than last week';
  }

  @override
  String get compareSameWeek => 'Same as last week';
}
