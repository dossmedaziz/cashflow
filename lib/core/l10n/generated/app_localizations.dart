import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Cashflow'**
  String get appName;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Take control of your spending, simply'**
  String get loginTagline;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @termsPrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the'**
  String get termsPrefix;

  /// No description provided for @termsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get termsLink;

  /// No description provided for @termsAnd.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get termsAnd;

  /// No description provided for @privacyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyLink;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @signInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in was cancelled.'**
  String get signInCancelled;

  /// No description provided for @signInNetworkError.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get signInNetworkError;

  /// No description provided for @signInConfigError.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in isn\'t configured for this build yet.'**
  String get signInConfigError;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign you in. Please try again.'**
  String get signInFailed;

  /// intl DateFormat pattern for the Home header and day groups. Do not translate the letters.
  ///
  /// In en, this message translates to:
  /// **'EEEE, d MMMM'**
  String get dateLongPattern;

  /// intl DateFormat pattern for the date button. Do not translate the letters.
  ///
  /// In en, this message translates to:
  /// **'d MMM'**
  String get dateShortPattern;

  /// intl DateFormat pattern for the month chip. Do not translate the letters.
  ///
  /// In en, this message translates to:
  /// **'MMM y'**
  String get monthChipPattern;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(String name);

  /// No description provided for @helloNoName.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get helloNoName;

  /// Hero card label. Arabic includes the month name.
  ///
  /// In en, this message translates to:
  /// **'Spent this month'**
  String monthTotalLabel(String month);

  /// No description provided for @compareLess.
  ///
  /// In en, this message translates to:
  /// **'{percent}% less than {month}'**
  String compareLess(String percent, String month);

  /// No description provided for @compareMore.
  ///
  /// In en, this message translates to:
  /// **'{percent}% more than {month}'**
  String compareMore(String percent, String month);

  /// No description provided for @compareSame.
  ///
  /// In en, this message translates to:
  /// **'Same as {month}'**
  String compareSame(String month);

  /// No description provided for @heroEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log your first expense to get started'**
  String get heroEmpty;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter by category'**
  String get filterLabel;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get emptyTitle;

  /// No description provided for @emptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to log your first expense. Small steps add up.'**
  String get emptySubtitle;

  /// No description provided for @emptyFilteredTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing in {category} this month'**
  String emptyFilteredTitle(String category);

  /// No description provided for @emptyFilteredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick another category or add a new expense.'**
  String get emptyFilteredSubtitle;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @categoriesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @expenseDeleted.
  ///
  /// In en, this message translates to:
  /// **'“{title}” deleted'**
  String expenseDeleted(String title);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your data.'**
  String get errorLoading;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing what was saved on this device.'**
  String get errorNetwork;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @newExpense.
  ///
  /// In en, this message translates to:
  /// **'New expense'**
  String get newExpense;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editExpense;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @notePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get notePlaceholder;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete expense'**
  String get deleteExpense;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @deleteDigit.
  ///
  /// In en, this message translates to:
  /// **'Delete digit'**
  String get deleteDigit;

  /// No description provided for @decimalPoint.
  ///
  /// In en, this message translates to:
  /// **'Decimal point'**
  String get decimalPoint;

  /// No description provided for @errorAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero.'**
  String get errorAmountRequired;

  /// No description provided for @errorCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a category.'**
  String get errorCategoryRequired;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get chooseDate;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @categoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 category} other{{count} categories}} · drag to reorder'**
  String categoriesSubtitle(int count);

  /// No description provided for @categoryMeta.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No expenses} =1{1 expense} other{{count} expenses}} · {amount}'**
  String categoryMeta(int count, String amount);

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @addNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Add a new category'**
  String get addNewCategory;

  /// No description provided for @categoryDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'Deleting a category moves its expenses to “Other” — nothing is lost.'**
  String get categoryDeleteNote;

  /// No description provided for @reorderCategory.
  ///
  /// In en, this message translates to:
  /// **'Reorder {name}'**
  String reorderCategory(String name);

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sport'**
  String get categoryNameHint;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @saveCategory.
  ///
  /// In en, this message translates to:
  /// **'Save category'**
  String get saveCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get deleteCategory;

  /// No description provided for @errorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Give the category a name.'**
  String get errorNameRequired;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”?'**
  String deleteCategoryTitle(String name);

  /// No description provided for @deleteCategoryBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{This category has no expenses.} =1{Its 1 expense will move to “Other”.} other{Its {count} expenses will move to “Other”.}}'**
  String deleteCategoryBody(int count);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get catFood;

  /// No description provided for @catTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get catTransport;

  /// No description provided for @catShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get catShopping;

  /// No description provided for @catBills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get catBills;

  /// No description provided for @catHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get catHealth;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @colorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get colorTeal;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorViolet.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get colorViolet;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @iconDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get iconDumbbell;

  /// No description provided for @iconCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get iconCoffee;

  /// No description provided for @iconBook.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get iconBook;

  /// No description provided for @iconGift.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get iconGift;

  /// No description provided for @iconHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get iconHome;

  /// No description provided for @iconPlane.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get iconPlane;

  /// No description provided for @iconMusic.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get iconMusic;

  /// No description provided for @iconPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get iconPhone;

  /// No description provided for @iconGrad.
  ///
  /// In en, this message translates to:
  /// **'Studies'**
  String get iconGrad;

  /// No description provided for @iconHeart.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get iconHeart;

  /// No description provided for @iconBag.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get iconBag;

  /// No description provided for @iconStar.
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get iconStar;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @connectedWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Connected with Google'**
  String get connectedWithGoogle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @chooseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Choose currency'**
  String get chooseCurrency;

  /// No description provided for @currencyNote.
  ///
  /// In en, this message translates to:
  /// **'Changing the currency only changes the symbol — amounts aren\'t converted.'**
  String get currencyNote;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @footerTagline.
  ///
  /// In en, this message translates to:
  /// **'made calmly'**
  String get footerTagline;

  /// No description provided for @currencyTND.
  ///
  /// In en, this message translates to:
  /// **'Tunisian dinar'**
  String get currencyTND;

  /// No description provided for @currencyEUR.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get currencyEUR;

  /// No description provided for @currencyUSD.
  ///
  /// In en, this message translates to:
  /// **'US dollar'**
  String get currencyUSD;

  /// No description provided for @currencyMAD.
  ///
  /// In en, this message translates to:
  /// **'Moroccan dirham'**
  String get currencyMAD;

  /// No description provided for @currencyDZD.
  ///
  /// In en, this message translates to:
  /// **'Algerian dinar'**
  String get currencyDZD;

  /// No description provided for @currencyLYD.
  ///
  /// In en, this message translates to:
  /// **'Libyan dinar'**
  String get currencyLYD;

  /// No description provided for @widgetTodayA11y.
  ///
  /// In en, this message translates to:
  /// **'Spent today: {amount} {currency}'**
  String widgetTodayA11y(String amount, String currency);

  /// No description provided for @periodThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get periodThisWeek;

  /// No description provided for @periodThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get periodThisMonth;

  /// No description provided for @changePeriod.
  ///
  /// In en, this message translates to:
  /// **'Change period'**
  String get changePeriod;

  /// No description provided for @dayTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Spent today'**
  String get dayTotalLabel;

  /// No description provided for @weekTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Spent this week'**
  String get weekTotalLabel;

  /// No description provided for @heroEmptyDay.
  ///
  /// In en, this message translates to:
  /// **'Nothing spent today yet'**
  String get heroEmptyDay;

  /// No description provided for @heroEmptyWeek.
  ///
  /// In en, this message translates to:
  /// **'Nothing spent this week yet'**
  String get heroEmptyWeek;

  /// No description provided for @compareLessDay.
  ///
  /// In en, this message translates to:
  /// **'{percent}% less than yesterday'**
  String compareLessDay(String percent);

  /// No description provided for @compareMoreDay.
  ///
  /// In en, this message translates to:
  /// **'{percent}% more than yesterday'**
  String compareMoreDay(String percent);

  /// No description provided for @compareSameDay.
  ///
  /// In en, this message translates to:
  /// **'Same as yesterday'**
  String get compareSameDay;

  /// No description provided for @compareLessWeek.
  ///
  /// In en, this message translates to:
  /// **'{percent}% less than last week'**
  String compareLessWeek(String percent);

  /// No description provided for @compareMoreWeek.
  ///
  /// In en, this message translates to:
  /// **'{percent}% more than last week'**
  String compareMoreWeek(String percent);

  /// No description provided for @compareSameWeek.
  ///
  /// In en, this message translates to:
  /// **'Same as last week'**
  String get compareSameWeek;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
