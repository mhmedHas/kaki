// // import 'dart:async';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'dart:typed_data';

// // class FS {
// //   static final _db = FirebaseFirestore.instance;
// //   static String get uid => FirebaseAuth.instance.currentUser!.uid;

// //   static CollectionReference itemsCol() =>
// //       _db.collection('users').doc(uid).collection('items');
// //   static CollectionReference invCol() =>
// //       _db.collection('users').doc(uid).collection('inventories');
// //   static CollectionReference salesCol() =>
// //       _db.collection('users').doc(uid).collection('sales');
// //   static CollectionReference salesHistoryCol() =>
// //       _db.collection('users').doc(uid).collection('sales_history');
// //   static CollectionReference depositsCol() =>
// //       _db.collection('users').doc(uid).collection('managementDeposits');
// //   static CollectionReference ImportedCol() =>
// //       _db.collection('users').doc(uid).collection('managementImported');
// //   static CollectionReference vouchersCol() =>
// //       _db.collection('users').doc(uid).collection('vouchers');
// //   static CollectionReference scrapCol() =>
// //       _db.collection('users').doc(uid).collection('scrapTransactions');
// //   static CollectionReference suppliersCol() =>
// //       _db.collection('users').doc(uid).collection('suppliers');
// //   static CollectionReference expensesCol() =>
// //       _db.collection('users').doc(uid).collection('expenses');
// //   static CollectionReference externalCol() =>
// //       _db.collection('users').doc(uid).collection('externalTransactions');
// //   static CollectionReference branchesCol() =>
// //       _db.collection('users').doc(uid).collection('branches');
// //   static CollectionReference balancesCol() =>
// //       _db.collection('users').doc(uid).collection('balances');
// //   static CollectionReference setRemaindersCol() =>
// //       _db.collection('users').doc(uid).collection('setRemainders');
// //   static CollectionReference deletedItemsCol() =>
// //       _db.collection('users').doc(uid).collection('deleted_items');

// //   static Future<void> saveItem({
// //     required String epcHex,
// //     required String category,
// //     required DateTime date,
// //     required Map<String, dynamic> payload,
// //     required bool fromOpeningBalance,
// //   }) async {
// //     final doc = itemsCol().doc();
// //     await doc.set({
// //       'userId': uid,
// //       'code': epcHex,
// //       'epcHex': epcHex,
// //       'category': category,
// //       'date': date,
// //       'payload': payload,
// //       'status': 'active',
// //       'createdAt': FieldValue.serverTimestamp(),
// //       'fromOpeningBalance': fromOpeningBalance,
// //     });
// //   }

// //   /// 📦 إرجاع عدد العناصر داخل كولكشن items
// //   static Future<int> getItemsCount() async {
// //     try {
// //       final snapshot = await itemsCol().get();
// //       return snapshot.size;
// //     } catch (e) {
// //       debugPrint("❌ خطأ أثناء جلب عدد العناصر: $e");
// //       return 0;
// //     }
// //   }

// //   /// ✅ تحديث عنصر (يدعم dot notation)
// //   static Future<void> uupdateItem(
// //       String epcHex, Map<String, dynamic> updates) async {
// //     final epc = epcHex.trim();

// // // البحث بالنظام الجديد
// //     QuerySnapshot q =
// //         await itemsCol().where("epcHex", isEqualTo: epc).limit(1).get();

// // // لو ملقاش، ابحث بالنظام القديم
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where("epcHex", isEqualTo: "${epc}ENTRE")
// //           .limit(1)
// //           .get();

// //       // لو لقى سجل قديم حدثه تلقائياً
// //       if (q.docs.isNotEmpty) {
// //         await itemsCol().doc(q.docs.first.id).update({
// //           "epcHex": epc,
// //         });
// //       }
// //     }

// //     if (q.docs.isEmpty) {
// //       throw Exception("⚠️ العنصر غير موجود");
// //     }

// //     final doc = q.docs.first;

// //     await itemsCol().doc(doc.id).update({
// //       ...updates,
// //       "updatedAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// ✅ تحديث عنصر (يدعم dot notation)
// //   static Future<void> updateItem(
// //       String epcHex, Map<String, dynamic> updates) async {
// //     final cleanEpc = epcHex.trim().toUpperCase();
// //     print("🛠️ محاولة تحديث العنصر برقم: $cleanEpc");

// // // 🔹 البحث بالنظام الجديد
// //     var q =
// //         await itemsCol().where("epcHex", isEqualTo: cleanEpc).limit(1).get();

// //     print("📄 نتائج البحث في epcHex: ${q.docs.length}");

// // // 🔹 لو مفيش نتيجة، ابحث بالنظام القديم (ENTRE)
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where("epcHex", isEqualTo: "${cleanEpc}ENTRE")
// //           .limit(1)
// //           .get();

// //       print("📄 نتائج البحث في epcHex القديم: ${q.docs.length}");

// //       // Migration تلقائي
// //       if (q.docs.isNotEmpty) {
// //         await itemsCol().doc(q.docs.first.id).update({
// //           "epcHex": cleanEpc,
// //         });
// //       }
// //     }

// //     // 🔹 لو مفيش نتيجة، ابحث في payload.qrCode
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where("payload.qrCode", isEqualTo: cleanEpc)
// //           .limit(1)
// //           .get();

// //       print("📄 نتائج البحث في payload.qrCode: ${q.docs.length}");
// //     }

// //     // 🔹 لو مفيش أي نتيجة
// //     if (q.docs.isEmpty) {
// //       throw Exception("⚠️ العنصر غير موجود في قاعدة البيانات!");
// //     }

// //     // 🔹 تحديث العنصر
// //     final doc = q.docs.first;
// //     await itemsCol().doc(doc.id).update({
// //       ...updates,
// //       "updatedAt": FieldValue.serverTimestamp(),
// //     });

// //     print("✅ تم تحديث العنصر بنجاح: ${doc.id}");
// //   }

// //   static Future<void> uploadImage(
// //       String epcHex, Map<String, dynamic> updates) async {
// //     final cleanEpc = epcHex.trim().toUpperCase();
// //     print("🛠️ محاولة تحديث العنصر برقم: $cleanEpc");

// // // 🔹 البحث بالنظام الجديد
// //     var q =
// //         await itemsCol().where("epcHex", isEqualTo: cleanEpc).limit(1).get();

// //     print("📄 نتائج البحث في epcHex: ${q.docs.length}");

// // // 🔹 لو مفيش نتيجة، ابحث بالنظام القديم (ENTRE)
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where("epcHex", isEqualTo: "${cleanEpc}ENTRE")
// //           .limit(1)
// //           .get();

// //       print("📄 نتائج البحث في epcHex القديم: ${q.docs.length}");

// //       // Migration تلقائي
// //       if (q.docs.isNotEmpty) {
// //         await itemsCol().doc(q.docs.first.id).update({
// //           "epcHex": cleanEpc,
// //         });
// //       }
// //     }

// //     // 🔹 لو مفيش نتيجة، ابحث في payload.qrCode
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where("payload.qrCode", isEqualTo: cleanEpc)
// //           .limit(1)
// //           .get();

// //       print("📄 نتائج البحث في payload.qrCode: ${q.docs.length}");
// //     }

// //     // 🔹 لو مفيش أي نتيجة
// //     if (q.docs.isEmpty) {
// //       throw Exception("⚠️ العنصر غير موجود في قاعدة البيانات!");
// //     }

// //     // 🔹 تحديث العنصر
// //     final doc = q.docs.first;
// //     await itemsCol().doc(doc.id).update({
// //       ...updates,
// //     });

// //     print("✅ تم تحديث العنصر بنجاح: ${doc.id}");
// //   }

// //   static Future<Map<String, dynamic>?> findItemByEpc(String epcHex,
// //       {bool includeBalances = false}) async {
// //     final epc = epcHex.toUpperCase();
// //     print("🔎 البحث عن: $epcHex");

// //     var q = await itemsCol().where('epcHex', isEqualTo: epc).limit(1).get();
// //     print("📄 عدد النتائج في items.epcHex: ${q.docs.length}");

// // // البحث بالنظام القديم
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where('epcHex', isEqualTo: "${epc}ENTRE")
// //           .limit(1)
// //           .get();

// //       print("📄 عدد النتائج في items.epcHex القديم: ${q.docs.length}");
// //       // Migration تلقائي
// //       if (q.docs.isNotEmpty) {
// //         await itemsCol().doc(q.docs.first.id).update({
// //           "epcHex": epc,
// //         });
// //       }
// //     }

// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where('payload.qrCode', isEqualTo: epcHex)
// //           .limit(1)
// //           .get();
// //       print("📄 عدد النتائج في items.payload.qrCode: ${q.docs.length}");
// //     }

// //     bool foundInBalances = false;
// //     if (q.docs.isEmpty && includeBalances) {
// //       q = await balancesCol().where('epcHex', isEqualTo: epc).limit(1).get();
// //       print("📄 عدد النتائج في balances.epcHex: ${q.docs.length}");

// //       if (q.docs.isEmpty) {
// //         q = await balancesCol()
// //             .where('epcHex', isEqualTo: "${epc}ENTRE")
// //             .limit(1)
// //             .get();

// //         print("📄 عدد النتائج في balances.epcHex القديم: ${q.docs.length}");
// //         // Migration تلقائي
// //         if (q.docs.isNotEmpty) {
// //           await balancesCol().doc(q.docs.first.id).update({
// //             "epcHex": epc,
// //           });
// //         }
// //       }
// //       if (q.docs.isEmpty) {
// //         q = await balancesCol()
// //             .where('payload.qrCode', isEqualTo: epcHex)
// //             .limit(1)
// //             .get();
// //         print("📄 عدد النتائج في balances.payload.qrCode: ${q.docs.length}");
// //       }
// //       foundInBalances = q.docs.isNotEmpty;
// //     }

// //     if (q.docs.isEmpty) {
// //       print("❌ مفيش نتيجة");
// //       return null;
// //     }

// //     final d = q.docs.first;
// //     print("✅ تم العثور على العنصر: ${d.id}");
// //     return {
// //       'id': d.id,
// //       'collection': foundInBalances ? 'balances' : 'items',
// //       ...d.data() as Map<String, dynamic>
// //     };
// //   }

// //   static Future<Map<String, dynamic>?> epcandcode(String epcHex) async {
// //     final epc = epcHex.toUpperCase();
// //     print("🔎 البحث عن: $epc");

// //     QuerySnapshot q =
// //         await itemsCol().where('epcHex', isEqualTo: epc).limit(1).get();

// //     print("📄 عدد النتائج في items.epcHex: ${q.docs.length}");

// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where('epcHex', isEqualTo: "${epc}ENTRE")
// //           .limit(1)
// //           .get();

// //       print("📄 عدد النتائج في items.epcHex القديم: ${q.docs.length}");
// //     }

// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where('payload.qrCode', isEqualTo: epcHex)
// //           .limit(1)
// //           .get();
// //       print("📄 عدد النتائج في items.payload.qrCode: ${q.docs.length}");
// //     }

// //     if (q.docs.isEmpty) {
// //       q = await balancesCol().where('epcHex', isEqualTo: epc).limit(1).get();

// //       print("📄 عدد النتائج في balances.epcHex: ${q.docs.length}");
// //     }

// //     if (q.docs.isEmpty) {
// //       q = await balancesCol()
// //           .where('epcHex', isEqualTo: "${epc}ENTRE")
// //           .limit(1)
// //           .get();

// //       print("📄 عدد النتائج في balances.epcHex القديم: ${q.docs.length}");
// //     }

// //     if (q.docs.isEmpty) {
// //       q = await balancesCol()
// //           .where('payload.qrCode', isEqualTo: epcHex)
// //           .limit(1)
// //           .get();
// //       print("📄 عدد النتائج في balances.payload.qrCode: ${q.docs.length}");
// //     }

// //     if (q.docs.isEmpty) {
// //       print("❌ مفيش نتيجة");
// //       return null;
// //     }

// //     final d = q.docs.first;
// //     final data = d.data() as Map<String, dynamic>;
// //     final payload = data['payload'] as Map<String, dynamic>?;

// //     return {
// //       'id': d.id,
// //       'epcHex': data['epcHex'],
// //       'qrCode': payload?['qrCode'],
// //       'collection': d.reference.parent.id,
// //     };
// //   }

// //   static Future<List<Map<String, dynamic>>> getAllEpcAndQr() async {
// //     print("📦 جلب كل الشرائح...");

// //     final QuerySnapshot q = await itemsCol().get();

// //     print("📄 عدد الشرائح: ${q.docs.length}");

// //     return q.docs.map((doc) {
// //       final data = doc.data() as Map<String, dynamic>;
// //       final payload = data['payload'] as Map<String, dynamic>?;

// //       return {
// //         'id': doc.id,
// //         'qrCode': payload?['qrCode'],
// //         ...data,
// //       };
// //     }).toList();
// //   }

// //   static Future<void> upsertInventory(
// //       String epcHex, Map<String, dynamic>? itemData) async {
// //     final now = FieldValue.serverTimestamp();

// //     // لو العنصر مش موجود في items أصلاً
// //     if (itemData == null) {
// //       final existingInv =
// //           await invCol().where('epcHex', isEqualTo: epcHex).limit(1).get();
// //       if (existingInv.docs.isEmpty) {
// //         await invCol().add({
// //           'epcHex': epcHex,
// //           'itemId': null,
// //           'firstSeenAt': now,
// //           //'lastSeenAt': now,
// //           'scanCount': 1,
// //         });
// //       } else {
// //         final doc = existingInv.docs.first;
// //         final currentCount =
// //             (doc.data() as Map<String, dynamic>)['scanCount'] ?? 1;
// //         await invCol().doc(doc.id).update({
// //           //'lastSeenAt': now,
// //           'scanCount': currentCount + 1,
// //         });
// //       }
// //     } else {
// //       final itemId = itemData['id'];
// //       final category = itemData['category'];
// //       final payload = itemData['payload'];

// //       final q =
// //           await invCol().where('itemId', isEqualTo: itemId).limit(1).get();
// //       if (q.docs.isEmpty) {
// //         await invCol().add({
// //           'epcHex': epcHex,
// //           'itemId': itemId,
// //           'category': category, // ✅ تخزين النوع
// //           'payload': payload, // ✅ تخزين التفاصيل
// //           'firstSeenAt': now,
// //           'lastSeenAt': now,
// //           'scanCount': 1,
// //           'createdAt': now,
// //         });
// //       } else {
// //         final doc = q.docs.first;
// //         final currentCount =
// //             (doc.data() as Map<String, dynamic>)['scanCount'] ?? 1;
// //         await invCol().doc(doc.id).update({
// //           'lastSeenAt': now,
// //           'scanCount': currentCount + 1,
// //           'category': category, // ✅ تحديث النوع
// //           'payload': payload, // ✅ تحديث التفاصيل
// //         });
// //       }
// //     }
// //   }

// //   /*static Future<void> deleteItem(String epcHex) async {
// //     final d = await findItemByEpc(epcHex);
// //     if (d == null) return;
// //     final itemRef = itemsCol().doc(d['id']);
// //     await itemRef.delete();
// //   }*/
// //   static Future<void> deleteItem(String epcHex) async {
// //     final d = await findItemByEpc(epcHex);
// //     if (d == null) return;

// //     final itemRef = itemsCol().doc(d['id']);
// //     final deletedRef = deletedItemsCol().doc(d['id']);

// //     final data = Map<String, dynamic>.from(d);
// //     await deleteItemImages(epcHex);

// //     data.remove('id');
// //     data.remove('collection');
// //     data['deletedAt'] = FieldValue.serverTimestamp();
// //     data['originalDocId'] = d['id'];

// //     await _db.runTransaction((transaction) async {
// //       transaction.set(deletedRef, data);
// //       transaction.delete(itemRef);
// //     });
// //   }

// //   static Future<void> deleteItemImages(String epc) async {
// //     try {
// //       final uid = FirebaseAuth.instance.currentUser!.uid;
// //       final cleanEpc = epc.toUpperCase();

// //       // 🔹 جرب الفولدر الجديد أولاً
// //       Reference sourceFolder = FirebaseStorage.instance
// //           .ref()
// //           .child('images')
// //           .child('users')
// //           .child(uid)
// //           .child(cleanEpc);

// //       ListResult result = await sourceFolder.listAll();

// //       // 🔹 لو مفيش صور، جرب الفولدر القديم (ENTRE)
// //       if (result.items.isEmpty) {
// //         sourceFolder = FirebaseStorage.instance
// //             .ref()
// //             .child('images')
// //             .child('users')
// //             .child(uid)
// //             .child("${cleanEpc}ENTRE");

// //         result = await sourceFolder.listAll();
// //       }

// //       // 🔹 فولدر المحذوفات (دائماً بالنظام الجديد)
// //       final deletedFolder = FirebaseStorage.instance
// //           .ref()
// //           .child('images')
// //           .child('users')
// //           .child(uid)
// //           .child('deleted')
// //           .child(cleanEpc);

// //       if (result.items.isEmpty) {
// //         print('ℹ️ لا توجد صور للشريحة $cleanEpc');
// //         return;
// //       }

// //       print('📦 نسخ ${result.items.length} صورة إلى مجلد المحذوفات');

// //       for (Reference sourceRef in result.items) {
// //         try {
// //           // تحميل الصورة
// //           final Uint8List? bytes = await sourceRef.getData();

// //           if (bytes == null) {
// //             print('❌ لم يتم تحميل ${sourceRef.name}');
// //             continue;
// //           }

// //           // إنشاء الملف الجديد بنفس الاسم
// //           final destRef = deletedFolder.child(sourceRef.name);

// //           // نسخ الصورة
// //           await destRef.putData(bytes);
// //           print('✅ تم نسخ ${sourceRef.name}');

// //           // حذف الأصل بعد نجاح النسخ
// //           await sourceRef.delete();
// //           print('🗑️ تم حذف ${sourceRef.name}');
// //         } catch (e) {
// //           print('❌ خطأ مع ${sourceRef.name}: $e');
// //         }
// //       }

// //       print('✅ انتهت عملية النسخ والحذف');
// //     } catch (e) {
// //       print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
// //     }
// //   }

// //   static Future<void> sellItem(
// //     String epcHex, {
// //     String? saleGroupId,
// //     Map<String, dynamic>? paymentData,
// //     bool partialSale = false,
// //     List<String>? soldComponents,
// //     double? weightSold,
// //     double? wageSold,
// //   }) async {
// //     final groupId =
// //         saleGroupId ?? DateTime.now().millisecondsSinceEpoch.toString();
// //     final d = await findItemByEpc(epcHex, includeBalances: true);
// //     if (d == null) return;

// //     final itemCollection =
// //         d['collection'] == 'balances' ? balancesCol() : itemsCol();
// //     final itemRef = itemCollection.doc(d['id']);
// //     final docSnap = await itemRef.get();
// //     if (!docSnap.exists) return;

// //     final itemData = docSnap.data() as Map<String, dynamic>;
// //     final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
// //     final currentWeight = (payload['weight'] ?? 0).toDouble();
// //     final currentWage = (payload['wage'] ?? 0).toDouble();

// //     /// لو بيع جزئي
// //     if (partialSale == true) {
// //       // حساب الوزن والأجر الجديد بعد الخصم
// //       final newWeight = currentWeight - (weightSold ?? 0);
// //       final newWage = currentWage - (wageSold ?? 0);

// //       // تحديث مكونات الطقم
// //       final updatedComponents =
// //           List<String>.from(payload['setComponents'] ?? []);
// //       if (soldComponents != null && soldComponents.isNotEmpty) {
// //         updatedComponents.removeWhere((c) => soldComponents.contains(c));
// //       }

// //       // تجهيز بيانات البيع الجزئي للسجل
// //       final saleData = {
// //         'itemId': d['id'],
// //         'epcHex': d['epcHex'],
// //         'saleGroupId': groupId,
// //         'soldAt': FieldValue.serverTimestamp(),
// //         'category': d['category'],
// //         'partialSale': true,
// //         'payload': {
// //           ...payload,
// //           'weight': weightSold,
// //           'wage': wageSold,
// //           'setComponents': soldComponents ?? [],
// //         },
// //         'createdAt': FieldValue.serverTimestamp(),
// //       };

// //       if (paymentData != null) {
// //         saleData['payment'] = paymentData;
// //       }

// //       await salesCol().add(saleData);
// //       await salesHistoryCol().add(saleData);

// //       // إنشاء رصيد لباقي الطقم في كولكشن جديد خاص ببقايا الأطقم
// //       final hasRemaining = newWeight > 0 || updatedComponents.isNotEmpty;
// //       if (hasRemaining) {
// //         await setRemaindersCol().add({
// //           'userId': uid,
// //           'originalItemId': d['id'],
// //           'originalEpcHex': d['epcHex'],
// //           'epcHex': d['epcHex'],
// //           'category': d['category'],
// //           'payload': {
// //             ...payload,
// //             'weight': newWeight,
// //             'wage': newWage,
// //             'setComponents': updatedComponents,
// //             'originalWeight': currentWeight,
// //             'originalWage': currentWage,
// //             'soldWeight': weightSold,
// //             'soldWage': wageSold,
// //           },
// //           'remainderType': 'partialSaleRemainder',
// //           'source': 'partialSale',
// //           'soldComponents': soldComponents ?? [],
// //           'remainingComponents': updatedComponents,
// //           'createdAt': FieldValue.serverTimestamp(),
// //           'updatedAt': FieldValue.serverTimestamp(),
// //         });
// //       }

// //       // حذف الطقم الأصلي
// //       await itemRef.delete();
// //     } else {
// //       /// البيع الكامل (زي النظام القديم)
// //       await itemRef.delete();

// //       final saleData = {
// //         'itemId': d['id'],
// //         'epcHex': d['epcHex'],
// //         'saleGroupId': groupId,
// //         'soldAt': FieldValue.serverTimestamp(),
// //         'category': d['category'],
// //         'payload': d['payload'],
// //         'createdAt': FieldValue.serverTimestamp(),
// //       };

// //       if (paymentData != null) {
// //         saleData['payment'] = paymentData;
// //       }

// //       await salesCol().add(saleData);
// //       await salesHistoryCol().add(saleData);
// //     }
// //   }

// //   /// ✅ دالة للتحقق من وجود العنصر قبل الإدخال
// //   static Future<bool> checkItemExists(String epcHex) async {
// //     final cleanEpc = epcHex.trim().toUpperCase();

// //     // items - النظام الجديد
// //     var q =
// //         await itemsCol().where('epcHex', isEqualTo: cleanEpc).limit(1).get();
// //     if (q.docs.isNotEmpty) return true;

// //     // items - النظام القديم
// //     q = await itemsCol()
// //         .where('epcHex', isEqualTo: '${cleanEpc}ENTRE')
// //         .limit(1)
// //         .get();
// //     if (q.docs.isNotEmpty) return true;

// //     // balances - النظام الجديد
// //     q = await balancesCol().where('epcHex', isEqualTo: cleanEpc).limit(1).get();
// //     if (q.docs.isNotEmpty) return true;

// //     // balances - النظام القديم
// //     q = await balancesCol()
// //         .where('epcHex', isEqualTo: '${cleanEpc}ENTRE')
// //         .limit(1)
// //         .get();
// //     if (q.docs.isNotEmpty) return true;

// //     q = await itemsCol()
// //         .where('payload.qrCode', isEqualTo: cleanEpc)
// //         .limit(1)
// //         .get();
// //     if (q.docs.isNotEmpty) return true;

// //     q = await balancesCol()
// //         .where('payload.qrCode', isEqualTo: cleanEpc)
// //         .limit(1)
// //         .get();
// //     return q.docs.isNotEmpty;
// //   }

// //   /// =========================
// //   /// 🔵 دوال خاصة بالمرتجعات (Returns)
// //   /// =========================

// //   /// ✅ جلب عمليات البيع المسجلة خلال آخر [days] أيام (افتراضيًا 3 أيام)
// //   static Future<List<Map<String, dynamic>>> getRecentSales(
// //       {int days = 3}) async {
// //     final cutoff = DateTime.now().subtract(Duration(days: days));
// //     final q = await salesCol()
// //         .where('soldAt', isGreaterThanOrEqualTo: Timestamp.fromDate(cutoff))
// //         .orderBy('soldAt', descending: true)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = Map<String, dynamic>.from(d.data() as Map<String, dynamic>);
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ حذف سجل بيع معين (يُستخدم بعد استرجاع القطعة وإعادة تسجيلها)
// //   static Future<void> deleteSale(String saleId) async {
// //     await salesCol().doc(saleId).delete();
// //   }

// //   /// =========================
// //   /// 🟡 دوال خاصة بالكسر (Scrap)
// //   /// =========================

// //   /// ✅ تسجيل عملية إضافة كسر
// //   static Future<void> saveScrapAdd(Map<String, dynamic> data) async {
// //     await scrapCol().add({
// //       ...data,
// //       "person": data["person"],
// //       "carat": data["carat"],
// //       "notes": data["notes"],
// //       "date": Timestamp.fromDate(data["date"]), // 👈 نخزن Timestamp
// //       "type": "add",
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// ✅ تسجيل عملية بيع كسر
// //   static Future<void> saveScrapSale(Map<String, dynamic> data) async {
// //     await scrapCol().add({
// //       ...data,
// //       "person": data["person"],
// //       "carat": data["carat"],
// //       "notes": data["notes"],
// //       "date": Timestamp.fromDate(data["date"]), // 👈 نخزن Timestamp
// //       "type": "sale", // خلي بالك خليتها مميزة
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// ✅ إرجاع كل المعاملات الخاصة بشخص
// //   static Future<List<Map<String, dynamic>>> getScrapTransactions(
// //       String name) async {
// //     final q = await scrapCol().where("person", isEqualTo: name.trim()).get();

// //     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
// //   }

// //   /// ✅ إرجاع أسماء الأشخاص (distinct)
// //   static Future<List<String>> getScrapPersons() async {
// //     final q = await scrapCol().get();
// //     final all = q.docs
// //         .map((d) => d['person'])
// //         .where((n) => n != null && n.toString().trim().isNotEmpty)
// //         .toList();

// //     return all.map((e) => e.toString().trim()).toSet().toList();
// //   }

// //   // تحديث الاسم في كل المعاملات
// //   static Future<void> updateScrapPerson(String oldName, String newName) async {
// //     final userDoc = _db.collection("users").doc(uid);

// //     // كل الكولكشن بتاع scrapTransactions
// //     final q = await userDoc
// //         .collection("scrapTransactions")
// //         .where("person", isEqualTo: oldName)
// //         .get();

// //     for (var doc in q.docs) {
// //       await doc.reference.update({"person": newName});
// //     }
// //   }

// // // حذف كل معاملات الشخص
// //   // 🔹 حذف شخص ومعاملاته
// //   static Future<void> deleteScrapPerson(String name) async {
// //     final q = await scrapCol().where("person", isEqualTo: name.trim()).get();

// //     for (var doc in q.docs) {
// //       await doc.reference.delete();
// //     }
// //   }

// //   static Stream<List<String>> scrapPersonsStream() {
// //     return _db
// //         .collection("users")
// //         .doc(uid)
// //         .collection("scrapTransactions")
// //         .snapshots()
// //         .map((snapshot) {
// //       final names = snapshot.docs
// //           .map((d) => d.data()["person"] as String?)
// //           .where((p) => p != null && p.isNotEmpty)
// //           .map((p) => p!) // نرجعها String مش nullable
// //           .toSet()
// //           .toList();
// //       names.sort();
// //       return names;
// //     });
// //   }

// //   static Stream<List<Map<String, dynamic>>> scrapTransactionsStream() {
// //     return scrapCol().snapshots().map((snap) {
// //       return snap.docs.map((d) {
// //         final data = d.data() as Map<String, dynamic>;
// //         data["id"] = d.id;
// //         return data;
// //       }).toList();
// //     });
// //   }

// //   /// 🟢 كولكشن الموردين
// //   /// 🟢 إضافة مورد جديد
// //   static Future<void> addSupplier({
// //     required String name,
// //     required List<String> delegates,
// //     required String phone,
// //   }) async {
// //     await suppliersCol().add({
// //       "name": name,
// //       "delegates": delegates,
// //       "phone": phone,
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// 🟢 جلب الموردين
// //   static Future<List<Map<String, dynamic>>> getSuppliers() async {
// //     final q = await suppliersCol().get();
// //     return q.docs
// //         .map((d) => {"id": d.id, ...d.data() as Map<String, dynamic>})
// //         .toList();
// //   }

