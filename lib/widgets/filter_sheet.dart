import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
<<<<<<< HEAD
import 'package:ecommerce_mobile/network/api_service.dart'; // Ensure this is imported
import 'package:ecommerce_mobile/models/author_model.dart'; // Ensure this is imported

=======

/// Returned map keys:
/// - sort: String
/// - priceRange: [min, max] (ints)
/// - priceBuckets: List<int> (selected bucket indices)
/// - formats: List<String>
/// - genres: List<String>
/// - categories: List<String>
/// - subCategories: List<String>
/// - authors: List<String>
/// - author: String (text search)
/// - languages: List<String>
/// - academic: List<String>
/// - merchandise: List<String>
/// - rating: String  (e.g. '4★ & up')
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
class FilterSheet extends StatefulWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
<<<<<<< HEAD
  final ApiService _apiService = ApiService();

=======
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
  // Sort options
  final List<String> _sortOptions = ['Relevance', 'Price: Low - High', 'Price: High - Low', 'Newest', 'Top Rated'];
  String _selectedSort = 'Relevance';

  // Price range
  double _priceMin = 0;
  double _priceMax = 3000;
  RangeValues _selectedRange = const RangeValues(0, 2000);

<<<<<<< HEAD
=======
  
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
  final List<Map<String, dynamic>> _priceBuckets = [
    {'label': 'Rs. 0 - Rs. 100', 'start': 0, 'end': 100},
    {'label': 'Rs. 101 - Rs. 200', 'start': 101, 'end': 200},
    {'label': 'Rs. 201 - Rs. 400', 'start': 201, 'end': 400},
    {'label': 'Rs. 401 - Rs. 1000', 'start': 401, 'end': 1000},
    {'label': 'Rs. 1001 - Rs. 3000', 'start': 1001, 'end': 3000},
    {'label': 'Rs. 3000 above', 'start': 3001, 'end': 999999},
  ];
  final Set<int> _selectedPriceBuckets = {};

<<<<<<< HEAD
  final List<String> _formats = ['Paperback', 'Hardcover', 'eBook', 'Audiobook'];
  final Set<String> _selectedFormats = {};

=======
  // Formats
  final List<String> _formats = ['Paperback', 'Hardcover', 'eBook', 'Audiobook'];
  final Set<String> _selectedFormats = {};

  // Genres (example list)
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

  // Categories + sub-categories (from screenshots)
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
  final List<String> _categories = ['Fantasy', 'Fiction', 'Mythology', 'Art', 'Si-Fi'];
  final Set<String> _selectedCategories = {};

  final List<String> _subCategories = ['Epic', 'Historical', 'Literary', 'Greek', 'Norse', 'Contemporary', 'CyberPunk'];
  final Set<String> _selectedSubCategories = {};

<<<<<<< HEAD
  // --- DYNAMIC DATA STATE ---
  List<Author> _authors = []; // Changed from String to Author model
  final Set<int> _selectedAuthorIds = {}; // Using IDs for API consistency
  
  List<String> _academic = []; 
  final Set<String> _selectedAcademic = {};

  bool _isLoadingAuthors = true;
  bool _isLoadingAcademics = true;
  // --------------------------

  final TextEditingController _authorController = TextEditingController();
  final List<String> _languages = ['English', 'French', 'Germany', 'Hindi', 'Tamil'];
  final Set<String> _selectedLanguages = {};
  final List<String> _merchandise = ['Bookmark', 'Poster'];
  final Set<String> _selectedMerchandise = {};
  final List<String> _ratingLabels = ['4★ & up', '3★ & up', '2★ & up', 'Any'];
  String _selectedRating = 'Any';
  bool _showMoreSubCategories = false;

  @override
  void initState() {
    super.initState();
    _loadDynamicFilters();
  }

  // Fetch data from API on load
  Future<void> _loadDynamicFilters() async {
    try {
      final results = await Future.wait([
        _apiService.fetchAuthors(),
        _apiService.fetchAcademics(),
      ]);

      if (mounted) {
        setState(() {
          _authors = results[0] as List<Author>;
          _academic = results[1] as List<String>;
          _isLoadingAuthors = false;
          _isLoadingAcademics = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingAuthors = false;
          _isLoadingAcademics = false;
        });
      }
      debugPrint("Error loading filters: $e");
    }
  }

  @override
