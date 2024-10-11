import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/ui/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [],
      child: const HomePageScreen(),
    );
  }
}
