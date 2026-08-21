import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfReportsPage extends StatefulWidget {
  const PdfReportsPage({super.key});

  @override
  State<PdfReportsPage> createState() => _PdfReportsPageState();
}

class _PdfReportsPageState extends State<PdfReportsPage> {
  List<FileSystemEntity> pdfFiles = [];
  Directory? targetDir;

  String _lang = 'ar';
  String _t(String ar, String en) => _lang == 'ar' ? ar : en;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadPdfFiles();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lang = prefs.getString('languageCode') ?? 'ar';
    });
  }

  Future<void> _loadPdfFiles() async {
    /*if (Platform.isAndroid) {
      final status = await Permission.manageExternalStorage.status;

      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
    }*/

    Directory dir = Directory("/storage/emulated/0/Download");

    final files = dir
        .listSync()
        .where(
            (file) => file is File && file.path.toLowerCase().endsWith(".pdf"))
        .toList();

    setState(() {
      pdfFiles = files;
    });
  }

  void _openFile(File file) {
    OpenFilex.open(file.path);
  }

  void _shareFile(File file) {
    Share.shareXFiles([XFile(file.path)], text: "📄 تقرير PDF");
  }

  Future<void> _deleteFile(File file) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t("تأكيد الحذف", "Delete Confirmation")),
        content: Text(_t(
          "هل أنت متأكد من حذف الملف؟\n${file.path.split('/').last}",
          "Are you sure you want to delete the file?\n${file.path.split('/').last}",
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_t("إلغاء", "Cancel")),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              _t("حذف", "Delete"),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await file.delete();
        _loadPdfFiles(); // 🔄 تحديث القائمة
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  _t("✅ تم حذف الملف بنجاح", "✅ File deleted successfully"))),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  _t("❌ فشل في حذف الملف: $e", "❌ Failed to delete file: $e"))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t("📁 التقارير المحفوظة", "📁 Saved Reports")),
        backgroundColor: const Color(0xFFD4AF37),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPdfFiles,
          ),
        ],
      ),
      body: pdfFiles.isEmpty
          ? Center(
              child: Text(_t("لا يوجد تقارير محفوظة حالياً",
                  "No saved reports available")))
          : ListView.builder(
              itemCount: pdfFiles.length,
              itemBuilder: (context, index) {
                final file = pdfFiles[index] as File;
                final name = file.path.split('/').last;
                final modified =
                    file.statSync().modified.toLocal().toString().split('.')[0];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading:
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                    title: Text(name),
                    subtitle: Text(_t("تاريخ : $modified", "Date: $modified")),
                    // 👇 الضغط على الصف = فتح مباشر
                    onTap: () => _openFile(file),
                    // 👇 الثلاث شرط فيها (فتح / مشاركة / حذف)
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'open') _openFile(file);
                        if (value == 'share') _shareFile(file);
                        if (value == 'delete') _deleteFile(file);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'open',
                          child: Row(
                            children: [
                              Icon(Icons.open_in_new, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(_t("فتح", "Open")),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(Icons.share, color: Colors.green),
                              SizedBox(width: 8),
                              Text(_t("مشاركة", "Share")),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text(_t("حذف", "Delete")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