// //   /// 🟢 كولكشن سندات
// //   /// 🟢 إضافة سند قبض
// //   static Future<void> addReceiptVoucher({
// //     required String supplierId,
// //     required String supplierName,
// //     required String delegate,
// //     required String carat,
// //     required double weight,
// //     required double wage,
// //     required DateTime date,
// //   }) async {
// //     await vouchersCol().add({
// //       "supplierId": supplierId,
// //       "supplierName": supplierName,
// //       "delegate": delegate,
// //       "carat": carat,
// //       "weight": weight,
// //       "wage": wage,
// //       "type": "receipt",
// //       "date": Timestamp.fromDate(date),
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// 🟢 إضافة سند صرف
// //   static Future<void> addPaymentVoucher({
// //     required String supplierId,
// //     required String supplierName,
// //     required String delegate,
// //     required String carat,
// //     required double weight,
// //     required double wage,
// //     required String paymentMethod, // "كاش" أو "شبكة" أو "متعدد"
// //     required double? cash,
// //     required double? network,
// //     required DateTime date,
// //   }) async {
// //     await vouchersCol().add({
// //       "supplierId": supplierId,
// //       "supplierName": supplierName,
// //       "delegate": delegate,
// //       "carat": carat,
// //       "weight": weight,
// //       "wage": wage,
// //       "type": "payment",
// //       "paymentMethod": paymentMethod,
// //       "cash": cash,
// //       "network": network,
// //       "total": (cash ?? 0) + (network ?? 0),
// //       "date": Timestamp.fromDate(date),
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //     await scrapCol().add({
// //       "supplierId": supplierId,
// //       "person": supplierName,
// //       "carat": carat,
// //       "weight": weight,
// //       "wage": wage,
// //       "date": Timestamp.fromDate(date), // 👈 نخزن Timestamp
// //       "type": "payment",
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// 🟢 جلب السندات لمورد
// //   static Future<List<Map<String, dynamic>>> getVouchersForSupplier(
// //       String supplierId) async {
// //     final q =
// //         await vouchersCol().where("supplierId", isEqualTo: supplierId).get();
// //     return q.docs
// //         .map((d) => {"id": d.id, ...d.data() as Map<String, dynamic>})
// //         .toList();
// //   }

// //   // داخل كلاس FS
// //   static Future<void> updateSupplier(
// //       String id, Map<String, dynamic> data) async {
// //     await suppliersCol().doc(id).update({
// //       ...data,
// //       'updatedAt': FieldValue.serverTimestamp(),
// //     });
// //   }

// //   static Future<void> deleteSupplier(String id) async {
// //     await suppliersCol().doc(id).delete();
// //   }

// //   static Stream<List<Map<String, dynamic>>> suppliersStream() {
// //     return suppliersCol()
// //         .orderBy('name') // أو حسب التاريخ لو عايز
// //         .snapshots()
// //         .map((snap) => snap.docs
// //             .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
// //             .toList());
// //   }

// //   /// ==============================
// //   /// 💰 دوال المصروفات (Expenses)
// //   /// ==============================

// //   /// 🔹 إضافة مصروف جديد
// //   static Future<void> addExpense({
// //     required String type,
// //     required double amount,
// //     required DateTime date,
// //     String? note,
// //   }) async {
// //     await expensesCol().add({
// //       'type': type,
// //       'amount': amount,
// //       'note': note ?? '',
// //       'date': Timestamp.fromDate(date),
// //       'createdAt': FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// 🔹 تعديل مصروف موجود
// //   static Future<void> updateExpense(
// //       String id, Map<String, dynamic> data) async {
// //     await expensesCol().doc(id).update({
// //       ...data,
// //       'updatedAt': FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// 🔹 حذف مصروف
// //   static Future<void> deleteExpense(String id) async {
// //     await expensesCol().doc(id).delete();
// //   }

// //   /// 🔹 جلب كل المصروفات
// //   static Stream<List<Map<String, dynamic>>> expensesStream({
// //     String? typeFilter,
// //     DateTimeRange? dateRange,
// //   }) {
// //     Query query = expensesCol().orderBy('date', descending: true);

// //     if (typeFilter != null && typeFilter.isNotEmpty) {
// //       query = query.where('type', isEqualTo: typeFilter);
// //     }

// //     if (dateRange != null) {
// //       final start = DateTime(dateRange.start.year, dateRange.start.month,
// //           dateRange.start.day, 0, 0, 0);
// //       final end = DateTime(dateRange.end.year, dateRange.end.month,
// //           dateRange.end.day, 23, 59, 59);

// //       query = query
// //           .where('date', isGreaterThanOrEqualTo: start)
// //           .where('date', isLessThanOrEqualTo: end);
// //     }

// //     return query.snapshots().map((snap) {
// //       return snap.docs.map((d) {
// //         final data = d.data() as Map<String, dynamic>;
// //         data['id'] = d.id;
// //         return data;
// //       }).toList();
// //     });
// //   }

// //   static Future<List<String>> getExpenseTypes() async {
// //     final snapshot = await expensesCol().get();

// //     final allTypes = snapshot.docs
// //         .map((d) => d['type']?.toString().trim() ?? '')
// //         .where((t) => t.isNotEmpty)
// //         .toSet()
// //         .toList();

// //     allTypes.sort(); // ترتيب أبجدي اختياري
// //     return allTypes;
// //   }

// //   static Stream<List<String>> expenseTypesStream() {
// //     return _db
// //         .collection('users')
// //         .doc(uid)
// //         .collection('expenses')
// //         .snapshots()
// //         .map((snapshot) {
// //       final all = snapshot.docs
// //           .map((d) => d['type']?.toString().trim() ?? '')
// //           .where((t) => t.isNotEmpty)
// //           .toSet()
// //           .toList();
// //       all.sort();
// //       return all;
// //     });
// //   }

// //   static Stream<List<String>> soldByStream() {
// //     return _db
// //         .collection('users')
// //         .doc(uid)
// //         .collection('sales')
// //         .snapshots()
// //         .map((snapshot) {
// //       final all = snapshot.docs
// //           .map((d) {
// //             final payment = d.data()['payment'];
// //             if (payment is Map && payment['soldBy'] != null) {
// //               return payment['soldBy'].toString().trim();
// //             }
// //             return '';
// //           })
// //           .where((s) => s.isNotEmpty)
// //           .toSet()
// //           .toList();

// //       all.sort();
// //       return all;
// //     });
// //   }

// //   static Stream<List<Map<String, dynamic>>> salesStream({
// //     String? soldByFilter,
// //     DateTimeRange? dateRange,
// //   }) {
// //     return _db
// //         .collection('users')
// //         .doc(uid)
// //         .collection('sales')
// //         .snapshots()
// //         .map((snapshot) {
// //       return snapshot.docs.map((d) {
// //         final data = d.data();
// //         data['id'] = d.id;
// //         return data;
// //       }).where((s) {
// //         // فلترة البائع
// //         if (soldByFilter != null) {
// //           final soldBy = s['payment']?['soldBy'];
// //           if (soldBy != soldByFilter) return false;
// //         }

// //         // فلترة التاريخ
// //         if (dateRange != null) {
// //           final ts = s['soldAt'] as Timestamp?;
// //           if (ts == null) return false;
// //           final date = ts.toDate();
// //           if (date.isBefore(dateRange.start) || date.isAfter(dateRange.end)) {
// //             return false;
// //           }
// //         }

// //         return true;
// //       }).toList();
// //     });
// //   }

// //   /// =========== فروع (Branches) =============

// //   static Future<void> addBranch({
// //     required String name,
// //     required String uid,
// //     required String address,
// //     required String manager,
// //     required String phone,
// //     required List<String> delegates,
// //     required DateTime date,
// //   }) async {
// //     await branchesCol().add({
// //       'name': name,
// //       'uid': uid,
// //       'address': address,
// //       'manager': manager,
// //       'phone': phone,
// //       'delegates': delegates,
// //       'date': Timestamp.fromDate(date),
// //       'createdAt': FieldValue.serverTimestamp(),
// //     });
// //   }

// //   static Future<void> updateBranch(String id, Map<String, dynamic> data) async {
// //     await branchesCol().doc(id).update({
// //       ...data,
// //       'updatedAt': FieldValue.serverTimestamp(),
// //     });
// //   }

// //   static Future<void> deleteBranch(String id) async {
// //     await branchesCol().doc(id).delete();
// //   }

// //   static Future<List<Map<String, dynamic>>> getBranches() async {
// //     final q = await branchesCol().orderBy('name').get();
// //     return q.docs
// //         .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
// //         .toList();
// //   }

// //   static Stream<List<Map<String, dynamic>>> branchesStream() {
// //     return branchesCol().orderBy('name').snapshots().map((snap) => snap.docs
// //         .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
// //         .toList());
// //   }

// //   /// ============================
// //   /// 🔄 دوال التحويل (Transform)
// //   /// ============================

// //   /// 🔹 تحويل صنف إلى كسر
// //   static Future<void> transferToScrap(
// //       Map<String, dynamic> itemData, String epcHex) async {
// //     final now = FieldValue.serverTimestamp();

// //     // 🔸 تجهيز البيانات
// //     //final payload = itemData['payload'] ?? itemData;
// //     final Map<String, dynamic> payload =
// //         Map<String, dynamic>.from(itemData['payload'] ?? itemData);
// //     final scrapData = {
// //       "person": "تحويل",
// //       "type": "transform",
// //       "createdAt": now,
// //       "date": now,
// //       //"payload": payload,
// //       ...payload,
// //     };

// //     // 🔸 تحديث حالة الصنف
// //     try {
// //       final d = await findItemByEpc(epcHex);
// //       if (d == null) return;

// //       // تحديث حالة القطعة -> مباعة
// //       await itemsCol().doc(d['id']).delete();
// //       await _db
// //           .collection('users')
// //           .doc(uid)
// //           .collection('scrapTransactions')
// //           .add(scrapData);
// //     } catch (_) {}
// //   }

// //   /// 🔹 تحويل صنف إلى فرع
// //   static Future<void> transferToBranch(
// //       Map<String, dynamic> itemData,
// //       String epcHex,
// //       String branchId,
// //       String branchName,
// //       String repName,
// //       String branchUid) async {
// //     final now = FieldValue.serverTimestamp();
// //     final payload = itemData['payload'] ?? itemData;
// //     final category = itemData['category'] ?? '';

// //     // 🔸 تجهيز بيانات التحويل
// //     final transferData = {
// //       'fromUId': uid,
// //       'branchUid': branchUid,
// //       "epcHex": epcHex,
// //       "branchId": branchId,
// //       "branchName": branchName,
// //       "rep": repName,
// //       "createdAt": now,
// //       "date": now,
// //       "payload": payload,
// //       "category": category,
// //       'status': 'pending',
// //     };

// //     // 🔸 حفظ العملية في كولكشن التحويلات
// //     await _db
// //         .collection('users')
// //         .doc(uid)
// //         .collection('branchTransfers')
// //         .add(transferData);

// //     /*// 🔸 تحديث حالة القطعة في items
// //     try {
// //       final d = await findItemByEpc(epcHex);
// //       if (d == null) return;

// //       // تحديث حالة القطعة -> مباعة
// //       await itemsCol().doc(d['id']).delete();
// //     } catch (_) {}*/

// //     await _db
// //         .collection('transferRequests')
// //         .doc(branchUid)
// //         .collection('branchTransfers')
// //         .add(transferData);
// //   }

// //   static StreamSubscription? _transferListener;

// //   static void listenToTransferUpdates() {
// //     final uid = FirebaseAuth.instance.currentUser?.uid;
// //     if (uid == null) return;

// //     // نلغي أي listener سابق
// //     _transferListener?.cancel();

// //     // stream على branchTransfers عند المرسل
// //     final userTransfersRef = FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(uid)
// //         .collection('branchTransfers')
// //         .where('status', isEqualTo: 'pending');

// //     _transferListener = userTransfersRef.snapshots().listen((snapshot) async {
// //       print(
// //           "✅Transfer listener triggered: ${snapshot.docs.length} pending items");
// //       for (var docChange in snapshot.docChanges) {
// //         final doc = docChange.doc;
// //         final data = doc.data();
// //         if (data == null) continue;

// //         final branchUid = data['branchUid'];
// //         final epcHex = data['epcHex'];
// //         if (branchUid == null || epcHex == null) continue;

// //         final targetTransfersRef = FirebaseFirestore.instance
// //             .collection('transferRequests')
// //             .doc(branchUid)
// //             .collection('branchTransfers');

// //         final targetSnapshot =
// //             await targetTransfersRef.where('epcHex', isEqualTo: epcHex).get();

// //         if (targetSnapshot.docs.isEmpty) continue;

// //         final targetStatus = targetSnapshot.docs.first.data()['status'];
// //         final targetDoc = targetSnapshot.docs.first;

// //         if (targetStatus == 'accepted') {
// //           // حذف من items عند المرسل
// //           final itemsSnapshot = await FirebaseFirestore.instance
// //               .collection('users')
// //               .doc(uid)
// //               .collection('items')
// //               .where('epcHex', isEqualTo: epcHex)
// //               .get();

// //           for (var itemDoc in itemsSnapshot.docs) {
// //             await itemDoc.reference.delete();
// //           }

// //           // حذف من branchTransfers عند المرسل
// //           //await doc.reference.delete();
// //           await doc.reference.update({'status': 'accepted'});
// //           await targetDoc.reference.delete();
// //         } else if (targetStatus == 'rejected') {
// //           // حذف من branchTransfers عند المرسل فقط
// //           await doc.reference.delete();
// //           await targetDoc.reference.delete();
// //         }
// //       }
// //     });
// //   }

// //   /// لإيقاف الاستماع عند إغلاق الصفحة أو الخروج
// //   static void cancelTransferListener() {
// //     _transferListener?.cancel();
// //     _transferListener = null;
// //   }

// //   static StreamSubscription? _transferSubscription;
// //   static bool _isDialogOpen = false;

// //   static void listenForTransfers(BuildContext context) {
// //     final uid = FirebaseAuth.instance.currentUser?.uid;
// //     if (uid == null) return;

// //     _transferSubscription?.cancel();

// //     _transferSubscription = FirebaseFirestore.instance
// //         .collection('transferRequests')
// //         .doc(uid)
// //         .collection('branchTransfers')
// //         .where('status', isEqualTo: 'pending')
// //         .snapshots()
// //         .listen((snapshot) {
// //       // 🔴 لو مفيش شرائح
// //       if (snapshot.docs.isEmpty) {
// //         if (_isDialogOpen) {
// //           Navigator.of(context, rootNavigator: true).pop();
// //           _isDialogOpen = false;
// //         }
// //         return;
// //       }

// //       // 🟢 لو فيه شرائح والديلوج مش مفتوح
// //       if (!_isDialogOpen) {
// //         _isDialogOpen = true;
// //         _showTransfersDialog(context, snapshot.docs);
// //       }
// //     });
// //   }

// //   static void stopListening() {
// //     _transferSubscription?.cancel();
// //   }

// //   static void _showTransfersDialog(
// //     BuildContext context,
// //     List<QueryDocumentSnapshot> docs,
// //   ) {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) {
// //         return Directionality(
// //           textDirection: TextDirection.rtl,
// //           child: AlertDialog(
// //             title: const Text("وصلك تحويلات جديدة"),
// //             content: SizedBox(
// //               width: double.maxFinite,
// //               height: 400,
// //               child: ListView.builder(
// //                 itemCount: docs.length,
// //                 itemBuilder: (context, index) {
// //                   final doc = docs[index];
// //                   final data = doc.data() as Map<String, dynamic>;
// //                   final payload = data['payload'] as Map<String, dynamic>?;

