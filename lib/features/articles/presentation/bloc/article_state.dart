import 'package:sovr_test/features/articles/data/models/_models.dart';

class ArticleState {
  const ArticleState({this.isLoading = false, this.error, this.articles = const []});

  final bool isLoading;
  final String? error;
  final List<SavedArticlesState> articles;

  ArticleState copyWith({bool? isLoading, String? error, List<SavedArticlesState>? articles}) {
    return ArticleState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      articles: articles ?? this.articles,
    );
  }
}

enum SavedArticlesStatus { initial, loading, success, error }

class SavedArticlesState {
  const SavedArticlesState({
    required this.article,
    this.saved = false,
    this.status = SavedArticlesStatus.initial,
    this.error,
  });

  final Article article;
  final bool saved;
  final SavedArticlesStatus status;
  final String? error;

  SavedArticlesState copyWith({
    Article? article,
    bool? saved,
    SavedArticlesStatus? status,
    String? error,
  }) {
    return SavedArticlesState(
      article: article ?? this.article,
      saved: saved ?? this.saved,
      status: status ?? this.status,
      error: error,
    );
  }
}
