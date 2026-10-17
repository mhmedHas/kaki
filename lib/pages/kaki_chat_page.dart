// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// import '../services/kaki_ai_service.dart';

// /// ============================================================
// /// KAKI CHAT — Gold Luxury Theme
// /// نفس ألوان صفحة "بقايا الأطقم" الرئيسية
// /// ============================================================

// const Color _kGold = Color(0xFFD4AF37);
// const Color _kGoldDark = Color(0xFFB8860B);

// /// Suggested prompts — each has an icon + category so a merchant
// /// can tap-to-ask in one gesture.
// class _Suggestion {
//   final IconData icon;
//   final String category;
//   final String question;
//   const _Suggestion({
//     required this.icon,
//     required this.category,
//     required this.question,
//   });
// }

// const List<_Suggestion> _kSuggestedQuestions = [
//   _Suggestion(
//     icon: Icons.inventory_2_outlined,
//     category: 'المخزون',
//     question: 'إجمالي عدد القطع ووزن الذهب؟',
//   ),
//   _Suggestion(
//     icon: Icons.scale_outlined,
//     category: 'الأوزان',
//     question: 'اعرضلي الوزن حسب نوع القطعة.',
//   ),
//   _Suggestion(
//     icon: Icons.diamond_outlined,
//     category: 'العيارات',
//     question: 'اعرضلي توزيع الذهب حسب العيار.',
//   ),
//   _Suggestion(
//     icon: Icons.account_balance_wallet_outlined,
//     category: 'القيمة',
//     question: 'ما إجمالي قيمة المخزون؟',
//   ),
//   _Suggestion(
//     icon: Icons.bar_chart_rounded,
//     category: 'تحليل',
//     question: 'ما أكثر أنواع الذهب الموجودة عندي؟',
//   ),
// ];

// class KakiChatPage extends StatefulWidget {
//   const KakiChatPage({super.key});

//   @override
//   State<KakiChatPage> createState() => _KakiChatPageState();
// }

// class _KakiChatPageState extends State<KakiChatPage> {
//   final _controller = TextEditingController();
//   final _scrollController = ScrollController();
//   final List<_KakiMessage> _messages = [];
//   bool _loading = false;

//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _sendMessage([String? presetQuestion]) async {
//     final question = (presetQuestion ?? _controller.text).trim();
//     if (question.isEmpty || _loading) return;

//     _controller.clear();
//     setState(() {
//       _messages.add(_KakiMessage(text: question, fromUser: true));
//       _loading = true;
//     });
//     _scrollToBottom();

//     try {
//       final answer = await KakiAiService.ask(question);
//       if (!mounted) return;
//       setState(() {
//         _messages.add(_KakiMessage(text: answer, fromUser: false));
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _messages.add(
//           _KakiMessage(
//             text: e is KakiAiException
//                 ? e.message
//                 : 'حدث خطأ أثناء الاتصال بكاكي. حاول مرة أخرى.',
//             fromUser: false,
//             isError: true,
//           ),
//         );
//       });
//     } finally {
//       if (!mounted) return;
//       setState(() => _loading = false);
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!_scrollController.hasClients) return;
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 250),
//         curve: Curves.easeOut,
//       );
//     });
//   }

//   void _clearChat() {
//     setState(() => _messages.clear());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: theme.colorScheme.surface,
//         appBar: _buildAppBar(),
//         body: Column(
//           children: [
//             Expanded(
//               child: _messages.isEmpty
//                   ? _EmptyState(onSuggestionTap: _sendMessage)
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final message = _messages[index];
//                         return _MessageBubble(message: message);
//                       },
//                     ),
//             ),
//             if (_loading) _buildThinkingIndicator(),
//             _Composer(
//               controller: _controller,
//               enabled: !_loading,
//               onSend: () => _sendMessage(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: _kGold,
//       foregroundColor: Colors.white,
//       titleSpacing: 12,
//       flexibleSpace: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [_kGold, _kGoldDark],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//         ),
//       ),
//       title: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.22),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.auto_awesome,
//               size: 20,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(width: 10),
//           const Text(
//             'شات كاكي',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         if (_messages.isNotEmpty)
//           IconButton(
//             onPressed: _loading ? null : _clearChat,
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             tooltip: 'محادثة جديدة',
//           ),
//       ],
//     );
//   }

//   Widget _buildThinkingIndicator() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: _kGold.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: _kGold.withOpacity(0.25)),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: _kGold,
//               ),
//             ),
//             SizedBox(width: 10),
//             Text(
//               'كاكي يفكر...',
//               style: TextStyle(
//                 color: _kGoldDark,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // MESSAGE MODEL
// // ============================================================
// class _KakiMessage {
//   final String text;
//   final bool fromUser;
//   final bool isError;

