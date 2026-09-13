import 'package:flutter/material.dart';

import '../services/kaki_ai_service.dart';

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

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final question = _controller.text.trim();
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome),
              SizedBox(width: 8),
              Text('شات كاكي'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _EmptyState(color: scheme.primary)
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
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Text('كاكي يفكر...'),
                  ],
                ),
              ),
            _Composer(
              controller: _controller,
              enabled: !_loading,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

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

class _MessageBubble extends StatelessWidget {
  final _KakiMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = message.fromUser
        ? scheme.primary
        : message.isError
            ? scheme.errorContainer
            : scheme.surfaceContainerHighest;
    final foreground = message.fromUser
        ? scheme.onPrimary
        : message.isError
            ? scheme.onErrorContainer
            : scheme.onSurface;

    return Align(
      alignment:
          message.fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 760),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.fromUser ? 18 : 4),
            bottomRight: Radius.circular(message.fromUser ? 4 : 18),
          ),
        ),
        child: SelectableText(
          message.text,
          style: TextStyle(
            color: foreground,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Color color;

  const _EmptyState({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 64, color: color),
            const SizedBox(height: 16),
            const Text(
              'أهلاً بك في شات كاكي',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'اسأل كاكي عن بيانات نشاطك التجاري وسيقوم الموديل بتحليل البيانات والرد عليك.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'اكتب سؤالك لكاكي...',
                  prefixIcon: const Icon(Icons.chat_bubble_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onSubmitted: (_) {
                  if (enabled) onSend();
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: enabled ? onSend : null,
              icon: const Icon(Icons.send),
              tooltip: 'إرسال',
            ),
          ],
        ),
      ),
    );
  }
}
