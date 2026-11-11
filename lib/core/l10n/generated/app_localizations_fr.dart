// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Cashflow';

  @override
  String get loginTagline => 'Maîtrisez vos dépenses, tout simplement';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get termsPrefix => 'En continuant, vous acceptez les';

  @override
  String get termsLink => 'Conditions';

  @override
  String get termsAnd => 'et la';

  @override
  String get privacyLink => 'Politique de confidentialité';

  @override
  String get languageLabel => 'Langue';

  @override
  String get signInCancelled => 'Connexion annulée.';

  @override
  String get signInNetworkError =>
      'Pas de connexion. Vérifiez Internet et réessayez.';

  @override
  String get signInConfigError =>
      'La connexion Google n’est pas encore configurée pour cette version.';

  @override
  String get signInFailed => 'Connexion impossible. Veuillez réessayer.';

  @override
  String get dateLongPattern => 'EEEE d MMMM';

  @override
  String get dateShortPattern => 'd MMM';

  @override
  String get monthChipPattern => 'MMM y';

  @override
  String hello(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get helloNoName => 'Bonjour';

  @override
  String monthTotalLabel(String month) {
    return 'Dépensé ce mois-ci';
  }

  @override
  String compareLess(String percent, String month) {
    return '$percent % de moins qu’en $month';
  }

  @override
  String compareMore(String percent, String month) {
    return '$percent % de plus qu’en $month';
  }

  @override
  String compareSame(String month) {
    return 'Comme en $month';
  }

  @override
  String get heroEmpty => 'Ajoutez une première dépense pour commencer';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterLabel => 'Filtrer par catégorie';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get emptyTitle => 'Aucune dépense pour l’instant';

  @override
  String get emptySubtitle =>
      'Touchez + pour ajouter votre première dépense. Les petits pas comptent.';

  @override
  String emptyFilteredTitle(String category) {
    return 'Rien dans « $category » ce mois-ci';
  }

  @override
  String get emptyFilteredSubtitle =>
      'Choisissez une autre catégorie ou ajoutez une dépense.';

  @override
  String get addExpense => 'Ajouter une dépense';

  @override
  String get categoriesTooltip => 'Catégories';

  @override
  String get settingsTooltip => 'Réglages';

  @override
  String get delete => 'Supprimer';

  @override
  String expenseDeleted(String title) {
    return '« $title » supprimée';
  }

  @override
  String get undo => 'Annuler';

  @override
  String get errorLoading => 'Impossible de charger vos données.';

  @override
  String get errorNetwork =>
      'Vous êtes hors ligne. Affichage des données enregistrées sur l’appareil.';

  @override
  String get errorGeneric => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get retry => 'Réessayer';

  @override
  String get newExpense => 'Nouvelle dépense';

  @override
  String get editExpense => 'Modifier la dépense';

  @override
  String get amount => 'Montant';

  @override
  String get category => 'Catégorie';

  @override
  String get noteLabel => 'Note';

  @override
  String get notePlaceholder => 'Ajouter une note (facultatif)';

  @override
  String get add => 'Ajouter';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String get deleteExpense => 'Supprimer la dépense';

  @override
  String get close => 'Fermer';

  @override
  String get deleteDigit => 'Effacer';

  @override
  String get decimalPoint => 'Virgule';

  @override
  String get errorAmountRequired => 'Saisissez un montant supérieur à zéro.';

  @override
  String get errorCategoryRequired => 'Choisissez une catégorie.';

  @override
  String get chooseDate => 'Choisir la date';

  @override
  String get categoriesTitle => 'Catégories';

  @override
  String categoriesSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count catégories',
      one: '1 catégorie',
      zero: 'Aucune catégorie',
    );
    return '$_temp0 · glissez pour réordonner';
  }

  @override
  String categoryMeta(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dépenses',
      one: '1 dépense',
      zero: 'Aucune dépense',
    );
    return '$_temp0 · $amount';
  }

  @override
  String get addCategory => 'Ajouter une catégorie';

  @override
  String get addNewCategory => 'Ajouter une nouvelle catégorie';

  @override
  String get categoryDeleteNote =>
      'Supprimer une catégorie déplace ses dépenses vers « Autre » — rien n’est perdu.';

  @override
  String reorderCategory(String name) {
    return 'Réordonner $name';
  }

  @override
  String get newCategory => 'Nouvelle catégorie';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get categoryName => 'Nom de la catégorie';

  @override
  String get categoryNameHint => 'ex. : Sport';

  @override
  String get color => 'Couleur';

  @override
  String get icon => 'Icône';

  @override
  String get saveCategory => 'Enregistrer la catégorie';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String get errorNameRequired => 'Donnez un nom à la catégorie.';

  @override
  String deleteCategoryTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String deleteCategoryBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ses $count dépenses seront déplacées vers « Autre ».',
      one: 'Sa dépense sera déplacée vers « Autre ».',
      zero: 'Cette catégorie n’a aucune dépense.',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get catFood => 'Alimentation';

  @override
  String get catTransport => 'Transport';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catBills => 'Factures';

  @override
  String get catHealth => 'Santé';

  @override
  String get catOther => 'Autre';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorYellow => 'Jaune';

  @override
  String get colorGreen => 'Vert';

  @override
  String get colorTeal => 'Turquoise';

  @override
  String get colorBlue => 'Bleu';

  @override
  String get colorViolet => 'Violet';

  @override
  String get colorPink => 'Rose';

  @override
  String get colorRed => 'Rouge';

  @override
  String get iconDumbbell => 'Sport';

  @override
  String get iconCoffee => 'Café';

  @override
  String get iconBook => 'Éducation';

  @override
  String get iconGift => 'Cadeaux';

  @override
  String get iconHome => 'Maison';

  @override
  String get iconPlane => 'Voyage';

  @override
  String get iconMusic => 'Loisirs';

  @override
  String get iconPhone => 'Téléphone';

  @override
  String get iconGrad => 'Études';

  @override
  String get iconHeart => 'Famille';

  @override
  String get iconBag => 'Shopping';

  @override
  String get iconStar => 'Spécial';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get back => 'Retour';

  @override
  String get account => 'Compte';

  @override
  String get connectedWithGoogle => 'Connecté avec Google';

  @override
  String get appearance => 'Apparence';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get currency => 'Devise';

  @override
  String get chooseCurrency => 'Choisir la devise';

  @override
  String get currencyNote =>
      'Changer de devise ne change que le symbole — les montants ne sont pas convertis.';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get footerTagline => 'fait avec calme';

  @override
  String get currencyTND => 'Dinar tunisien';

  @override
  String get currencyEUR => 'Euro';

  @override
  String get currencyUSD => 'Dollar américain';

  @override
  String get currencyMAD => 'Dirham marocain';

  @override
  String get currencyDZD => 'Dinar algérien';

  @override
  String get currencyLYD => 'Dinar libyen';

  @override
  String widgetTodayA11y(String amount, String currency) {
    return 'Dépenses du jour : $amount $currency';
  }
}
