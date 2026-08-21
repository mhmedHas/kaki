class Item {
  final String id; // Firestore doc id
  final String userId;
  final String code; // readable code (same as EPC hex)
  final String epcHex; // 24 hex chars (96-bit EPC)
  final String category; // gold | gem
  final DateTime date;
  final Map<String, dynamic> payload; // gold or gem fields
  final String status; // active | sold
  Item({
    required this.id,
    required this.userId,
    required this.code,
    required this.epcHex,
    required this.category,
    required this.date,
    required this.payload,
    this.status = 'active',
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'code': code,
    'epcHex': epcHex,
    'category': category,
    'date': date,
    'payload': payload,
    'status': status,
    'createdAt': DateTime.now(),
  };

  static Item fromMap(String id, Map<String, dynamic> m) => Item(
    id: id,
    userId: m['userId'],
    code: m['code'],
    epcHex: m['epcHex'],
    category: m['category'],
    date: (m['date'] as DateTime?) ?? DateTime.tryParse(m['date'].toString()) ?? DateTime.now(),
    payload: Map<String, dynamic>.from(m['payload']),
    status: m['status'] ?? 'active',
  );
}
