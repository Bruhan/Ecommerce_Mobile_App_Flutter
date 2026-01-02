import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/network/api_service.dart'; // Ensure this is imported
import 'package:ecommerce_mobile/models/author_model.dart'; // Ensure this is imported

class FilterSheet extends StatefulWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final ApiService _apiService = ApiService();

  // Sort options
  final List<String> _sortOptions = ['Relevance', 'Price: Low - High', 'Price: High - Low', 'Newest', 'Top Rated'];
  String _selectedSort = 'Relevance';

  // Price range
  double _priceMin = 0;
  double _priceMax = 3000;
  RangeValues _selectedRange = const RangeValues(0, 2000);

  final List<Map<String, dynamic>> _priceBuckets = [
    {'label': 'Rs. 0 - Rs. 100', 'start': 0, 'end': 100},
    {'label': 'Rs. 101 - Rs. 200', 'start': 101, 'end': 200},
    {'label': 'Rs. 201 - Rs. 400', 'start': 201, 'end': 400},
    {'label': 'Rs. 401 - Rs. 1000', 'start': 401, 'end': 1000},
    {'label': 'Rs. 1001 - Rs. 3000', 'start': 1001, 'end': 3000},
    {'label': 'Rs. 3000 above', 'start': 3001, 'end': 999999},
  ];
  final Set<int> _selectedPriceBuckets = {};

  final List<String> _formats = ['Paperback', 'Hardcover', 'eBook', 'Audiobook'];
  final Set<String> _selectedFormats = {};

  final List<String> _categories = ['Fantasy', 'Fiction', 'Mythology', 'Art', 'Si-Fi'];
  final Set<String> _selectedCategories = {};

  final List<String> _subCategories = ['Epic', 'Historical', 'Literary', 'Greek', 'Norse', 'Contemporary', 'CyberPunk'];
  final Set<String> _selectedSubCategories = {};

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
      _selectedCategories.clear();
      _selectedSubCategories.clear();
      _selectedAuthorIds.clear(); // Updated
      _selectedAcademic.clear(); // Updated
      _authorController.clear();
      _selectedLanguages.clear();
      _selectedMerchandise.clear();
      _selectedRating = 'Any';
      _showMoreSubCategories = false;
    });
  }

  void _applyFilters() {
    final Map<String, dynamic> filters = {
      'sort': _selectedSort,
      'priceRange': [_selectedRange.start.toInt(), _selectedRange.end.toInt()],
      'categories': _selectedCategories.toList(),
      'authorIds': _selectedAuthorIds.toList(), // Sending IDs to backend
      'academic': _selectedAcademic.toList(),
      'languages': _selectedLanguages.toList(),
      // Add other fields as needed for your search API
    };
    Navigator.of(context).pop(filters);
  }

  Color get _bg => AppColors.bg ?? Colors.white;
  Color get _card => AppColors.surface ?? Colors.grey.shade50;
  Color get _primary => AppColors.primary ?? const Color(0xFF326638);
  Color get _border => AppColors.fieldBorder ?? Colors.grey.shade300;
  TextStyle get _titleStyle => AppTextStyles.h2?.copyWith(fontSize: 18) ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
  TextStyle get _bodyStyle => AppTextStyles.body ?? const TextStyle(fontSize: 14);
  TextStyle get _captionStyle => AppTextStyles.caption ?? const TextStyle(fontSize: 12, color: Colors.grey);

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 16),
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
            Icon(selected ? Icons.check_box : Icons.check_box_outline_blank, color: selected ? Colors.white : _border),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: selected ? _bodyStyle.copyWith(color: Colors.white) : _bodyStyle)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Filters', style: _titleStyle)),
                    TextButton(onPressed: _clearAll, child: Text('Clear all', style: _captionStyle.copyWith(color: _primary))),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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