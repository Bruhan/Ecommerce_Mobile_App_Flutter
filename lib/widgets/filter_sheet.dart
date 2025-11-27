// lib/widgets/filter_sheet.dart
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

/// FilterSheet
///
/// A bookstore-focused filter bottom sheet that returns a Map<String,dynamic>
/// of selected filters when the user taps "Apply Filters".
///
/// Returned map keys:
/// - sort: String
/// - priceRange: [min, max] (ints)
/// - formats: List<String>
/// - genres: List<String>
/// - author: String
/// - languages: List<String>
/// - rating: String  (e.g. '4★ & up')
class FilterSheet extends StatefulWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  // Sort options
  final List<String> _sortOptions = ['Relevance', 'Price: Low - High', 'Price: High - Low', 'Newest', 'Top Rated'];
  String _selectedSort = 'Relevance';

  // Price range
  double _priceMin = 0;
  double _priceMax = 2000;
  RangeValues _selectedRange = const RangeValues(0, 2000);

  // Formats
  final List<String> _formats = ['Paperback', 'Hardcover', 'eBook', 'Audiobook'];
  final Set<String> _selectedFormats = {};

  // Genres (example list - replace with your categories if needed)
  final List<String> _genres = [
    'Programming',
    'Fiction',
    'Business',
    'Self-Help',
    'Science',
    'Education',
    'Technology',
    'Academic',
    'Reference'
  ];
  final Set<String> _selectedGenres = {};

  // Author text
  final TextEditingController _authorController = TextEditingController();

  // Languages
  final List<String> _languages = ['English', 'Tamil', 'Hindi', 'Telugu', 'Kannada'];
  final Set<String> _selectedLanguages = {};

  // Rating
  final List<String> _ratingLabels = ['4★ & up', '3★ & up', '2★ & up', 'Any'];
  String _selectedRating = 'Any';

  @override
  void dispose() {
    _authorController.dispose();
    super.dispose();
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

  void _applyFilters() {
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

  // theme-safe getters
  Color get _bg => AppColors.surface ?? Colors.white ;
  // Color get _bg => AppColors.surface ?? Colors.white;
  Color get _card => AppColors.surface ?? Colors.grey.shade50;
  Color get _primary => AppColors.primary ?? Colors.black;
  Color get _border => AppColors.fieldBorder ?? Colors.grey.shade300;
  TextStyle get _titleStyle => AppTextStyles.h2?.copyWith(fontSize: 18) ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  TextStyle get _bodyStyle => AppTextStyles.body ?? const TextStyle(fontSize: 14);
  TextStyle get _captionStyle => AppTextStyles.caption ?? const TextStyle(fontSize: 12, color: Colors.grey);

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t, style: _titleStyle),
      );

  Widget _chip(String label, {required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _primary : _card,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(color: selected ? _primary : _border),
        ),
        child: Text(label, style: selected ? _bodyStyle.copyWith(color: Colors.white) : _bodyStyle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the sheet is large enough and scrollable
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  children: [
                    Expanded(child: Text('Filters', style: _titleStyle)),
                    TextButton(onPressed: _clearAll, child: Text('Clear all', style: _captionStyle.copyWith(color: _primary))),
                    IconButton(icon: Icon(Icons.close, color: AppColors.textPrimary ?? Colors.black), onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // content (scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sort by
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
                        RangeSlider(
                          values: _selectedRange,
                          min: _priceMin,
                          max: _priceMax,
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
                            prefixIcon: const Icon(Icons.person_search),
                            filled: true,
                            fillColor: _card,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.md), borderSide: BorderSide.none),
                          ),
                          onSubmitted: (_) => setState(() {}),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Languages
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
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
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
      ),
    );
  }
}
