import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/network/search_service.dart';
import 'package:ecommerce_mobile/routes/routes.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({Key? key}) : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String _query = '';
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  final ScrollController _scroll = ScrollController();
  final List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_checkScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    _query = (args['query'] ?? '').toString();

    _loadPage(1);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _checkScroll() {
    if (!_scroll.hasClients || _isLoading || !_hasMore) return;

    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      _loadPage(_page + 1);
    }
  }

  Future<void> _loadPage(int page) async {
    setState(() => _isLoading = true);

    final res = await SearchService.searchProducts(_query, page: page);

    final List data = res["data"] ?? [];
    final nextPage = res["nextPage"];

    if (page == 1) _products.clear();
    _products.addAll(data.map((e) => e as Map<String, dynamic>));

    setState(() {
      _page = page;
      _hasMore = nextPage != null;
      _isLoading = false;
    });
  }

  Widget _productTile(Map<String, dynamic> p) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.productDetails,
          arguments: p,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        padding: const EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                p["imageUrl"],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              p["title"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body,
            ),

            const SizedBox(height: 4),

            Text(
              p["author"],
              style: AppTextStyles.caption,
            ),

            const SizedBox(height: 8),

            // FIXED: Removed h3
            Text(
              "₹${p["price"]}",
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _results() {
    if (_products.isEmpty && _isLoading)
      return const Center(child: CircularProgressIndicator());

    if (_products.isEmpty)
      return Center(child: Text("No results", style: AppTextStyles.body));

    return GridView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _products.length + (_hasMore ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 300,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        if (index >= _products.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return _productTile(_products[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search results", style: AppTextStyles.h2),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              'Results for "$_query"',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),

          Expanded(child: _results()),
        ],
      ),
    );
  }
}
