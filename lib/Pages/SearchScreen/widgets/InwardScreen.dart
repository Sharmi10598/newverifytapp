import 'package:flutter/material.dart';

import '../../../Constant/Screen.dart';

class SearchScreenPage extends StatefulWidget {
  const SearchScreenPage({super.key});

  @override
  State<SearchScreenPage> createState() => _SearchScreenPageState();
}

class _SearchScreenPageState extends State<SearchScreenPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text('Search'),
          ),
          SingleChildScrollView(
            child: Container(
              height: Screens.padingHeight(context) * 0.85,
              child: Center(
                child: Text('No data to load..!!!'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
