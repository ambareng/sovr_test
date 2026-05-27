TAKE NOTE:

Flutter Version: 3.38.10
Compatibility: ANDROID, IOS and WEB ONLY to save space

saveArticle function is wrapped in ArticleRemoteSource class in article_remote_source.dart but the code is as is unmodified

mockArticles are in mock_articles.dart

models are in article.dart and save_result.dart

modified a bit the main.dart to wrap it in BlocBuilder and the ListView.builder itemCount

ArticleCard widget is in article_card.dart file

Part 2 / API design
 - The endpoint: 
    - HTTP Method: POST
    - Path: <your domain here>/api/v1/articles/{articleId}/bookmark
    - Request Body (no need since the article id is already in the url parameters)
    - Response (I usually want the below response format if I were to design the BE response as well)
     - {
        data: {<this is optional but is really not needed but if you really want to put the Article data here>} // alternatively this is where you would put an error message if there was an error
        success: boolean // this is just to show if the request was a success or not
     }

     if success:
     data: {
        id: String
        title: String
        author: String
        preview: String
     }

     if error:
     data: {
        code: 400,
        message: 'Something went wrong with server'
     }
 - How to ensure user can't save an article twice
  - in a middleware in API check in database relationship if User already has a "saved" relationship to an Article if so then return a 400 error and say something like "Already bookmarked" but really the FE should already handle through the UI to show that the user has already saved something
 - simple schema to show many is to many relationship of user to articles (many user has many saved articles)
   - saved_articles
    - id: String
    - user_id: String
    - article_id: String
    - created_at: DateTime
 - if a request just so happens to call the server just barely after an article is deleted, then the  article_id should now no longer be found on database and middleware should throw error exception saying that the article is now no longer found, in that case send 404 response with corresponding message, it is now up to the UI to either just show as toast the message or to also remove from the list the article

Part 3 / Your thinking
 - I used Bloc as it is undustry standard and I am used to it, no reason really asides from that, if it's a really simple hobby project setState or Provider is enough but for professional work I use Bloc
 - I assumed by save you meant bookmark, I made the "button" not an actual button but an icon, I assumed the design, I assumed you wanted me to unsave an article as well
 - Repository, dpeendency injection and unit tests, to keep things simple and understandable and the use of freezed and build_runner and also navigation using go_router
 - just make the design of the ui be more beautiful haha, honestly 1 hour maybe add some unit tests or an actual depenedncy injection