import 'package:flutter/material.dart';
import 'TeamSyncApp.dart';
import 'package:provider/provider.dart';
import 'package:teamsync/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const TeamSyncApp(),
    ),
  );
}