=======
  // Author list from image
  final List<String> _authors = ['Sarah Johnson', 'J. K. Rowling', 'Chetan Bagath', 'Emma Smith'];
  final Set<String> _selectedAuthors = {};

  // Author text input (search)
  final TextEditingController _authorController = TextEditingController();

  // Languages
  final List<String> _languages = ['English', 'French', 'Germany', 'Hindi', 'Tamil'];
  final Set<String> _selectedLanguages = {};

  // Academic (subjects)
  final List<String> _academic = ['Chemistry', 'Physics', 'Mathematics', 'Biology', 'Electrical'];
  final Set<String> _selectedAcademic = {};

  // Merchandise
  final List<String> _merchandise = ['Bookmark', 'Poster'];
  final Set<String> _selectedMerchandise = {};

  // Rating
  final List<String> _ratingLabels = ['4★ & up', '3★ & up', '2★ & up', 'Any'];
  String _selectedRating = 'Any';

  // show more flags
  bool _showMoreCategories = false;
  bool _showMoreSubCategories = false;

  @override
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
  void dispose() {
    _authorController.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      _selectedSort = 'Relevance';
      _selectedRange = RangeValues(_priceMin, _priceMax);
      _selectedPriceBuckets.clear();
      _selectedFormats.clear();
<<<<<<< HEAD
      _selectedCategories.clear();
      _selectedSubCategories.clear();
      _selectedAuthorIds.clear(); // Updated
      _selectedAcademic.clear(); // Updated
      _authorController.clear();
      _selectedLanguages.clear();
      _selectedMerchandise.clear();
      _selectedRating = 'Any';
=======
      _selectedGenres.clear();
      _selectedCategories.clear();
      _selectedSubCategories.clear();
      _selectedAuthors.clear();
      _authorController.clear();
      _selectedLanguages.clear();
      _selectedAcademic.clear();
      _selectedMerchandise.clear();
      _selectedRating = 'Any';
      _showMoreCategories = false;
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
      _showMoreSubCategories = false;
    });
  }

  void _applyFilters() {
    final Map<String, dynamic> filters = {
      'sort': _selectedSort,
      'priceRange': [_selectedRange.start.toInt(), _selectedRange.end.toInt()],
<<<<<<< HEAD
      'categories': _selectedCategories.toList(),
      'authorIds': _selectedAuthorIds.toList(), // Sending IDs to backend
      'academic': _selectedAcademic.toList(),
      'languages': _selectedLanguages.toList(),
      // Add other fields as needed for your search API
=======
      'priceBuckets': _selectedPriceBuckets.toList(),
      'formats': _selectedFormats.toList(),
      'genres': _selectedGenres.toList(),
      'categories': _selectedCategories.toList(),
      'subCategories': _selectedSubCategories.toList(),
      'authors': _selectedAuthors.toList(),
      'author': _authorController.text.trim(),
      'languages': _selectedLanguages.toList(),
      'academic': _selectedAcademic.toList(),
      'merchandise': _selectedMerchandise.toList(),
      'rating': _selectedRating,
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
    };
    Navigator.of(context).pop(filters);
  }