// //                   return Card(
// //                     margin: const EdgeInsets.symmetric(vertical: 8),
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(8),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text("الفرع: ${data['branchName']}"),
// //                           Text("المندوب: ${data['rep']}"),
// //                           Text("رقم الشريحة: ${data['epcHex']}"),
// //                           Text("التصنيف: ${data['category']}"),
// //                           if (payload?["carat"] != null)
// //                             Text("العيار: ${payload?['carat']}"),
// //                           if (payload?["weight"] != null)
// //                             Text("الوزن: ${payload?['weight']}"),
// //                           const SizedBox(height: 10),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               ElevatedButton(
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor: Colors.green,
// //                                   foregroundColor: Colors.white,
// //                                 ),
// //                                 onPressed: () async {
// //                                   await acceptTransfer(data, doc.id);
// //                                 },
// //                                 child: const Text("قبول"),
// //                               ),
// //                               const SizedBox(width: 20),
// //                               ElevatedButton(
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor: Colors.red,
// //                                   foregroundColor: Colors.white,
// //                                 ),
// //                                 onPressed: () async {
// //                                   await rejectTransfer(doc.id);
// //                                 },
// //                                 child: const Text("رفض"),
// //                               ),
// //                             ],
// //                           )
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     ).then((_) {
// //       _isDialogOpen = false;
// //     });
// //   }

// //   static Future<void> acceptTransfer(
// //       Map<String, dynamic> data, String docId) async {
// //     final uid = FirebaseAuth.instance.currentUser!.uid;

// //     // 🔹 حفظ القطعة في itemsCol
// //     await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(uid)
// //         .collection('items')
// //         .add(data);

// //     // 🔹 تغيير الحالة
// //     await FirebaseFirestore.instance
// //         .collection('transferRequests')
// //         .doc(uid)
// //         .collection('branchTransfers')
// //         .doc(docId)
// //         .update({'status': 'accepted'});
// //   }

// //   static Future<void> rejectTransfer(String docId) async {
// //     final uid = FirebaseAuth.instance.currentUser!.uid;

// //     await FirebaseFirestore.instance
// //         .collection('transferRequests')
// //         .doc(uid)
// //         .collection('branchTransfers')
// //         .doc(docId)
// //         .update({'status': 'rejected'});
// //   }

// //   /// 🔹 جلب المناديب الخاصة بفرع
// //   static Future<List<String>> getRepsForBranch(String branchId) async {
// //     final doc = await branchesCol().doc(branchId).get();
// //     if (!doc.exists) return [];
// //     final data = doc.data() as Map<String, dynamic>;
// //     final reps = data["delegates"];
// //     if (reps is List) {
// //       return reps.map((e) => e.toString()).toList();
// //     }
// //     return [];
// //   }

// //   static Future<Map<String, dynamic>> getGeneralBalance() async {
// //     double gold18 = 0, gold21 = 0, gold22 = 0;
// //     double barsWeight = 0;

// //     int stonesCount = 0;
// //     double stonesCost = 0;

// //     double cash = 0;
// //     double network = 0;

// //     double scrapWeight = 0;

// //     double creditor = 0; // دائن
// //     double debtor = 0; // مدين
// //     double supply = 0;

// //     /// ================== الأصناف ==================
// //     final itemsSnap = await itemsCol().get();
// //     for (var d in itemsSnap.docs) {
// //       final data = d.data() as Map<String, dynamic>;
// //       final payload = Map<String, dynamic>.from(data['payload'] ?? {});
// //       final weight = (payload['weight'] ?? 0).toDouble();
// //       final carat = payload['carat'];

// //       if (carat == 18) gold18 += weight;
// //       if (carat == 21) gold21 += weight;
// //       if (carat == 22) gold22 += weight;

// //       stonesCount += (payload['stonesCount'] ?? 0) as int;
// //       stonesCost += (payload['stonesCost'] ?? 0).toDouble();

// //       if (data['category'] == 'bar') {
// //         barsWeight += weight;
// //       }
// //     }

// //     /// ================== المبيعات ==================
// //     final salesSnap = await salesCol().get();
// //     for (var d in salesSnap.docs) {
// //       final pay = d['payment'];
// //       if (pay != null) {
// //         cash += (pay['cash'] ?? 0).toDouble();
// //         network += (pay['network'] ?? 0).toDouble();
// //       }
// //     }

// //     /// ================== الكسر ==================
// //     final scrapSnap = await scrapCol().get();
// //     for (var d in scrapSnap.docs) {
// //       scrapWeight += (d['weight'] ?? 0).toDouble();
// //     }

// //     /// ================== السندات ==================
// //     final vouchersSnap = await vouchersCol().get();
// //     for (var d in vouchersSnap.docs) {
// //       final weight = (d['weight'] ?? 0).toDouble();
// //       if (d['type'] == 'receipt') {
// //         creditor += weight;
// //       } else if (d['type'] == 'payment') {
// //         debtor += weight;
// //       }
// //     }

// //     /// ================== التوريد ==================
// //     final depSnap = await depositsCol().get();
// //     for (var d in depSnap.docs) {
// //       supply += (d['amount'] ?? 0).toDouble();
// //     }

// //     return {
// //       "gold18": gold18,
// //       "gold21": gold21,
// //       "gold22": gold22,
// //       "barsWeight": barsWeight,
// //       "stonesCount": stonesCount,
// //       "stonesCost": stonesCost,
// //       "cash": cash,
// //       "network": network,
// //       "scrapWeight": scrapWeight,
// //       "creditor": creditor,
// //       "debtor": debtor,
// //       "supply": supply,
// //     };
// //   }

// //   /// ================== التعاملات ==================
// //   static Future<void> sendToExternal({
// //     required String epc,
// //     required Map<String, dynamic> itemData,
// //     required String shopName,
// //     required String managerName,
// //     required String sentBy,
// //   }) async {
// //     // تأكد إن الشريحة مش موجودة بالفعل
// //     final existing = await externalCol().doc(epc).get();
// //     if (existing.exists) {
// //       throw Exception("هذه الشريحة موجودة بالفعل في التعاملات الخارجية");
// //     }

// //     await externalCol().doc(epc).set({
// //       "epc": epc,
// //       //"itemData": itemData,
// //       ...itemData,
// //       "shopName": shopName,
// //       "managerName": managerName,
// //       "sentBy": sentBy,
// //       "sentAt": Timestamp.now(),
// //       "status": "pending",
// //     });
// //   }

// //   static Stream<QuerySnapshot> getExternalTransactions() {
// //     return externalCol()
// //         .where('status', isEqualTo: 'pending')
// //         .orderBy('sentAt', descending: true)
// //         .snapshots();
// //   }

// //   static Future<void> returnExternal(String epc) async {
// //     await externalCol().doc(epc).delete();
// //   }

// //   static Future<void> receiveExternalPayment({
// //     required String epc,
// //     required Map<String, dynamic> paymentData,
// //   }) async {
// //     /*final doc = await externalCol().doc(epc).get();

// //     if (!doc.exists) {
// //       throw Exception("الشريحة غير موجودة");
// //     }

// //     final data = doc.data() as Map<String, dynamic>;

// //     // حفظ في المبيعات
// //     await salesCol().add({
// //       ...data,
// //       "paymentData": paymentData,
// //       "soldAt": Timestamp.now(),
// //       "saleType": "external",
// //     });

// //     // حذف من التعاملات الخارجية
// //     await externalCol().doc(epc).delete();*/

// //     /////////
// //     final d = await findItemByEpc(epc);
// //     if (d == null) return;

// //     final itemRef = itemsCol().doc(d['id']);
// //     final docSnap = await itemRef.get();
// //     if (!docSnap.exists) return;

// //     /*final itemData = docSnap.data() as Map<String, dynamic>;
// //     final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
// //     final currentWeight = (payload['weight'] ?? 0).toDouble();
// //     final currentWage = (payload['wage'] ?? 0).toDouble();*/
// //     await itemRef.delete();

// //     final saleData = {
// //       'itemId': d['id'],
// //       'epcHex': d['epcHex'],
// //       'soldAt': FieldValue.serverTimestamp(),
// //       'category': d['category'],
// //       'payload': d['payload'],
// //       'createdAt': FieldValue.serverTimestamp(),
// //     };

// //     saleData['payment'] = paymentData;

// //     await salesCol().add(saleData);
// //     // حذف من التعاملات الخارجية
// //     await externalCol().doc(epc).delete();
// //   }

// //   // ✅ إضافة تصريح خروج
// //   static Future<void> addStatement(
// //     String epc,
// //     Map<String, dynamic> item,
// //     String userId,
// //   ) async {
// //     await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(userId)
// //         .collection('Statements')
// //         .doc(epc) // منع التكرار
// //         .set({
// //       ...item,
// //       'StatementDate': FieldValue.serverTimestamp(),
// //       'status': 'active',
// //     });
// //   }

// //   // ✅ جلب التصاريح
// //   static Stream<QuerySnapshot> getStatements(String userId) {
// //     return FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(userId)
// //         .collection('Statements')
// //         .orderBy('StatementDate', descending: true)
// //         .snapshots();
// //   }

// //   // ✅ إلغاء التصريح
// //   static Future<void> cancelStatement(String epc, String userId) async {
// //     await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(userId)
// //         .collection('Statements')
// //         .doc(epc)
// //         .delete(); // 🔥 حذف كامل
// //   }

// //   static Future<bool> checkIfExists(String epc, String userId) async {
// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(userId)
// //         .collection('Statements')
// //         .where('epcHex', isEqualTo: epc)
// //         .where('userId', isEqualTo: userId)
// //         .get();

// //     return q.docs.isNotEmpty;
// //   }
// //   /*
// //   static Future<void> sellItem(
// //       String epcHex, {
// //         Map<String, dynamic>? paymentData,
// //         bool partialSale = false,
// //         List<String>? soldComponents,
// //         double? weightSold,
// //         double? wageSold,
// //       }) async {
// //     final d = await findItemByEpc(epcHex, includeBalances: true);
// //     if (d == null) return;

// //     final itemCollection = d['collection'] == 'balances' ? balancesCol() : itemsCol();
// //     final itemRef = itemCollection.doc(d['id']);
// //     final docSnap = await itemRef.get();
// //     if (!docSnap.exists) return;

// //     final itemData = docSnap.data() as Map<String, dynamic>;
// //     final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
// //     final currentWeight = (payload['weight'] ?? 0).toDouble();
// //     final currentWage = (payload['wage'] ?? 0).toDouble();

// //     /// لو بيع جزئي
// //     if (partialSale == true) {
// //       // حساب الوزن والأجر الجديد بعد الخصم
// //       final newWeight = currentWeight - (weightSold ?? 0);
// //       final newWage = currentWage - (wageSold ?? 0);

// //       // تحديث مكونات الطقم
// //       final updatedComponents = List<String>.from(payload['setComponents'] ?? []);
// //       if (soldComponents != null && soldComponents.isNotEmpty) {
// //         updatedComponents.removeWhere((c) => soldComponents.contains(c));
// //       }

// //       // تعديل العنصر الأصلي في كولكشن العناصر
// //       await itemRef.update({
// //         'payload.weight': newWeight,
// //         'payload.wage': newWage,
// //         'payload.setComponents': updatedComponents,
// //         'updatedAt': FieldValue.serverTimestamp(),
// //       });

// //       // تجهيز بيانات البيع الجزئي
// //       final saleData = {
// //         'itemId': d['id'],
// //         'epcHex': d['epcHex'],
// //         'soldAt': FieldValue.serverTimestamp(),
// //         'category': d['category'],
// //         'partialSale': true,
// //         'payload': {
// //           ...payload,
// //           'weight': weightSold,
// //           'wage': wageSold,
// //           'setComponents': soldComponents ?? [],
// //         },
// //         'createdAt': FieldValue.serverTimestamp(),
// //       };

// //       if (paymentData != null) {
// //         saleData['payment'] = paymentData;
// //       }

// //       await salesCol().add(saleData);
// //     }
// //     else {
// //       /// البيع الكامل (زي النظام القديم)
// //       await itemRef.delete();

// //       final saleData = {
// //         'itemId': d['id'],
// //         'epcHex': d['epcHex'],
// //         'soldAt': FieldValue.serverTimestamp(),
// //         'category': d['category'],
// //         'payload': d['payload'],
// //         'createdAt': FieldValue.serverTimestamp(),
// //       };

// //       if (paymentData != null) {
// //         saleData['payment'] = paymentData;
// //       }

// //       await salesCol().add(saleData);
// //     }
// //   }
// //    */
// // // }
// // import 'dart:async';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'dart:typed_data';

// // class FS {
// //   static final _db = FirebaseFirestore.instance;
// //   static String get uid => FirebaseAuth.instance.currentUser!.uid;

// //   static CollectionReference itemsCol() =>
// //       _db.collection('users').doc(uid).collection('items');
// //   static CollectionReference invCol() =>
// //       _db.collection('users').doc(uid).collection('inventories');
// //   static CollectionReference salesCol() =>
// //       _db.collection('users').doc(uid).collection('sales');
// //   static CollectionReference salesHistoryCol() =>
// //       _db.collection('users').doc(uid).collection('sales_history');
// //   static CollectionReference depositsCol() =>
// //       _db.collection('users').doc(uid).collection('managementDeposits');
// //   static CollectionReference ImportedCol() =>
// //       _db.collection('users').doc(uid).collection('managementImported');
// //   static CollectionReference vouchersCol() =>
// //       _db.collection('users').doc(uid).collection('vouchers');
// //   static CollectionReference scrapCol() =>
// //       _db.collection('users').doc(uid).collection('scrapTransactions');
// //   static CollectionReference suppliersCol() =>
// //       _db.collection('users').doc(uid).collection('suppliers');
// //   static CollectionReference expensesCol() =>
// //       _db.collection('users').doc(uid).collection('expenses');
// //   static CollectionReference externalCol() =>
// //       _db.collection('users').doc(uid).collection('externalTransactions');
// //   static CollectionReference branchesCol() =>
// //       _db.collection('users').doc(uid).collection('branches');
// //   static CollectionReference balancesCol() =>
// //       _db.collection('users').doc(uid).collection('balances');
// //   static CollectionReference setRemaindersCol() =>
// //       _db.collection('users').doc(uid).collection('setRemainders');
// //   static CollectionReference deletedItemsCol() =>
// //       _db.collection('users').doc(uid).collection('deleted_items');

// //   static Future<void> saveItem({
// //     required String epcHex,
// //     required String category,
// //     required DateTime date,
// //     required Map<String, dynamic> payload,
// //     required bool fromOpeningBalance,
// //   }) async {
// //     final doc = itemsCol().doc();
// //     await doc.set({
// //       'userId': uid,
// //       'code': epcHex,
// //       'epcHex': epcHex,
// //       'category': category,
// //       'date': date,
// //       'payload': payload,
// //       'status': 'active',
// //       'createdAt': FieldValue.serverTimestamp(),
// //       'fromOpeningBalance': fromOpeningBalance,
// //     });
// //   }

// //   /// 📦 إرجاع عدد العناصر داخل كولكشن items
// //   static Future<int> getItemsCount() async {
// //     try {
// //       final snapshot = await itemsCol().get();
// //       return snapshot.size;
// //     } catch (e) {
// //       debugPrint("❌ خطأ أثناء جلب عدد العناصر: $e");
// //       return 0;
// //     }
// //   }

// //   /// ✅ تحديث عنصر (يدعم dot notation)
// //   static Future<void> uupdateItem(
// //       String epcHex, Map<String, dynamic> updates) async {
// //     final epc = epcHex.trim();

// // // البحث بالنظام الجديد
// //     QuerySnapshot q =
// //         await itemsCol().where("epcHex", isEqualTo: epc).limit(1).get();

// // // لو ملقاش، ابحث بالنظام القديم
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where("epcHex", isEqualTo: "${epc}ENTRE")
// //           .limit(1)
// //           .get();

// //       // لو لقى سجل قديم حدثه تلقائياً
// //       if (q.docs.isNotEmpty) {
// //         await itemsCol().doc(q.docs.first.id).update({
// //           "epcHex": epc,
// //         });
// //       }
// //     }

// //     if (q.docs.isEmpty) {
// //       throw Exception("⚠️ العنصر غير موجود");
// //     }

// //     final doc = q.docs.first;

// //     await itemsCol().doc(doc.id).update({
// //       ...updates,
// //       "updatedAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// ✅ تحديث عنصر (يدعم dot notation)
// //   static Future<void> updateItem(
// //       String epcHex, Map<String, dynamic> updates) async {
// //     final cleanEpc = epcHex.trim().toUpperCase();
// //     print("🛠️ محاولة تحديث العنصر برقم: $cleanEpc");

// // // 🔹 البحث بالنظام الجديد
// //     var q =
// //         await itemsCol().where("epcHex", isEqualTo: cleanEpc).limit(1).get();

// //     print("📄 نتائج البحث في epcHex: ${q.docs.length}");

// // // 🔹 لو مفيش نتيجة، ابحث بالنظام القديم (ENTRE)
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where("epcHex", isEqualTo: "${cleanEpc}ENTRE")
// //           .limit(1)
// //           .get();

// //       print("📄 نتائج البحث في epcHex القديم: ${q.docs.length}");

// //       // Migration تلقائي
// //       if (q.docs.isNotEmpty) {
// //         await itemsCol().doc(q.docs.first.id).update({
// //           "epcHex": cleanEpc,
// //         });
// //       }
// //     }

// //     // 🔹 لو مفيش نتيجة، ابحث في payload.qrCode
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where("payload.qrCode", isEqualTo: cleanEpc)
// //           .limit(1)
// //           .get();

// //       print("📄 نتائج البحث في payload.qrCode: ${q.docs.length}");
// //     }

// //     // 🔹 لو مفيش أي نتيجة
// //     if (q.docs.isEmpty) {
// //       throw Exception("⚠️ العنصر غير موجود في قاعدة البيانات!");
// //     }

// //     // 🔹 تحديث العنصر
// //     final doc = q.docs.first;
// //     await itemsCol().doc(doc.id).update({
// //       ...updates,
// //       "updatedAt": FieldValue.serverTimestamp(),
// //     });

// //     print("✅ تم تحديث العنصر بنجاح: ${doc.id}");
// //   }

// //   static Future<void> uploadImage(
// //       String epcHex, Map<String, dynamic> updates) async {
// //     final cleanEpc = epcHex.trim().toUpperCase();
// //     print("🛠️ محاولة تحديث العنصر برقم: $cleanEpc");

// // // 🔹 البحث بالنظام الجديد
// //     var q =
// //         await itemsCol().where("epcHex", isEqualTo: cleanEpc).limit(1).get();

// //     print("📄 نتائج البحث في epcHex: ${q.docs.length}");

// // // 🔹 لو مفيش نتيجة، ابحث بالنظام القديم (ENTRE)
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where("epcHex", isEqualTo: "${cleanEpc}ENTRE")
// //           .limit(1)
// //           .get();

// //       print("📄 نتائج البحث في epcHex القديم: ${q.docs.length}");

// //       // Migration تلقائي
// //       if (q.docs.isNotEmpty) {
// //         await itemsCol().doc(q.docs.first.id).update({
// //           "epcHex": cleanEpc,
// //         });
// //       }
// //     }

// //     // 🔹 لو مفيش نتيجة، ابحث في payload.qrCode
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where("payload.qrCode", isEqualTo: cleanEpc)
// //           .limit(1)
// //           .get();

// //       print("📄 نتائج البحث في payload.qrCode: ${q.docs.length}");
// //     }

// //     // 🔹 لو مفيش أي نتيجة
// //     if (q.docs.isEmpty) {
// //       throw Exception("⚠️ العنصر غير موجود في قاعدة البيانات!");
// //     }

// //     // 🔹 تحديث العنصر
// //     final doc = q.docs.first;
// //     await itemsCol().doc(doc.id).update({
// //       ...updates,
// //     });

// //     print("✅ تم تحديث العنصر بنجاح: ${doc.id}");
// //   }

// //   static Future<Map<String, dynamic>?> findItemByEpc(String epcHex,
// //       {bool includeBalances = false}) async {
// //     final epc = epcHex.toUpperCase();
// //     print("🔎 البحث عن: $epcHex");

// //     var q = await itemsCol().where('epcHex', isEqualTo: epc).limit(1).get();
// //     print("📄 عدد النتائج في items.epcHex: ${q.docs.length}");

// // // البحث بالنظام القديم
// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where('epcHex', isEqualTo: "${epc}ENTRE")
// //           .limit(1)
// //           .get();

// //       print("📄 عدد النتائج في items.epcHex القديم: ${q.docs.length}");
// //       // Migration تلقائي
// //       if (q.docs.isNotEmpty) {
// //         await itemsCol().doc(q.docs.first.id).update({
// //           "epcHex": epc,
// //         });
// //       }
// //     }

// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where('payload.qrCode', isEqualTo: epcHex)
// //           .limit(1)
// //           .get();
// //       print("📄 عدد النتائج في items.payload.qrCode: ${q.docs.length}");
// //     }

// //     bool foundInBalances = false;
// //     if (q.docs.isEmpty && includeBalances) {
// //       q = await balancesCol().where('epcHex', isEqualTo: epc).limit(1).get();
// //       print("📄 عدد النتائج في balances.epcHex: ${q.docs.length}");

// //       if (q.docs.isEmpty) {
// //         q = await balancesCol()
// //             .where('epcHex', isEqualTo: "${epc}ENTRE")
// //             .limit(1)
// //             .get();

// //         print("📄 عدد النتائج في balances.epcHex القديم: ${q.docs.length}");
// //         // Migration تلقائي
// //         if (q.docs.isNotEmpty) {
// //           await balancesCol().doc(q.docs.first.id).update({
// //             "epcHex": epc,
// //           });
// //         }
// //       }
// //       if (q.docs.isEmpty) {
// //         q = await balancesCol()
// //             .where('payload.qrCode', isEqualTo: epcHex)
// //             .limit(1)
// //             .get();
// //         print("📄 عدد النتائج في balances.payload.qrCode: ${q.docs.length}");
// //       }
// //       foundInBalances = q.docs.isNotEmpty;
// //     }

// //     if (q.docs.isEmpty) {
// //       print("❌ مفيش نتيجة");
// //       return null;
// //     }

// //     final d = q.docs.first;
// //     print("✅ تم العثور على العنصر: ${d.id}");
// //     return {
// //       'id': d.id,
// //       'collection': foundInBalances ? 'balances' : 'items',
// //       ...d.data() as Map<String, dynamic>
// //     };
// //   }

// //   static Future<Map<String, dynamic>?> epcandcode(String epcHex) async {
// //     final epc = epcHex.toUpperCase();
// //     print("🔎 البحث عن: $epc");

// //     QuerySnapshot q =
// //         await itemsCol().where('epcHex', isEqualTo: epc).limit(1).get();

// //     print("📄 عدد النتائج في items.epcHex: ${q.docs.length}");

// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where('epcHex', isEqualTo: "${epc}ENTRE")
// //           .limit(1)
// //           .get();

// //       print("📄 عدد النتائج في items.epcHex القديم: ${q.docs.length}");
// //     }

// //     if (q.docs.isEmpty) {
// //       q = await itemsCol()
// //           .where('payload.qrCode', isEqualTo: epcHex)
// //           .limit(1)
// //           .get();
// //       print("📄 عدد النتائج في items.payload.qrCode: ${q.docs.length}");
// //     }

// //     if (q.docs.isEmpty) {
// //       q = await balancesCol().where('epcHex', isEqualTo: epc).limit(1).get();

// //       print("📄 عدد النتائج في balances.epcHex: ${q.docs.length}");
// //     }

// //     if (q.docs.isEmpty) {
// //       q = await balancesCol()
// //           .where('epcHex', isEqualTo: "${epc}ENTRE")
// //           .limit(1)
// //           .get();

// //       print("📄 عدد النتائج في balances.epcHex القديم: ${q.docs.length}");
// //     }

// //     if (q.docs.isEmpty) {
// //       q = await balancesCol()
// //           .where('payload.qrCode', isEqualTo: epcHex)
// //           .limit(1)
// //           .get();
// //       print("📄 عدد النتائج في balances.payload.qrCode: ${q.docs.length}");
// //     }

// //     if (q.docs.isEmpty) {
// //       print("❌ مفيش نتيجة");
// //       return null;
// //     }

// //     final d = q.docs.first;
// //     final data = d.data() as Map<String, dynamic>;
// //     final payload = data['payload'] as Map<String, dynamic>?;

// //     return {
// //       'id': d.id,
// //       'epcHex': data['epcHex'],
// //       'qrCode': payload?['qrCode'],
// //       'collection': d.reference.parent.id,
// //     };
// //   }

// //   static Future<List<Map<String, dynamic>>> getAllEpcAndQr() async {
// //     print("📦 جلب كل الشرائح...");

// //     final QuerySnapshot q = await itemsCol().get();

// //     print("📄 عدد الشرائح: ${q.docs.length}");

// //     return q.docs.map((doc) {
// //       final data = doc.data() as Map<String, dynamic>;
// //       final payload = data['payload'] as Map<String, dynamic>?;

// //       return {
// //         'id': doc.id,
// //         'qrCode': payload?['qrCode'],
// //         ...data,
// //       };
// //     }).toList();
// //   }

// //   static Future<void> upsertInventory(
// //       String epcHex, Map<String, dynamic>? itemData) async {
// //     final now = FieldValue.serverTimestamp();

// //     // لو العنصر مش موجود في items أصلاً
// //     if (itemData == null) {
// //       final existingInv =
// //           await invCol().where('epcHex', isEqualTo: epcHex).limit(1).get();
// //       if (existingInv.docs.isEmpty) {
// //         await invCol().add({
// //           'epcHex': epcHex,
// //           'itemId': null,
// //           'firstSeenAt': now,
// //           //'lastSeenAt': now,
// //           'scanCount': 1,
// //         });
// //       } else {
// //         final doc = existingInv.docs.first;
// //         final currentCount =
// //             (doc.data() as Map<String, dynamic>)['scanCount'] ?? 1;
// //         await invCol().doc(doc.id).update({
// //           //'lastSeenAt': now,
// //           'scanCount': currentCount + 1,
// //         });
// //       }
// //     } else {
// //       final itemId = itemData['id'];
// //       final category = itemData['category'];
// //       final payload = itemData['payload'];

// //       final q =
// //           await invCol().where('itemId', isEqualTo: itemId).limit(1).get();
// //       if (q.docs.isEmpty) {
// //         await invCol().add({
// //           'epcHex': epcHex,
// //           'itemId': itemId,
// //           'category': category, // ✅ تخزين النوع
// //           'payload': payload, // ✅ تخزين التفاصيل
// //           'firstSeenAt': now,
// //           'lastSeenAt': now,
// //           'scanCount': 1,
// //           'createdAt': now,
// //         });
// //       } else {
// //         final doc = q.docs.first;
// //         final currentCount =
// //             (doc.data() as Map<String, dynamic>)['scanCount'] ?? 1;
// //         await invCol().doc(doc.id).update({
// //           'lastSeenAt': now,
// //           'scanCount': currentCount + 1,
// //           'category': category, // ✅ تحديث النوع
// //           'payload': payload, // ✅ تحديث التفاصيل
// //         });
// //       }
// //     }
// //   }

// //   /*static Future<void> deleteItem(String epcHex) async {
// //     final d = await findItemByEpc(epcHex);
// //     if (d == null) return;
// //     final itemRef = itemsCol().doc(d['id']);
// //     await itemRef.delete();
// //   }*/
// //   static Future<void> deleteItem(String epcHex) async {
// //     final d = await findItemByEpc(epcHex);
// //     if (d == null) return;

// //     final itemRef = itemsCol().doc(d['id']);
// //     final deletedRef = deletedItemsCol().doc(d['id']);

// //     final data = Map<String, dynamic>.from(d);
// //     await deleteItemImages(epcHex);

// //     data.remove('id');
// //     data.remove('collection');
// //     data['deletedAt'] = FieldValue.serverTimestamp();
// //     data['originalDocId'] = d['id'];

// //     await _db.runTransaction((transaction) async {
// //       transaction.set(deletedRef, data);
// //       transaction.delete(itemRef);
// //     });
// //   }

// //   static Future<void> deleteItemImages(String epc) async {
// //     try {
// //       final uid = FirebaseAuth.instance.currentUser!.uid;
// //       final cleanEpc = epc.toUpperCase();

// //       // 🔹 جرب الفولدر الجديد أولاً
// //       Reference sourceFolder = FirebaseStorage.instance
// //           .ref()
// //           .child('images')
// //           .child('users')
// //           .child(uid)
// //           .child(cleanEpc);

// //       ListResult result = await sourceFolder.listAll();

// //       // 🔹 لو مفيش صور، جرب الفولدر القديم (ENTRE)
// //       if (result.items.isEmpty) {
// //         sourceFolder = FirebaseStorage.instance
// //             .ref()
// //             .child('images')
// //             .child('users')
// //             .child(uid)
// //             .child("${cleanEpc}ENTRE");

// //         result = await sourceFolder.listAll();
// //       }

// //       // 🔹 فولدر المحذوفات (دائماً بالنظام الجديد)
// //       final deletedFolder = FirebaseStorage.instance
// //           .ref()
// //           .child('images')
// //           .child('users')
// //           .child(uid)
// //           .child('deleted')
// //           .child(cleanEpc);

// //       if (result.items.isEmpty) {
// //         print('ℹ️ لا توجد صور للشريحة $cleanEpc');
// //         return;
// //       }

// //       print('📦 نسخ ${result.items.length} صورة إلى مجلد المحذوفات');

// //       for (Reference sourceRef in result.items) {
// //         try {
// //           // تحميل الصورة
// //           final Uint8List? bytes = await sourceRef.getData();

// //           if (bytes == null) {
// //             print('❌ لم يتم تحميل ${sourceRef.name}');
// //             continue;
// //           }

// //           // إنشاء الملف الجديد بنفس الاسم
// //           final destRef = deletedFolder.child(sourceRef.name);

// //           // نسخ الصورة
// //           await destRef.putData(bytes);
// //           print('✅ تم نسخ ${sourceRef.name}');

// //           // حذف الأصل بعد نجاح النسخ
// //           await sourceRef.delete();
// //           print('🗑️ تم حذف ${sourceRef.name}');
// //         } catch (e) {
// //           print('❌ خطأ مع ${sourceRef.name}: $e');
// //         }
// //       }

// //       print('✅ انتهت عملية النسخ والحذف');
// //     } catch (e) {
// //       print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
// //     }
// //   }

// //   static Future<void> sellItem(
// //     String epcHex, {
// //     String? saleGroupId,
// //     Map<String, dynamic>? paymentData,
// //     bool partialSale = false,
// //     List<String>? soldComponents,
// //     double? weightSold,
// //     double? wageSold,
// //   }) async {
// //     final groupId =
// //         saleGroupId ?? DateTime.now().millisecondsSinceEpoch.toString();
// //     final d = await findItemByEpc(epcHex, includeBalances: true);
// //     if (d == null) return;

// //     final itemCollection =
// //         d['collection'] == 'balances' ? balancesCol() : itemsCol();
// //     final itemRef = itemCollection.doc(d['id']);
// //     final docSnap = await itemRef.get();
// //     if (!docSnap.exists) return;

// //     final itemData = docSnap.data() as Map<String, dynamic>;
// //     final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
// //     final currentWeight = (payload['weight'] ?? 0).toDouble();
// //     final currentWage = (payload['wage'] ?? 0).toDouble();

// //     /// لو بيع جزئي
// //     if (partialSale == true) {
// //       // حساب الوزن والأجر الجديد بعد الخصم
// //       final newWeight = currentWeight - (weightSold ?? 0);
// //       final newWage = currentWage - (wageSold ?? 0);

// //       // تحديث مكونات الطقم
// //       final updatedComponents =
// //           List<String>.from(payload['setComponents'] ?? []);
// //       if (soldComponents != null && soldComponents.isNotEmpty) {
// //         updatedComponents.removeWhere((c) => soldComponents.contains(c));
// //       }

// //       // تجهيز بيانات البيع الجزئي للسجل
// //       final saleData = {
// //         'itemId': d['id'],
// //         'epcHex': d['epcHex'],
// //         'saleGroupId': groupId,
// //         'soldAt': FieldValue.serverTimestamp(),
// //         'category': d['category'],
// //         'partialSale': true,
// //         'payload': {
// //           ...payload,
// //           'weight': weightSold,
// //           'wage': wageSold,
// //           'setComponents': soldComponents ?? [],
// //         },
// //         'createdAt': FieldValue.serverTimestamp(),
// //       };

// //       if (paymentData != null) {
// //         saleData['payment'] = paymentData;
// //       }

// //       await salesCol().add(saleData);
// //       await salesHistoryCol().add(saleData);

// //       // إنشاء رصيد لباقي الطقم في كولكشن جديد خاص ببقايا الأطقم
// //       final hasRemaining = newWeight > 0 || updatedComponents.isNotEmpty;
// //       if (hasRemaining) {
// //         await setRemaindersCol().add({
// //           'userId': uid,
// //           'originalItemId': d['id'],
// //           'originalEpcHex': d['epcHex'],
// //           'epcHex': d['epcHex'],
// //           'category': d['category'],
// //           'payload': {
// //             ...payload,
// //             'weight': newWeight,
// //             'wage': newWage,
// //             'setComponents': updatedComponents,
// //             'originalWeight': currentWeight,
// //             'originalWage': currentWage,
// //             'soldWeight': weightSold,
// //             'soldWage': wageSold,
// //           },
// //           'remainderType': 'partialSaleRemainder',
// //           'source': 'partialSale',
// //           'soldComponents': soldComponents ?? [],
// //           'remainingComponents': updatedComponents,
// //           'createdAt': FieldValue.serverTimestamp(),
// //           'updatedAt': FieldValue.serverTimestamp(),
// //         });
// //       }

// //       // حذف الطقم الأصلي
// //       await itemRef.delete();
// //     } else {
// //       /// البيع الكامل (زي النظام القديم)
// //       await itemRef.delete();

// //       final saleData = {
// //         'itemId': d['id'],
// //         'epcHex': d['epcHex'],
// //         'saleGroupId': groupId,
// //         'soldAt': FieldValue.serverTimestamp(),
// //         'category': d['category'],
// //         'payload': d['payload'],
// //         'createdAt': FieldValue.serverTimestamp(),
// //       };

// //       if (paymentData != null) {
// //         saleData['payment'] = paymentData;
// //       }

// //       await salesCol().add(saleData);
// //       await salesHistoryCol().add(saleData);
// //     }
// //   }

// //   /// ✅ دالة للتحقق من وجود العنصر قبل الإدخال
// //   static Future<bool> checkItemExists(String epcHex) async {
// //     final cleanEpc = epcHex.trim().toUpperCase();

// //     // items - النظام الجديد
// //     var q =
// //         await itemsCol().where('epcHex', isEqualTo: cleanEpc).limit(1).get();
// //     if (q.docs.isNotEmpty) return true;

// //     // items - النظام القديم
// //     q = await itemsCol()
// //         .where('epcHex', isEqualTo: '${cleanEpc}ENTRE')
// //         .limit(1)
// //         .get();
// //     if (q.docs.isNotEmpty) return true;

// //     // balances - النظام الجديد
// //     q = await balancesCol().where('epcHex', isEqualTo: cleanEpc).limit(1).get();
// //     if (q.docs.isNotEmpty) return true;

// //     // balances - النظام القديم
// //     q = await balancesCol()
// //         .where('epcHex', isEqualTo: '${cleanEpc}ENTRE')
// //         .limit(1)
// //         .get();
// //     if (q.docs.isNotEmpty) return true;

// //     q = await itemsCol()
// //         .where('payload.qrCode', isEqualTo: cleanEpc)
// //         .limit(1)
// //         .get();
// //     if (q.docs.isNotEmpty) return true;

// //     q = await balancesCol()
// //         .where('payload.qrCode', isEqualTo: cleanEpc)
// //         .limit(1)
// //         .get();
// //     return q.docs.isNotEmpty;
// //   }

// //   /// =========================
// //   /// 🔵 دوال خاصة بالمرتجعات (Returns)
// //   /// =========================

// //   /// ✅ جلب عمليات البيع المسجلة خلال آخر [days] أيام (افتراضيًا 3 أيام)
// //   static Future<List<Map<String, dynamic>>> getRecentSales(
// //       {int days = 3}) async {
// //     final cutoff = DateTime.now().subtract(Duration(days: days));
// //     final q = await salesCol()
// //         .where('soldAt', isGreaterThanOrEqualTo: Timestamp.fromDate(cutoff))
// //         .orderBy('soldAt', descending: true)
// //         .get();

// //     return q.docs.map((d) {
// //       final data = Map<String, dynamic>.from(d.data() as Map<String, dynamic>);
// //       data['id'] = d.id;
// //       return data;
// //     }).toList();
// //   }

// //   /// ✅ حذف سجل بيع معين (يُستخدم بعد استرجاع القطعة وإعادة تسجيلها)
// //   static Future<void> deleteSale(String saleId) async {
// //     await salesCol().doc(saleId).delete();
// //   }

// //   /// =========================
// //   /// 🟡 دوال خاصة بالكسر (Scrap)
// //   /// =========================

// //   /// ✅ تسجيل عملية إضافة كسر
// //   static Future<void> saveScrapAdd(Map<String, dynamic> data) async {
// //     await scrapCol().add({
// //       ...data,
// //       "person": data["person"],
// //       "carat": data["carat"],
// //       "notes": data["notes"],
// //       "date": Timestamp.fromDate(data["date"]),
// //       "type": "add",
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// ✅ تسجيل عملية بيع كسر
// //   static Future<void> saveScrapSale(Map<String, dynamic> data) async {
// //     await scrapCol().add({
// //       ...data,
// //       "person": data["person"],
// //       "carat": data["carat"],
// //       "notes": data["notes"],
// //       "date": Timestamp.fromDate(data["date"]),
// //       "type": "sale",
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// ✅ تسجيل عملية تحويل كسر
// //   static Future<void> saveScrapTransform(Map<String, dynamic> data) async {
// //     await scrapCol().add({
// //       ...data,
// //       "person": data["person"],
// //       "toPerson": data["toPerson"],
// //       "carat": data["carat"],
// //       "toCarat": data["toCarat"],
// //       "notes": data["notes"] ?? "",
// //       "date": Timestamp.fromDate(data["date"]),
// //       "type": data["type"] ?? "transform",
// //       "direction": data["direction"] ?? "out",
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// ✅ إرجاع كل المعاملات الخاصة بشخص
// //   static Future<List<Map<String, dynamic>>> getScrapTransactions(
// //       String name) async {
// //     final q = await scrapCol().where("person", isEqualTo: name.trim()).get();

// //     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
// //   }

// //   /// ✅ جلب معاملات شخص معين وعيار معين
// //   static Future<List<Map<String, dynamic>>>
// //       getScrapTransactionsByPersonAndCarat(
// //     String person,
// //     String carat,
// //   ) async {
// //     final q = await scrapCol()
// //         .where("person", isEqualTo: person.trim())
// //         .where("carat", isEqualTo: carat)
// //         .get();

// //     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
// //   }

// //   /// ✅ جلب معاملات عيار معين (للتحقق من الرصيد)
// //   static Future<List<Map<String, dynamic>>> getScrapTransactionsByCarat(
// //     String carat,
// //   ) async {
// //     final q = await scrapCol().where("carat", isEqualTo: carat).get();

// //     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
// //   }

// //   /// ✅ جلب رصيد شخص معين (كل العيارات)
// //   static Future<double> getPersonBalance(String person) async {
// //     final q = await scrapCol().where("person", isEqualTo: person.trim()).get();

// //     double balance = 0;
// //     for (var doc in q.docs) {
// //       final data = doc.data() as Map<String, dynamic>;
// //       final type = data["type"] ?? "";
// //       final weight = (data["weight"] ?? 0).toDouble();

// //       if (type == "add" || type == "transform") {
// //         balance += weight;
// //       } else if (type == "sale" || type == "payment") {
// //         balance -= weight.abs();
// //       }
// //     }
// //     return balance;
// //   }

// //   /// ✅ جلب رصيد شخص معين لعيار محدد
// //   static Future<double> getPersonBalanceByCarat(
// //       String person, String carat) async {
// //     final q = await scrapCol()
// //         .where("person", isEqualTo: person.trim())
// //         .where("carat", isEqualTo: carat)
// //         .get();

// //     double balance = 0;
// //     for (var doc in q.docs) {
// //       final data = doc.data() as Map<String, dynamic>;
// //       final type = data["type"] ?? "";
// //       final weight = (data["weight"] ?? 0).toDouble();

// //       if (type == "add" || type == "transform") {
// //         balance += weight;
// //       } else if (type == "sale" || type == "payment") {
// //         balance -= weight.abs();
// //       }
// //     }
// //     return balance;
// //   }

// //   /// ✅ جلب كل المعاملات لشخص معين مع فلترة حسب النوع
// //   static Future<List<Map<String, dynamic>>> getScrapTransactionsByType(
// //     String person,
// //     String type,
// //   ) async {
// //     final q = await scrapCol()
// //         .where("person", isEqualTo: person.trim())
// //         .where("type", isEqualTo: type)
// //         .get();

// //     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
// //   }

// //   /// ✅ جلب المعاملات في نطاق تاريخي
// //   static Future<List<Map<String, dynamic>>> getScrapTransactionsByDateRange(
// //     DateTime startDate,
// //     DateTime endDate,
// //   ) async {
// //     final q = await scrapCol()
// //         .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
// //         .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
// //         .orderBy("date", descending: true)
// //         .get();

// //     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
// //   }

// //   /// ✅ حذف معاملة كسر معينة
// //   static Future<void> deleteScrapTransaction(String docId) async {
// //     await scrapCol().doc(docId).delete();
// //   }

// //   /// ✅ تحديث معاملة كسر
// //   static Future<void> updateScrapTransaction(
// //     String docId,
// //     Map<String, dynamic> data,
// //   ) async {
// //     await scrapCol().doc(docId).update({
// //       ...data,
// //       "updatedAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// ✅ إرجاع أسماء الأشخاص (distinct)
// //   static Future<List<String>> getScrapPersons() async {
// //     final q = await scrapCol().get();
// //     final all = q.docs
// //         .map((d) => d['person'])
// //         .where((n) => n != null && n.toString().trim().isNotEmpty)
// //         .toList();

// //     return all.map((e) => e.toString().trim()).toSet().toList();
// //   }

// //   // تحديث الاسم في كل المعاملات
// //   static Future<void> updateScrapPerson(String oldName, String newName) async {
// //     final userDoc = _db.collection("users").doc(uid);

// //     // كل الكولكشن بتاع scrapTransactions
// //     final q = await userDoc
// //         .collection("scrapTransactions")
// //         .where("person", isEqualTo: oldName)
// //         .get();

// //     for (var doc in q.docs) {
// //       await doc.reference.update({"person": newName});
// //     }
// //   }

// //   // حذف كل معاملات الشخص
// //   // 🔹 حذف شخص ومعاملاته
// //   static Future<void> deleteScrapPerson(String name) async {
// //     final q = await scrapCol().where("person", isEqualTo: name.trim()).get();

// //     for (var doc in q.docs) {
// //       await doc.reference.delete();
// //     }
// //   }

// //   static Stream<List<String>> scrapPersonsStream() {
// //     return _db
// //         .collection("users")
// //         .doc(uid)
// //         .collection("scrapTransactions")
// //         .snapshots()
// //         .map((snapshot) {
// //       final names = snapshot.docs
// //           .map((d) => d.data()["person"] as String?)
// //           .where((p) => p != null && p.isNotEmpty)
// //           .map((p) => p!) // نرجعها String مش nullable
// //           .toSet()
// //           .toList();
// //       names.sort();
// //       return names;
// //     });
// //   }

// //   static Stream<List<Map<String, dynamic>>> scrapTransactionsStream() {
// //     return scrapCol().snapshots().map((snap) {
// //       return snap.docs.map((d) {
// //         final data = d.data() as Map<String, dynamic>;
// //         data["id"] = d.id;
// //         return data;
// //       }).toList();
// //     });
// //   }

// //   /// ✅ جلب إحصائيات الكسر (ملخص عام)
// //   static Future<Map<String, dynamic>> getScrapStatistics() async {
// //     final q = await scrapCol().get();

// //     Map<String, dynamic> stats = {
// //       "totalAdd": 0.0,
// //       "totalSale": 0.0,
// //       "totalPayment": 0.0,
// //       "totalTransform": 0.0,
// //       "byCarat": {
// //         "14": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
// //         "18": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
// //         "21": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
// //         "22": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
// //         "24": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
// //       }
// //     };

// //     for (var doc in q.docs) {
// //       final data = doc.data() as Map<String, dynamic>;
// //       final type = data["type"] ?? "";
// //       final carat = (data["carat"] ?? "18").toString();
// //       final weight = (data["weight"] ?? 0).toDouble();

// //       if (type == "add") {
// //         stats["totalAdd"] = (stats["totalAdd"] ?? 0.0) + weight;
// //         if (stats["byCarat"][carat] != null) {
// //           stats["byCarat"][carat]["add"] =
// //               (stats["byCarat"][carat]["add"] ?? 0.0) + weight;
// //         }
// //       } else if (type == "sale") {
// //         stats["totalSale"] = (stats["totalSale"] ?? 0.0) + weight.abs();
// //         if (stats["byCarat"][carat] != null) {
// //           stats["byCarat"][carat]["sale"] =
// //               (stats["byCarat"][carat]["sale"] ?? 0.0) + weight.abs();
// //         }
// //       } else if (type == "payment") {
// //         stats["totalPayment"] = (stats["totalPayment"] ?? 0.0) + weight.abs();
// //         if (stats["byCarat"][carat] != null) {
// //           stats["byCarat"][carat]["payment"] =
// //               (stats["byCarat"][carat]["payment"] ?? 0.0) + weight.abs();
// //         }
// //       } else if (type == "transform") {
// //         stats["totalTransform"] = (stats["totalTransform"] ?? 0.0) + weight;
// //         if (stats["byCarat"][carat] != null) {
// //           stats["byCarat"][carat]["transform"] =
// //               (stats["byCarat"][carat]["transform"] ?? 0.0) + weight;
// //         }
// //       }
// //     }

// //     return stats;
// //   }

// //   /// 🟢 كولكشن الموردين
// //   /// 🟢 إضافة مورد جديد
// //   static Future<void> addSupplier({
// //     required String name,
// //     required List<String> delegates,
// //     required String phone,
// //   }) async {
// //     await suppliersCol().add({
// //       "name": name,
// //       "delegates": delegates,
// //       "phone": phone,
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// 🟢 جلب الموردين
// //   static Future<List<Map<String, dynamic>>> getSuppliers() async {
// //     final q = await suppliersCol().get();
// //     return q.docs
// //         .map((d) => {"id": d.id, ...d.data() as Map<String, dynamic>})
// //         .toList();
// //   }

// //   /// 🟢 كولكشن سندات
// //   /// 🟢 إضافة سند قبض
// //   static Future<void> addReceiptVoucher({
// //     required String supplierId,
// //     required String supplierName,
// //     required String delegate,
// //     required String carat,
// //     required double weight,
// //     required double wage,
// //     required DateTime date,
// //   }) async {
// //     await vouchersCol().add({
// //       "supplierId": supplierId,
// //       "supplierName": supplierName,
// //       "delegate": delegate,
// //       "carat": carat,
// //       "weight": weight,
// //       "wage": wage,
// //       "type": "receipt",
// //       "date": Timestamp.fromDate(date),
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// 🟢 إضافة سند صرف
// //   static Future<void> addPaymentVoucher({
// //     required String supplierId,
// //     required String supplierName,
// //     required String delegate,
// //     required String carat,
// //     required double weight,
// //     required double wage,
// //     required String paymentMethod, // "كاش" أو "شبكة" أو "متعدد"
// //     required double? cash,
// //     required double? network,
// //     required DateTime date,
// //   }) async {
// //     await vouchersCol().add({
// //       "supplierId": supplierId,
// //       "supplierName": supplierName,
// //       "delegate": delegate,
// //       "carat": carat,
// //       "weight": weight,
// //       "wage": wage,
// //       "type": "payment",
// //       "paymentMethod": paymentMethod,
// //       "cash": cash,
// //       "network": network,
// //       "total": (cash ?? 0) + (network ?? 0),
// //       "date": Timestamp.fromDate(date),
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //     await scrapCol().add({
// //       "supplierId": supplierId,
// //       "person": supplierName,
// //       "carat": carat,
// //       "weight": weight,
// //       "wage": wage,
// //       "date": Timestamp.fromDate(date),
// //       "type": "payment",
// //       "createdAt": FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// 🟢 جلب السندات لمورد
// //   static Future<List<Map<String, dynamic>>> getVouchersForSupplier(
// //       String supplierId) async {
// //     final q =
// //         await vouchersCol().where("supplierId", isEqualTo: supplierId).get();
// //     return q.docs
// //         .map((d) => {"id": d.id, ...d.data() as Map<String, dynamic>})
// //         .toList();
// //   }

// //   // داخل كلاس FS
// //   static Future<void> updateSupplier(
// //       String id, Map<String, dynamic> data) async {
// //     await suppliersCol().doc(id).update({
// //       ...data,
// //       'updatedAt': FieldValue.serverTimestamp(),
// //     });
// //   }

// //   static Future<void> deleteSupplier(String id) async {
// //     await suppliersCol().doc(id).delete();
// //   }

// //   static Stream<List<Map<String, dynamic>>> suppliersStream() {
// //     return suppliersCol()
// //         .orderBy('name') // أو حسب التاريخ لو عايز
// //         .snapshots()
// //         .map((snap) => snap.docs
// //             .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
// //             .toList());
// //   }

// //   /// ==============================
// //   /// 💰 دوال المصروفات (Expenses)
// //   /// ==============================

// //   /// 🔹 إضافة مصروف جديد
// //   static Future<void> addExpense({
// //     required String type,
// //     required double amount,
// //     required DateTime date,
// //     String? note,
// //   }) async {
// //     await expensesCol().add({
// //       'type': type,
// //       'amount': amount,
// //       'note': note ?? '',
// //       'date': Timestamp.fromDate(date),
// //       'createdAt': FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// 🔹 تعديل مصروف موجود
// //   static Future<void> updateExpense(
// //       String id, Map<String, dynamic> data) async {
// //     await expensesCol().doc(id).update({
// //       ...data,
// //       'updatedAt': FieldValue.serverTimestamp(),
// //     });
// //   }

// //   /// 🔹 حذف مصروف
// //   static Future<void> deleteExpense(String id) async {
// //     await expensesCol().doc(id).delete();
// //   }

// //   /// 🔹 جلب كل المصروفات
// //   static Stream<List<Map<String, dynamic>>> expensesStream({
// //     String? typeFilter,
// //     DateTimeRange? dateRange,
// //   }) {
// //     Query query = expensesCol().orderBy('date', descending: true);

// //     if (typeFilter != null && typeFilter.isNotEmpty) {
// //       query = query.where('type', isEqualTo: typeFilter);
// //     }

// //     if (dateRange != null) {
// //       final start = DateTime(dateRange.start.year, dateRange.start.month,
// //           dateRange.start.day, 0, 0, 0);
// //       final end = DateTime(dateRange.end.year, dateRange.end.month,
// //           dateRange.end.day, 23, 59, 59);

// //       query = query
// //           .where('date', isGreaterThanOrEqualTo: start)
// //           .where('date', isLessThanOrEqualTo: end);
// //     }

// //     return query.snapshots().map((snap) {
// //       return snap.docs.map((d) {
// //         final data = d.data() as Map<String, dynamic>;
// //         data['id'] = d.id;
// //         return data;
// //       }).toList();
// //     });
// //   }

// //   static Future<List<String>> getExpenseTypes() async {
// //     final snapshot = await expensesCol().get();

// //     final allTypes = snapshot.docs
// //         .map((d) => d['type']?.toString().trim() ?? '')
// //         .where((t) => t.isNotEmpty)
// //         .toSet()
// //         .toList();

// //     allTypes.sort(); // ترتيب أبجدي اختياري
// //     return allTypes;
// //   }

// //   static Stream<List<String>> expenseTypesStream() {
// //     return _db
// //         .collection('users')
// //         .doc(uid)
// //         .collection('expenses')
// //         .snapshots()
// //         .map((snapshot) {
// //       final all = snapshot.docs
// //           .map((d) => d['type']?.toString().trim() ?? '')
// //           .where((t) => t.isNotEmpty)
// //           .toSet()
// //           .toList();
// //       all.sort();
// //       return all;
// //     });
// //   }

// //   static Stream<List<String>> soldByStream() {
// //     return _db
// //         .collection('users')
// //         .doc(uid)
// //         .collection('sales')
// //         .snapshots()
// //         .map((snapshot) {
// //       final all = snapshot.docs
// //           .map((d) {
// //             final payment = d.data()['payment'];
// //             if (payment is Map && payment['soldBy'] != null) {
// //               return payment['soldBy'].toString().trim();
// //             }
// //             return '';
// //           })
// //           .where((s) => s.isNotEmpty)
// //           .toSet()
// //           .toList();

// //       all.sort();
// //       return all;
// //     });
// //   }

// //   static Stream<List<Map<String, dynamic>>> salesStream({
// //     String? soldByFilter,
// //     DateTimeRange? dateRange,
// //   }) {
// //     return _db
// //         .collection('users')
// //         .doc(uid)
// //         .collection('sales')
// //         .snapshots()
// //         .map((snapshot) {
// //       return snapshot.docs.map((d) {
// //         final data = d.data();
// //         data['id'] = d.id;
// //         return data;
// //       }).where((s) {
// //         // فلترة البائع
// //         if (soldByFilter != null) {
// //           final soldBy = s['payment']?['soldBy'];
// //           if (soldBy != soldByFilter) return false;
// //         }

// //         // فلترة التاريخ
// //         if (dateRange != null) {
// //           final ts = s['soldAt'] as Timestamp?;
// //           if (ts == null) return false;
// //           final date = ts.toDate();
// //           if (date.isBefore(dateRange.start) || date.isAfter(dateRange.end)) {
// //             return false;
// //           }
// //         }

// //         return true;
// //       }).toList();
// //     });
// //   }

// //   /// =========== فروع (Branches) =============

// //   static Future<void> addBranch({
// //     required String name,
// //     required String uid,
// //     required String address,
// //     required String manager,
// //     required String phone,
// //     required List<String> delegates,
// //     required DateTime date,
// //   }) async {
// //     await branchesCol().add({
// //       'name': name,
// //       'uid': uid,
// //       'address': address,
// //       'manager': manager,
// //       'phone': phone,
// //       'delegates': delegates,
// //       'date': Timestamp.fromDate(date),
// //       'createdAt': FieldValue.serverTimestamp(),
// //     });
// //   }

// //   static Future<void> updateBranch(String id, Map<String, dynamic> data) async {
// //     await branchesCol().doc(id).update({
// //       ...data,
// //       'updatedAt': FieldValue.serverTimestamp(),
// //     });
// //   }

// //   static Future<void> deleteBranch(String id) async {
// //     await branchesCol().doc(id).delete();
// //   }

// //   static Future<List<Map<String, dynamic>>> getBranches() async {
// //     final q = await branchesCol().orderBy('name').get();
// //     return q.docs
// //         .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
// //         .toList();
// //   }

// //   static Stream<List<Map<String, dynamic>>> branchesStream() {
// //     return branchesCol().orderBy('name').snapshots().map((snap) => snap.docs
// //         .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
// //         .toList());
// //   }

// //   /// ============================
// //   /// 🔄 دوال التحويل (Transform)
// //   /// ============================

// //   /// 🔹 تحويل صنف إلى كسر
// //   static Future<void> transferToScrap(
// //       Map<String, dynamic> itemData, String epcHex) async {
// //     final now = FieldValue.serverTimestamp();

// //     // 🔸 تجهيز البيانات
// //     //final payload = itemData['payload'] ?? itemData;
// //     final Map<String, dynamic> payload =
// //         Map<String, dynamic>.from(itemData['payload'] ?? itemData);
// //     final scrapData = {
// //       "person": "تحويل",
// //       "type": "transform",
// //       "createdAt": now,
// //       "date": now,
// //       //"payload": payload,
// //       ...payload,
// //     };

// //     // 🔸 تحديث حالة الصنف
// //     try {
// //       final d = await findItemByEpc(epcHex);
// //       if (d == null) return;

// //       // تحديث حالة القطعة -> مباعة
// //       await itemsCol().doc(d['id']).delete();
// //       await _db
// //           .collection('users')
// //           .doc(uid)
// //           .collection('scrapTransactions')
// //           .add(scrapData);
// //     } catch (_) {}
// //   }

// //   /// 🔹 تحويل صنف إلى فرع
// //   static Future<void> transferToBranch(
// //       Map<String, dynamic> itemData,
// //       String epcHex,
// //       String branchId,
// //       String branchName,
// //       String repName,
// //       String branchUid) async {
// //     final now = FieldValue.serverTimestamp();
// //     final payload = itemData['payload'] ?? itemData;
// //     final category = itemData['category'] ?? '';

// //     // 🔸 تجهيز بيانات التحويل
// //     final transferData = {
// //       'fromUId': uid,
// //       'branchUid': branchUid,
// //       "epcHex": epcHex,
// //       "branchId": branchId,
// //       "branchName": branchName,
// //       "rep": repName,
// //       "createdAt": now,
// //       "date": now,
// //       "payload": payload,
// //       "category": category,
// //       'status': 'pending',
// //     };

// //     // 🔸 حفظ العملية في كولكشن التحويلات
// //     await _db
// //         .collection('users')
// //         .doc(uid)
// //         .collection('branchTransfers')
// //         .add(transferData);

// //     /*// 🔸 تحديث حالة القطعة في items
// //     try {
// //       final d = await findItemByEpc(epcHex);
// //       if (d == null) return;

// //       // تحديث حالة القطعة -> مباعة
// //       await itemsCol().doc(d['id']).delete();
// //     } catch (_) {}*/

// //     await _db
// //         .collection('transferRequests')
// //         .doc(branchUid)
// //         .collection('branchTransfers')
// //         .add(transferData);
// //   }

// //   static StreamSubscription? _transferListener;

// //   static void listenToTransferUpdates() {
// //     final uid = FirebaseAuth.instance.currentUser?.uid;
// //     if (uid == null) return;

// //     // نلغي أي listener سابق
// //     _transferListener?.cancel();

// //     // stream على branchTransfers عند المرسل
// //     final userTransfersRef = FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(uid)
// //         .collection('branchTransfers')
// //         .where('status', isEqualTo: 'pending');

// //     _transferListener = userTransfersRef.snapshots().listen((snapshot) async {
// //       print(
// //           "✅Transfer listener triggered: ${snapshot.docs.length} pending items");
// //       for (var docChange in snapshot.docChanges) {
// //         final doc = docChange.doc;
// //         final data = doc.data();
// //         if (data == null) continue;

// //         final branchUid = data['branchUid'];
// //         final epcHex = data['epcHex'];
// //         if (branchUid == null || epcHex == null) continue;

// //         final targetTransfersRef = FirebaseFirestore.instance
// //             .collection('transferRequests')
// //             .doc(branchUid)
// //             .collection('branchTransfers');

// //         final targetSnapshot =
// //             await targetTransfersRef.where('epcHex', isEqualTo: epcHex).get();

// //         if (targetSnapshot.docs.isEmpty) continue;

// //         final targetStatus = targetSnapshot.docs.first.data()['status'];
// //         final targetDoc = targetSnapshot.docs.first;

// //         if (targetStatus == 'accepted') {
// //           // حذف من items عند المرسل
// //           final itemsSnapshot = await FirebaseFirestore.instance
// //               .collection('users')
// //               .doc(uid)
// //               .collection('items')
// //               .where('epcHex', isEqualTo: epcHex)
// //               .get();

// //           for (var itemDoc in itemsSnapshot.docs) {
// //             await itemDoc.reference.delete();
// //           }

// //           // حذف من branchTransfers عند المرسل
// //           //await doc.reference.delete();
// //           await doc.reference.update({'status': 'accepted'});
// //           await targetDoc.reference.delete();
// //         } else if (targetStatus == 'rejected') {
// //           // حذف من branchTransfers عند المرسل فقط
// //           await doc.reference.delete();
// //           await targetDoc.reference.delete();
// //         }
// //       }
// //     });
// //   }

// //   /// لإيقاف الاستماع عند إغلاق الصفحة أو الخروج
// //   static void cancelTransferListener() {
// //     _transferListener?.cancel();
// //     _transferListener = null;
// //   }

// //   static StreamSubscription? _transferSubscription;
// //   static bool _isDialogOpen = false;

// //   static void listenForTransfers(BuildContext context) {
// //     final uid = FirebaseAuth.instance.currentUser?.uid;
// //     if (uid == null) return;

// //     _transferSubscription?.cancel();

// //     _transferSubscription = FirebaseFirestore.instance
// //         .collection('transferRequests')
// //         .doc(uid)
// //         .collection('branchTransfers')
// //         .where('status', isEqualTo: 'pending')
// //         .snapshots()
// //         .listen((snapshot) {
// //       // 🔴 لو مفيش شرائح
// //       if (snapshot.docs.isEmpty) {
// //         if (_isDialogOpen) {
// //           Navigator.of(context, rootNavigator: true).pop();
// //           _isDialogOpen = false;
// //         }
// //         return;
// //       }

// //       // 🟢 لو فيه شرائح والديلوج مش مفتوح
// //       if (!_isDialogOpen) {
// //         _isDialogOpen = true;
// //         _showTransfersDialog(context, snapshot.docs);
// //       }
// //     });
// //   }

// //   static void stopListening() {
// //     _transferSubscription?.cancel();
// //   }

// //   static void _showTransfersDialog(
// //     BuildContext context,
// //     List<QueryDocumentSnapshot> docs,
// //   ) {
// //     showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) {
// //         return Directionality(
// //           textDirection: TextDirection.rtl,
// //           child: AlertDialog(
// //             title: const Text("وصلك تحويلات جديدة"),
// //             content: SizedBox(
// //               width: double.maxFinite,
// //               height: 400,
// //               child: ListView.builder(
// //                 itemCount: docs.length,
// //                 itemBuilder: (context, index) {
// //                   final doc = docs[index];
// //                   final data = doc.data() as Map<String, dynamic>;
// //                   final payload = data['payload'] as Map<String, dynamic>?;

// //                   return Card(
// //                     margin: const EdgeInsets.symmetric(vertical: 8),
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(8),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text("الفرع: ${data['branchName']}"),
// //                           Text("المندوب: ${data['rep']}"),
// //                           Text("رقم الشريحة: ${data['epcHex']}"),
// //                           Text("التصنيف: ${data['category']}"),
// //                           if (payload?["carat"] != null)
// //                             Text("العيار: ${payload?['carat']}"),
// //                           if (payload?["weight"] != null)
// //                             Text("الوزن: ${payload?['weight']}"),
// //                           const SizedBox(height: 10),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               ElevatedButton(
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor: Colors.green,
// //                                   foregroundColor: Colors.white,
// //                                 ),
// //                                 onPressed: () async {
// //                                   await acceptTransfer(data, doc.id);
// //                                 },
// //                                 child: const Text("قبول"),
// //                               ),
// //                               const SizedBox(width: 20),
// //                               ElevatedButton(
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor: Colors.red,
// //                                   foregroundColor: Colors.white,
// //                                 ),
// //                                 onPressed: () async {
// //                                   await rejectTransfer(doc.id);
// //                                 },
// //                                 child: const Text("رفض"),
// //                               ),
// //                             ],
// //                           )
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     ).then((_) {
// //       _isDialogOpen = false;
// //     });
// //   }

// //   static Future<void> acceptTransfer(
// //       Map<String, dynamic> data, String docId) async {
// //     final uid = FirebaseAuth.instance.currentUser!.uid;

// //     // 🔹 حفظ القطعة في itemsCol
// //     await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(uid)
// //         .collection('items')
// //         .add(data);

// //     // 🔹 تغيير الحالة
// //     await FirebaseFirestore.instance
// //         .collection('transferRequests')
// //         .doc(uid)
// //         .collection('branchTransfers')
// //         .doc(docId)
// //         .update({'status': 'accepted'});
// //   }

// //   static Future<void> rejectTransfer(String docId) async {
// //     final uid = FirebaseAuth.instance.currentUser!.uid;

// //     await FirebaseFirestore.instance
// //         .collection('transferRequests')
// //         .doc(uid)
// //         .collection('branchTransfers')
// //         .doc(docId)
// //         .update({'status': 'rejected'});
// //   }

// //   /// 🔹 جلب المناديب الخاصة بفرع
// //   static Future<List<String>> getRepsForBranch(String branchId) async {
// //     final doc = await branchesCol().doc(branchId).get();
// //     if (!doc.exists) return [];
// //     final data = doc.data() as Map<String, dynamic>;
// //     final reps = data["delegates"];
// //     if (reps is List) {
// //       return reps.map((e) => e.toString()).toList();
// //     }
// //     return [];
// //   }

// //   static Future<Map<String, dynamic>> getGeneralBalance() async {
// //     double gold18 = 0, gold21 = 0, gold22 = 0;
// //     double barsWeight = 0;

// //     int stonesCount = 0;
// //     double stonesCost = 0;

// //     double cash = 0;
// //     double network = 0;

// //     double scrapWeight = 0;

// //     double creditor = 0; // دائن
// //     double debtor = 0; // مدين
// //     double supply = 0;

// //     /// ================== الأصناف ==================
// //     final itemsSnap = await itemsCol().get();
// //     for (var d in itemsSnap.docs) {
// //       final data = d.data() as Map<String, dynamic>;
// //       final payload = Map<String, dynamic>.from(data['payload'] ?? {});
// //       final weight = (payload['weight'] ?? 0).toDouble();
// //       final carat = payload['carat'];

// //       if (carat == 18) gold18 += weight;
// //       if (carat == 21) gold21 += weight;
// //       if (carat == 22) gold22 += weight;

// //       stonesCount += (payload['stonesCount'] ?? 0) as int;
// //       stonesCost += (payload['stonesCost'] ?? 0).toDouble();

// //       if (data['category'] == 'bar') {
// //         barsWeight += weight;
// //       }
// //     }

// //     /// ================== المبيعات ==================
// //     final salesSnap = await salesCol().get();
// //     for (var d in salesSnap.docs) {
// //       final pay = d['payment'];
// //       if (pay != null) {
// //         cash += (pay['cash'] ?? 0).toDouble();
// //         network += (pay['network'] ?? 0).toDouble();
// //       }
// //     }

// //     /// ================== الكسر ==================
// //     final scrapSnap = await scrapCol().get();
// //     for (var d in scrapSnap.docs) {
// //       scrapWeight += (d['weight'] ?? 0).toDouble();
// //     }

// //     /// ================== السندات ==================
// //     final vouchersSnap = await vouchersCol().get();
// //     for (var d in vouchersSnap.docs) {
// //       final weight = (d['weight'] ?? 0).toDouble();
// //       if (d['type'] == 'receipt') {
// //         creditor += weight;
// //       } else if (d['type'] == 'payment') {
// //         debtor += weight;
// //       }
// //     }

// //     /// ================== التوريد ==================
// //     final depSnap = await depositsCol().get();
// //     for (var d in depSnap.docs) {
// //       supply += (d['amount'] ?? 0).toDouble();
// //     }

// //     return {
// //       "gold18": gold18,
// //       "gold21": gold21,
// //       "gold22": gold22,
// //       "barsWeight": barsWeight,
// //       "stonesCount": stonesCount,
// //       "stonesCost": stonesCost,
// //       "cash": cash,
// //       "network": network,
// //       "scrapWeight": scrapWeight,
// //       "creditor": creditor,
// //       "debtor": debtor,
// //       "supply": supply,
// //     };
// //   }

// //   /// ================== التعاملات ==================
// //   static Future<void> sendToExternal({
// //     required String epc,
// //     required Map<String, dynamic> itemData,
// //     required String shopName,
// //     required String managerName,
// //     required String sentBy,
// //   }) async {
// //     // تأكد إن الشريحة مش موجودة بالفعل
// //     final existing = await externalCol().doc(epc).get();
// //     if (existing.exists) {
// //       throw Exception("هذه الشريحة موجودة بالفعل في التعاملات الخارجية");
// //     }

// //     await externalCol().doc(epc).set({
// //       "epc": epc,
// //       //"itemData": itemData,
// //       ...itemData,
// //       "shopName": shopName,
// //       "managerName": managerName,
// //       "sentBy": sentBy,
// //       "sentAt": Timestamp.now(),
// //       "status": "pending",
// //     });
// //   }

// //   static Stream<QuerySnapshot> getExternalTransactions() {
// //     return externalCol()
// //         .where('status', isEqualTo: 'pending')
// //         .orderBy('sentAt', descending: true)
// //         .snapshots();
// //   }

// //   static Future<void> returnExternal(String epc) async {
// //     await externalCol().doc(epc).delete();
// //   }

// //   static Future<void> receiveExternalPayment({
// //     required String epc,
// //     required Map<String, dynamic> paymentData,
// //   }) async {
// //     /*final doc = await externalCol().doc(epc).get();

// //     if (!doc.exists) {
// //       throw Exception("الشريحة غير موجودة");
// //     }

// //     final data = doc.data() as Map<String, dynamic>;

// //     // حفظ في المبيعات
// //     await salesCol().add({
// //       ...data,
// //       "paymentData": paymentData,
// //       "soldAt": Timestamp.now(),
// //       "saleType": "external",
// //     });

// //     // حذف من التعاملات الخارجية
// //     await externalCol().doc(epc).delete();*/

// //     /////////
// //     final d = await findItemByEpc(epc);
// //     if (d == null) return;

// //     final itemRef = itemsCol().doc(d['id']);
// //     final docSnap = await itemRef.get();
// //     if (!docSnap.exists) return;

// //     /*final itemData = docSnap.data() as Map<String, dynamic>;
// //     final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
// //     final currentWeight = (payload['weight'] ?? 0).toDouble();
// //     final currentWage = (payload['wage'] ?? 0).toDouble();*/
// //     await itemRef.delete();

// //     final saleData = {
// //       'itemId': d['id'],
// //       'epcHex': d['epcHex'],
// //       'soldAt': FieldValue.serverTimestamp(),
// //       'category': d['category'],
// //       'payload': d['payload'],
// //       'createdAt': FieldValue.serverTimestamp(),
// //     };

// //     saleData['payment'] = paymentData;

// //     await salesCol().add(saleData);
// //     // حذف من التعاملات الخارجية
// //     await externalCol().doc(epc).delete();
// //   }

// //   // ✅ إضافة تصريح خروج
// //   static Future<void> addStatement(
// //     String epc,
// //     Map<String, dynamic> item,
// //     String userId,
// //   ) async {
// //     await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(userId)
// //         .collection('Statements')
// //         .doc(epc) // منع التكرار
// //         .set({
// //       ...item,
// //       'StatementDate': FieldValue.serverTimestamp(),
// //       'status': 'active',
// //     });
// //   }

// //   // ✅ جلب التصاريح
// //   static Stream<QuerySnapshot> getStatements(String userId) {
// //     return FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(userId)
// //         .collection('Statements')
// //         .orderBy('StatementDate', descending: true)
// //         .snapshots();
// //   }

// //   // ✅ إلغاء التصريح
// //   static Future<void> cancelStatement(String epc, String userId) async {
// //     await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(userId)
// //         .collection('Statements')
// //         .doc(epc)
// //         .delete(); // 🔥 حذف كامل
// //   }

// //   static Future<bool> checkIfExists(String epc, String userId) async {
// //     final q = await FirebaseFirestore.instance
// //         .collection('users')
// //         .doc(userId)
// //         .collection('Statements')
// //         .where('epcHex', isEqualTo: epc)
// //         .where('userId', isEqualTo: userId)
// //         .get();

// //     return q.docs.isNotEmpty;
// //   }
// // }
// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:typed_data';

// class FS {
//   static final _db = FirebaseFirestore.instance;
//   static String get uid => FirebaseAuth.instance.currentUser!.uid;

//   static CollectionReference itemsCol() =>
//       _db.collection('users').doc(uid).collection('items');
//   static CollectionReference invCol() =>
//       _db.collection('users').doc(uid).collection('inventories');
//   static CollectionReference salesCol() =>
//       _db.collection('users').doc(uid).collection('sales');
//   static CollectionReference salesHistoryCol() =>
//       _db.collection('users').doc(uid).collection('sales_history');
//   static CollectionReference depositsCol() =>
//       _db.collection('users').doc(uid).collection('managementDeposits');
//   static CollectionReference ImportedCol() =>
//       _db.collection('users').doc(uid).collection('managementImported');
//   static CollectionReference vouchersCol() =>
//       _db.collection('users').doc(uid).collection('vouchers');
//   static CollectionReference scrapCol() =>
//       _db.collection('users').doc(uid).collection('scrapTransactions');
//   static CollectionReference suppliersCol() =>
//       _db.collection('users').doc(uid).collection('suppliers');
//   static CollectionReference expensesCol() =>
//       _db.collection('users').doc(uid).collection('expenses');
//   static CollectionReference externalCol() =>
//       _db.collection('users').doc(uid).collection('externalTransactions');
//   static CollectionReference branchesCol() =>
//       _db.collection('users').doc(uid).collection('branches');
//   static CollectionReference balancesCol() =>
//       _db.collection('users').doc(uid).collection('balances');
//   static CollectionReference setRemaindersCol() =>
//       _db.collection('users').doc(uid).collection('setRemainders');
//   static CollectionReference deletedItemsCol() =>
//       _db.collection('users').doc(uid).collection('deleted_items');

//   static Future<void> saveItem({
//     required String epcHex,
//     required String category,
//     required DateTime date,
//     required Map<String, dynamic> payload,
//     required bool fromOpeningBalance,
//   }) async {
//     final doc = itemsCol().doc();
//     await doc.set({
//       'userId': uid,
//       'code': epcHex,
//       'epcHex': epcHex,
//       'category': category,
//       'date': date,
//       'payload': payload,
//       'status': 'active',
//       'createdAt': FieldValue.serverTimestamp(),
//       'fromOpeningBalance': fromOpeningBalance,
//     });
//   }

//   /// 📦 إرجاع عدد العناصر داخل كولكشن items
//   static Future<int> getItemsCount() async {
//     try {
//       final snapshot = await itemsCol().get();
//       return snapshot.size;
//     } catch (e) {
//       debugPrint("❌ خطأ أثناء جلب عدد العناصر: $e");
//       return 0;
//     }
//   }

//   /// ✅ تحديث عنصر (يدعم dot notation)
//   static Future<void> uupdateItem(
//       String epcHex, Map<String, dynamic> updates) async {
//     final epc = epcHex.trim();

// // البحث بالنظام الجديد
//     QuerySnapshot q =
//         await itemsCol().where("epcHex", isEqualTo: epc).limit(1).get();

// // لو ملقاش، ابحث بالنظام القديم
//     if (q.docs.isEmpty) {
//       q = await itemsCol()
//           .where("epcHex", isEqualTo: "${epc}ENTRE")
//           .limit(1)
//           .get();

//       // لو لقى سجل قديم حدثه تلقائياً
//       if (q.docs.isNotEmpty) {
//         await itemsCol().doc(q.docs.first.id).update({
//           "epcHex": epc,
//         });
//       }
//     }

//     if (q.docs.isEmpty) {
//       throw Exception("⚠️ العنصر غير موجود");
//     }

//     final doc = q.docs.first;

//     await itemsCol().doc(doc.id).update({
//       ...updates,
//       "updatedAt": FieldValue.serverTimestamp(),
//     });
//   }

//   /// ✅ تحديث عنصر (يدعم dot notation)
//   static Future<void> updateItem(
//       String epcHex, Map<String, dynamic> updates) async {
//     final cleanEpc = epcHex.trim().toUpperCase();
//     print("🛠️ محاولة تحديث العنصر برقم: $cleanEpc");

// // 🔹 البحث بالنظام الجديد
//     var q =
//         await itemsCol().where("epcHex", isEqualTo: cleanEpc).limit(1).get();

//     print("📄 نتائج البحث في epcHex: ${q.docs.length}");

// // 🔹 لو مفيش نتيجة، ابحث بالنظام القديم (ENTRE)
//     if (q.docs.isEmpty) {
//       q = await itemsCol()
//           .where("epcHex", isEqualTo: "${cleanEpc}ENTRE")
//           .limit(1)
//           .get();

//       print("📄 نتائج البحث في epcHex القديم: ${q.docs.length}");

//       // Migration تلقائي
//       if (q.docs.isNotEmpty) {
//         await itemsCol().doc(q.docs.first.id).update({
//           "epcHex": cleanEpc,
//         });
//       }
//     }

//     // 🔹 لو مفيش نتيجة، ابحث في payload.qrCode
//     if (q.docs.isEmpty) {
//       q = await itemsCol()
//           .where("payload.qrCode", isEqualTo: cleanEpc)
//           .limit(1)
//           .get();

//       print("📄 نتائج البحث في payload.qrCode: ${q.docs.length}");
//     }

//     // 🔹 لو مفيش أي نتيجة
//     if (q.docs.isEmpty) {
//       throw Exception("⚠️ العنصر غير موجود في قاعدة البيانات!");
//     }

//     // 🔹 تحديث العنصر
//     final doc = q.docs.first;
//     await itemsCol().doc(doc.id).update({
//       ...updates,
//       "updatedAt": FieldValue.serverTimestamp(),
//     });

//     print("✅ تم تحديث العنصر بنجاح: ${doc.id}");
//   }

//   static Future<void> uploadImage(
//       String epcHex, Map<String, dynamic> updates) async {
//     final cleanEpc = epcHex.trim().toUpperCase();
//     print("🛠️ محاولة تحديث العنصر برقم: $cleanEpc");

// // 🔹 البحث بالنظام الجديد
//     var q =
//         await itemsCol().where("epcHex", isEqualTo: cleanEpc).limit(1).get();

//     print("📄 نتائج البحث في epcHex: ${q.docs.length}");

// // 🔹 لو مفيش نتيجة، ابحث بالنظام القديم (ENTRE)
//     if (q.docs.isEmpty) {
//       q = await itemsCol()
//           .where("epcHex", isEqualTo: "${cleanEpc}ENTRE")
//           .limit(1)
//           .get();

//       print("📄 نتائج البحث في epcHex القديم: ${q.docs.length}");

//       // Migration تلقائي
//       if (q.docs.isNotEmpty) {
//         await itemsCol().doc(q.docs.first.id).update({
//           "epcHex": cleanEpc,
//         });
//       }
//     }

//     // 🔹 لو مفيش نتيجة، ابحث في payload.qrCode
//     if (q.docs.isEmpty) {
//       q = await itemsCol()
//           .where("payload.qrCode", isEqualTo: cleanEpc)
//           .limit(1)
//           .get();

//       print("📄 نتائج البحث في payload.qrCode: ${q.docs.length}");
//     }

//     // 🔹 لو مفيش أي نتيجة
//     if (q.docs.isEmpty) {
//       throw Exception("⚠️ العنصر غير موجود في قاعدة البيانات!");
//     }

//     // 🔹 تحديث العنصر
//     final doc = q.docs.first;
//     await itemsCol().doc(doc.id).update({
//       ...updates,
//     });

//     print("✅ تم تحديث العنصر بنجاح: ${doc.id}");
//   }

//   static Future<Map<String, dynamic>?> findItemByEpc(String epcHex,
//       {bool includeBalances = false}) async {
//     final epc = epcHex.toUpperCase();
//     print("🔎 البحث عن: $epcHex");

//     var q = await itemsCol().where('epcHex', isEqualTo: epc).limit(1).get();
//     print("📄 عدد النتائج في items.epcHex: ${q.docs.length}");

// // البحث بالنظام القديم
//     if (q.docs.isEmpty) {
//       q = await itemsCol()
//           .where('epcHex', isEqualTo: "${epc}ENTRE")
//           .limit(1)
//           .get();

//       print("📄 عدد النتائج في items.epcHex القديم: ${q.docs.length}");
//       // Migration تلقائي
//       if (q.docs.isNotEmpty) {
//         await itemsCol().doc(q.docs.first.id).update({
//           "epcHex": epc,
//         });
//       }
//     }

//     if (q.docs.isEmpty) {
//       q = await itemsCol()
//           .where('payload.qrCode', isEqualTo: epcHex)
//           .limit(1)
//           .get();
//       print("📄 عدد النتائج في items.payload.qrCode: ${q.docs.length}");
//     }

//     bool foundInBalances = false;
//     if (q.docs.isEmpty && includeBalances) {
//       q = await balancesCol().where('epcHex', isEqualTo: epc).limit(1).get();
//       print("📄 عدد النتائج في balances.epcHex: ${q.docs.length}");

//       if (q.docs.isEmpty) {
//         q = await balancesCol()
//             .where('epcHex', isEqualTo: "${epc}ENTRE")
//             .limit(1)
//             .get();

//         print("📄 عدد النتائج في balances.epcHex القديم: ${q.docs.length}");
//         // Migration تلقائي
//         if (q.docs.isNotEmpty) {
//           await balancesCol().doc(q.docs.first.id).update({
//             "epcHex": epc,
//           });
//         }
//       }
//       if (q.docs.isEmpty) {
//         q = await balancesCol()
//             .where('payload.qrCode', isEqualTo: epcHex)
//             .limit(1)
//             .get();
//         print("📄 عدد النتائج في balances.payload.qrCode: ${q.docs.length}");
//       }
//       foundInBalances = q.docs.isNotEmpty;
//     }

//     if (q.docs.isEmpty) {
//       print("❌ مفيش نتيجة");
//       return null;
//     }

//     final d = q.docs.first;
//     print("✅ تم العثور على العنصر: ${d.id}");
//     return {
//       'id': d.id,
//       'collection': foundInBalances ? 'balances' : 'items',
//       ...d.data() as Map<String, dynamic>
//     };
//   }

//   static Future<Map<String, dynamic>?> epcandcode(String epcHex) async {
//     final epc = epcHex.toUpperCase();
//     print("🔎 البحث عن: $epc");

//     QuerySnapshot q =
//         await itemsCol().where('epcHex', isEqualTo: epc).limit(1).get();

//     print("📄 عدد النتائج في items.epcHex: ${q.docs.length}");

//     if (q.docs.isEmpty) {
//       q = await itemsCol()
//           .where('epcHex', isEqualTo: "${epc}ENTRE")
//           .limit(1)
//           .get();

//       print("📄 عدد النتائج في items.epcHex القديم: ${q.docs.length}");
//     }

//     if (q.docs.isEmpty) {
//       q = await itemsCol()
//           .where('payload.qrCode', isEqualTo: epcHex)
//           .limit(1)
//           .get();
//       print("📄 عدد النتائج في items.payload.qrCode: ${q.docs.length}");
//     }

//     if (q.docs.isEmpty) {
//       q = await balancesCol().where('epcHex', isEqualTo: epc).limit(1).get();

//       print("📄 عدد النتائج في balances.epcHex: ${q.docs.length}");
//     }

//     if (q.docs.isEmpty) {
//       q = await balancesCol()
//           .where('epcHex', isEqualTo: "${epc}ENTRE")
//           .limit(1)
//           .get();

//       print("📄 عدد النتائج في balances.epcHex القديم: ${q.docs.length}");
//     }

//     if (q.docs.isEmpty) {
//       q = await balancesCol()
//           .where('payload.qrCode', isEqualTo: epcHex)
//           .limit(1)
//           .get();
//       print("📄 عدد النتائج في balances.payload.qrCode: ${q.docs.length}");
//     }

//     if (q.docs.isEmpty) {
//       print("❌ مفيش نتيجة");
//       return null;
//     }

//     final d = q.docs.first;
//     final data = d.data() as Map<String, dynamic>;
//     final payload = data['payload'] as Map<String, dynamic>?;

//     return {
//       'id': d.id,
//       'epcHex': data['epcHex'],
//       'qrCode': payload?['qrCode'],
//       'collection': d.reference.parent.id,
//     };
//   }

//   static Future<List<Map<String, dynamic>>> getAllEpcAndQr() async {
//     print("📦 جلب كل الشرائح...");

//     final QuerySnapshot q = await itemsCol().get();

//     print("📄 عدد الشرائح: ${q.docs.length}");

//     return q.docs.map((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       final payload = data['payload'] as Map<String, dynamic>?;

//       return {
//         'id': doc.id,
//         'qrCode': payload?['qrCode'],
//         ...data,
//       };
//     }).toList();
//   }

//   static Future<void> upsertInventory(
//       String epcHex, Map<String, dynamic>? itemData) async {
//     final now = FieldValue.serverTimestamp();

//     // لو العنصر مش موجود في items أصلاً
//     if (itemData == null) {
//       final existingInv =
//           await invCol().where('epcHex', isEqualTo: epcHex).limit(1).get();
//       if (existingInv.docs.isEmpty) {
//         await invCol().add({
//           'epcHex': epcHex,
//           'itemId': null,
//           'firstSeenAt': now,
//           //'lastSeenAt': now,
//           'scanCount': 1,
//         });
//       } else {
//         final doc = existingInv.docs.first;
//         final currentCount =
//             (doc.data() as Map<String, dynamic>)['scanCount'] ?? 1;
//         await invCol().doc(doc.id).update({
//           //'lastSeenAt': now,
//           'scanCount': currentCount + 1,
//         });
//       }
//     } else {
//       final itemId = itemData['id'];
//       final category = itemData['category'];
//       final payload = itemData['payload'];

//       final q =
//           await invCol().where('itemId', isEqualTo: itemId).limit(1).get();
//       if (q.docs.isEmpty) {
//         await invCol().add({
//           'epcHex': epcHex,
//           'itemId': itemId,
//           'category': category, // ✅ تخزين النوع
//           'payload': payload, // ✅ تخزين التفاصيل
//           'firstSeenAt': now,
//           'lastSeenAt': now,
//           'scanCount': 1,
//           'createdAt': now,
//         });
//       } else {
//         final doc = q.docs.first;
//         final currentCount =
//             (doc.data() as Map<String, dynamic>)['scanCount'] ?? 1;
//         await invCol().doc(doc.id).update({
//           'lastSeenAt': now,
//           'scanCount': currentCount + 1,
//           'category': category, // ✅ تحديث النوع
//           'payload': payload, // ✅ تحديث التفاصيل
//         });
//       }
//     }
//   }

//   /*static Future<void> deleteItem(String epcHex) async {
//     final d = await findItemByEpc(epcHex);
//     if (d == null) return;
//     final itemRef = itemsCol().doc(d['id']);
//     await itemRef.delete();
//   }*/
//   static Future<void> deleteItem(String epcHex) async {
//     final d = await findItemByEpc(epcHex);
//     if (d == null) return;

//     final itemRef = itemsCol().doc(d['id']);
//     final deletedRef = deletedItemsCol().doc(d['id']);

//     final data = Map<String, dynamic>.from(d);
//     await deleteItemImages(epcHex);

//     data.remove('id');
//     data.remove('collection');
//     data['deletedAt'] = FieldValue.serverTimestamp();
//     data['originalDocId'] = d['id'];

//     await _db.runTransaction((transaction) async {
//       transaction.set(deletedRef, data);
//       transaction.delete(itemRef);
//     });
//   }

//   static Future<void> deleteItemImages(String epc) async {
//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;
//       final cleanEpc = epc.toUpperCase();

//       // 🔹 جرب الفولدر الجديد أولاً
//       Reference sourceFolder = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child(cleanEpc);

//       ListResult result = await sourceFolder.listAll();

//       // 🔹 لو مفيش صور، جرب الفولدر القديم (ENTRE)
//       if (result.items.isEmpty) {
//         sourceFolder = FirebaseStorage.instance
//             .ref()
//             .child('images')
//             .child('users')
//             .child(uid)
//             .child("${cleanEpc}ENTRE");

//         result = await sourceFolder.listAll();
//       }

//       // 🔹 فولدر المحذوفات (دائماً بالنظام الجديد)
//       final deletedFolder = FirebaseStorage.instance
//           .ref()
//           .child('images')
//           .child('users')
//           .child(uid)
//           .child('deleted')
//           .child(cleanEpc);

//       if (result.items.isEmpty) {
//         print('ℹ️ لا توجد صور للشريحة $cleanEpc');
//         return;
//       }

//       print('📦 نسخ ${result.items.length} صورة إلى مجلد المحذوفات');

//       for (Reference sourceRef in result.items) {
//         try {
//           // تحميل الصورة
//           final Uint8List? bytes = await sourceRef.getData();

//           if (bytes == null) {
//             print('❌ لم يتم تحميل ${sourceRef.name}');
//             continue;
//           }

//           // إنشاء الملف الجديد بنفس الاسم
//           final destRef = deletedFolder.child(sourceRef.name);

//           // نسخ الصورة
//           await destRef.putData(bytes);
//           print('✅ تم نسخ ${sourceRef.name}');

//           // حذف الأصل بعد نجاح النسخ
//           await sourceRef.delete();
//           print('🗑️ تم حذف ${sourceRef.name}');
//         } catch (e) {
//           print('❌ خطأ مع ${sourceRef.name}: $e');
//         }
//       }

//       print('✅ انتهت عملية النسخ والحذف');
//     } catch (e) {
//       print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
//     }
//   }

//   static Future<void> sellItem(
//     String epcHex, {
//     String? saleGroupId,
//     Map<String, dynamic>? paymentData,
//     bool partialSale = false,
//     List<String>? soldComponents,
//     double? weightSold,
//     double? wageSold,
//   }) async {
//     final groupId =
//         saleGroupId ?? DateTime.now().millisecondsSinceEpoch.toString();
//     final d = await findItemByEpc(epcHex, includeBalances: true);
//     if (d == null) return;

//     final itemCollection =
//         d['collection'] == 'balances' ? balancesCol() : itemsCol();
//     final itemRef = itemCollection.doc(d['id']);
//     final docSnap = await itemRef.get();
//     if (!docSnap.exists) return;

//     final itemData = docSnap.data() as Map<String, dynamic>;
//     final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
//     final currentWeight = (payload['weight'] ?? 0).toDouble();
//     final currentWage = (payload['wage'] ?? 0).toDouble();

//     /// لو بيع جزئي
//     if (partialSale == true) {
//       // حساب الوزن والأجر الجديد بعد الخصم
//       final newWeight = currentWeight - (weightSold ?? 0);
//       final newWage = currentWage - (wageSold ?? 0);

//       // تحديث مكونات الطقم
//       final updatedComponents =
//           List<String>.from(payload['setComponents'] ?? []);
//       if (soldComponents != null && soldComponents.isNotEmpty) {
//         updatedComponents.removeWhere((c) => soldComponents.contains(c));
//       }

//       // تجهيز بيانات البيع الجزئي للسجل
//       final saleData = {
//         'itemId': d['id'],
//         'epcHex': d['epcHex'],
//         'saleGroupId': groupId,
//         'soldAt': FieldValue.serverTimestamp(),
//         'category': d['category'],
//         'partialSale': true,
//         'payload': {
//           ...payload,
//           'weight': weightSold,
//           'wage': wageSold,
//           'setComponents': soldComponents ?? [],
//         },
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       if (paymentData != null) {
//         saleData['payment'] = paymentData;
//       }

//       await salesCol().add(saleData);
//       await salesHistoryCol().add(saleData);

//       // إنشاء رصيد لباقي الطقم في كولكشن جديد خاص ببقايا الأطقم
//       final hasRemaining = newWeight > 0 || updatedComponents.isNotEmpty;
//       if (hasRemaining) {
//         await setRemaindersCol().add({
//           'userId': uid,
//           'originalItemId': d['id'],
//           'originalEpcHex': d['epcHex'],
//           'epcHex': d['epcHex'],
//           'category': d['category'],
//           'payload': {
//             ...payload,
//             'weight': newWeight,
//             'wage': newWage,
//             'setComponents': updatedComponents,
//             'originalWeight': currentWeight,
//             'originalWage': currentWage,
//             'soldWeight': weightSold,
//             'soldWage': wageSold,
//           },
//           'remainderType': 'partialSaleRemainder',
//           'source': 'partialSale',
//           'soldComponents': soldComponents ?? [],
//           'remainingComponents': updatedComponents,
//           'createdAt': FieldValue.serverTimestamp(),
//           'updatedAt': FieldValue.serverTimestamp(),
//         });
//       }

//       // حذف الطقم الأصلي
//       await itemRef.delete();
//     } else {
//       /// البيع الكامل (زي النظام القديم)
//       await itemRef.delete();

//       final saleData = {
//         'itemId': d['id'],
//         'epcHex': d['epcHex'],
//         'saleGroupId': groupId,
//         'soldAt': FieldValue.serverTimestamp(),
//         'category': d['category'],
//         'payload': d['payload'],
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       if (paymentData != null) {
//         saleData['payment'] = paymentData;
//       }

//       await salesCol().add(saleData);
//       await salesHistoryCol().add(saleData);
//     }
//   }

//   /// ✅ دالة للتحقق من وجود العنصر قبل الإدخال
//   static Future<bool> checkItemExists(String epcHex) async {
//     final cleanEpc = epcHex.trim().toUpperCase();

//     // items - النظام الجديد
//     var q =
//         await itemsCol().where('epcHex', isEqualTo: cleanEpc).limit(1).get();
//     if (q.docs.isNotEmpty) return true;

//     // items - النظام القديم
//     q = await itemsCol()
//         .where('epcHex', isEqualTo: '${cleanEpc}ENTRE')
//         .limit(1)
//         .get();
//     if (q.docs.isNotEmpty) return true;

//     // balances - النظام الجديد
//     q = await balancesCol().where('epcHex', isEqualTo: cleanEpc).limit(1).get();
//     if (q.docs.isNotEmpty) return true;

//     // balances - النظام القديم
//     q = await balancesCol()
//         .where('epcHex', isEqualTo: '${cleanEpc}ENTRE')
//         .limit(1)
//         .get();
//     if (q.docs.isNotEmpty) return true;

//     q = await itemsCol()
//         .where('payload.qrCode', isEqualTo: cleanEpc)
//         .limit(1)
//         .get();
//     if (q.docs.isNotEmpty) return true;

//     q = await balancesCol()
//         .where('payload.qrCode', isEqualTo: cleanEpc)
//         .limit(1)
//         .get();
//     return q.docs.isNotEmpty;
//   }

//   /// =========================
//   /// 🔵 دوال خاصة بالمرتجعات (Returns)
//   /// =========================

//   /// ✅ جلب عمليات البيع المسجلة خلال آخر [days] أيام (افتراضيًا 3 أيام)
//   static Future<List<Map<String, dynamic>>> getRecentSales(
//       {int days = 3}) async {
//     final cutoff = DateTime.now().subtract(Duration(days: days));
//     final q = await salesCol()
//         .where('soldAt', isGreaterThanOrEqualTo: Timestamp.fromDate(cutoff))
//         .orderBy('soldAt', descending: true)
//         .get();

//     return q.docs.map((d) {
//       final data = Map<String, dynamic>.from(d.data() as Map<String, dynamic>);
//       data['id'] = d.id;
//       return data;
//     }).toList();
//   }

//   /// ✅ حذف سجل بيع معين (يُستخدم بعد استرجاع القطعة وإعادة تسجيلها)
//   static Future<void> deleteSale(String saleId) async {
//     await salesCol().doc(saleId).delete();
//   }

//   /// =========================
//   /// 🟡 دوال خاصة بالكسر (Scrap)
//   /// =========================

//   /// ✅ تسجيل عملية إضافة كسر
//   static Future<void> saveScrapAdd(Map<String, dynamic> data) async {
//     await scrapCol().add({
//       ...data,
//       "person": data["person"],
//       "carat": data["carat"],
//       "notes": data["notes"],
//       "date": Timestamp.fromDate(data["date"]),
//       "type": "add",
//       "createdAt": FieldValue.serverTimestamp(),
//     });
//   }

//   /// ✅ تسجيل عملية بيع كسر
//   static Future<void> saveScrapSale(Map<String, dynamic> data) async {
//     await scrapCol().add({
//       ...data,
//       "person": data["person"],
//       "carat": data["carat"],
//       "notes": data["notes"],
//       "date": Timestamp.fromDate(data["date"]),
//       "type": "sale",
//       "createdAt": FieldValue.serverTimestamp(),
//     });
//   }

//   /// ✅ تسجيل عملية تحويل كسر
//   static Future<void> saveScrapTransform(Map<String, dynamic> data) async {
//     await scrapCol().add({
//       ...data,
//       "person": data["person"],
//       "toPerson": data["toPerson"],
//       "carat": data["carat"],
//       "toCarat": data["toCarat"],
//       "notes": data["notes"] ?? "",
//       "date": Timestamp.fromDate(data["date"]),
//       "type": data["type"] ?? "transform",
//       "direction": data["direction"] ?? "out",
//       "createdAt": FieldValue.serverTimestamp(),
//     });
//   }

//   /// ✅ إرجاع كل المعاملات الخاصة بشخص
//   static Future<List<Map<String, dynamic>>> getScrapTransactions(
//       String name) async {
//     final q = await scrapCol().where("person", isEqualTo: name.trim()).get();

//     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
//   }

//   /// ✅ جلب معاملات شخص معين وعيار معين
//   static Future<List<Map<String, dynamic>>>
//       getScrapTransactionsByPersonAndCarat(
//     String person,
//     String carat,
//   ) async {
//     final q = await scrapCol()
//         .where("person", isEqualTo: person.trim())
//         .where("carat", isEqualTo: carat)
//         .get();

//     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
//   }

//   /// ✅ جلب معاملات عيار معين (للتحقق من الرصيد)
//   static Future<List<Map<String, dynamic>>> getScrapTransactionsByCarat(
//     String carat,
//   ) async {
//     final q = await scrapCol().where("carat", isEqualTo: carat).get();

//     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
//   }

//   /// ✅ جلب رصيد شخص معين (كل العيارات)
//   static Future<double> getPersonBalance(String person) async {
//     final q = await scrapCol().where("person", isEqualTo: person.trim()).get();

//     double balance = 0;
//     for (var doc in q.docs) {
//       final data = doc.data() as Map<String, dynamic>;
//       final type = data["type"] ?? "";
//       final weight = (data["weight"] ?? 0).toDouble();

//       if (type == "add" || type == "transform") {
//         balance += weight;
//       } else if (type == "sale" || type == "payment") {
//         balance -= weight.abs();
//       }
//     }
//     return balance;
//   }

//   /// ✅ جلب رصيد شخص معين لعيار محدد
//   static Future<double> getPersonBalanceByCarat(
//       String person, String carat) async {
//     final q = await scrapCol()
//         .where("person", isEqualTo: person.trim())
//         .where("carat", isEqualTo: carat)
//         .get();

//     double balance = 0;
//     for (var doc in q.docs) {
//       final data = doc.data() as Map<String, dynamic>;
//       final type = data["type"] ?? "";
//       final weight = (data["weight"] ?? 0).toDouble();

//       if (type == "add" || type == "transform") {
//         balance += weight;
//       } else if (type == "sale" || type == "payment") {
//         balance -= weight.abs();
//       }
//     }
//     return balance;
//   }

//   /// ✅ جلب كل المعاملات لشخص معين مع فلترة حسب النوع
//   static Future<List<Map<String, dynamic>>> getScrapTransactionsByType(
//     String person,
//     String type,
//   ) async {
//     final q = await scrapCol()
//         .where("person", isEqualTo: person.trim())
//         .where("type", isEqualTo: type)
//         .get();

//     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
//   }

//   /// ✅ جلب المعاملات في نطاق تاريخي
//   static Future<List<Map<String, dynamic>>> getScrapTransactionsByDateRange(
//     DateTime startDate,
//     DateTime endDate,
//   ) async {
//     final q = await scrapCol()
//         .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
//         .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
//         .orderBy("date", descending: true)
//         .get();

//     return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
//   }

//   /// ✅ حذف معاملة كسر معينة
//   static Future<void> deleteScrapTransaction(String docId) async {
//     await scrapCol().doc(docId).delete();
//   }

//   /// ✅ تحديث معاملة كسر
//   static Future<void> updateScrapTransaction(
//     String docId,
//     Map<String, dynamic> data,
//   ) async {
//     await scrapCol().doc(docId).update({
//       ...data,
//       "updatedAt": FieldValue.serverTimestamp(),
//     });
//   }

//   /// ✅ إرجاع أسماء الأشخاص (distinct)
//   static Future<List<String>> getScrapPersons() async {
//     final q = await scrapCol().get();
//     final all = q.docs
//         .map((d) => d['person'])
//         .where((n) => n != null && n.toString().trim().isNotEmpty)
//         .toList();

//     return all.map((e) => e.toString().trim()).toSet().toList();
//   }

//   // تحديث الاسم في كل المعاملات
//   static Future<void> updateScrapPerson(String oldName, String newName) async {
//     final userDoc = _db.collection("users").doc(uid);

//     // كل الكولكشن بتاع scrapTransactions
//     final q = await userDoc
//         .collection("scrapTransactions")
//         .where("person", isEqualTo: oldName)
//         .get();

//     for (var doc in q.docs) {
//       await doc.reference.update({"person": newName});
//     }
//   }

//   // حذف كل معاملات الشخص
//   // 🔹 حذف شخص ومعاملاته
//   static Future<void> deleteScrapPerson(String name) async {
//     final q = await scrapCol().where("person", isEqualTo: name.trim()).get();

//     for (var doc in q.docs) {
//       await doc.reference.delete();
//     }
//   }

//   static Stream<List<String>> scrapPersonsStream() {
//     return _db
//         .collection("users")
//         .doc(uid)
//         .collection("scrapTransactions")
//         .snapshots()
//         .map((snapshot) {
//       final names = snapshot.docs
//           .map((d) => d.data()["person"] as String?)
//           .where((p) => p != null && p.isNotEmpty)
//           .map((p) => p!) // نرجعها String مش nullable
//           .toSet()
//           .toList();
//       names.sort();
//       return names;
//     });
//   }

//   static Stream<List<Map<String, dynamic>>> scrapTransactionsStream() {
//     return scrapCol().snapshots().map((snap) {
//       return snap.docs.map((d) {
//         final data = d.data() as Map<String, dynamic>;
//         data["id"] = d.id;
//         return data;
//       }).toList();
//     });
//   }

//   /// ✅ جلب إحصائيات الكسر (ملخص عام)
//   static Future<Map<String, dynamic>> getScrapStatistics() async {
//     final q = await scrapCol().get();

//     Map<String, dynamic> stats = {
//       "totalAdd": 0.0,
//       "totalSale": 0.0,
//       "totalPayment": 0.0,
//       "totalTransform": 0.0,
//       "byCarat": {
//         "14": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
//         "18": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
//         "21": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
//         "22": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
//         "24": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
//       }
//     };

//     for (var doc in q.docs) {
//       final data = doc.data() as Map<String, dynamic>;
//       final type = data["type"] ?? "";
//       final carat = (data["carat"] ?? "18").toString();
//       final weight = (data["weight"] ?? 0).toDouble();

//       if (type == "add") {
//         stats["totalAdd"] = (stats["totalAdd"] ?? 0.0) + weight;
//         if (stats["byCarat"][carat] != null) {
//           stats["byCarat"][carat]["add"] =
//               (stats["byCarat"][carat]["add"] ?? 0.0) + weight;
//         }
//       } else if (type == "sale") {
//         stats["totalSale"] = (stats["totalSale"] ?? 0.0) + weight.abs();
//         if (stats["byCarat"][carat] != null) {
//           stats["byCarat"][carat]["sale"] =
//               (stats["byCarat"][carat]["sale"] ?? 0.0) + weight.abs();
//         }
//       } else if (type == "payment") {
//         stats["totalPayment"] = (stats["totalPayment"] ?? 0.0) + weight.abs();
//         if (stats["byCarat"][carat] != null) {
//           stats["byCarat"][carat]["payment"] =
//               (stats["byCarat"][carat]["payment"] ?? 0.0) + weight.abs();
//         }
//       } else if (type == "transform") {
//         stats["totalTransform"] = (stats["totalTransform"] ?? 0.0) + weight;
//         if (stats["byCarat"][carat] != null) {
//           stats["byCarat"][carat]["transform"] =
//               (stats["byCarat"][carat]["transform"] ?? 0.0) + weight;
//         }
//       }
//     }

//     return stats;
//   }

//   /// 🟢 كولكشن الموردين
//   /// 🟢 إضافة مورد جديد
//   static Future<void> addSupplier({
//     required String name,
//     required List<String> delegates,
//     required String phone,
//   }) async {
//     await suppliersCol().add({
//       "name": name,
//       "delegates": delegates,
//       "phone": phone,
//       "createdAt": FieldValue.serverTimestamp(),
//     });
//   }

//   /// 🟢 جلب الموردين
//   static Future<List<Map<String, dynamic>>> getSuppliers() async {
//     final q = await suppliersCol().get();
//     return q.docs
//         .map((d) => {"id": d.id, ...d.data() as Map<String, dynamic>})
//         .toList();
//   }

//   /// 🟢 كولكشن سندات
//   /// 🟢 إضافة سند قبض (معدل لدعم العيارات المتعددة)
//   static Future<void> addReceiptVoucher({
//     required String supplierId,
//     required String supplierName,
//     required String delegate,
//     required String carat,
//     required double weight,
//     required double wage,
//     required DateTime date,
//     List<Map<String, dynamic>>? carats, // ✅ إضافة معامل العيارات المتعددة
//   }) async {
//     await vouchersCol().add({
//       "supplierId": supplierId,
//       "supplierName": supplierName,
//       "delegate": delegate,
//       "carat": carat,
//       "weight": weight,
//       "wage": wage,
//       "type": "receipt",
//       "date": Timestamp.fromDate(date),
//       "createdAt": FieldValue.serverTimestamp(),
//       "carats": carats ?? [], // ✅ إضافة حقل العيارات المتعددة
//     });
//   }

//   /// 🟢 إضافة سند صرف (معدل لدعم العيارات المتعددة)
//   static Future<void> addPaymentVoucher({
//     required String supplierId,
//     required String supplierName,
//     required String delegate,
//     required String carat,
//     required double weight,
//     required double wage,
//     required String paymentMethod, // "كاش" أو "شبكة" أو "متعدد"
//     required double? cash,
//     required double? network,
//     required DateTime date,
//     List<Map<String, dynamic>>? carats, // ✅ إضافة معامل العيارات المتعددة
//   }) async {
//     await vouchersCol().add({
//       "supplierId": supplierId,
//       "supplierName": supplierName,
//       "delegate": delegate,
//       "carat": carat,
//       "weight": weight,
//       "wage": wage,
//       "type": "payment",
//       "paymentMethod": paymentMethod,
//       "cash": cash,
//       "network": network,
//       "total": (cash ?? 0) + (network ?? 0),
//       "date": Timestamp.fromDate(date),
//       "createdAt": FieldValue.serverTimestamp(),
//       "carats": carats ?? [], // ✅ إضافة حقل العيارات المتعددة
//     });
//     await scrapCol().add({
//       "supplierId": supplierId,
//       "person": supplierName,
//       "carat": carat,
//       "weight": weight,
//       "wage": wage,
//       "date": Timestamp.fromDate(date),
//       "type": "payment",
//       "createdAt": FieldValue.serverTimestamp(),
//     });
//   }

//   /// 🟢 جلب السندات لمورد
//   static Future<List<Map<String, dynamic>>> getVouchersForSupplier(
//       String supplierId) async {
//     final q =
//         await vouchersCol().where("supplierId", isEqualTo: supplierId).get();
//     return q.docs
//         .map((d) => {"id": d.id, ...d.data() as Map<String, dynamic>})
//         .toList();
//   }

//   // داخل كلاس FS
//   static Future<void> updateSupplier(
//       String id, Map<String, dynamic> data) async {
//     await suppliersCol().doc(id).update({
//       ...data,
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   static Future<void> deleteSupplier(String id) async {
//     await suppliersCol().doc(id).delete();
//   }

//   static Stream<List<Map<String, dynamic>>> suppliersStream() {
//     return suppliersCol()
//         .orderBy('name') // أو حسب التاريخ لو عايز
//         .snapshots()
//         .map((snap) => snap.docs
//             .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
//             .toList());
//   }

//   /// ==============================
//   /// 💰 دوال المصروفات (Expenses)
//   /// ==============================

//   /// 🔹 إضافة مصروف جديد
//   static Future<void> addExpense({
//     required String type,
//     required double amount,
//     required DateTime date,
//     String? note,
//   }) async {
//     await expensesCol().add({
//       'type': type,
//       'amount': amount,
//       'note': note ?? '',
//       'date': Timestamp.fromDate(date),
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   /// 🔹 تعديل مصروف موجود
//   static Future<void> updateExpense(
//       String id, Map<String, dynamic> data) async {
//     await expensesCol().doc(id).update({
//       ...data,
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   /// 🔹 حذف مصروف
//   static Future<void> deleteExpense(String id) async {
//     await expensesCol().doc(id).delete();
//   }

//   /// 🔹 جلب كل المصروفات
//   static Stream<List<Map<String, dynamic>>> expensesStream({
//     String? typeFilter,
//     DateTimeRange? dateRange,
//   }) {
//     Query query = expensesCol().orderBy('date', descending: true);

//     if (typeFilter != null && typeFilter.isNotEmpty) {
//       query = query.where('type', isEqualTo: typeFilter);
//     }

//     if (dateRange != null) {
//       final start = DateTime(dateRange.start.year, dateRange.start.month,
//           dateRange.start.day, 0, 0, 0);
//       final end = DateTime(dateRange.end.year, dateRange.end.month,
//           dateRange.end.day, 23, 59, 59);

//       query = query
//           .where('date', isGreaterThanOrEqualTo: start)
//           .where('date', isLessThanOrEqualTo: end);
//     }

//     return query.snapshots().map((snap) {
//       return snap.docs.map((d) {
//         final data = d.data() as Map<String, dynamic>;
//         data['id'] = d.id;
//         return data;
//       }).toList();
//     });
//   }

//   static Future<List<String>> getExpenseTypes() async {
//     final snapshot = await expensesCol().get();

//     final allTypes = snapshot.docs
//         .map((d) => d['type']?.toString().trim() ?? '')
//         .where((t) => t.isNotEmpty)
//         .toSet()
//         .toList();

//     allTypes.sort(); // ترتيب أبجدي اختياري
//     return allTypes;
//   }

//   static Stream<List<String>> expenseTypesStream() {
//     return _db
//         .collection('users')
//         .doc(uid)
//         .collection('expenses')
//         .snapshots()
//         .map((snapshot) {
//       final all = snapshot.docs
//           .map((d) => d['type']?.toString().trim() ?? '')
//           .where((t) => t.isNotEmpty)
//           .toSet()
//           .toList();
//       all.sort();
//       return all;
//     });
//   }

//   static Stream<List<String>> soldByStream() {
//     return _db
//         .collection('users')
//         .doc(uid)
//         .collection('sales')
//         .snapshots()
//         .map((snapshot) {
//       final all = snapshot.docs
//           .map((d) {
//             final payment = d.data()['payment'];
//             if (payment is Map && payment['soldBy'] != null) {
//               return payment['soldBy'].toString().trim();
//             }
//             return '';
//           })
//           .where((s) => s.isNotEmpty)
//           .toSet()
//           .toList();

//       all.sort();
//       return all;
//     });
//   }

//   static Stream<List<Map<String, dynamic>>> salesStream({
//     String? soldByFilter,
//     DateTimeRange? dateRange,
//   }) {
//     return _db
//         .collection('users')
//         .doc(uid)
//         .collection('sales')
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((d) {
//         final data = d.data();
//         data['id'] = d.id;
//         return data;
//       }).where((s) {
//         // فلترة البائع
//         if (soldByFilter != null) {
//           final soldBy = s['payment']?['soldBy'];
//           if (soldBy != soldByFilter) return false;
//         }

//         // فلترة التاريخ
//         if (dateRange != null) {
//           final ts = s['soldAt'] as Timestamp?;
//           if (ts == null) return false;
//           final date = ts.toDate();
//           if (date.isBefore(dateRange.start) || date.isAfter(dateRange.end)) {
//             return false;
//           }
//         }

//         return true;
//       }).toList();
//     });
//   }

//   /// =========== فروع (Branches) =============

//   static Future<void> addBranch({
//     required String name,
//     required String uid,
//     required String address,
//     required String manager,
//     required String phone,
//     required List<String> delegates,
//     required DateTime date,
//   }) async {
//     await branchesCol().add({
//       'name': name,
//       'uid': uid,
//       'address': address,
//       'manager': manager,
//       'phone': phone,
//       'delegates': delegates,
//       'date': Timestamp.fromDate(date),
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }

//   static Future<void> updateBranch(String id, Map<String, dynamic> data) async {
//     await branchesCol().doc(id).update({
//       ...data,
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   static Future<void> deleteBranch(String id) async {
//     await branchesCol().doc(id).delete();
//   }

//   static Future<List<Map<String, dynamic>>> getBranches() async {
//     final q = await branchesCol().orderBy('name').get();
//     return q.docs
//         .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
//         .toList();
//   }

//   static Stream<List<Map<String, dynamic>>> branchesStream() {
//     return branchesCol().orderBy('name').snapshots().map((snap) => snap.docs
//         .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
//         .toList());
//   }

//   /// ============================
//   /// 🔄 دوال التحويل (Transform)
//   /// ============================

//   /// 🔹 تحويل صنف إلى كسر
//   static Future<void> transferToScrap(
//       Map<String, dynamic> itemData, String epcHex) async {
//     final now = FieldValue.serverTimestamp();

//     // 🔸 تجهيز البيانات
//     //final payload = itemData['payload'] ?? itemData;
//     final Map<String, dynamic> payload =
//         Map<String, dynamic>.from(itemData['payload'] ?? itemData);
//     final scrapData = {
//       "person": "تحويل",
//       "type": "transform",
//       "createdAt": now,
//       "date": now,
//       //"payload": payload,
//       ...payload,
//     };

//     // 🔸 تحديث حالة الصنف
//     try {
//       final d = await findItemByEpc(epcHex);
//       if (d == null) return;

//       // تحديث حالة القطعة -> مباعة
//       await itemsCol().doc(d['id']).delete();
//       await _db
//           .collection('users')
//           .doc(uid)
//           .collection('scrapTransactions')
//           .add(scrapData);
//     } catch (_) {}
//   }

//   /// 🔹 تحويل صنف إلى فرع
//   static Future<void> transferToBranch(
//       Map<String, dynamic> itemData,
//       String epcHex,
//       String branchId,
//       String branchName,
//       String repName,
//       String branchUid) async {
//     final now = FieldValue.serverTimestamp();
//     final payload = itemData['payload'] ?? itemData;
//     final category = itemData['category'] ?? '';

//     // 🔸 تجهيز بيانات التحويل
//     final transferData = {
//       'fromUId': uid,
//       'branchUid': branchUid,
//       "epcHex": epcHex,
//       "branchId": branchId,
//       "branchName": branchName,
//       "rep": repName,
//       "createdAt": now,
//       "date": now,
//       "payload": payload,
//       "category": category,
//       'status': 'pending',
//     };

//     // 🔸 حفظ العملية في كولكشن التحويلات
//     await _db
//         .collection('users')
//         .doc(uid)
//         .collection('branchTransfers')
//         .add(transferData);

//     /*// 🔸 تحديث حالة القطعة في items
//     try {
//       final d = await findItemByEpc(epcHex);
//       if (d == null) return;

//       // تحديث حالة القطعة -> مباعة
//       await itemsCol().doc(d['id']).delete();
//     } catch (_) {}*/

//     await _db
//         .collection('transferRequests')
//         .doc(branchUid)
//         .collection('branchTransfers')
//         .add(transferData);
//   }

//   static StreamSubscription? _transferListener;

//   static void listenToTransferUpdates() {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     // نلغي أي listener سابق
//     _transferListener?.cancel();

//     // stream على branchTransfers عند المرسل
//     final userTransfersRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('branchTransfers')
//         .where('status', isEqualTo: 'pending');

//     _transferListener = userTransfersRef.snapshots().listen((snapshot) async {
//       print(
//           "✅Transfer listener triggered: ${snapshot.docs.length} pending items");
//       for (var docChange in snapshot.docChanges) {
//         final doc = docChange.doc;
//         final data = doc.data();
//         if (data == null) continue;

//         final branchUid = data['branchUid'];
//         final epcHex = data['epcHex'];
//         if (branchUid == null || epcHex == null) continue;

//         final targetTransfersRef = FirebaseFirestore.instance
//             .collection('transferRequests')
//             .doc(branchUid)
//             .collection('branchTransfers');

//         final targetSnapshot =
//             await targetTransfersRef.where('epcHex', isEqualTo: epcHex).get();

//         if (targetSnapshot.docs.isEmpty) continue;

//         final targetStatus = targetSnapshot.docs.first.data()['status'];
//         final targetDoc = targetSnapshot.docs.first;

//         if (targetStatus == 'accepted') {
//           // حذف من items عند المرسل
//           final itemsSnapshot = await FirebaseFirestore.instance
//               .collection('users')
//               .doc(uid)
//               .collection('items')
//               .where('epcHex', isEqualTo: epcHex)
//               .get();

//           for (var itemDoc in itemsSnapshot.docs) {
//             await itemDoc.reference.delete();
//           }

//           // حذف من branchTransfers عند المرسل
//           //await doc.reference.delete();
//           await doc.reference.update({'status': 'accepted'});
//           await targetDoc.reference.delete();
//         } else if (targetStatus == 'rejected') {
//           // حذف من branchTransfers عند المرسل فقط
//           await doc.reference.delete();
//           await targetDoc.reference.delete();
//         }
//       }
//     });
//   }

//   /// لإيقاف الاستماع عند إغلاق الصفحة أو الخروج
//   static void cancelTransferListener() {
//     _transferListener?.cancel();
//     _transferListener = null;
//   }

//   static StreamSubscription? _transferSubscription;
//   static bool _isDialogOpen = false;

//   static void listenForTransfers(BuildContext context) {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;

//     _transferSubscription?.cancel();

//     _transferSubscription = FirebaseFirestore.instance
//         .collection('transferRequests')
//         .doc(uid)
//         .collection('branchTransfers')
//         .where('status', isEqualTo: 'pending')
//         .snapshots()
//         .listen((snapshot) {
//       // 🔴 لو مفيش شرائح
//       if (snapshot.docs.isEmpty) {
//         if (_isDialogOpen) {
//           Navigator.of(context, rootNavigator: true).pop();
//           _isDialogOpen = false;
//         }
//         return;
//       }

//       // 🟢 لو فيه شرائح والديلوج مش مفتوح
//       if (!_isDialogOpen) {
//         _isDialogOpen = true;
//         _showTransfersDialog(context, snapshot.docs);
//       }
//     });
//   }

//   static void stopListening() {
//     _transferSubscription?.cancel();
//   }

//   static void _showTransfersDialog(
//     BuildContext context,
//     List<QueryDocumentSnapshot> docs,
//   ) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return Directionality(
//           textDirection: TextDirection.rtl,
//           child: AlertDialog(
//             title: const Text("وصلك تحويلات جديدة"),
//             content: SizedBox(
//               width: double.maxFinite,
//               height: 400,
//               child: ListView.builder(
//                 itemCount: docs.length,
//                 itemBuilder: (context, index) {
//                   final doc = docs[index];
//                   final data = doc.data() as Map<String, dynamic>;
//                   final payload = data['payload'] as Map<String, dynamic>?;

//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("الفرع: ${data['branchName']}"),
//                           Text("المندوب: ${data['rep']}"),
//                           Text("رقم الشريحة: ${data['epcHex']}"),
//                           Text("التصنيف: ${data['category']}"),
//                           if (payload?["carat"] != null)
//                             Text("العيار: ${payload?['carat']}"),
//                           if (payload?["weight"] != null)
//                             Text("الوزن: ${payload?['weight']}"),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   foregroundColor: Colors.white,
//                                 ),
//                                 onPressed: () async {
//                                   await acceptTransfer(data, doc.id);
//                                 },
//                                 child: const Text("قبول"),
//                               ),
//                               const SizedBox(width: 20),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                   foregroundColor: Colors.white,
//                                 ),
//                                 onPressed: () async {
//                                   await rejectTransfer(doc.id);
//                                 },
//                                 child: const Text("رفض"),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     ).then((_) {
//       _isDialogOpen = false;
//     });
//   }

//   static Future<void> acceptTransfer(
//       Map<String, dynamic> data, String docId) async {
//     final uid = FirebaseAuth.instance.currentUser!.uid;

//     // 🔹 حفظ القطعة في itemsCol
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(uid)
//         .collection('items')
//         .add(data);

//     // 🔹 تغيير الحالة
//     await FirebaseFirestore.instance
//         .collection('transferRequests')
//         .doc(uid)
//         .collection('branchTransfers')
//         .doc(docId)
//         .update({'status': 'accepted'});
//   }

//   static Future<void> rejectTransfer(String docId) async {
//     final uid = FirebaseAuth.instance.currentUser!.uid;

//     await FirebaseFirestore.instance
//         .collection('transferRequests')
//         .doc(uid)
//         .collection('branchTransfers')
//         .doc(docId)
//         .update({'status': 'rejected'});
//   }

//   /// 🔹 جلب المناديب الخاصة بفرع
//   static Future<List<String>> getRepsForBranch(String branchId) async {
//     final doc = await branchesCol().doc(branchId).get();
//     if (!doc.exists) return [];
//     final data = doc.data() as Map<String, dynamic>;
//     final reps = data["delegates"];
//     if (reps is List) {
//       return reps.map((e) => e.toString()).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> getGeneralBalance() async {
//     double gold18 = 0, gold21 = 0, gold22 = 0;
//     double barsWeight = 0;

//     int stonesCount = 0;
//     double stonesCost = 0;

//     double cash = 0;
//     double network = 0;

//     double scrapWeight = 0;

//     double creditor = 0; // دائن
//     double debtor = 0; // مدين
//     double supply = 0;

//     /// ================== الأصناف ==================
//     final itemsSnap = await itemsCol().get();
//     for (var d in itemsSnap.docs) {
//       final data = d.data() as Map<String, dynamic>;
//       final payload = Map<String, dynamic>.from(data['payload'] ?? {});
//       final weight = (payload['weight'] ?? 0).toDouble();
//       final carat = payload['carat'];

//       if (carat == 18) gold18 += weight;
//       if (carat == 21) gold21 += weight;
//       if (carat == 22) gold22 += weight;

//       stonesCount += (payload['stonesCount'] ?? 0) as int;
//       stonesCost += (payload['stonesCost'] ?? 0).toDouble();

//       if (data['category'] == 'bar') {
//         barsWeight += weight;
//       }
//     }

//     /// ================== المبيعات ==================
//     final salesSnap = await salesCol().get();
//     for (var d in salesSnap.docs) {
//       final pay = d['payment'];
//       if (pay != null) {
//         cash += (pay['cash'] ?? 0).toDouble();
//         network += (pay['network'] ?? 0).toDouble();
//       }
//     }

//     /// ================== الكسر ==================
//     final scrapSnap = await scrapCol().get();
//     for (var d in scrapSnap.docs) {
//       scrapWeight += (d['weight'] ?? 0).toDouble();
//     }

//     /// ================== السندات ==================
//     final vouchersSnap = await vouchersCol().get();
//     for (var d in vouchersSnap.docs) {
//       final weight = (d['weight'] ?? 0).toDouble();
//       if (d['type'] == 'receipt') {
//         creditor += weight;
//       } else if (d['type'] == 'payment') {
//         debtor += weight;
//       }
//     }

//     /// ================== التوريد ==================
//     final depSnap = await depositsCol().get();
//     for (var d in depSnap.docs) {
//       supply += (d['amount'] ?? 0).toDouble();
//     }

//     return {
//       "gold18": gold18,
//       "gold21": gold21,
//       "gold22": gold22,
//       "barsWeight": barsWeight,
//       "stonesCount": stonesCount,
//       "stonesCost": stonesCost,
//       "cash": cash,
//       "network": network,
//       "scrapWeight": scrapWeight,
//       "creditor": creditor,
//       "debtor": debtor,
//       "supply": supply,
//     };
//   }

//   /// ================== التعاملات ==================
//   static Future<void> sendToExternal({
//     required String epc,
//     required Map<String, dynamic> itemData,
//     required String shopName,
//     required String managerName,
//     required String sentBy,
//   }) async {
//     // تأكد إن الشريحة مش موجودة بالفعل
//     final existing = await externalCol().doc(epc).get();
//     if (existing.exists) {
//       throw Exception("هذه الشريحة موجودة بالفعل في التعاملات الخارجية");
//     }

//     await externalCol().doc(epc).set({
//       "epc": epc,
//       //"itemData": itemData,
//       ...itemData,
//       "shopName": shopName,
//       "managerName": managerName,
//       "sentBy": sentBy,
//       "sentAt": Timestamp.now(),
//       "status": "pending",
//     });
//   }

//   static Stream<QuerySnapshot> getExternalTransactions() {
//     return externalCol()
//         .where('status', isEqualTo: 'pending')
//         .orderBy('sentAt', descending: true)
//         .snapshots();
//   }

//   static Future<void> returnExternal(String epc) async {
//     await externalCol().doc(epc).delete();
//   }

//   static Future<void> receiveExternalPayment({
//     required String epc,
//     required Map<String, dynamic> paymentData,
//   }) async {
//     /*final doc = await externalCol().doc(epc).get();

//     if (!doc.exists) {
//       throw Exception("الشريحة غير موجودة");
//     }

//     final data = doc.data() as Map<String, dynamic>;

//     // حفظ في المبيعات
//     await salesCol().add({
//       ...data,
//       "paymentData": paymentData,
//       "soldAt": Timestamp.now(),
//       "saleType": "external",
//     });

//     // حذف من التعاملات الخارجية
//     await externalCol().doc(epc).delete();*/

//     /////////
//     final d = await findItemByEpc(epc);
//     if (d == null) return;

//     final itemRef = itemsCol().doc(d['id']);
//     final docSnap = await itemRef.get();
//     if (!docSnap.exists) return;

//     /*final itemData = docSnap.data() as Map<String, dynamic>;
//     final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
//     final currentWeight = (payload['weight'] ?? 0).toDouble();
//     final currentWage = (payload['wage'] ?? 0).toDouble();*/
//     await itemRef.delete();

//     final saleData = {
//       'itemId': d['id'],
//       'epcHex': d['epcHex'],
//       'soldAt': FieldValue.serverTimestamp(),
//       'category': d['category'],
//       'payload': d['payload'],
//       'createdAt': FieldValue.serverTimestamp(),
//     };

//     saleData['payment'] = paymentData;

//     await salesCol().add(saleData);
//     // حذف من التعاملات الخارجية
//     await externalCol().doc(epc).delete();
//   }

//   // ✅ إضافة تصريح خروج
//   static Future<void> addStatement(
//     String epc,
//     Map<String, dynamic> item,
//     String userId,
//   ) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('Statements')
//         .doc(epc) // منع التكرار
//         .set({
//       ...item,
//       'StatementDate': FieldValue.serverTimestamp(),
//       'status': 'active',
//     });
//   }

//   // ✅ جلب التصاريح
//   static Stream<QuerySnapshot> getStatements(String userId) {
//     return FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('Statements')
//         .orderBy('StatementDate', descending: true)
//         .snapshots();
//   }

//   // ✅ إلغاء التصريح
//   static Future<void> cancelStatement(String epc, String userId) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('Statements')
//         .doc(epc)
//         .delete(); // 🔥 حذف كامل
//   }

//   static Future<bool> checkIfExists(String epc, String userId) async {
//     final q = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .collection('Statements')
//         .where('epcHex', isEqualTo: epc)
//         .where('userId', isEqualTo: userId)
//         .get();

//     return q.docs.isNotEmpty;
//   }
// }
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class FS {
  static final _db = FirebaseFirestore.instance;
  static String get uid => FirebaseAuth.instance.currentUser!.uid;

  static CollectionReference itemsCol() =>
      _db.collection('users').doc(uid).collection('items');
  static CollectionReference invCol() =>
      _db.collection('users').doc(uid).collection('inventories');
  static CollectionReference salesCol() =>
      _db.collection('users').doc(uid).collection('sales');
  static CollectionReference salesHistoryCol() =>
      _db.collection('users').doc(uid).collection('sales_history');
  static CollectionReference depositsCol() =>
      _db.collection('users').doc(uid).collection('managementDeposits');
  static CollectionReference ImportedCol() =>
      _db.collection('users').doc(uid).collection('managementImported');
  static CollectionReference vouchersCol() =>
      _db.collection('users').doc(uid).collection('vouchers');
  static CollectionReference scrapCol() =>
      _db.collection('users').doc(uid).collection('scrapTransactions');
  static CollectionReference suppliersCol() =>
      _db.collection('users').doc(uid).collection('suppliers');
  static CollectionReference expensesCol() =>
      _db.collection('users').doc(uid).collection('expenses');
  static CollectionReference externalCol() =>
      _db.collection('users').doc(uid).collection('externalTransactions');
  static CollectionReference branchesCol() =>
      _db.collection('users').doc(uid).collection('branches');
  static CollectionReference balancesCol() =>
      _db.collection('users').doc(uid).collection('balances');
  static CollectionReference setRemaindersCol() =>
      _db.collection('users').doc(uid).collection('setRemainders');
  static CollectionReference deletedItemsCol() =>
      _db.collection('users').doc(uid).collection('deleted_items');

  static Future<void> saveItem({
    required String epcHex,
    required String category,
    required DateTime date,
    required Map<String, dynamic> payload,
    required bool fromOpeningBalance,
  }) async {
    final doc = itemsCol().doc();
    await doc.set({
      'userId': uid,
      'code': epcHex,
      'epcHex': epcHex,
      'category': category,
      'date': date,
      'payload': payload,
      'status': 'active',
      'createdAt': FieldValue.serverTimestamp(),
      'fromOpeningBalance': fromOpeningBalance,
    });
  }

  /// 📦 إرجاع عدد العناصر داخل كولكشن items
  static Future<int> getItemsCount() async {
    try {
      final snapshot = await itemsCol().get();
      return snapshot.size;
    } catch (e) {
      debugPrint("❌ خطأ أثناء جلب عدد العناصر: $e");
      return 0;
    }
  }

  /// ✅ تحديث عنصر (يدعم dot notation)
  static Future<void> uupdateItem(
      String epcHex, Map<String, dynamic> updates) async {
    final epc = epcHex.trim();

// البحث بالنظام الجديد
    QuerySnapshot q =
        await itemsCol().where("epcHex", isEqualTo: epc).limit(1).get();

// لو ملقاش، ابحث بالنظام القديم
    if (q.docs.isEmpty) {
      q = await itemsCol()
          .where("epcHex", isEqualTo: "${epc}ENTRE")
          .limit(1)
          .get();

      // لو لقى سجل قديم حدثه تلقائياً
      if (q.docs.isNotEmpty) {
        await itemsCol().doc(q.docs.first.id).update({
          "epcHex": epc,
        });
      }
    }

    if (q.docs.isEmpty) {
      throw Exception("⚠️ العنصر غير موجود");
    }

    final doc = q.docs.first;

    await itemsCol().doc(doc.id).update({
      ...updates,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// ✅ تحديث عنصر (يدعم dot notation)
  static Future<void> updateItem(
      String epcHex, Map<String, dynamic> updates) async {
    final cleanEpc = epcHex.trim().toUpperCase();
    print("🛠️ محاولة تحديث العنصر برقم: $cleanEpc");

// 🔹 البحث بالنظام الجديد
    var q =
        await itemsCol().where("epcHex", isEqualTo: cleanEpc).limit(1).get();

    print("📄 نتائج البحث في epcHex: ${q.docs.length}");

// 🔹 لو مفيش نتيجة، ابحث بالنظام القديم (ENTRE)
    if (q.docs.isEmpty) {
      q = await itemsCol()
          .where("epcHex", isEqualTo: "${cleanEpc}ENTRE")
          .limit(1)
          .get();

      print("📄 نتائج البحث في epcHex القديم: ${q.docs.length}");

      // Migration تلقائي
      if (q.docs.isNotEmpty) {
        await itemsCol().doc(q.docs.first.id).update({
          "epcHex": cleanEpc,
        });
      }
    }

    // 🔹 لو مفيش نتيجة، ابحث في payload.qrCode
    if (q.docs.isEmpty) {
      q = await itemsCol()
          .where("payload.qrCode", isEqualTo: cleanEpc)
          .limit(1)
          .get();

      print("📄 نتائج البحث في payload.qrCode: ${q.docs.length}");
    }

    // 🔹 لو مفيش أي نتيجة
    if (q.docs.isEmpty) {
      throw Exception("⚠️ العنصر غير موجود في قاعدة البيانات!");
    }

    // 🔹 تحديث العنصر
    final doc = q.docs.first;
    await itemsCol().doc(doc.id).update({
      ...updates,
      "updatedAt": FieldValue.serverTimestamp(),
    });

    print("✅ تم تحديث العنصر بنجاح: ${doc.id}");
  }

  static Future<void> uploadImage(
      String epcHex, Map<String, dynamic> updates) async {
    final cleanEpc = epcHex.trim().toUpperCase();
    print("🛠️ محاولة تحديث العنصر برقم: $cleanEpc");

// 🔹 البحث بالنظام الجديد
    var q =
        await itemsCol().where("epcHex", isEqualTo: cleanEpc).limit(1).get();

    print("📄 نتائج البحث في epcHex: ${q.docs.length}");

// 🔹 لو مفيش نتيجة، ابحث بالنظام القديم (ENTRE)
    if (q.docs.isEmpty) {
      q = await itemsCol()
          .where("epcHex", isEqualTo: "${cleanEpc}ENTRE")
          .limit(1)
          .get();

      print("📄 نتائج البحث في epcHex القديم: ${q.docs.length}");

      // Migration تلقائي
      if (q.docs.isNotEmpty) {
        await itemsCol().doc(q.docs.first.id).update({
          "epcHex": cleanEpc,
        });
      }
    }

    // 🔹 لو مفيش نتيجة، ابحث في payload.qrCode
    if (q.docs.isEmpty) {
      q = await itemsCol()
          .where("payload.qrCode", isEqualTo: cleanEpc)
          .limit(1)
          .get();

      print("📄 نتائج البحث في payload.qrCode: ${q.docs.length}");
    }

    // 🔹 لو مفيش أي نتيجة
    if (q.docs.isEmpty) {
      throw Exception("⚠️ العنصر غير موجود في قاعدة البيانات!");
    }

    // 🔹 تحديث العنصر
    final doc = q.docs.first;
    await itemsCol().doc(doc.id).update({
      ...updates,
    });

    print("✅ تم تحديث العنصر بنجاح: ${doc.id}");
  }

  static Future<Map<String, dynamic>?> findItemByEpc(String epcHex,
      {bool includeBalances = false}) async {
    final epc = epcHex.toUpperCase();
    print("🔎 البحث عن: $epcHex");

    var q = await itemsCol().where('epcHex', isEqualTo: epc).limit(1).get();
    print("📄 عدد النتائج في items.epcHex: ${q.docs.length}");

// البحث بالنظام القديم
    if (q.docs.isEmpty) {
      q = await itemsCol()
          .where('epcHex', isEqualTo: "${epc}ENTRE")
          .limit(1)
          .get();

      print("📄 عدد النتائج في items.epcHex القديم: ${q.docs.length}");
      // Migration تلقائي
      if (q.docs.isNotEmpty) {
        await itemsCol().doc(q.docs.first.id).update({
          "epcHex": epc,
        });
      }
    }

    if (q.docs.isEmpty) {
      q = await itemsCol()
          .where('payload.qrCode', isEqualTo: epcHex)
          .limit(1)
          .get();
      print("📄 عدد النتائج في items.payload.qrCode: ${q.docs.length}");
    }

    bool foundInBalances = false;
    if (q.docs.isEmpty && includeBalances) {
      q = await balancesCol().where('epcHex', isEqualTo: epc).limit(1).get();
      print("📄 عدد النتائج في balances.epcHex: ${q.docs.length}");

      if (q.docs.isEmpty) {
        q = await balancesCol()
            .where('epcHex', isEqualTo: "${epc}ENTRE")
            .limit(1)
            .get();

        print("📄 عدد النتائج في balances.epcHex القديم: ${q.docs.length}");
        // Migration تلقائي
        if (q.docs.isNotEmpty) {
          await balancesCol().doc(q.docs.first.id).update({
            "epcHex": epc,
          });
        }
      }
      if (q.docs.isEmpty) {
        q = await balancesCol()
            .where('payload.qrCode', isEqualTo: epcHex)
            .limit(1)
            .get();
        print("📄 عدد النتائج في balances.payload.qrCode: ${q.docs.length}");
      }
      foundInBalances = q.docs.isNotEmpty;
    }

    if (q.docs.isEmpty) {
      print("❌ مفيش نتيجة");
      return null;
    }

    final d = q.docs.first;
    print("✅ تم العثور على العنصر: ${d.id}");
    return {
      'id': d.id,
      'collection': foundInBalances ? 'balances' : 'items',
      ...d.data() as Map<String, dynamic>
    };
  }

  static Future<Map<String, dynamic>?> epcandcode(String epcHex) async {
    final epc = epcHex.toUpperCase();
    print("🔎 البحث عن: $epc");

    QuerySnapshot q =
        await itemsCol().where('epcHex', isEqualTo: epc).limit(1).get();

    print("📄 عدد النتائج في items.epcHex: ${q.docs.length}");

    if (q.docs.isEmpty) {
      q = await itemsCol()
          .where('epcHex', isEqualTo: "${epc}ENTRE")
          .limit(1)
          .get();

      print("📄 عدد النتائج في items.epcHex القديم: ${q.docs.length}");
    }

    if (q.docs.isEmpty) {
      q = await itemsCol()
          .where('payload.qrCode', isEqualTo: epcHex)
          .limit(1)
          .get();
      print("📄 عدد النتائج في items.payload.qrCode: ${q.docs.length}");
    }

    if (q.docs.isEmpty) {
      q = await balancesCol().where('epcHex', isEqualTo: epc).limit(1).get();

      print("📄 عدد النتائج في balances.epcHex: ${q.docs.length}");
    }

    if (q.docs.isEmpty) {
      q = await balancesCol()
          .where('epcHex', isEqualTo: "${epc}ENTRE")
          .limit(1)
          .get();

      print("📄 عدد النتائج في balances.epcHex القديم: ${q.docs.length}");
    }

    if (q.docs.isEmpty) {
      q = await balancesCol()
          .where('payload.qrCode', isEqualTo: epcHex)
          .limit(1)
          .get();
      print("📄 عدد النتائج في balances.payload.qrCode: ${q.docs.length}");
    }

    if (q.docs.isEmpty) {
      print("❌ مفيش نتيجة");
      return null;
    }

    final d = q.docs.first;
    final data = d.data() as Map<String, dynamic>;
    final payload = data['payload'] as Map<String, dynamic>?;

    return {
      'id': d.id,
      'epcHex': data['epcHex'],
      'qrCode': payload?['qrCode'],
      'collection': d.reference.parent.id,
    };
  }

  static Future<List<Map<String, dynamic>>> getAllEpcAndQr() async {
    print("📦 جلب كل الشرائح...");

    final QuerySnapshot q = await itemsCol().get();

    print("📄 عدد الشرائح: ${q.docs.length}");

    return q.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final payload = data['payload'] as Map<String, dynamic>?;

      return {
        'id': doc.id,
        'qrCode': payload?['qrCode'],
        ...data,
      };
    }).toList();
  }

  static Future<void> upsertInventory(
      String epcHex, Map<String, dynamic>? itemData) async {
    final now = FieldValue.serverTimestamp();

    // لو العنصر مش موجود في items أصلاً
    if (itemData == null) {
      final existingInv =
          await invCol().where('epcHex', isEqualTo: epcHex).limit(1).get();
      if (existingInv.docs.isEmpty) {
        await invCol().add({
          'epcHex': epcHex,
          'itemId': null,
          'firstSeenAt': now,
          //'lastSeenAt': now,
          'scanCount': 1,
        });
      } else {
        final doc = existingInv.docs.first;
        final currentCount =
            (doc.data() as Map<String, dynamic>)['scanCount'] ?? 1;
        await invCol().doc(doc.id).update({
          //'lastSeenAt': now,
          'scanCount': currentCount + 1,
        });
      }
    } else {
      final itemId = itemData['id'];
      final category = itemData['category'];
      final payload = itemData['payload'];

      final q =
          await invCol().where('itemId', isEqualTo: itemId).limit(1).get();
      if (q.docs.isEmpty) {
        await invCol().add({
          'epcHex': epcHex,
          'itemId': itemId,
          'category': category, // ✅ تخزين النوع
          'payload': payload, // ✅ تخزين التفاصيل
          'firstSeenAt': now,
          'lastSeenAt': now,
          'scanCount': 1,
          'createdAt': now,
        });
      } else {
        final doc = q.docs.first;
        final currentCount =
            (doc.data() as Map<String, dynamic>)['scanCount'] ?? 1;
        await invCol().doc(doc.id).update({
          'lastSeenAt': now,
          'scanCount': currentCount + 1,
          'category': category, // ✅ تحديث النوع
          'payload': payload, // ✅ تحديث التفاصيل
        });
      }
    }
  }

  static Future<void> deleteItem(String epcHex) async {
    final d = await findItemByEpc(epcHex);
    if (d == null) return;

    final itemRef = itemsCol().doc(d['id']);
    final deletedRef = deletedItemsCol().doc(d['id']);

    final data = Map<String, dynamic>.from(d);
    await deleteItemImages(epcHex);

    data.remove('id');
    data.remove('collection');
    data['deletedAt'] = FieldValue.serverTimestamp();
    data['originalDocId'] = d['id'];

    await _db.runTransaction((transaction) async {
      transaction.set(deletedRef, data);
      transaction.delete(itemRef);
    });
  }

  static Future<void> deleteItemImages(String epc) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final cleanEpc = epc.toUpperCase();

      // 🔹 جرب الفولدر الجديد أولاً
      Reference sourceFolder = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child(cleanEpc);

      ListResult result = await sourceFolder.listAll();

      // 🔹 لو مفيش صور، جرب الفولدر القديم (ENTRE)
      if (result.items.isEmpty) {
        sourceFolder = FirebaseStorage.instance
            .ref()
            .child('images')
            .child('users')
            .child(uid)
            .child("${cleanEpc}ENTRE");

        result = await sourceFolder.listAll();
      }

      // 🔹 فولدر المحذوفات (دائماً بالنظام الجديد)
      final deletedFolder = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('users')
          .child(uid)
          .child('deleted')
          .child(cleanEpc);

      if (result.items.isEmpty) {
        print('ℹ️ لا توجد صور للشريحة $cleanEpc');
        return;
      }

      print('📦 نسخ ${result.items.length} صورة إلى مجلد المحذوفات');

      for (Reference sourceRef in result.items) {
        try {
          // تحميل الصورة
          final Uint8List? bytes = await sourceRef.getData();

          if (bytes == null) {
            print('❌ لم يتم تحميل ${sourceRef.name}');
            continue;
          }

          // إنشاء الملف الجديد بنفس الاسم
          final destRef = deletedFolder.child(sourceRef.name);

          // نسخ الصورة
          await destRef.putData(bytes);
          print('✅ تم نسخ ${sourceRef.name}');

          // حذف الأصل بعد نجاح النسخ
          await sourceRef.delete();
          print('🗑️ تم حذف ${sourceRef.name}');
        } catch (e) {
          print('❌ خطأ مع ${sourceRef.name}: $e');
        }
      }

      print('✅ انتهت عملية النسخ والحذف');
    } catch (e) {
      print('🔥 خطأ أثناء حذف صور الشريحة $epc: $e');
    }
  }

  static Future<void> sellItem(
    String epcHex, {
    String? saleGroupId,
    Map<String, dynamic>? paymentData,
    bool partialSale = false,
    List<String>? soldComponents,
    double? weightSold,
    double? wageSold,
  }) async {
    final groupId =
        saleGroupId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final d = await findItemByEpc(epcHex, includeBalances: true);
    if (d == null) return;

    final itemCollection =
        d['collection'] == 'balances' ? balancesCol() : itemsCol();
    final itemRef = itemCollection.doc(d['id']);
    final docSnap = await itemRef.get();
    if (!docSnap.exists) return;

    final itemData = docSnap.data() as Map<String, dynamic>;
    final payload = Map<String, dynamic>.from(itemData['payload'] ?? {});
    final currentWeight = (payload['weight'] ?? 0).toDouble();
    final currentWage = (payload['wage'] ?? 0).toDouble();

    /// لو بيع جزئي
    if (partialSale == true) {
      // حساب الوزن والأجر الجديد بعد الخصم
      final newWeight = currentWeight - (weightSold ?? 0);
      final newWage = currentWage - (wageSold ?? 0);

      // تحديث مكونات الطقم
      final updatedComponents =
          List<String>.from(payload['setComponents'] ?? []);
      if (soldComponents != null && soldComponents.isNotEmpty) {
        updatedComponents.removeWhere((c) => soldComponents.contains(c));
      }

      // تجهيز بيانات البيع الجزئي للسجل
      final saleData = {
        'itemId': d['id'],
        'epcHex': d['epcHex'],
        'saleGroupId': groupId,
        'soldAt': FieldValue.serverTimestamp(),
        'category': d['category'],
        'partialSale': true,
        'payload': {
          ...payload,
          'weight': weightSold,
          'wage': wageSold,
          'setComponents': soldComponents ?? [],
        },
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (paymentData != null) {
        saleData['payment'] = paymentData;
      }

      await salesCol().add(saleData);
      await salesHistoryCol().add(saleData);

      // إنشاء رصيد لباقي الطقم في كولكشن جديد خاص ببقايا الأطقم
      final hasRemaining = newWeight > 0 || updatedComponents.isNotEmpty;
      if (hasRemaining) {
        await setRemaindersCol().add({
          'userId': uid,
          'originalItemId': d['id'],
          'originalEpcHex': d['epcHex'],
          'epcHex': d['epcHex'],
          'category': d['category'],
          'payload': {
            ...payload,
            'weight': newWeight,
            'wage': newWage,
            'setComponents': updatedComponents,
            'originalWeight': currentWeight,
            'originalWage': currentWage,
            'soldWeight': weightSold,
            'soldWage': wageSold,
          },
          'remainderType': 'partialSaleRemainder',
          'source': 'partialSale',
          'soldComponents': soldComponents ?? [],
          'remainingComponents': updatedComponents,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // حذف الطقم الأصلي
      await itemRef.delete();
    } else {
      /// البيع الكامل (زي النظام القديم)
      await itemRef.delete();

      final saleData = {
        'itemId': d['id'],
        'epcHex': d['epcHex'],
        'saleGroupId': groupId,
        'soldAt': FieldValue.serverTimestamp(),
        'category': d['category'],
        'payload': d['payload'],
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (paymentData != null) {
        saleData['payment'] = paymentData;
      }

      await salesCol().add(saleData);
      await salesHistoryCol().add(saleData);
    }
  }

  /// ✅ دالة للتحقق من وجود العنصر قبل الإدخال
  static Future<bool> checkItemExists(String epcHex) async {
    final cleanEpc = epcHex.trim().toUpperCase();

    // items - النظام الجديد
    var q =
        await itemsCol().where('epcHex', isEqualTo: cleanEpc).limit(1).get();
    if (q.docs.isNotEmpty) return true;

    // items - النظام القديم
    q = await itemsCol()
        .where('epcHex', isEqualTo: '${cleanEpc}ENTRE')
        .limit(1)
        .get();
    if (q.docs.isNotEmpty) return true;

    // balances - النظام الجديد
    q = await balancesCol().where('epcHex', isEqualTo: cleanEpc).limit(1).get();
    if (q.docs.isNotEmpty) return true;

    // balances - النظام القديم
    q = await balancesCol()
        .where('epcHex', isEqualTo: '${cleanEpc}ENTRE')
        .limit(1)
        .get();
    if (q.docs.isNotEmpty) return true;

    q = await itemsCol()
        .where('payload.qrCode', isEqualTo: cleanEpc)
        .limit(1)
        .get();
    if (q.docs.isNotEmpty) return true;

    q = await balancesCol()
        .where('payload.qrCode', isEqualTo: cleanEpc)
        .limit(1)
        .get();
    return q.docs.isNotEmpty;
  }

  /// =========================
  /// 🔵 دوال خاصة بالمرتجعات (Returns)
  /// =========================

  /// ✅ جلب عمليات البيع المسجلة خلال آخر [days] أيام (افتراضيًا 3 أيام)
  static Future<List<Map<String, dynamic>>> getRecentSales(
      {int days = 3}) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final q = await salesCol()
        .where('soldAt', isGreaterThanOrEqualTo: Timestamp.fromDate(cutoff))
        .orderBy('soldAt', descending: true)
        .get();

    return q.docs.map((d) {
      final data = Map<String, dynamic>.from(d.data() as Map<String, dynamic>);
      data['id'] = d.id;
      return data;
    }).toList();
  }

  /// ✅ حذف سجل بيع معين (يُستخدم بعد استرجاع القطعة وإعادة تسجيلها)
  static Future<void> deleteSale(String saleId) async {
    await salesCol().doc(saleId).delete();
  }

  /// =========================
  /// 🟡 دوال خاصة بالكسر (Scrap)
  /// =========================

  /// ✅ تسجيل عملية إضافة كسر
  static Future<void> saveScrapAdd(Map<String, dynamic> data) async {
    await scrapCol().add({
      ...data,
      "person": data["person"],
      "carat": data["carat"],
      "notes": data["notes"],
      "date": Timestamp.fromDate(data["date"]),
      "type": "add",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// ✅ تسجيل عملية بيع كسر
  static Future<void> saveScrapSale(Map<String, dynamic> data) async {
    await scrapCol().add({
      ...data,
      "person": data["person"],
      "carat": data["carat"],
      "notes": data["notes"],
      "date": Timestamp.fromDate(data["date"]),
      "type": "sale",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// ✅ تسجيل عملية سند صرف (خصم من الكسر) - جديدة
  static Future<void> saveScrapPayment(Map<String, dynamic> data) async {
    await scrapCol().add({
      ...data,
      "person": data["person"],
      "carat": data["carat"],
      "notes": data["notes"] ?? "",
      "date": Timestamp.fromDate(data["date"]),
      "type": "payment",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// ✅ تسجيل عملية تحويل كسر
  static Future<void> saveScrapTransform(Map<String, dynamic> data) async {
    await scrapCol().add({
      ...data,
      "person": data["person"],
      "toPerson": data["toPerson"],
      "carat": data["carat"],
      "toCarat": data["toCarat"],
      "notes": data["notes"] ?? "",
      "date": Timestamp.fromDate(data["date"]),
      "type": data["type"] ?? "transform",
      "direction": data["direction"] ?? "out",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// ✅ إرجاع كل المعاملات الخاصة بشخص
  static Future<List<Map<String, dynamic>>> getScrapTransactions(
      String name) async {
    final q = await scrapCol().where("person", isEqualTo: name.trim()).get();

    return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
  }

  /// ✅ جلب معاملات شخص معين وعيار معين
  static Future<List<Map<String, dynamic>>>
      getScrapTransactionsByPersonAndCarat(
    String person,
    String carat,
  ) async {
    final q = await scrapCol()
        .where("person", isEqualTo: person.trim())
        .where("carat", isEqualTo: carat)
        .get();

    return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
  }

  /// ✅ جلب معاملات عيار معين (للتحقق من الرصيد)
  static Future<List<Map<String, dynamic>>> getScrapTransactionsByCarat(
    String carat,
  ) async {
    final q = await scrapCol().where("carat", isEqualTo: carat).get();

    return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
  }

  /// ✅ جلب رصيد شخص معين (كل العيارات)
  static Future<double> getPersonBalance(String person) async {
    final q = await scrapCol().where("person", isEqualTo: person.trim()).get();

    double balance = 0;
    for (var doc in q.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final type = data["type"] ?? "";
      final weight = (data["weight"] ?? 0).toDouble();

      if (type == "add" || type == "transform") {
        balance += weight;
      } else if (type == "sale" || type == "payment") {
        balance -= weight.abs();
      }
    }
    return balance;
  }

  /// ✅ جلب رصيد شخص معين لعيار محدد
  static Future<double> getPersonBalanceByCarat(
      String person, String carat) async {
    final q = await scrapCol()
        .where("person", isEqualTo: person.trim())
        .where("carat", isEqualTo: carat)
        .get();

    double balance = 0;
    for (var doc in q.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final type = data["type"] ?? "";
      final weight = (data["weight"] ?? 0).toDouble();

      if (type == "add" || type == "transform") {
        balance += weight;
      } else if (type == "sale" || type == "payment") {
        balance -= weight.abs();
      }
    }
    return balance;
  }

  /// ✅ جلب كل المعاملات لشخص معين مع فلترة حسب النوع
  static Future<List<Map<String, dynamic>>> getScrapTransactionsByType(
    String person,
    String type,
  ) async {
    final q = await scrapCol()
        .where("person", isEqualTo: person.trim())
        .where("type", isEqualTo: type)
        .get();

    return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
  }

  /// ✅ جلب المعاملات في نطاق تاريخي
  static Future<List<Map<String, dynamic>>> getScrapTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final q = await scrapCol()
        .where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where("date", isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy("date", descending: true)
        .get();

    return q.docs.map((d) => d.data() as Map<String, dynamic>).toList();
  }

  /// ✅ حذف معاملة كسر معينة
  static Future<void> deleteScrapTransaction(String docId) async {
    await scrapCol().doc(docId).delete();
  }

  /// ✅ تحديث معاملة كسر
  static Future<void> updateScrapTransaction(
    String docId,
    Map<String, dynamic> data,
  ) async {
    await scrapCol().doc(docId).update({
      ...data,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  /// ✅ إرجاع أسماء الأشخاص (distinct)
  static Future<List<String>> getScrapPersons() async {
    final q = await scrapCol().get();
    final all = q.docs
        .map((d) => d['person'])
        .where((n) => n != null && n.toString().trim().isNotEmpty)
        .toList();

    return all.map((e) => e.toString().trim()).toSet().toList();
  }

  // تحديث الاسم في كل المعاملات
  static Future<void> updateScrapPerson(String oldName, String newName) async {
    final userDoc = _db.collection("users").doc(uid);

    // كل الكولكشن بتاع scrapTransactions
    final q = await userDoc
        .collection("scrapTransactions")
        .where("person", isEqualTo: oldName)
        .get();

    for (var doc in q.docs) {
      await doc.reference.update({"person": newName});
    }
  }

  // حذف كل معاملات الشخص
  static Future<void> deleteScrapPerson(String name) async {
    final q = await scrapCol().where("person", isEqualTo: name.trim()).get();

    for (var doc in q.docs) {
      await doc.reference.delete();
    }
  }

  static Stream<List<String>> scrapPersonsStream() {
    return _db
        .collection("users")
        .doc(uid)
        .collection("scrapTransactions")
        .snapshots()
        .map((snapshot) {
      final names = snapshot.docs
          .map((d) => d.data()["person"] as String?)
          .where((p) => p != null && p.isNotEmpty)
          .map((p) => p!)
          .toSet()
          .toList();
      names.sort();
      return names;
    });
  }

  static Stream<List<Map<String, dynamic>>> scrapTransactionsStream() {
    return scrapCol().snapshots().map((snap) {
      return snap.docs.map((d) {
        final data = d.data() as Map<String, dynamic>;
        data["id"] = d.id;
        return data;
      }).toList();
    });
  }

  /// ✅ جلب إحصائيات الكسر (ملخص عام)
  static Future<Map<String, dynamic>> getScrapStatistics() async {
    final q = await scrapCol().get();

    Map<String, dynamic> stats = {
      "totalAdd": 0.0,
      "totalSale": 0.0,
      "totalPayment": 0.0,
      "totalTransform": 0.0,
      "byCarat": {
        "14": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
        "18": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
        "21": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
        "22": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
        "24": {"add": 0.0, "sale": 0.0, "payment": 0.0, "transform": 0.0},
      }
    };

    for (var doc in q.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final type = data["type"] ?? "";
      final carat = (data["carat"] ?? "18").toString();
      final weight = (data["weight"] ?? 0).toDouble();

      if (type == "add") {
        stats["totalAdd"] = (stats["totalAdd"] ?? 0.0) + weight;
        if (stats["byCarat"][carat] != null) {
          stats["byCarat"][carat]["add"] =
              (stats["byCarat"][carat]["add"] ?? 0.0) + weight;
        }
      } else if (type == "sale") {
        stats["totalSale"] = (stats["totalSale"] ?? 0.0) + weight.abs();
        if (stats["byCarat"][carat] != null) {
          stats["byCarat"][carat]["sale"] =
              (stats["byCarat"][carat]["sale"] ?? 0.0) + weight.abs();
        }
      } else if (type == "payment") {
        stats["totalPayment"] = (stats["totalPayment"] ?? 0.0) + weight.abs();
        if (stats["byCarat"][carat] != null) {
          stats["byCarat"][carat]["payment"] =
              (stats["byCarat"][carat]["payment"] ?? 0.0) + weight.abs();
        }
      } else if (type == "transform") {
        stats["totalTransform"] = (stats["totalTransform"] ?? 0.0) + weight;
        if (stats["byCarat"][carat] != null) {
          stats["byCarat"][carat]["transform"] =
              (stats["byCarat"][carat]["transform"] ?? 0.0) + weight;
        }
      }
    }

    return stats;
  }

  /// 🟢 كولكشن الموردين
  /// 🟢 إضافة مورد جديد
  static Future<void> addSupplier({
    required String name,
    required List<String> delegates,
    required String phone,
  }) async {
    await suppliersCol().add({
      "name": name,
      "delegates": delegates,
      "phone": phone,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// 🟢 جلب الموردين
  static Future<List<Map<String, dynamic>>> getSuppliers() async {
    final q = await suppliersCol().get();
    return q.docs
        .map((d) => {"id": d.id, ...d.data() as Map<String, dynamic>})
        .toList();
  }

  /// 🟢 كولكشن سندات
  /// 🟢 إضافة سند قبض (معدل لدعم العيارات المتعددة)
  static Future<void> addReceiptVoucher({
    required String supplierId,
    required String supplierName,
    required String delegate,
    required String carat,
    required double weight,
    required double wage,
    required DateTime date,
    List<Map<String, dynamic>>? carats,
  }) async {
    await vouchersCol().add({
      "supplierId": supplierId,
      "supplierName": supplierName,
      "delegate": delegate,
      "carat": carat,
      "weight": weight,
      "wage": wage,
      "type": "receipt",
      "date": Timestamp.fromDate(date),
      "createdAt": FieldValue.serverTimestamp(),
      "carats": carats ?? [],
    });
  }

  /// 🟢 إضافة سند صرف (معدل لدعم العيارات المتعددة - سند واحد في الكسر)
  static Future<void> addPaymentVoucher({
    required String supplierId,
    required String supplierName,
    required String delegate,
    required String carat,
    required double weight,
    required double wage,
    required String paymentMethod,
    required double? cash,
    required double? network,
    required DateTime date,
    List<Map<String, dynamic>>? carats,
  }) async {
    // 1️⃣ حفظ سند الصرف في كولكشن vouchers
    await vouchersCol().add({
      "supplierId": supplierId,
      "supplierName": supplierName,
      "delegate": delegate,
      "carat": carat,
      "weight": weight,
      "wage": wage,
      "type": "payment",
      "paymentMethod": paymentMethod,
      "cash": cash,
      "network": network,
      "total": (cash ?? 0) + (network ?? 0),
      "date": Timestamp.fromDate(date),
      "createdAt": FieldValue.serverTimestamp(),
      "carats": carats ?? [],
    });

    // 2️⃣ حفظ سند صرف واحد في الكسر مع العيارات
    if (carats != null && carats.isNotEmpty) {
      // ✅ تحديد العيار الفعلي (إذا كان عيار واحد فقط)
      String actualCarat = carat;
      double actualWeight = weight;
      double actualWage = wage;

      // إذا كان carat = 'multiple' ولكن يوجد عيار واحد فقط
      if (carat == 'multiple' && carats.length == 1) {
        actualCarat = (carats[0]['carat'] ?? "18").toString();
        actualWeight = (carats[0]['weight'] ?? 0).toDouble();
        actualWage = (carats[0]['wage'] ?? 0).toDouble();
      }

      // ✅ إذا كان عيار واحد فقط - نخزن كسند عادي
      if (carats.length == 1) {
        await scrapCol().add({
          "supplierId": supplierId,
          "person": supplierName,
          "delegate": delegate,
          "carat": actualCarat,
          "weight": actualWeight,
          "wage": actualWage,
          "type": "payment",
          "paymentMethod": paymentMethod,
          "cash": cash,
          "network": network,
          "date": Timestamp.fromDate(date),
          "notes": "سند صرف - عيار واحد",
          "createdAt": FieldValue.serverTimestamp(),
          "carats": carats
              .map((item) => {
                    'carat': (item['carat'] ?? "18").toString(),
                    'weight': (item['weight'] ?? 0).toDouble(),
                    'wage': (item['wage'] ?? 0).toDouble(),
                  })
              .toList(),
          "totalWeight": actualWeight,
          "totalWage": actualWage,
        });
      } else {
        // ✅ عيارات متعددة - نخزن كسند واحد مع قائمة العيارات
        await scrapCol().add({
          "supplierId": supplierId,
          "person": supplierName,
          "delegate": delegate,
          "carat": "multiple",
          "weight": weight,
          "wage": wage,
          "type": "payment",
          "paymentMethod": paymentMethod,
          "cash": cash,
          "network": network,
          "date": Timestamp.fromDate(date),
          "notes": "سند صرف - ${carats.length} عيار",
          "createdAt": FieldValue.serverTimestamp(),
          "carats": carats
              .map((item) => {
                    'carat': (item['carat'] ?? "18").toString(),
                    'weight': (item['weight'] ?? 0).toDouble(),
                    'wage': (item['wage'] ?? 0).toDouble(),
                  })
              .toList(),
          "totalWeight": weight,
          "totalWage": wage,
        });
      }
    } else {
      // 🔸 حالة عدم وجود carats (للتوافق مع الإصدارات القديمة)
      await scrapCol().add({
        "supplierId": supplierId,
        "person": supplierName,
        "delegate": delegate,
        "carat": carat,
        "weight": weight,
        "wage": wage,
        "type": "payment",
        "paymentMethod": paymentMethod,
        "cash": cash,
        "network": network,
        "date": Timestamp.fromDate(date),
        "notes": "سند صرف - عيار واحد",
        "createdAt": FieldValue.serverTimestamp(),
        "carats": [
          {
            'carat': carat,
            'weight': weight,
            'wage': wage,
          }
        ],
        "totalWeight": weight,
        "totalWage": wage,
      });
    }
  }

  /// 🟢 إضافة سند صرف (معدل لدعم العيارات المتعددة وخصم الكسر)
  // static Future<void> addPaymentVoucher({
  //   required String supplierId,
  //   required String supplierName,
  //   required String delegate,
  //   required String carat,
  //   required double weight,
  //   required double wage,
  //   required String paymentMethod,
  //   required double? cash,
  //   required double? network,
  //   required DateTime date,
  //   List<Map<String, dynamic>>? carats,
  // }) async {
  //   // 1️⃣ حفظ سند الصرف في كولكشن vouchers
  //   await vouchersCol().add({
  //     "supplierId": supplierId,
  //     "supplierName": supplierName,
  //     "delegate": delegate,
  //     "carat": carat,
  //     "weight": weight,
  //     "wage": wage,
  //     "type": "payment",
  //     "paymentMethod": paymentMethod,
  //     "cash": cash,
  //     "network": network,
  //     "total": (cash ?? 0) + (network ?? 0),
  //     "date": Timestamp.fromDate(date),
  //     "createdAt": FieldValue.serverTimestamp(),
  //     "carats": carats ?? [],
  //   });

  //   // 2️⃣ خصم من الكسر لكل عيار على حدة
  //   if (carats != null && carats.isNotEmpty) {
  //     for (var item in carats) {
  //       final itemCarat = (item['carat'] ?? "18").toString();
  //       final itemWeight = (item['weight'] ?? 0).toDouble();
  //       final itemWage = (item['wage'] ?? 0).toDouble();

  //       await scrapCol().add({
  //         "supplierId": supplierId,
  //         "person": supplierName,
  //         "delegate": delegate,
  //         "carat": itemCarat,
  //         "weight": itemWeight,
  //         "wage": itemWage,
  //         "paymentMethod": paymentMethod,
  //         "cash": cash,
  //         "network": network,
  //         "date": Timestamp.fromDate(date),
  //         "type": "payment",
  //         "notes": "سند صرف - ${carats.length} عيار",
  //         "createdAt": FieldValue.serverTimestamp(),
  //       });
  //     }
  //   } else {
  //     // 🔸 حالة العيار الواحد (للتوافق مع الإصدارات القديمة)
  //     await scrapCol().add({
  //       "supplierId": supplierId,
  //       "person": supplierName,
  //       "delegate": delegate,
  //       "carat": carat,
  //       "weight": weight,
  //       "wage": wage,
  //       "paymentMethod": paymentMethod,
  //       "cash": cash,
  //       "network": network,
  //       "date": Timestamp.fromDate(date),
  //       "type": "payment",
  //       "notes": "سند صرف - عيار واحد",
  //       "createdAt": FieldValue.serverTimestamp(),
  //     });
  //   }
  // }

  /// 🟢 جلب السندات لمورد
  static Future<List<Map<String, dynamic>>> getVouchersForSupplier(
      String supplierId) async {
    final q =
        await vouchersCol().where("supplierId", isEqualTo: supplierId).get();
    return q.docs
        .map((d) => {"id": d.id, ...d.data() as Map<String, dynamic>})
        .toList();
  }

  // داخل كلاس FS
  static Future<void> updateSupplier(
      String id, Map<String, dynamic> data) async {
    await suppliersCol().doc(id).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteSupplier(String id) async {
    await suppliersCol().doc(id).delete();
  }

  static Stream<List<Map<String, dynamic>>> suppliersStream() {
    return suppliersCol().orderBy('name').snapshots().map((snap) => snap.docs
        .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
        .toList());
  }

  /// ==============================
  /// 💰 دوال المصروفات (Expenses)
  /// ==============================

  /// 🔹 إضافة مصروف جديد
  static Future<void> addExpense({
    required String type,
    required double amount,
    required DateTime date,
    String? note,
  }) async {
    await expensesCol().add({
      'type': type,
      'amount': amount,
      'note': note ?? '',
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 🔹 تعديل مصروف موجود
  static Future<void> updateExpense(
      String id, Map<String, dynamic> data) async {
    await expensesCol().doc(id).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 🔹 حذف مصروف
  static Future<void> deleteExpense(String id) async {
    await expensesCol().doc(id).delete();
  }

  /// 🔹 جلب كل المصروفات
  static Stream<List<Map<String, dynamic>>> expensesStream({
    String? typeFilter,
    DateTimeRange? dateRange,
  }) {
    Query query = expensesCol().orderBy('date', descending: true);

    if (typeFilter != null && typeFilter.isNotEmpty) {
      query = query.where('type', isEqualTo: typeFilter);
    }

    if (dateRange != null) {
      final start = DateTime(dateRange.start.year, dateRange.start.month,
          dateRange.start.day, 0, 0, 0);
      final end = DateTime(dateRange.end.year, dateRange.end.month,
          dateRange.end.day, 23, 59, 59);

      query = query
          .where('date', isGreaterThanOrEqualTo: start)
          .where('date', isLessThanOrEqualTo: end);
    }

    return query.snapshots().map((snap) {
      return snap.docs.map((d) {
        final data = d.data() as Map<String, dynamic>;
        data['id'] = d.id;
        return data;
      }).toList();
    });
  }

  static Future<List<String>> getExpenseTypes() async {
    final snapshot = await expensesCol().get();

    final allTypes = snapshot.docs
        .map((d) => d['type']?.toString().trim() ?? '')
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList();

    allTypes.sort();
    return allTypes;
  }

  static Stream<List<String>> expenseTypesStream() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .snapshots()
        .map((snapshot) {
      final all = snapshot.docs
          .map((d) => d['type']?.toString().trim() ?? '')
          .where((t) => t.isNotEmpty)
          .toSet()
          .toList();
      all.sort();
      return all;
    });
  }

  static Stream<List<String>> soldByStream() {
    return _db
        .collection('users')
        .doc(uid)
        .collection('sales')
        .snapshots()
        .map((snapshot) {
      final all = snapshot.docs
          .map((d) {
            final payment = d.data()['payment'];
            if (payment is Map && payment['soldBy'] != null) {
              return payment['soldBy'].toString().trim();
            }
            return '';
          })
          .where((s) => s.isNotEmpty)
          .toSet()
          .toList();

      all.sort();
      return all;
    });
  }

  static Stream<List<Map<String, dynamic>>> salesStream({
    String? soldByFilter,
    DateTimeRange? dateRange,
  }) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('sales')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((d) {
        final data = d.data();
        data['id'] = d.id;
        return data;
      }).where((s) {
        // فلترة البائع
        if (soldByFilter != null) {
          final soldBy = s['payment']?['soldBy'];
          if (soldBy != soldByFilter) return false;
        }

        // فلترة التاريخ
        if (dateRange != null) {
          final ts = s['soldAt'] as Timestamp?;
          if (ts == null) return false;
          final date = ts.toDate();
          if (date.isBefore(dateRange.start) || date.isAfter(dateRange.end)) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  /// =========== فروع (Branches) =============

  static Future<void> addBranch({
    required String name,
    required String uid,
    required String address,
    required String manager,
    required String phone,
    required List<String> delegates,
    required DateTime date,
  }) async {
    await branchesCol().add({
      'name': name,
      'uid': uid,
      'address': address,
      'manager': manager,
      'phone': phone,
      'delegates': delegates,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateBranch(String id, Map<String, dynamic> data) async {
    await branchesCol().doc(id).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteBranch(String id) async {
    await branchesCol().doc(id).delete();
  }

  static Future<List<Map<String, dynamic>>> getBranches() async {
    final q = await branchesCol().orderBy('name').get();
    return q.docs
        .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
        .toList();
  }

  static Stream<List<Map<String, dynamic>>> branchesStream() {
    return branchesCol().orderBy('name').snapshots().map((snap) => snap.docs
        .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
        .toList());
  }

  /// ============================
  /// 🔄 دوال التحويل (Transform)
  /// ============================

  /// 🔹 تحويل صنف إلى كسر
  static Future<void> transferToScrap(
      Map<String, dynamic> itemData, String epcHex) async {
    final now = FieldValue.serverTimestamp();

    final Map<String, dynamic> payload =
        Map<String, dynamic>.from(itemData['payload'] ?? itemData);
    final scrapData = {
      "person": "تحويل",
      "type": "transform",
      "createdAt": now,
      "date": now,
      ...payload,
    };

    try {
      final d = await findItemByEpc(epcHex);
      if (d == null) return;

      await itemsCol().doc(d['id']).delete();
      await _db
          .collection('users')
          .doc(uid)
          .collection('scrapTransactions')
          .add(scrapData);
    } catch (_) {}
  }

  /// 🔹 تحويل صنف إلى فرع
  static Future<void> transferToBranch(
      Map<String, dynamic> itemData,
      String epcHex,
      String branchId,
      String branchName,
      String repName,
      String branchUid) async {
    final now = FieldValue.serverTimestamp();
    final payload = itemData['payload'] ?? itemData;
    final category = itemData['category'] ?? '';

    final transferData = {
      'fromUId': uid,
      'branchUid': branchUid,
      "epcHex": epcHex,
      "branchId": branchId,
      "branchName": branchName,
      "rep": repName,
      "createdAt": now,
      "date": now,
      "payload": payload,
      "category": category,
      'status': 'pending',
    };

    await _db
        .collection('users')
        .doc(uid)
        .collection('branchTransfers')
        .add(transferData);

    await _db
        .collection('transferRequests')
        .doc(branchUid)
        .collection('branchTransfers')
        .add(transferData);
  }

  static StreamSubscription? _transferListener;

  static void listenToTransferUpdates() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _transferListener?.cancel();

    final userTransfersRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('branchTransfers')
        .where('status', isEqualTo: 'pending');

    _transferListener = userTransfersRef.snapshots().listen((snapshot) async {
      print(
          "✅Transfer listener triggered: ${snapshot.docs.length} pending items");
      for (var docChange in snapshot.docChanges) {
        final doc = docChange.doc;
        final data = doc.data();
        if (data == null) continue;

        final branchUid = data['branchUid'];
        final epcHex = data['epcHex'];
        if (branchUid == null || epcHex == null) continue;

        final targetTransfersRef = FirebaseFirestore.instance
            .collection('transferRequests')
            .doc(branchUid)
            .collection('branchTransfers');

        final targetSnapshot =
            await targetTransfersRef.where('epcHex', isEqualTo: epcHex).get();

        if (targetSnapshot.docs.isEmpty) continue;

        final targetStatus = targetSnapshot.docs.first.data()['status'];
        final targetDoc = targetSnapshot.docs.first;

        if (targetStatus == 'accepted') {
          final itemsSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('items')
              .where('epcHex', isEqualTo: epcHex)
              .get();

          for (var itemDoc in itemsSnapshot.docs) {
            await itemDoc.reference.delete();
          }

          await doc.reference.update({'status': 'accepted'});
          await targetDoc.reference.delete();
        } else if (targetStatus == 'rejected') {
          await doc.reference.delete();
          await targetDoc.reference.delete();
        }
      }
    });
  }

  static void cancelTransferListener() {
    _transferListener?.cancel();
    _transferListener = null;
  }

  static StreamSubscription? _transferSubscription;
  static bool _isDialogOpen = false;

  static void listenForTransfers(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _transferSubscription?.cancel();

    _transferSubscription = FirebaseFirestore.instance
        .collection('transferRequests')
        .doc(uid)
        .collection('branchTransfers')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        if (_isDialogOpen) {
          Navigator.of(context, rootNavigator: true).pop();
          _isDialogOpen = false;
        }
        return;
      }

      if (!_isDialogOpen) {
        _isDialogOpen = true;
        _showTransfersDialog(context, snapshot.docs);
      }
    });
  }

  static void stopListening() {
    _transferSubscription?.cancel();
  }

  static void _showTransfersDialog(
    BuildContext context,
    List<QueryDocumentSnapshot> docs,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text("وصلك تحويلات جديدة"),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final payload = data['payload'] as Map<String, dynamic>?;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("الفرع: ${data['branchName']}"),
                          Text("المندوب: ${data['rep']}"),
                          Text("رقم الشريحة: ${data['epcHex']}"),
                          Text("التصنيف: ${data['category']}"),
                          if (payload?["carat"] != null)
                            Text("العيار: ${payload?['carat']}"),
                          if (payload?["weight"] != null)
                            Text("الوزن: ${payload?['weight']}"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  await acceptTransfer(data, doc.id);
                                },
                                child: const Text("قبول"),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  await rejectTransfer(doc.id);
                                },
                                child: const Text("رفض"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isDialogOpen = false;
    });
  }

  static Future<void> acceptTransfer(
      Map<String, dynamic> data, String docId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('items')
        .add(data);

    await FirebaseFirestore.instance
        .collection('transferRequests')
        .doc(uid)
        .collection('branchTransfers')
        .doc(docId)
        .update({'status': 'accepted'});
  }

  static Future<void> rejectTransfer(String docId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('transferRequests')
        .doc(uid)
        .collection('branchTransfers')
        .doc(docId)
        .update({'status': 'rejected'});
  }

  /// 🔹 جلب المناديب الخاصة بفرع
  static Future<List<String>> getRepsForBranch(String branchId) async {
    final doc = await branchesCol().doc(branchId).get();
    if (!doc.exists) return [];
    final data = doc.data() as Map<String, dynamic>;
    final reps = data["delegates"];
    if (reps is List) {
      return reps.map((e) => e.toString()).toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> getGeneralBalance() async {
    double gold18 = 0, gold21 = 0, gold22 = 0;
    double barsWeight = 0;

    int stonesCount = 0;
    double stonesCost = 0;

    double cash = 0;
    double network = 0;

    double scrapWeight = 0;

    double creditor = 0;
    double debtor = 0;
    double supply = 0;

    /// ================== الأصناف ==================
    final itemsSnap = await itemsCol().get();
    for (var d in itemsSnap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final payload = Map<String, dynamic>.from(data['payload'] ?? {});
      final weight = (payload['weight'] ?? 0).toDouble();
      final carat = payload['carat'];

      if (carat == 18) gold18 += weight;
      if (carat == 21) gold21 += weight;
      if (carat == 22) gold22 += weight;

      stonesCount += (payload['stonesCount'] ?? 0) as int;
      stonesCost += (payload['stonesCost'] ?? 0).toDouble();

      if (data['category'] == 'bar') {
        barsWeight += weight;
      }
    }

    /// ================== المبيعات ==================
    final salesSnap = await salesCol().get();
    for (var d in salesSnap.docs) {
      final pay = d['payment'];
      if (pay != null) {
        cash += (pay['cash'] ?? 0).toDouble();
        network += (pay['network'] ?? 0).toDouble();
      }
    }

    /// ================== الكسر ==================
    final scrapSnap = await scrapCol().get();
    for (var d in scrapSnap.docs) {
      scrapWeight += (d['weight'] ?? 0).toDouble();
    }

    /// ================== السندات ==================
    final vouchersSnap = await vouchersCol().get();
    for (var d in vouchersSnap.docs) {
      final weight = (d['weight'] ?? 0).toDouble();
      if (d['type'] == 'receipt') {
        creditor += weight;
      } else if (d['type'] == 'payment') {
        debtor += weight;
      }
    }

    /// ================== التوريد ==================
    final depSnap = await depositsCol().get();
    for (var d in depSnap.docs) {
      supply += (d['amount'] ?? 0).toDouble();
    }

    return {
      "gold18": gold18,
      "gold21": gold21,
      "gold22": gold22,
      "barsWeight": barsWeight,
      "stonesCount": stonesCount,
      "stonesCost": stonesCost,
      "cash": cash,
      "network": network,
      "scrapWeight": scrapWeight,
      "creditor": creditor,
      "debtor": debtor,
      "supply": supply,
    };
  }

  /// ================== التعاملات ==================
  static Future<void> sendToExternal({
    required String epc,
    required Map<String, dynamic> itemData,
    required String shopName,
    required String managerName,
    required String sentBy,
  }) async {
    final existing = await externalCol().doc(epc).get();
    if (existing.exists) {
      throw Exception("هذه الشريحة موجودة بالفعل في التعاملات الخارجية");
    }

    await externalCol().doc(epc).set({
      "epc": epc,
      ...itemData,
      "shopName": shopName,
      "managerName": managerName,
      "sentBy": sentBy,
      "sentAt": Timestamp.now(),
      "status": "pending",
    });
  }

  static Stream<QuerySnapshot> getExternalTransactions() {
    return externalCol()
        .where('status', isEqualTo: 'pending')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  static Future<void> returnExternal(String epc) async {
    await externalCol().doc(epc).delete();
  }

  static Future<void> receiveExternalPayment({
    required String epc,
    required Map<String, dynamic> paymentData,
  }) async {
    final d = await findItemByEpc(epc);
    if (d == null) return;

    final itemRef = itemsCol().doc(d['id']);
    final docSnap = await itemRef.get();
    if (!docSnap.exists) return;

    await itemRef.delete();

    final saleData = {
      'itemId': d['id'],
      'epcHex': d['epcHex'],
      'soldAt': FieldValue.serverTimestamp(),
      'category': d['category'],
      'payload': d['payload'],
      'createdAt': FieldValue.serverTimestamp(),
    };

    saleData['payment'] = paymentData;

    await salesCol().add(saleData);
    await externalCol().doc(epc).delete();
  }

  // ✅ إضافة تصريح خروج
  static Future<void> addStatement(
    String epc,
    Map<String, dynamic> item,
    String userId,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Statements')
        .doc(epc)
        .set({
      ...item,
      'StatementDate': FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }

  // ✅ جلب التصاريح
  static Stream<QuerySnapshot> getStatements(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Statements')
        .orderBy('StatementDate', descending: true)
        .snapshots();
  }

  // ✅ إلغاء التصريح
  static Future<void> cancelStatement(String epc, String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Statements')
        .doc(epc)
        .delete();
  }

  static Future<bool> checkIfExists(String epc, String userId) async {
    final q = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Statements')
        .where('epcHex', isEqualTo: epc)
        .where('userId', isEqualTo: userId)
        .get();

    return q.docs.isNotEmpty;
  }
}
