import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

import '../../../globals/text_styles.dart';

/// FiltersBottomSheet
/// - Safe, theme-aware bottom sheet for bookstore filters.
/// - Uses fallbacks if AppColors / AppTextStyles are missing so it
///   will always be visible (useful when testing).
class FiltersBottomSheet {
  /// Show the filters bottom sheet and return selected filters or null.
  static Future<Map<String, dynamic>?> show(BuildContext context, {Map<String, dynamic>? initial}) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // keep overlay rounded corners
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => _FilterSheetContent(controller: controller, initial: initial ?? {}),
      ),
    );
  }
}

class _FilterSheetContent extends StatefulWidget {
  final ScrollController controller;
  final Map<String, dynamic> initial;
  const _FilterSheetContent({Key? key, required this.controller, required this.initial}) : super(key: key);

  @override
  State<_FilterSheetContent> createState() => _FilterSheetContentState();
}

class _FilterSheetContentState extends State<_FilterSheetContent> {
  // Sort options
  final List<String> _sortOptions = ['Relevance shit', 'Price: Low - High', 'Price: High - Low', 'Newest', 'Top Rated'];
  String _selectedSort = 'Relevance';

  // Price range (defaults)
  double _priceMin = 0;
  double _priceMax = 2000;
  RangeValues _selectedRange = const RangeValues(0, 2000);

  // Formats
  final List<String> _formats = ['Paperback', 'Hardcover', 'eBook', 'Audiobook'];
  final Set<String> _selectedFormats = {};

  // Genres (example)
  final List<String> _genres = [
    'Programming',
    'Fiction',
    'Business',
    'Self-Help',
    'Science',
    'Education',
    'Technology',
    'Exam Prep',
    'Design',
  ];
  final Set<String> _selectedGenres = {};

  // Author
  final TextEditingController _authorController = TextEditingController();

  // Languages
  final List<String> _languages = ['English', 'Tamil', 'Hindi', 'Telugu', 'Kannada'];
  final Set<String> _selectedLanguages = {};

  // Rating
  final List<String> _ratingLabels = ['4★ & up', '3★ & up', '2★ & up', 'Any'];
  String _selectedRating = 'Any';

  @override
  void initState() {
    super.initState();
    _applyInitial();
  }

  void _applyInitial() {
    final init = widget.initial;
    if (init.isEmpty) return;

    if (init['sort'] is String) _selectedSort = init['sort'];
    if (init['priceRange'] is List && (init['priceRange'] as List).length >= 2) {
      final lr = init['priceRange'] as List;
      _selectedRange = RangeValues((lr[0] as num).toDouble(), (lr[1] as num).toDouble());
    }
    if (init['formats'] is List) _selectedFormats.addAll(List<String>.from(init['formats']));
    if (init['genres'] is List) _selectedGenres.addAll(List<String>.from(init['genres']));
    if (init['author'] is String) _authorController.text = init['author'];
    if (init['languages'] is List) _selectedLanguages.addAll(List<String>.from(init['languages']));
    if (init['rating'] is String) _selectedRating = init['rating'];
  }

  void _clearAll() {
    setState(() {
      _selectedSort = 'Relevance';
      _selectedRange = RangeValues(_priceMin, _priceMax);
      _selectedFormats.clear();
      _selectedGenres.clear();
      _authorController.clear();
      _selectedLanguages.clear();
      _selectedRating = 'Any';
    });
  }

  void _apply() {
    final Map<String, dynamic> filters = {
      'sort': _selectedSort,
      'priceRange': [_selectedRange.start.toInt(), _selectedRange.end.toInt()],
      'formats': _selectedFormats.toList(),
      'genres': _selectedGenres.toList(),
      'author': _authorController.text.trim(),
      'languages': _selectedLanguages.toList(),
      'rating': _selectedRating,
    };
    Navigator.of(context).pop(filters);
  }

