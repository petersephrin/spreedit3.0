import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spreedit/models/books.dart';

class ReadEpub extends StatefulWidget {
  const ReadEpub({super.key, required this.book});

  final Book book;

  @override
  State<ReadEpub> createState() => _ReadEpubState();
}

class _ReadEpubState extends State<ReadEpub> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(),
    );
  }
}