<<<<<<< HEAD
=======
  // theme-safe getters
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
  Color get _bg => AppColors.bg ?? Colors.white;
  Color get _card => AppColors.surface ?? Colors.grey.shade50;
  Color get _primary => AppColors.primary ?? const Color(0xFF326638);
  Color get _border => AppColors.fieldBorder ?? Colors.grey.shade300;
  TextStyle get _titleStyle => AppTextStyles.h2?.copyWith(fontSize: 18) ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  TextStyle get _bodyStyle => AppTextStyles.body ?? const TextStyle(fontSize: 14);
  TextStyle get _captionStyle => AppTextStyles.caption ?? const TextStyle(fontSize: 12, color: Colors.grey);

  Widget _sectionTitle(String t) => Padding(
<<<<<<< HEAD
        padding: const EdgeInsets.only(bottom: 8, top: 16),
=======
        padding: const EdgeInsets.only(bottom: 8),
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
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

  Widget _priceBucketRow(int index) {
    final label = _priceBuckets[index]['label'].toString();
    final selected = _selectedPriceBuckets.contains(index);
    return InkWell(
      onTap: () {
        setState(() {
          if (selected) _selectedPriceBuckets.remove(index);
          else _selectedPriceBuckets.add(index);
<<<<<<< HEAD
=======
          // sync the range to the bucket (useful UX)
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
          final bucket = _priceBuckets[index];
          _selectedRange = RangeValues((bucket['start'] as num).toDouble(), (bucket['end'] as num).toDouble());
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? _primary : _border),
        ),
        child: Row(
          children: [
<<<<<<< HEAD
            Icon(selected ? Icons.check_box : Icons.check_box_outline_blank, color: selected ? Colors.white : _border),
=======
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                border: Border.all(color: selected ? Colors.white : _border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: selected ? const Icon(Icons.check, size: 16, color: Colors.black) : null,
            ),
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: selected ? _bodyStyle.copyWith(color: Colors.white) : _bodyStyle)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(16),
=======
    final double maxPriceValue = _priceMax;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12)],
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
<<<<<<< HEAD
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
=======
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
                Row(
                  children: [
                    Expanded(child: Text('Filters', style: _titleStyle)),
                    TextButton(onPressed: _clearAll, child: Text('Clear all', style: _captionStyle.copyWith(color: _primary))),
<<<<<<< HEAD
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
=======
                    IconButton(icon: Icon(Icons.close, color: AppColors.textPrimary ?? Colors.black), onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // content (scrollable)
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
<<<<<<< HEAD
                        _sectionTitle('Sort By'),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: _sortOptions.map((s) => _chip(s, selected: s == _selectedSort, onTap: () => setState(() => _selectedSort = s))).toList(),
                        ),

                        _sectionTitle('Price Range'),
                        RangeSlider(
                          values: _selectedRange,
                          min: _priceMin, max: _priceMax,
                          divisions: 30,
                          activeColor: _primary,
                          labels: RangeLabels('₹${_selectedRange.start.toInt()}', '₹${_selectedRange.end.toInt()}'),
                          onChanged: (rv) => setState(() { _selectedRange = rv; _selectedPriceBuckets.clear(); }),
                        ),

                        _sectionTitle('Category'),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: _categories.map((c) => _chip(c, selected: _selectedCategories.contains(c), onTap: () {
                            setState(() => _selectedCategories.contains(c) ? _selectedCategories.remove(c) : _selectedCategories.add(c));
                          })).toList(),
                        ),

                        _sectionTitle('Author'),
                        _isLoadingAuthors 
                          ? const Center(child: CircularProgressIndicator()) 
                          : Column(
                              children: _authors.map((a) {
                                final sel = _selectedAuthorIds.contains(a.id);
                                return CheckboxListTile(
                                  title: Text(a.authorName ?? "Unknown", style: _bodyStyle),
                                  value: sel,
                                  activeColor: _primary,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (_) => setState(() => sel ? _selectedAuthorIds.remove(a.id) : _selectedAuthorIds.add(a.id!)),
                                );
                              }).toList(),
                            ),

                        _sectionTitle('Academic'),
                        _isLoadingAcademics
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: _academic.map((s) {
                                final sel = _selectedAcademic.contains(s);
                                return CheckboxListTile(
                                  title: Text(s, style: _bodyStyle),
                                  value: sel,
                                  activeColor: _primary,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (_) => setState(() => sel ? _selectedAcademic.remove(s) : _selectedAcademic.add(s)),
                                );
                              }).toList(),
                            ),

                        _sectionTitle('Language'),
                        Wrap(
                          spacing: 8, runSpacing: 8,
                          children: _languages.map((l) => _chip(l, selected: _selectedLanguages.contains(l), onTap: () {
                            setState(() => _selectedLanguages.contains(l) ? _selectedLanguages.remove(l) : _selectedLanguages.add(l));
                          })).toList(),
                        ),
                        const SizedBox(height: 24),
=======
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

                        // Price buckets
                        _sectionTitle('Price'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Column(
                            children: List.generate(_priceBuckets.length, (i) => _priceBucketRow(i)),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Range slider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RangeSlider(
                                values: _selectedRange,
                                min: _priceMin,
                                max: maxPriceValue,
                                divisions: 30,
                                labels: RangeLabels('₹${_selectedRange.start.toInt()}', '₹${_selectedRange.end.toInt()}'),
                                onChanged: (rv) => setState(() {
                                  _selectedRange = rv;
                                  // clear bucket selection when custom range chosen
                                  _selectedPriceBuckets.clear();
                                }),
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

                        // Category
                        _sectionTitle('Category'),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _categories.map((c) {
                            final sel = _selectedCategories.contains(c);
                            return _chip(c, selected: sel, onTap: () {
                              setState(() {
                                if (sel) _selectedCategories.remove(c);
                                else _selectedCategories.add(c);
                              });
                            });
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        // Sub Category with "show more"
                        _sectionTitle('Sub Category'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._subCategories.asMap().entries.take(_showMoreSubCategories ? _subCategories.length : 4).map((e) {
                              final label = e.value;
                              final sel = _selectedSubCategories.contains(label);
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: sel,
                                      onChanged: (_) => setState(() {
                                        if (sel) _selectedSubCategories.remove(label);
                                        else _selectedSubCategories.add(label);
                                      }),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(label, style: _bodyStyle)),
                                  ],
                                ),
                              );
                            }),
                            if (_subCategories.length > 4)
                              GestureDetector(
                                onTap: () => setState(() => _showMoreSubCategories = !_showMoreSubCategories),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Text(_showMoreSubCategories ? 'Show less' : 'Show more', style: _captionStyle.copyWith(color: _primary)),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Author (checkbox list) + search field
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
                        const SizedBox(height: AppSpacing.sm),
                        Column(
                          children: _authors.map((a) {
                            final sel = _selectedAuthors.contains(a);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: sel,
                                    onChanged: (_) => setState(() {
                                      if (sel) _selectedAuthors.remove(a);
                                      else _selectedAuthors.add(a);
                                    }),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text(a, style: _bodyStyle)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Language
                        _sectionTitle('Language'),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
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

                        // Academic (checkboxes)
                        _sectionTitle('Academic'),
                        Column(
                          children: _academic.map((s) {
                            final sel = _selectedAcademic.contains(s);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: sel,
                                    onChanged: (_) => setState(() {
                                      if (sel) _selectedAcademic.remove(s);
                                      else _selectedAcademic.add(s);
                                    }),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text(s, style: _bodyStyle)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Merchandise
                        _sectionTitle('Merchandise'),
                        Column(
                          children: _merchandise.map((m) {
                            final sel = _selectedMerchandise.contains(m);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: sel,
                                    onChanged: (_) => setState(() {
                                      if (sel) _selectedMerchandise.remove(m);
                                      else _selectedMerchandise.add(m);
                                    }),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text(m, style: _bodyStyle)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Format chips
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
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
                      ],
                    ),
                  ),
                ),
<<<<<<< HEAD
=======

                // Apply button
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
<<<<<<< HEAD
=======
                      elevation: 0,
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
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
<<<<<<< HEAD
}
=======
}
>>>>>>> 4d90baaf36c315ceb75de8c136857807c3e6c892
