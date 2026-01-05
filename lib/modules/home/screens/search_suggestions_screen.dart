// lib/modules/home/screens/search_suggestions_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/network/search_service.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

import '../../../globals/text_styles.dart';

class SearchSuggestionsScreen extends StatefulWidget {
  static const routeName = '/search-suggestions';
  const SearchSuggestionsScreen({Key? key}) : super(key: key);

  @override
  State<SearchSuggestionsScreen> createState() => _SearchSuggestionsScreenState();
}

class _SearchSuggestionsScreenState extends State<SearchSuggestionsScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<String> _suggestions = [];
  List<String> _recent = [];
  bool _isLoading = false;
  String _query = '';

  // preview products for typed query
  List<Map<String, dynamic>> _previewProducts = [];
  bool _isPreviewLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
    _loadTrending();
  }

  void _onChanged() {
    final q = _controller.text.trim();
    setState(() => _query = q);

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (q.isEmpty) {
        await _loadTrending();
        _clearPreview();
      } else {
        await _performSuggestionSearch(q);
        await _loadPreviewProducts(q);
      }
    });
  }

  Future<void> _loadTrending() async {
    setState(() => _isLoading = true);
    try {
      final res = await SearchService.getSearchSuggestions('');
      setState(() => _suggestions = res);
    } catch (_) {
      setState(() => _suggestions = []);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performSuggestionSearch(String q) async {
    setState(() => _isLoading = true);
    try {
      final list = await SearchService.getSearchSuggestions(q);
      setState(() => _suggestions = list);
    } catch (_) {
      setState(() => _suggestions = []);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPreviewProducts(String q) async {
    setState(() {
      _isPreviewLoading = true;
      _previewProducts = [];
    });

    try {
      final map = await SearchService.searchProducts(q, page: 1, pageSize: 6);
      final List data = map['data'] ?? [];
      setState(() {
        _previewProducts = List<Map<String, dynamic>>.from(data.map((e) => e as Map<String, dynamic>));
      });
    } catch (_) {
      setState(() {
        _previewProducts = [];
      });
    } finally {
      setState(() => _isPreviewLoading = false);
    }
  }

  void _clearPreview() {
    setState(() {
      _previewProducts = [];
      _isPreviewLoading = false;
    });
  }

  void _onSuggestionTap(String s) {
    // update recent (simple in-memory)
    setState(() {
      _recent.removeWhere((r) => r.toLowerCase() == s.toLowerCase());
      _recent.insert(0, s);
      if (_recent.length > 10) _recent.removeLast();
    });

    Navigator.pushNamed(context, Routes.searchResults, arguments: {'query': s});
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onSubmitted: (v) {
        if (v.trim().isNotEmpty) _onSuggestionTap(v.trim());
      },
      decoration: InputDecoration(
        hintText: "Search books, authors…",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _query.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                  _clearPreview();
                },
              )
            : null,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.md), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _recentSection() {
    if (_recent.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent searches",
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 10,
          children: _recent
              .map((e) => ActionChip(
                    label: Text(e),
                    backgroundColor: AppColors.surface,
                    onPressed: () => _onSuggestionTap(e),
                  ))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _previewStrip() {
    if (_isPreviewLoading) {
      return SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
    }

    if (_previewProducts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preview results', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _previewProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (ctx, i) {
              final p = _previewProducts[i];
              final title = (p['title'] ?? '').toString();
              final img = (p['imageUrl'] ?? '').toString();
              final price = (p['price'] ?? 0).toString();
              final author = (p['author'] ?? '').toString();

              return GestureDetector(
                onTap: () {
                  // navigate to product details with the full product map
                  Navigator.pushNamed(context, Routes.productDetails, arguments: p);
                },
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.fieldBorder),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: img.isNotEmpty ? Image.network(img, height: 92, width: double.infinity, fit: BoxFit.cover) : Container(height: 92, color: AppColors.bg),
                      ),
                      const SizedBox(height: 8),
                      Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.body),
                      const SizedBox(height: 4),
                      Text(author, style: AppTextStyles.caption),
                      const Spacer(),
                      Text('₹$price', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _suggestionList() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_suggestions.isEmpty) return Center(child: Text("No suggestions", style: AppTextStyles.caption));

    return Column(
      children: _suggestions
          .map((s) => ListTile(
                title: Text(s, style: AppTextStyles.body),
                leading: const Icon(Icons.history),
                onTap: () => _onSuggestionTap(s),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search", style: AppTextStyles.h2),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: AppSpacing.lg),
              _recentSection(),
              // preview strip (product thumbnails from API)
              _previewStrip(),
              Text("Suggestions", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: AppSpacing.sm),
              _suggestionList(),
            ],
          ),
        ),
      ),
    );
  }
}