//   const _KakiMessage({
//     required this.text,
//     required this.fromUser,
//     this.isError = false,
//   });
// }

// // ============================================================
// // MESSAGE BUBBLE — زى الرد الحالى بالظبط
// // ============================================================
// class _MessageBubble extends StatelessWidget {
//   final _KakiMessage message;

//   const _MessageBubble({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     final isUser = message.fromUser;
//     final isError = message.isError;

//     // ===== ألوان الفقاعة =====
//     final Color bubbleColor = isUser
//         ? _kGold
//         : isError
//             ? const Color(0xFFFFEBEE)
//             : Colors.white;

//     final Color foreground = isUser
//         ? Colors.white
//         : isError
//             ? const Color(0xFFB71C1C)
//             : const Color(0xFF2B2B2B);

//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 760),
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           gradient: isUser
//               ? const LinearGradient(
//                   colors: [_kGold, _kGoldDark],
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                 )
//               : null,
//           color: isUser ? null : bubbleColor,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(20),
//             topRight: const Radius.circular(20),
//             bottomLeft: Radius.circular(isUser ? 20 : 4),
//             bottomRight: Radius.circular(isUser ? 4 : 20),
//           ),
//           border: isUser
//               ? null
//               : Border.all(
//                   color: isError
//                       ? const Color(0xFFB71C1C).withOpacity(0.25)
//                       : _kGold.withOpacity(0.30),
//                   width: 1,
//                 ),
//           boxShadow: [
//             BoxShadow(
//               color: (isUser ? _kGoldDark : Colors.black)
//                   .withOpacity(isUser ? 0.20 : 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (!isUser) ...[
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 22,
//                       height: 22,
//                       decoration: BoxDecoration(
//                         color: _kGold.withOpacity(0.15),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.auto_awesome,
//                         size: 12,
//                         color: isError ? const Color(0xFFB71C1C) : _kGold,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       isError ? 'خطأ' : 'كاكي',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: isError ? const Color(0xFFB71C1C) : _kGoldDark,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//               ],
//               if (isUser)
//                 SelectableText(
//                   message.text,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     height: 1.5,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 )
//               else
//                 MarkdownBody(
//                   data: message.text,
//                   selectable: true,
//                   styleSheet: MarkdownStyleSheet(
//                     p: TextStyle(
//                       color: foreground,
//                       fontSize: 15,
//                       height: 1.6,
//                     ),
//                     h1: TextStyle(
//                       color: isError ? const Color(0xFFB71C1C) : _kGoldDark,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     h2: TextStyle(
//                       color: isError ? const Color(0xFFB71C1C) : _kGoldDark,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     h3: TextStyle(
//                       color: isError ? const Color(0xFFB71C1C) : _kGoldDark,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     strong: TextStyle(
//                       color: isError ? const Color(0xFFB71C1C) : _kGoldDark,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     em: const TextStyle(fontStyle: FontStyle.italic),
//                     code: const TextStyle(
//                       backgroundColor: Color(0x1FD4AF37),
//                       color: _kGoldDark,
//                       fontFamily: 'monospace',
//                     ),
//                     codeblockDecoration: BoxDecoration(
//                       color: _kGold.withOpacity(0.06),
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: _kGold.withOpacity(0.2)),
//                     ),
//                     listBullet: const TextStyle(color: _kGoldDark),
//                     tableHead: const TextStyle(
//                       color: _kGoldDark,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     tableBody: TextStyle(color: foreground, fontSize: 14),
//                     tableBorder: TableBorder.all(
//                       color: const Color.fromARGB(255, 0, 0, 0),
//                     ),
//                     tableCellsPadding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 6,
//                     ),
//                     blockquoteDecoration: BoxDecoration(
//                       color:
//                           const Color.fromARGB(255, 0, 0, 0).withOpacity(0.06),
//                       border: const Border(
//                         right: BorderSide(color: _kGold, width: 3),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // EMPTY STATE — أول ما يفتح الشات
// // ============================================================
// class _EmptyState extends StatelessWidget {
//   final ValueChanged<String> onSuggestionTap;

//   const _EmptyState({required this.onSuggestionTap});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // ===== Avatar =====

//           // ===== Welcome =====
//           const Text(
//             'أهلاً بك في شات كاكي',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: _kGoldDark,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'مساعدك الذكي لتحليل المخزون والمبيعات — اسألني في أي وقت ✨',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               height: 1.6,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 28),

