import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firestore_service.dart';

class CashBoxPage extends StatefulWidget {
  const CashBoxPage({super.key});

  @override
  State<CashBoxPage> createState() => _CashBoxPageState();
}

class _CashBoxPageState extends State<CashBoxPage> {
  double total = 0.0;
  double cashtotal = 0.0;
  double visatotal = 0.0;
  List<Map<String, dynamic>> transactions = [];
  bool loading = true;
  String _lang = 'ar';

  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadData();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _loadData() async {
    double sum = 0.0;
    double cash = 0.0;
    double visa = 0.0;
    List<Map<String, dynamic>> all = [];

    // 🟢 بيع القطع
    final salesSnap = await FS.salesCol().get();
    for (var d in salesSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final wage = (data['payment']?['total'] ?? 0).toDouble();
      final totalcash = (data['payment']?['cash'] ?? 0).toDouble();
      final totalvisa = (data['payment']?['visa'] ?? 0).toDouble();
      final date = (data['createdAt'] as Timestamp?)?.toDate();
      all.add({
        "type": _t("بيع قطعة", "Piece Sale"),
        "value": wage,
        "date": date,
        "data": data,
      });
      sum += wage;
      cash += totalcash;
      visa += totalvisa;
    }

    // 🟢 بيع كسر
    final scrapSnap = await FS.scrapCol().where("type", isEqualTo: "sale").get();
    for (var d in scrapSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final wage = (data['total'] ?? 0).toDouble();
      final totalcash = (data['cash'] ?? 0).toDouble();
      final totalvisa = (data['network'] ?? 0).toDouble();
      final date = (data['date'] as Timestamp?)?.toDate();
      all.add({
        "type": _t("بيع كسر", "Scrap Sale"),
        "value": wage,
        "date": date,
        "data": data,
      });
      sum += wage;
      cash += totalcash;
      visa += totalvisa;
    }

    // 🔴 شراء كسر
    final scrapBuySnap = await FS.scrapCol().where("type", isEqualTo: "add").get();
    for (var d in scrapBuySnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final wage = (data['total'] ?? 0).toDouble();
      final totalcash = (data['cash'] ?? 0).toDouble();
      final totalvisa = (data['network'] ?? 0).toDouble();
      final date = (data['date'] as Timestamp?)?.toDate();
      all.add({
        "type": _t("شراء كسر", "Scrap Purchase"),
        "value": -wage,
        "date": date,
        "data": data,
      });
      sum -= wage;
      cash -= totalcash;
      visa -= totalvisa;
    }

    // 🔴 سندات الصرف
    final vouchersSnap = await FS.vouchersCol().where("type", isEqualTo: "payment").get();
    for (var d in vouchersSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final wage = (data['total'] ?? 0).toDouble();
      final totalcash = (data['cash'] ?? 0).toDouble();
      final totalvisa = (data['network'] ?? 0).toDouble();
      final date = (data['date'] as Timestamp?)?.toDate();
      all.add({
        "type": _t("سند صرف", "Payment Voucher"),
        "value": -wage,
        "date": date,
        "data": data,
      });
      sum -= wage;
      cash -= totalcash;
      visa -= totalvisa;
    }

    // 🔴 المصروفات
    final expSnap = await FS.expensesCol().get();
    for (var d in expSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final amount = double.tryParse(data['amount'].toString()) ?? 0.0;
      final date = (data['date'] as Timestamp?)?.toDate();

      final displayType = _t('مصروف', 'Expense');
      all.add({
        "type": displayType,
        "value": -amount,
        "date": date,
        "data": data,
      });
      sum -= amount;
      cash -= amount;
    }

    // 🔵 توريد للإدارة
    final depositSnap = await FS.depositsCol().get();
    for (var d in depositSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final totalcash = (data['cash'] ?? 0).toDouble();
      final totalvisa = (data['visa'] ?? 0).toDouble();
      final totalValue = totalcash + totalvisa;
      final date = (data['date'] as Timestamp?)?.toDate();
      all.add({
        "type": _t("توريد للإدارة", "Deposit to Admin"),
        "value": -totalValue,
        "date": date,
        "data": data,
      });
      sum -= totalValue;
      cash -= totalcash;
      visa -= totalvisa;
    }
    // 🔵 استيراد من الإدارة
    final ImportSnap = await FS.ImportedCol().get();
    for (var d in ImportSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final totalcash = (data['cash'] ?? 0).toDouble();
      final totalvisa = (data['visa'] ?? 0).toDouble();
      final totalValue = totalcash + totalvisa;
      final date = (data['date'] as Timestamp?)?.toDate();
      all.add({
        "type": _t("استيراد من الادارة", "Deposit to Admin"),
        "value": totalValue,
        "date": date,
        "data": data,
      });
      sum += totalValue;
      cash += totalcash;
      visa += totalvisa;
    }

    all.sort((a, b) => (b['date'] ?? DateTime.now()).compareTo(a['date'] ?? DateTime.now()));

    setState(() {
      total = sum;
      cashtotal = cash;
      visatotal = visa;
      transactions = all;
      loading = false;
    });
  }

