import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chaturvyuha_foundation/staff/member/utils/app_colors.dart';
import 'package:chaturvyuha_foundation/staff/member/utils/app_text_styles.dart';
import 'package:chaturvyuha_foundation/staff/member/models/article_item.dart';

import '../../dataProvider/foundation_provider.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  ArticleItem? _activeArticle; // For detail drilldown locally

  final List<String> _categories = [
    'All',
    'Wellness',
    'Language',
    'Philosophy',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FoundationProvider>();

    if (_activeArticle != null) {
      return _buildArticleDetail(_activeArticle!);
    }

    final filteredArticles = provider.articles.where((art) {
      final matchesSearch =
          art.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          art.excerpt.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || art.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1320),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 48 : 24,
                      vertical: isDesktop ? 56 : 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header label labels
                        Text(
                          'KNOWLEDGE & ARTICLES',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Insights & Spiritual Discourses',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: isDesktop ? 36 : 28,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Search and Filter Bar Row/Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              onChanged: (val) =>
                                  setState(() => _searchQuery = val),
                              decoration: InputDecoration(
                                hintText:
                                    'Search articles by title or keywords...',
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              children: _categories.map((cat) {
                                final bool isSelected =
                                    _selectedCategory == cat;
                                return ChoiceChip(
                                  label: Text(cat),
                                  selected: isSelected,
                                  onSelected: (val) {
                                    if (val)
                                      setState(() => _selectedCategory = cat);
                                  },
                                  selectedColor: AppColor.primary,
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // Articles grid looping
                        LayoutBuilder(
                          builder: (context, box) {
                            final double cardWidth = isDesktop
                                ? (box.maxWidth - 24) / 2
                                : box.maxWidth;
                            return Wrap(
                              spacing: 24,
                              runSpacing: 24,
                              children: filteredArticles
                                  .map(
                                    (art) => _buildArticleCard(art, cardWidth),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildArticleCard(ArticleItem art, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.primary.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(art.category.toUpperCase(), style: AppTextStyles.bulletLabel),
          const SizedBox(height: 16),
          Text(art.title, style: AppTextStyles.title),
          const SizedBox(height: 12),
          Text(art.excerpt, style: AppTextStyles.bodySmall),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'By ${art.author}',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _activeArticle = art),
                child: const Text(
                  'Read Full Article →',
                  style: AppTextStyles.link,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleDetail(ArticleItem art) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => setState(() => _activeArticle = null),
        ),
        title: const Text(
          'Article Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    art.category.toUpperCase(),
                    style: AppTextStyles.sectionLabel,
                  ),
                  const SizedBox(height: 16),
                  Text(art.title, style: AppTextStyles.heading2),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.person, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            art.author,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Published: ${art.publishedDate.day}/${art.publishedDate.month}/${art.publishedDate.year}',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(art.content, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 48),

                  // Tags looping chips
                  Text('TAGS:', style: AppTextStyles.bulletLabel),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: art.tags
                        .map(
                          (t) => Chip(
                            label: Text(
                              t,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 48),

                  // Related section dummy
                  Text('RELATED ARTICLES', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 12),
                  const Text(
                    '// Related article previews would appear here based on IDs provided in metadata.',
                    style: TextStyle(
                      color: AppColor.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // SEO Meta data indicator for developer
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SEO METADATA (DEMO FIELDS):',
                          style: AppTextStyles.bulletLabel,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• SEO Title: ${art.seoTitle}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          '• SEO Description: ${art.seoDescription}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          '• SEO Keywords: ${art.seoKeywords}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '// NOTE: Setting these fields alone does not implement web SEO. It requires proper head tag injection on the web index.html.',
                          style: TextStyle(fontSize: 10, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