//           // ===== Section title =====
//           Row(
//             children: [
//               Container(
//                 width: 4,
//                 height: 18,
//                 decoration: BoxDecoration(
//                   color: _kGold,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 'جرّب تسأل عن:',
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: _kGoldDark,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),

//           // ===== Suggestion cards =====
//           ..._kSuggestedQuestions.map(
//             (s) => _SuggestionCard(
//               suggestion: s,
//               onTap: () => onSuggestionTap(s.question),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================
// // SUGGESTION CARD — بطاقة سؤال بنفس ستايل بطاقات بقايا الأطقم
// // ============================================================
// class _SuggestionCard extends StatelessWidget {
//   final _Suggestion suggestion;
//   final VoidCallback onTap;

//   const _SuggestionCard({
//     required this.suggestion,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         elevation: 0,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: _kGold.withOpacity(0.30),
//                 width: 1,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 // ===== Icon box =====
//                 Container(
//                   width: 46,
//                   height: 46,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [_kGold, _kGoldDark],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: _kGold.withOpacity(0.30),
//                         blurRadius: 8,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     suggestion.icon,
//                     color: Colors.white,
//                     size: 22,
//                   ),
//                 ),
//                 const SizedBox(width: 12),

//                 // ===== Texts =====
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         suggestion.category,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: _kGoldDark,
//                         ),
//                       ),
//                       const SizedBox(height: 3),
//                       Text(
//                         suggestion.question,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF2B2B2B),
//                           height: 1.4,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 6),

//                 // ===== Arrow =====
//                 Icon(
//                   Icons.arrow_back_ios_new,
//                   size: 14,
//                   color: _kGold.withOpacity(0.7),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================
// // COMPOSER — شريط الكتابة
// // ============================================================
// class _Composer extends StatelessWidget {
//   final TextEditingController controller;
//   final bool enabled;
//   final VoidCallback onSend;

//   const _Composer({
//     required this.controller,
//     required this.enabled,
//     required this.onSend,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border(
//             top: BorderSide(color: _kGold.withOpacity(0.25), width: 1),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: controller,
//                 enabled: enabled,
//                 minLines: 1,
//                 maxLines: 5,
//                 textInputAction: TextInputAction.send,
//                 style: const TextStyle(fontSize: 15),
//                 decoration: InputDecoration(
//                   hintText: 'اكتب سؤالك لكاكي...',
//                   hintStyle: TextStyle(color: Colors.grey[500]),
//                   prefixIcon: const Icon(
//                     Icons.chat_bubble_outline,
//                     color: _kGold,
//                   ),
//                   filled: true,
//                   fillColor: _kGold.withOpacity(0.06),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide.none,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide(
//                       color: _kGold.withOpacity(0.25),
//                       width: 1,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: const BorderSide(color: _kGold, width: 2),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 18,
//                     vertical: 14,
//                   ),
//                 ),
//                 onSubmitted: (_) {
//                   if (enabled) onSend();
//                 },
//               ),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: enabled
//                     ? const LinearGradient(
//                         colors: [_kGold, _kGoldDark],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       )
//                     : null,
//                 color: enabled ? null : Colors.grey[300],
//                 shape: BoxShape.circle,
//                 boxShadow: enabled
//                     ? [
//                         BoxShadow(
//                           color: _kGold.withOpacity(0.35),
//                           blurRadius: 10,
//                           offset: const Offset(0, 3),
//                         ),
//                       ]
//                     : [],
//               ),
//               child: IconButton(
//                 onPressed: enabled ? onSend : null,
//                 icon: const Icon(Icons.send, color: Colors.white),
//                 tooltip: 'إرسال',
//                 style: IconButton.styleFrom(
//                   minimumSize: const Size(48, 48),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../services/kaki_ai_service.dart';

/// ============================================================
/// KAKI CHAT — Gold Luxury Theme
/// ============================================================

const Color _kGold = Color(0xFFD4AF37);
const Color _kGoldDark = Color(0xFFB8860B);

class _Suggestion {
  final IconData icon;
  final String category;
  final String question;
  const _Suggestion({
    required this.icon,
    required this.category,
    required this.question,
  });
}

