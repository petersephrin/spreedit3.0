import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spreedit/models/books.dart';
import 'package:spreedit/pages/read_pdf.dart';

class ReadLobby extends StatefulWidget {
  const ReadLobby({super.key, required this.book});

  final Book book;

  @override
  State<ReadLobby> createState() => _ReadLobbyState();
}

class _ReadLobbyState extends State<ReadLobby> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(widget.book.title ?? ""),
              expandedHeight: 400,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                    tag: widget.book.title ?? "title${widget.book.coverImage}",
                    child: Image.file(File(widget.book.coverImage!))),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (widget.book.fileType! == "epub") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReadPdf(book: widget.book),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReadPdf(book: widget.book),
                              ));
                        }
                      },
                      child: Text("Read")),
                )
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ButtonTheme(
                  child: ActionChip.elevated(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                    backgroundColor: Theme.of(context).primaryColor,
                    label: const Text("Read"),
                    onPressed: () {
                      if (widget.book.fileType! == "epub") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadPdf(book: widget.book),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadPdf(book: widget.book),
                            ));
                      }
                    },
                  ),
                ),
              ), // Space for the FAB
            ),
            //Tags
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: [
                    for (String tag in widget.book.tags ?? [""])
                      Chip(
                        label: Text(tag),
                        padding: const EdgeInsets.all(6.0),
                        elevation: 6.0,
                      )
                  ],
                ),
              ),
            ),
            //Authors
            //Skip Includes
            SliverList(
              delegate: SliverChildListDelegate([
                ListTile(
                    title: Text(
                        'Main Objective of Reading ${widget.book.fileType} ',
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                InputChip(label: Text(widget.book.fileContentGoal!)),
                const ListTile(
                    title: Text('Must Read Parts',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                ...widget.book.includedskipIncludes!.map((unskipped) => Card(
                      child: ListTile(
                        title: Text(unskipped.title ?? ""),
                        subtitle: Text(unskipped.description ?? ""),
                        trailing: Text(
                            "Page ${unskipped.beginningPage}-${unskipped.endingPage}"),
                      ),
                    )),
                const SizedBox(height: 16),
                const ListTile(
                    title: Text('Parts To Skip',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                ...widget.book.skippedskipIncludes!.map((skipped) => Card(
                        child: ListTile(
                      title: Text(skipped.title ?? ""),
                      subtitle: Text(skipped.description ?? ""),
                      trailing: Text(
                          "Page ${skipped.beginningPage}-${skipped.endingPage}"),
                    ))),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
