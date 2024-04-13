import 'package:flutter/material.dart';
import 'package:flutter_api_example/models/post.dart';
import 'package:flutter_api_example/widgets/spacing_widgets.dart';

class PostCard extends StatelessWidget {
  // The post to display the info of
  final Post post;

  const PostCard({
    super.key,
    // Require that a post be provided to this widget
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the post screen that displays one post with the argument post so that the new screen knows
        // what to post to display the data of
        Navigator.of(context).pushNamed('/post', arguments: post);
      },
      child: Card(
        color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const VerticalSpacing(),
              Text(
                post.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
