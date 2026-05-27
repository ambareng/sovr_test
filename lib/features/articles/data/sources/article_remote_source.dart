import 'package:sovr_test/features/articles/data/models/_models.dart';

abstract class ArticleRemoteSource {
  Future<SaveResult> saveArticle(String articleId);
  Future<SaveResult> unsaveArticle(String articleId);
}

class ArticleRemoteSourceImpl implements ArticleRemoteSource {
  // saveArticle function is unmodified but is wrapped in a ArticleRemoteSource class for architectural purposes
  @override
  Future<SaveResult> saveArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (DateTime.now().millisecondsSinceEpoch % 10 < 2) {
      throw Exception('Network error — please try again');
    }
    return SaveResult(articleId: articleId, saved: true);
  }

  // added this just in case the user want to unsave an article
  @override
  Future<SaveResult> unsaveArticle(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return SaveResult(articleId: articleId, saved: false);
  }
}
