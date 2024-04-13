import 'package:flutter/material.dart';
import 'package:flutter_api_example/misc/colors.dart';
import 'package:flutter_api_example/screens/all_posts_screen/all_posts_screen.dart';
import 'package:flutter_api_example/screens/home_screen/home_screen.dart';
import 'package:flutter_api_example/screens/post_screen/post_screen.dart';
import 'package:flutter_api_example/services/api_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Wrap the MaterialApp with the MultiProvider or the Provider widget so that the whole app has access to the
    // ApiService or any other Provider you create
    return MultiProvider(
      // Define the Providers you want your whole app to have access to
      providers: [
        // Provider to provide a reference to the single instance of the ApiService class
        Provider(create: (_) => ApiService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // Set the app's primary colors from the constants defined in misc/colors.dart
          primarySwatch: AppColors.primaryColor,
        ),
        // Create a list of routes
        routes: {
          '/': (context) => const HomeScreen(),
          '/all-posts': (context) => const AllPostsScreen(),
          '/post': (context) => const PostScreen(),
        },
        // Set the initial route to the home screen
        initialRoute: '/',
      ),
    );
  }
}
