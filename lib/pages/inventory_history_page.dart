import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';

class InventoryHistoryPage extends StatefulWidget {
  const InventoryHistoryPage({super.key});

  @override
  State<InventoryHistoryPage> createState() => _InventoryHistoryPageState();
}

class _InventoryHistoryPageState extends State<InventoryHistoryPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('سجل الجرد'),
        backgroundColor: const Color(0xFFD4AF37),
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Column(
        children: [
          // 🔍 شريط البحث
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث برقم الشريحة (EPC) أو الباركود...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val.trim().toUpperCase());
              },
            ),
          ),

          // 📋 قائمة العناصر
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FS
                  .invCol()
                  .orderBy('lastSeenAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text(
                          'لا يوجد سجل جرد حتى الآن',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // فلترة العناصر حسب البحث
                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final epc = (data['epcHex'] ?? '').toString().toUpperCase();
                  final payload =
                      data['payload'] as Map<String, dynamic>? ?? {};
                  final qr = (payload['qrCode'] ?? '').toString().toUpperCase();
                  return epc.contains(_searchQuery) ||
                      qr.contains(_searchQuery);
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Text('لا توجد نتائج مطابقة للبحث'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return _buildHistoryCard(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> data) {
    final payload = data['payload'] as Map<String, dynamic>? ?? {};
    final epcHex = data['epcHex'] ?? '';
    final category = data['category'] ?? '';
    final lastSeenAt = (data['lastSeenAt'] as Timestamp?)?.toDate();

    String dateStr = 'غير متوفر';
    if (lastSeenAt != null) {
      dateStr = DateFormat('yyyy/MM/dd - hh:mm a').format(lastSeenAt);
    }

    // تحديد أيقونة ولون القسم
    IconData catIcon = Icons.help_outline;
    Color catColor = Colors.grey;
    String catName = 'غير محدد';

    switch (category) {
      case 'gold':
        catIcon = Icons.workspace_premium;
        catColor = const Color(0xFFD4AF37);
        catName = 'ذهب';
        break;
      case 'bullion':
        catIcon = Icons.account_balance;
        catColor = const Color(0xFFD4AF37);
        catName = 'سبائك';
        break;
      case 'gem':
        catIcon = Icons.diamond;
        catColor = Colors.purple;
        catName = 'أحجار';
        break;
      case 'scrap':
        catIcon = Icons.recycling;
        catColor = Colors.orange;
        catName = 'كسر';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: catColor.withOpacity(0.15),
          child: Icon(catIcon, color: catColor),
        ),
        title: Text(
          epcHex.isNotEmpty ? epcHex : 'بدون شريحة',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          'التاريخ: $dateStr',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row(Icons.category, 'القسم', catName),
                if (payload['carat'] != null)
                  _row(Icons.grade, 'العيار', '${payload['carat']}'),
                if (payload['weight'] != null)
                  _row(Icons.scale, 'الوزن', '${payload['weight']} جم'),
                if (payload['wage'] != null)
                  _row(Icons.attach_money, 'المصنعية', '${payload['wage']}'),
                if (payload['cost'] != null)
                  _row(Icons.payments, 'التكلفة', '${payload['cost']}'),
                if (payload['type'] != null)
                  _row(Icons.diamond, 'نوع الحجر', '${payload['type']}'),
                if (payload['qrCode'] != null)
                  _row(Icons.qr_code, 'الباركود', '${payload['qrCode']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
