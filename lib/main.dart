import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'TeamSyncApp.dart';
import 'theme_provider.dart';  // Ensure you're importing the correct file

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const TeamSyncApp(),
    ),
  );
}