const List<_Suggestion> _kSuggestedQuestions = [
  _Suggestion(
    icon: Icons.inventory_2_outlined,
    category: 'المخزون',
    question: 'إجمالي عدد القطع ووزن الذهب؟',
  ),
  _Suggestion(
    icon: Icons.scale_outlined,
    category: 'الأوزان',
    question: 'اعرضلي الوزن حسب نوع القطعة.',
  ),
  _Suggestion(
    icon: Icons.diamond_outlined,
    category: 'العيارات',
    question: 'اعرضلي توزيع الذهب حسب العيار.',
  ),
  _Suggestion(
    icon: Icons.account_balance_wallet_outlined,
    category: 'القيمة',
    question: 'ما إجمالي قيمة المخزون؟',
  ),
  _Suggestion(
    icon: Icons.bar_chart_rounded,
    category: 'تحليل',
    question: 'ما أكثر أنواع الذهب الموجودة عندي؟',
  ),
];

class KakiChatPage extends StatefulWidget {
  const KakiChatPage({super.key});

  @override
  State<KakiChatPage> createState() => _KakiChatPageState();
}

class _KakiChatPageState extends State<KakiChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_KakiMessage> _messages = [];
  bool _loading = false;

  /// null = بنتحقق، true = الشات مفتوح، false = مقفول
  bool? _unlocked;

  @override
  void initState() {
    super.initState();
    _checkUnlock();
  }

  Future<void> _checkUnlock() async {
    final ok = await KakiPasswordService.isUnlocked();
    if (!mounted) return;
    setState(() => _unlocked = ok);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? presetQuestion]) async {
    final question = (presetQuestion ?? _controller.text).trim();
    if (question.isEmpty || _loading) return;

    _controller.clear();
    setState(() {
      _messages.add(_KakiMessage(text: question, fromUser: true));
      _loading = true;
    });
    _scrollToBottom();

    try {
      final answer = await KakiAiService.ask(question);
      if (!mounted) return;
      setState(() {
        _messages.add(_KakiMessage(text: answer, fromUser: false));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _KakiMessage(
            text: e is KakiAiException
                ? e.message
                : 'حدث خطأ أثناء الاتصال بكاكي. حاول مرة أخرى.',
            fromUser: false,
            isError: true,
          ),
        );
      });
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _clearChat() {
    setState(() => _messages.clear());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // لسه بنتحقق
    if (_unlocked == null) {
      return const Center(
        child: CircularProgressIndicator(color: _kGold),
      );
    }

    // مقفول → شاشة الباسورد
    if (_unlocked == false) {
      return _KakiLockScreen(
        onUnlocked: () => setState(() => _unlocked = true),
      );
    }

    // مفتوح → الشات
    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? _EmptyState(onSuggestionTap: _sendMessage)
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _MessageBubble(message: message);
                  },
                ),
        ),
        if (_loading) _buildThinkingIndicator(),
        _Composer(
          controller: _controller,
          enabled: !_loading,
          onSend: () => _sendMessage(),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: _kGold,
      foregroundColor: Colors.white,
      titleSpacing: 12,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_kGold, _kGoldDark],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'شات كاكي',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        if (_unlocked == true && _messages.isNotEmpty)
          IconButton(
            onPressed: _loading ? null : _clearChat,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'محادثة جديدة',
          ),
      ],
    );
  }

  Widget _buildThinkingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _kGold.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _kGold.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _kGold,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'كاكي يفكر...',
              style: TextStyle(
                color: _kGoldDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 🔐 LOCK SCREEN — شاشة الباسورد
// ============================================================
class _KakiLockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;
  const _KakiLockScreen({required this.onUnlocked});

  @override
  State<_KakiLockScreen> createState() => _KakiLockScreenState();
}

