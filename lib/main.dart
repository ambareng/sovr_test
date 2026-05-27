import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sovr_test/features/articles/data/sources/article_remote_source.dart';
import 'package:sovr_test/features/articles/presentation/_presentation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (context) => ArticleBloc(remoteSource: ArticleRemoteSourceImpl()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Article Feed',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('For You')),
        body: BlocBuilder<ArticleBloc, ArticleState>(
          // used BlocBuilder wrapper here as it needs context
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state
                  .articles
                  .length, // replaced with articles state using my bloc but is initialized from mockArticles given
              itemBuilder: (context, index) {
                return ArticleCard(savedState: state.articles[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
