import 'package:flutter/material.dart';
import 'package:flutter_api_example/models/comment.dart';
import 'package:flutter_api_example/widgets/spacing_widgets.dart';

class CommentWidget extends StatelessWidget {
  // The comment to display the info of
  final Comment comment;

  const CommentWidget({
    super.key,
    // Require that a comment be provided to this widget
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  comment.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  comment.email,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const VerticalSpacing(),
            Text(comment.body),
          ],
        ),
      ),
    );
  }
}
