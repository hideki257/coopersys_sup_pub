import 'package:flutter/material.dart';

class PageMessageWidget extends StatelessWidget {
  final String appTitle;
  final String message;
  final FontWeight? fontWeight;
  const PageMessageWidget(
      {super.key,
      required this.appTitle,
      required this.message,
      this.fontWeight});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Center(
          child: Text(
        message,
        style: TextStyle(fontWeight: fontWeight),
      )),
    );
  }
}