  // Safe getters with fallback values (ensures visibility even if theme missing)
  Color get _bgColor => AppColors.bg ?? Colors.white;
  Color get _cardColor => AppColors.surface ?? Colors.grey.shade50;
  Color get _primary => AppColors.primary ?? Colors.black;
  Color get _borderColor => AppColors.fieldBorder ?? Colors.grey.shade300;
  TextStyle get _titleStyle => AppTextStyles.h2?.copyWith(fontSize: 18) ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  TextStyle get _bodyStyle => AppTextStyles.body ?? const TextStyle(fontSize: 14);
  TextStyle get _captionStyle => AppTextStyles.caption ?? const TextStyle(fontSize: 12, color: Colors.grey);

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: _titleStyle),
    );
  }

  Widget _chip(String label, {required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _primary : _cardColor,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(color: selected ? _primary : _borderColor),
        ),
        child: Text(label, style: selected ? _bodyStyle.copyWith(color: Colors.white) : _bodyStyle),
      ),
    );
  }

  @override
  void dispose() {
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If you want the slider max to be dynamic, compute from products; use constant for now.
    final double maxPriceValue = 2000;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12)],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(child: Text('Filters', style: _titleStyle)),
                  TextButton(
                    onPressed: _clearAll,
                    child: Text('Clear all', style: _captionStyle.copyWith(color: _primary)),
                  ),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close, color: AppColors.textPrimary ?? Colors.black)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Content
              Expanded(
                child: ListView(
                  controller: widget.controller,
                  children: [
                    // Sort
                    _sectionTitle('Sort By'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sortOptions.map((s) {
                        final sel = s == _selectedSort;
                        return _chip(s, selected: sel, onTap: () => setState(() => _selectedSort = s));
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Price
                    _sectionTitle('Price'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RangeSlider(
                            values: _selectedRange,
                            min: _priceMin,
                            max: maxPriceValue,
                            divisions: 20,
                            labels: RangeLabels('₹${_selectedRange.start.toInt()}', '₹${_selectedRange.end.toInt()}'),
                            onChanged: (rv) => setState(() => _selectedRange = rv),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('₹${_selectedRange.start.toInt()}', style: _captionStyle),
                              Text('₹${_selectedRange.end.toInt()}', style: _captionStyle),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Format
                    _sectionTitle('Format'),
                    Wrap(
                      spacing: 10,
                      children: _formats.map((f) {
                        final sel = _selectedFormats.contains(f);
                        return _chip(f, selected: sel, onTap: () {
                          setState(() {
                            if (sel) _selectedFormats.remove(f);
                            else _selectedFormats.add(f);
                          });
                        });
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Genres
                    _sectionTitle('Genres'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _genres.map((g) {
                        final sel = _selectedGenres.contains(g);
                        return _chip(g, selected: sel, onTap: () {
                          setState(() {
                            if (sel) _selectedGenres.remove(g);
                            else _selectedGenres.add(g);
                          });
                        });
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Author
                    _sectionTitle('Author'),
                    TextField(
                      controller: _authorController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Search author name',
                        filled: true,
                        fillColor: _cardColor,
                        prefixIcon: const Icon(Icons.person_search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.md), borderSide: BorderSide.none),
                      ),
                      onSubmitted: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Language
                    _sectionTitle('Language'),
                    Wrap(
                      spacing: 8,
                      children: _languages.map((l) {
                        final sel = _selectedLanguages.contains(l);
                        return _chip(l, selected: sel, onTap: () {
                          setState(() {
                            if (sel) _selectedLanguages.remove(l);
                            else _selectedLanguages.add(l);
                          });
                        });
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Rating
                    _sectionTitle('Rating'),
                    Wrap(
                      spacing: 10,
                      children: _ratingLabels.map((r) {
                        final sel = _selectedRating == r;
                        return _chip(r, selected: sel, onTap: () => setState(() => _selectedRating = r));
                      }).toList(),
                    ),
                    const SizedBox(height: AppSpacing.xl * 0.8),
                  ],
                ),
              ),

              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _apply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text('Apply Filters', style: _bodyStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
