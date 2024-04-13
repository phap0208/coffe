import 'package:flutter/material.dart';
import 'package:flutter_api_example/models/post.dart';
import 'package:flutter_api_example/screens/post_screen/comment_widget.dart';
import 'package:flutter_api_example/services/api_service.dart';
import 'package:flutter_api_example/widgets/loading_indicator.dart';
import 'package:flutter_api_example/widgets/spacing_widgets.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the post that was passed to this screen
    final Post post = ModalRoute.of(context)!.settings.arguments as Post;
    // Get the reference to the ApiService
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const VerticalSpacing(),
            Row(
              children: [
                Text('User ID: ${post.userId}'),
                const Spacer(),
                Text('Post ID: ${post.id}'),
              ],
            ),
            const VerticalSpacing(),
            Text(post.body),
            const VerticalSpacing(),
            // Using FutureBuilder to show specific widgets depending on the state of the Future (the API call)
            // Whenever this screen is built, the Future is started
            FutureBuilder(
              future: apiService.getPostComments(postId: post.id),
              builder: (_, snapshot) {
                // Has the future completed?
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future completed without errors, display list of posts
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        // Make this ListView the primary scrollable on this page
                        primary: true,
                        // Make sure ListView only takes up as much space as it needs and not infinite
                        shrinkWrap: true,
                        itemBuilder: (_, index) => CommentWidget(comment: snapshot.data![index]),
                        itemCount: snapshot.data!.length,
                      ),
                    );
                  }
                  // If the Future completed with errors, display error text
                  else {
                    return Center(
                      child: Text('Error encountered: ${snapshot.error}'),
                    );
                  }
                }
                // If the Future has not completed, show a loading indicator
                return const LoadingIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
