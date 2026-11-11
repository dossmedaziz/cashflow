class Expense {
  const Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  final String id;

  /// Thousandths of the currency unit (millimes for TND). Always > 0.
  final int amount;
  final String categoryId;
  final String? note;

  /// When the expense happened (local time).
  final DateTime date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense copyWith({int? amount, String? categoryId, String? note, bool clearNote = false, DateTime? date}) => Expense(
        id: id,
        amount: amount ?? this.amount,
        categoryId: categoryId ?? this.categoryId,
        note: clearNote ? null : (note ?? this.note),
        date: date ?? this.date,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );

  factory Expense.fromJson(Map<String, dynamic> j) => Expense(
        id: j['id'] as String,
        amount: (j['amount'] as num).toInt(),
        categoryId: j['category_id'] as String,
        note: j['note'] as String?,
        date: DateTime.parse(j['date'] as String).toLocal(),
        createdAt: j['created_at'] == null ? null : DateTime.parse(j['created_at'] as String).toLocal(),
        updatedAt: j['updated_at'] == null ? null : DateTime.parse(j['updated_at'] as String).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'category_id': categoryId,
        'note': note,
        'date': date.toUtc().toIso8601String(),
        if (createdAt != null) 'created_at': createdAt!.toUtc().toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toUtc().toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      other is Expense &&
      other.id == id &&
      other.amount == amount &&
      other.categoryId == categoryId &&
      other.note == note &&
      other.date == date;

  @override
  int get hashCode => Object.hash(id, amount, categoryId, note, date);
}

/// Fields the user enters in the add/edit sheet.
class ExpenseInput {
  ExpenseInput({required this.amount, required this.categoryId, required this.date, String? note})
      : note = (note == null || note.trim().isEmpty) ? null : note.trim();

  final int amount;
  final String categoryId;
  final DateTime date;
  final String? note;

  /// Validation errors, empty when valid.
  List<ExpenseInputError> validate() => [
        if (amount <= 0) ExpenseInputError.amount,
        if (categoryId.isEmpty) ExpenseInputError.category,
      ];
}

enum ExpenseInputError { amount, category }
