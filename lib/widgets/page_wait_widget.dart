import 'package:flutter/material.dart';

class PageWaitWidget extends StatelessWidget {
  final String appTitle;
  const PageWaitWidget({
    super.key,
    this.appTitle = '',
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
