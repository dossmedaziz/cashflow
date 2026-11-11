import '../../../core/l10n/l10n.dart';

/// Keys of the six categories seeded for every new user.
abstract final class DefaultCategory {
  static const food = 'food';
  static const transport = 'transport';
  static const shopping = 'shopping';
  static const bills = 'bills';
  static const health = 'health';
  static const other = 'other';

  static const keys = [food, transport, shopping, bills, health, other];

  static String localizedName(AppLocalizations l10n, String key) => switch (key) {
        food => l10n.catFood,
        transport => l10n.catTransport,
        shopping => l10n.catShopping,
        bills => l10n.catBills,
        health => l10n.catHealth,
        _ => l10n.catOther,
      };
}

class Category {
  const Category({
    required this.id,
    required this.colorHex,
    required this.iconKey,
    required this.order,
    this.name,
    this.defaultKey,
    this.isDefault = false,
  });

  final String id;

  /// Custom name. Null for an untouched default category, whose name is
  /// localized from [defaultKey] so it follows the app language.
  final String? name;
  final String? defaultKey;
  final String colorHex;
  final String iconKey;
  final int order;
  final bool isDefault;

  bool get isOther => defaultKey == DefaultCategory.other;

  String displayName(AppLocalizations l10n) =>
      name ?? (defaultKey != null ? DefaultCategory.localizedName(l10n, defaultKey!) : '');

  Category copyWith({String? name, bool clearName = false, String? colorHex, String? iconKey, int? order}) => Category(
        id: id,
        name: clearName ? null : (name ?? this.name),
        defaultKey: defaultKey,
        colorHex: colorHex ?? this.colorHex,
        iconKey: iconKey ?? this.iconKey,
        order: order ?? this.order,
        isDefault: isDefault,
      );

  factory Category.fromJson(Map<String, dynamic> j) => Category(
        id: j['id'] as String,
        name: j['name'] as String?,
        defaultKey: j['default_key'] as String?,
        colorHex: j['color_hex'] as String,
        iconKey: j['icon_key'] as String,
        order: (j['sort_order'] as num?)?.toInt() ?? 0,
        isDefault: j['is_default'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'default_key': defaultKey,
        'color_hex': colorHex,
        'icon_key': iconKey,
        'sort_order': order,
        'is_default': isDefault,
      };

  @override
  bool operator ==(Object other) =>
      other is Category &&
      other.id == id &&
      other.name == name &&
      other.defaultKey == defaultKey &&
      other.colorHex == colorHex &&
      other.iconKey == iconKey &&
      other.order == order &&
      other.isDefault == isDefault;

  @override
  int get hashCode => Object.hash(id, name, defaultKey, colorHex, iconKey, order, isDefault);
}

/// User-editable fields of a category.
class CategoryInput {
  const CategoryInput({required this.name, required this.colorHex, required this.iconKey});

  /// Null keeps a default category's localized name.
  final String? name;
  final String colorHex;
  final String iconKey;
}
