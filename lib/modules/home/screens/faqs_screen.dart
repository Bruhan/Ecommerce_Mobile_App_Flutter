import 'package:flutter/material.dart';
import '../../../globals/theme.dart';
import '../../../globals/text_styles.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  int _selectedTab = 0;

  final _tabs = const ['General', 'Account', 'Service', 'Payment'];

  final Map<String, List<Map<String, String>>> _faqData = {
    'General': [
      {
        'q': 'How do I make a purchase?',
        'a':
            'Browse books, open a product, tap “Add to Cart”, and follow the checkout steps.'
      },
      {
        'q': 'How do I track my orders?',
        'a': 'Go to My Orders in the Account section to track your order.'
      },
    ],
    'Account': [
      {
        'q': 'How do I update my profile?',
        'a': 'Go to Account → My Details and update your information.'
      },
    ],
    'Service': [
      {
        'q': 'How can I contact customer support?',
        'a': 'Use the Help Center to reach customer service.'
      },
    ],
    'Payment': [
      {
        'q': 'What payment methods are accepted?',
        'a': 'We support cards, UPI, and other digital payment methods.'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentTab = _tabs[_selectedTab];
    final items = _faqData[currentTab] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.md),

          /// Tabs
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final selected = _selectedTab == index;
                return ChoiceChip(
                  label: Text(_tabs[index]),
                  selected: selected,
                  selectedColor: Colors.black,
                  backgroundColor: AppColors.surface,
                  labelStyle: selected
                      ? AppTextStyles.body.copyWith(color: Colors.white)
                      : AppTextStyles.body,
                  onSelected: (_) {
                    setState(() => _selectedTab = index);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          /// Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for questions...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.mic_none),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          /// FAQ List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final item = items[index];
                return _FaqTile(
                  question: item['q']!,
                  answer: item['a']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqTile({
    required this.question,
    required this.answer,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: AppTextStyles.body,
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  widget.answer,
                  style: AppTextStyles.caption,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