class _KakiLockScreenState extends State<_KakiLockScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  Future<void> _tryUnlock() async {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      setState(() => _error = 'اكتب الباسورد أولاً.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final ok = await KakiPasswordService.verifyPassword(input);
      if (!ok) {
        setState(() {
          _loading = false;
          _error = '❌ الباسورد غير صحيح';
        });
        return;
      }
      await KakiPasswordService.markUnlocked();
      if (!mounted) return;
      widget.onUnlocked();
    } catch (e) {
      setState(() {
        _loading = false;
        _error = '$e';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kGold.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_kGold, _kGoldDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'شات كاكي محمي',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _kGoldDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'أدخل الباسورد لفتح الشات',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                obscureText: _obscure,
                autofocus: true,
                enabled: !_loading,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, letterSpacing: 4),
                decoration: InputDecoration(
                  hintText: '••••',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                      color: _kGold,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  filled: true,
                  fillColor: _kGold.withOpacity(0.06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: _kGold.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _kGold, width: 2),
                  ),
                ),
                onSubmitted: (_) => _tryUnlock(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Color(0xFFB71C1C),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _tryUnlock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kGold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'فتح',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MESSAGE MODEL
// ============================================================
class _KakiMessage {
  final String text;
  final bool fromUser;
  final bool isError;

  const _KakiMessage({
    required this.text,
    required this.fromUser,
    this.isError = false,
  });
}

// ============================================================
// MESSAGE BUBBLE
// ============================================================
class _MessageBubble extends StatelessWidget {
  final _KakiMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.fromUser;
    final isError = message.isError;

    final Color bubbleColor = isUser
        ? _kGold
        : isError
            ? const Color(0xFFFFEBEE)
            : Colors.white;

    final Color foreground = isUser
        ? Colors.white
        : isError
            ? const Color(0xFFB71C1C)
            : const Color(0xFF2B2B2B);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 760),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
                  colors: [_kGold, _kGoldDark],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                )
              : null,
          color: isUser ? null : bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          border: isUser
              ? null
              : Border.all(
                  color: isError
                      ? const Color(0xFFB71C1C).withOpacity(0.25)
                      : _kGold.withOpacity(0.30),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: (isUser ? _kGoldDark : Colors.black)
                  .withOpacity(isUser ? 0.20 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _kGold.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_awesome,
                        size: 12,
                        color: isError ? const Color(0xFFB71C1C) : _kGold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isError ? 'خطأ' : 'كاكي',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isError ? const Color(0xFFB71C1C) : _kGoldDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              if (isUser)
                SelectableText(
                  message.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                )
              else
                MarkdownBody(
                  data: message.text,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: foreground,
                      fontSize: 15,
                      height: 1.6,
                    ),
                    h1: TextStyle(
                      color: isError ? const Color(0xFFB71C1C) : _kGoldDark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    h2: TextStyle(
                      color: isError ? const Color(0xFFB71C1C) : _kGoldDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    h3: TextStyle(
                      color: isError ? const Color(0xFFB71C1C) : _kGoldDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    strong: TextStyle(
                      color: isError ? const Color(0xFFB71C1C) : _kGoldDark,
                      fontWeight: FontWeight.bold,
                    ),
                    em: const TextStyle(fontStyle: FontStyle.italic),
                    code: const TextStyle(
                      backgroundColor: Color(0x1FD4AF37),
                      color: _kGoldDark,
                      fontFamily: 'monospace',
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: _kGold.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _kGold.withOpacity(0.2)),
                    ),
                    listBullet: const TextStyle(color: _kGoldDark),
                    tableHead: const TextStyle(
                      color: _kGoldDark,
                      fontWeight: FontWeight.bold,
                    ),
                    tableBody: TextStyle(color: foreground, fontSize: 14),
                    tableBorder: TableBorder.all(
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    tableCellsPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    blockquoteDecoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.06),
                      border: const Border(
                        right: BorderSide(color: _kGold, width: 3),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY STATE
// ============================================================
class _EmptyState extends StatelessWidget {
  final ValueChanged<String> onSuggestionTap;

  const _EmptyState({required this.onSuggestionTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'أهلاً بك في شات كاكي',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _kGoldDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'مساعدك الذكي لتحليل المخزون والمبيعات — اسألني في أي وقت ✨',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: _kGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'جرّب تسأل عن:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _kGoldDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._kSuggestedQuestions.map(
            (s) => _SuggestionCard(
              suggestion: s,
              onTap: () => onSuggestionTap(s.question),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final _Suggestion suggestion;
  final VoidCallback onTap;

  const _SuggestionCard({
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _kGold.withOpacity(0.30),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_kGold, _kGoldDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _kGold.withOpacity(0.30),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    suggestion.icon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _kGoldDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        suggestion.question,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2B2B2B),
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.arrow_back_ios_new,
                  size: 14,
                  color: _kGold.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// COMPOSER
// ============================================================
class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;

  const _Composer({
    required this.controller,
    required this.enabled,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: _kGold.withOpacity(0.25), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'اكتب سؤالك لكاكي...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: const Icon(
                    Icons.chat_bubble_outline,
                    color: _kGold,
                  ),
                  filled: true,
                  fillColor: _kGold.withOpacity(0.06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: _kGold.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: _kGold, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) {
                  if (enabled) onSend();
                },
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                gradient: enabled
                    ? const LinearGradient(
                        colors: [_kGold, _kGoldDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: enabled ? null : Colors.grey[300],
                shape: BoxShape.circle,
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: _kGold.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: IconButton(
                onPressed: enabled ? onSend : null,
                icon: const Icon(Icons.send, color: Colors.white),
                tooltip: 'إرسال',
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
