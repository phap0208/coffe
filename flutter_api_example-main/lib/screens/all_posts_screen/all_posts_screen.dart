import 'package:flutter/material.dart';
import 'package:flutter_api_example/screens/all_posts_screen/post_card.dart';
import 'package:flutter_api_example/services/api_service.dart';
import 'package:flutter_api_example/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

// Screen to show all the posts in a ListView
class AllPostsScreen extends StatelessWidget {
  const AllPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the reference to ApiService object using Provider
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts Screen'),
      ),
      // Using FutureBuilder to show specific widgets depending on the state of the Future (the API call)
      // Whenever this screen is built, the Future is started
      body: FutureBuilder(
        future: apiService.getPosts(),
        builder: (_, snapshot) {
          print("snapshotsnapshot ${snapshot.data}");
          // Has the future completed?
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future completed without errors, display list of posts
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (_, index) => PostCard(post: snapshot.data![index]),
                itemCount: snapshot.data!.length,
              );
            }
            // If the Future completed with errors, display error text
            else {
              return const Center(child: Text('Error encountered'));
            }
          }
          // If the Future has not completed, show a loading indicator
          return const LoadingIndicator();
        },
      ),
    );
  }
}