  void _addDepositDialog() {
    String type = "كاش";
    final cashCtrl = TextEditingController();
    final visaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(_t("توريد للإدارة", "Deposit to Admin")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: type,
                isExpanded: true,
                items: [
                  DropdownMenuItem(value: "كاش", child: Text(_t("كاش", "Cash"))),
                  DropdownMenuItem(value: "شبكة", child: Text(_t("شبكة", "Network"))),
                  DropdownMenuItem(value: "متعدد", child: Text(_t("متعدد", "Mixed"))),
                ],
                onChanged: (val) => setDialogState(() => type = val!),
              ),
              if (type == "كاش" || type == "متعدد")
                TextField(
                  controller: cashCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: _t("مبلغ الكاش", "Cash Amount")),
                ),
              const SizedBox(height: 15),
              if (type == "شبكة" || type == "متعدد")
                TextField(
                  controller: visaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: _t("مبلغ الشبكة", "Network Amount")),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t("إلغاء", "Cancel")),
            ),
            ElevatedButton(
              onPressed: () async {
                final cash = double.tryParse(cashCtrl.text) ?? 0.0;
                final visa = double.tryParse(visaCtrl.text) ?? 0.0;
                await FS.depositsCol().add({
                  "type": type,
                  "cash": cash,
                  "total": cash + visa,
                  "visa": visa,
                  "date": DateTime.now(),
                });
                Navigator.pop(context);
                _loadData();
              },
              child: Text(_t("حفظ", "Save")),
            ),
          ],
        ),
      ),
    );
  }
  void _addImportedDialog() {
    String type = "كاش";
    final cashCtrl = TextEditingController();
    final visaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(_t("استيراد من الادارة", "Import from Admin")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: type,
                isExpanded: true,
                items: [
                  DropdownMenuItem(value: "كاش", child: Text(_t("كاش", "Cash"))),
                  DropdownMenuItem(value: "شبكة", child: Text(_t("شبكة", "Network"))),
                  DropdownMenuItem(value: "متعدد", child: Text(_t("متعدد", "Mixed"))),
                ],
                onChanged: (val) => setDialogState(() => type = val!),
              ),
              if (type == "كاش" || type == "متعدد")
                TextField(
                  controller: cashCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: _t("مبلغ الكاش", "Cash Amount")),
                ),
              const SizedBox(height: 15),
              if (type == "شبكة" || type == "متعدد")
                TextField(
                  controller: visaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: _t("مبلغ الشبكة", "Network Amount")),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_t("إلغاء", "Cancel")),
            ),
            ElevatedButton(
              onPressed: () async {
                final cash = double.tryParse(cashCtrl.text) ?? 0.0;
                final visa = double.tryParse(visaCtrl.text) ?? 0.0;
                await FS.ImportedCol().add({
                  "type": type,
                  "cash": cash,
                  "total": cash + visa,
                  "visa": visa,
                  "date": DateTime.now(),
                });
                Navigator.pop(context);
                _loadData();
              },
              child: Text(_t("حفظ", "Save")),
            ),
          ],
        ),
      ),
    );
  }
  final Map<String, Map<String, String>> fieldNames = {
    "person": {"ar": "المعاملة", "en": "Transaction"},
    "wage": {"ar": "الأجر", "en": "Wage"},
    "weight": {"ar": "الوزن", "en": "Weight"},
    "carat": {"ar": "العيار", "en": "Carat"},
    "notes": {"ar": "ملاحظات", "en": "Notes"},
    "note": {"ar": "ملاحظات", "en": "Note"},
    "type": {"ar": "النوع", "en": "Type"},
    "amount": {"ar": "المبلغ", "en": "Amount"},
    "createdAt": {"ar": "تاريخ الإنشاء", "en": "Created At"},
    "date": {"ar": "التاريخ", "en": "Date"},
    "delegate": {"ar": "المندوب", "en": "Delegate"},
    "supplier": {"ar": "المورد", "en": "Supplier"},
    "category": {"ar": "الفئة", "en": "Category"},
    "price": {"ar": "السعر", "en": "Price"},
    "total": {"ar": "الإجمالي", "en": "Total"},
    "itemId": {"ar": "رقم القطعة", "en": "Item ID"},
    "epcHex": {"ar": "Rfid", "en": "Rfid"},
    "qrCode": {"ar": "الكود", "en": "QR Code"},
    "showQr": {"ar": "عرض QR", "en": "Show QR"},
    "kind": {"ar": "النوع", "en": "Kind"},
    "visa": {"ar": "شبكة", "en": "Network"},
    "cash": {"ar": "كاش", "en": "Cash"},
    "payload": {"ar": "تفاصيل الشريحة", "en": "Payload Details"},
    "payment": {"ar": "تفاصيل الدفع", "en": "Payment Details"},
    "soldAt": {"ar": "تاريخ البيع", "en": "Sold At"},
    "supplierName": {"ar": "اسم المورد", "en": "Supplier Name"},
    "supplierId": {"ar": "الرقم التسلسلي", "en": "Supplier ID"},
    "network": {"ar": "شبكة", "en": "Network"},
    "paymentMethod": {"ar": "طريقة الدفع", "en": "Payment Method"},
    "cost": {"ar": "التكلفة", "en": "Cost"},
    "updatedAt": {"ar": "تاريخ التحديث", "en": "Updated At"},
    "soldBy": {"ar": "بيع بواسطة", "en": "soldBy"},
    "partialSale": {"ar": "بيع جزئي", "en": "partialSale"},
  };


  void _showDetails(Map<String, dynamic> data, String type) {
    List<Widget> buildFields(dynamic value, {String? key, int indent = 0}) {
      List<Widget> widgets = [];

      if (value is Map<String, dynamic>) {
        value.forEach((k, v) {
          widgets.addAll(buildFields(v, key: k, indent: indent + 1));
        });
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          widgets.addAll(buildFields(value[i], key: "${key ?? 'Item'} ${i+1}", indent: indent + 1));
        }
      } else {
        String label = key != null ? (fieldNames[key]?[_lang] ?? key) : '';
        if (value is Timestamp) value = value.toDate().toString().split(' ').first;
        widgets.add(
          Padding(
            padding: EdgeInsets.only(left: indent * 12.0, top: 4),
            child: Row(
              children: [
                Expanded(child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text(value.toString(), textAlign: TextAlign.right)),
              ],
            ),
          ),
        );
      }

      return widgets;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(_lang == 'ar' ? "تفاصيل $type" : "$type Details"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildFields(data),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_lang == 'ar' ? "إغلاق" : "Close"),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("الصندوق", "Cash Box")),
        backgroundColor: const Color(0xFFD4AF37),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            tooltip: _t("توريد للإدارة", "Deposit to Admin"),
            onPressed: _addDepositDialog,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: _t("استيراد من الادارة", "Import from Admin"),
            onPressed: _addImportedDialog,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              color: Colors.green[50],
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      _t("إجمالي الصندوق", "Total Balance"),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${total.toStringAsFixed(2)} ${_t("ريال", "SAR")}",
                      style: TextStyle(
                        fontSize: 22,
                        color: total >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(children: [
                          Text(_t("كاش", "Cash"),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(cashtotal.toStringAsFixed(2)),
                        ]),
                        Column(children: [
                          Text(_t("شبكة", "Network"),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(visatotal.toStringAsFixed(2)),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                elevation: 3,
                child: ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final t = transactions[index];
                    final date = t['date'] != null
                        ? "${t['date'].day}/${t['date'].month}/${t['date'].year}"
                        : '';
                    return ListTile(
                      onTap: () => _showDetails(t['data'], t['type']),
                      leading: Icon(
                        t['value'] >= 0
                            ? Icons.add_circle
                            : Icons.remove_circle,
                        color:
                        t['value'] >= 0 ? Colors.green : Colors.red,
                      ),
                      title: Text(t['type']),
                      subtitle: Text(date),
                      trailing: Text(
                        "${t['value'] >= 0 ? '+' : ''}${t['value'].toStringAsFixed(2)}",
                        style: TextStyle(
                          color: t['value'] >= 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
