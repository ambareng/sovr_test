import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sovr_test/core/mocks/mock_articles.dart';
import 'package:sovr_test/features/articles/data/sources/_sources.dart';
import 'package:sovr_test/features/articles/presentation/bloc/article_state.dart';

class ArticleBloc extends Cubit<ArticleState> {
  ArticleBloc({required ArticleRemoteSource remoteSource}) : _remoteSource = remoteSource, super(const ArticleState()) {
    _init();
  }

  final ArticleRemoteSource _remoteSource;

  void _init() {
    initMockArticlesData();
  }

  void initMockArticlesData() {
    emit(
      state.copyWith(
        articles: mockArticles.map((article) => SavedArticlesState(article: article)).toList(),
        isLoading: false,
        error: null,
      ),
    );
  }

  Future<void> saveArticle(String articleId) => _toggleSave(articleId, _remoteSource.saveArticle);

  Future<void> unsaveArticle(String articleId) => _toggleSave(articleId, _remoteSource.unsaveArticle);

  Future<void> _toggleSave(String articleId, Future<dynamic> Function(String) remoteCall) async {
    _emitArticleUpdate(articleId, (a) => a.copyWith(status: SavedArticlesStatus.loading, error: null));
    try {
      final result = await remoteCall(articleId);
      _emitArticleUpdate(articleId, (a) => a.copyWith(status: SavedArticlesStatus.success, saved: result.saved));
    } catch (e) {
      _emitArticleUpdate(articleId, (a) => a.copyWith(status: SavedArticlesStatus.error, error: e.toString()));
    }
  }

  void _emitArticleUpdate(String articleId, SavedArticlesState Function(SavedArticlesState) update) {
    emit(
      state.copyWith(
        articles: state.articles.map((a) => a.article.id == articleId ? update(a) : a).toList(),
      ),
    );
  }
}
