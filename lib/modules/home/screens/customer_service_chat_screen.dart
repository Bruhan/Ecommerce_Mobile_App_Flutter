import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/globals/text_styles.dart';

class CustomerServiceChatScreen extends StatefulWidget {
  const CustomerServiceChatScreen({super.key});

  @override
  State<CustomerServiceChatScreen> createState() =>
      _CustomerServiceChatScreenState();
}

class _CustomerServiceChatScreenState extends State<CustomerServiceChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_Message> _messages = [
    _Message(
      text: 'Hello, good morning.',
      isUser: false,
      time: '10:41 pm',
    ),
    _Message(
      text:
          'I am a Customer Service agent. Is there anything I can help you with?',
      isUser: false,
      time: '10:41 pm',
    ),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _Message(
          text: text,
          isUser: true,
          time: _formatTime(DateTime.now()),
        ),
      );
    });

    _controller.clear();
    _scrollToBottom();

    _simulateSupportReply(text);
  }

  void _simulateSupportReply(String userMessage) {
    Timer(const Duration(milliseconds: 1200), () {
      final reply = _generateAutoReply(userMessage);

      if (!mounted) return;

      setState(() {
        _messages.add(
          _Message(
            text: reply,
            isUser: false,
            time: _formatTime(DateTime.now()),
          ),
        );
      });

      _scrollToBottom();
    });
  }

  String _generateAutoReply(String message) {
    final msg = message.toLowerCase();

    if (msg.contains('order')) {
      return 'I understand you’re having an issue with your order. Could you please share your order ID?';
    }
    if (msg.contains('payment')) {
      return 'Sorry about the payment trouble. Did the payment fail or was the amount deducted?';
    }
    if (msg.contains('refund')) {
      return 'Refunds usually take 5–7 business days. May I know your order ID to check the status?';
    }
    if (msg.contains('delivery')) {
      return 'I can help you with delivery details. Could you confirm your delivery location?';
    }

    return 'Thank you for reaching out. Please provide more details so I can assist you better.';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : time.hour == 0
            ? 12
            : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $period';
  }

  Widget _bubble(_Message msg) {
    final isUser = msg.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.black : const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          msg.text,
          style: AppTextStyles.body.copyWith(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _time(String time, {bool right = false}) {
    return Align(
      alignment: right ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 6),
        child: Text(
          time,
          style: AppTextStyles.caption,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Service'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {
              // TODO: Call support
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),

            // Today label
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Today'),
            ),

            const SizedBox(height: AppSpacing.md),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _bubble(msg),
                      _time(msg.time, right: msg.isUser),
                    ],
                  );
                },
              ),
            ),

            // Input bar
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Write your message...',
                        hintStyle: AppTextStyles.caption,
                        prefixIcon: const Icon(Icons.image_outlined),
                        filled: true,
                        fillColor: AppColors.fieldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final String time;

  _Message({
    required this.text,
    required this.isUser,
    required this.time,
  });
}
