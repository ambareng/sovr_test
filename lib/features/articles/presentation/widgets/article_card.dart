import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sovr_test/features/articles/presentation/bloc/article_bloc.dart';
import 'package:sovr_test/features/articles/presentation/bloc/article_state.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.savedState});

  final SavedArticlesState savedState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final article = savedState.article;

    return BlocListener<ArticleBloc, ArticleState>(
      listenWhen: (prev, curr) {
        final prevStatus = prev.articles.firstWhere((a) => a.article.id == article.id, orElse: () => savedState).status;
        final currStatus = curr.articles.firstWhere((a) => a.article.id == article.id, orElse: () => savedState).status;
        return prevStatus != currStatus &&
            (currStatus == SavedArticlesStatus.success || currStatus == SavedArticlesStatus.error);
      },
      listener: (context, state) {
        final current = state.articles.firstWhere((a) => a.article.id == article.id, orElse: () => savedState);
        final messenger = ScaffoldMessenger.of(context);
        if (current.status == SavedArticlesStatus.success) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(current.saved ? 'Article saved' : 'Article unsaved'),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
        } else if (current.status == SavedArticlesStatus.error) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(current.error ?? 'Failed to save'),
                backgroundColor: theme.colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.preview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              savedState.status == SavedArticlesStatus.loading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : IconButton(
                      onPressed: () {
                        final bloc = context.read<ArticleBloc>();
                        savedState.saved ? bloc.unsaveArticle(article.id) : bloc.saveArticle(article.id);
                      },
                      icon: Icon(savedState.saved ? Icons.bookmark : Icons.bookmark_border),
                      color: savedState.saved ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
