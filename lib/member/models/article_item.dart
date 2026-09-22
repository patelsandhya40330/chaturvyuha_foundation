class ArticleItem {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final String category;
  final List<String> tags;
  final String author;
  final DateTime publishedDate;
  final DateTime updatedDate;
  final List<String> relatedArticleIds;

  // SEO fields for requirement
  final String seoTitle;
  final String seoDescription;
  final String seoKeywords;

  ArticleItem({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.category,
    required this.tags,
    required this.author,
    required this.publishedDate,
    required this.updatedDate,
    required this.relatedArticleIds,
    required this.seoTitle,
    required this.seoDescription,
    required this.seoKeywords,
  });
}
