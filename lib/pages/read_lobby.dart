import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:spreedit/gemini/gemini.dart';
import 'package:spreedit/models/books.dart';
import 'package:spreedit/pages/home_page.dart';
import 'package:spreedit/pages/read_pdf.dart';
import 'package:spreedit/prompts/prompts.dart';

class ReadLobby extends StatefulWidget {
  const ReadLobby({super.key, required this.book});

  final Book book;

  @override
  State<ReadLobby> createState() => _ReadLobbyState();
}

class _ReadLobbyState extends State<ReadLobby> {
  final _goalEditingController = TextEditingController();
  GlobalKey slglobalkey = GlobalKey();
  bool goalchanging = false;
  @override
  Widget build(BuildContext context) {
    _goalEditingController.text = widget.book.fileContentGoal!;
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
              key: slglobalkey,
              delegate: SliverChildListDelegate([
                ListTile(
                    title: Text(
                        'Main Objective of Reading ${widget.book.fileType} ',
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: goalchanging
                              ? const CircularProgressIndicator()
                              : IconButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: submitGoal,
                                  icon: const Icon(Icons.send)),
                          hintText: "Enter your custom objective"),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 8,
                      controller: _goalEditingController,
                    ),
                  ),
                ),
                const ListTile(
                    title: Text('Must Read Parts',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                ...widget.book.includedskipIncludes!.map((unskipped) => Card(
                      child: ListTile(
                        onTap: () {
                          if (widget.book.fileType! == "epub") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadPdf(
                                      book: widget.book,
                                      targetPage: unskipped.beginningPage),
                                ));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadPdf(
                                      book: widget.book,
                                      targetPage: unskipped.beginningPage),
                                ));
                          }
                        },
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
                      onTap: () {
                        if (widget.book.fileType! == "epub") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadPdf(
                                    book: widget.book,
                                    targetPage: skipped.beginningPage),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadPdf(
                                    book: widget.book,
                                    targetPage: skipped.beginningPage),
                              ));
                        }
                      },
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

  Future<GenerateContentResponse> geminiGenerateContent(
      List<Content> content) async {
    final gemini = Gemini().init();
    var gResponse = await gemini.generateContent(content);
    return gResponse;
  }

  void submitGoal() async {
    debugPrint(_goalEditingController.text);
    String goal = _goalEditingController.text;
    setState(() {
      goalchanging = true;
      widget.book.fileContentGoal = goal;
    });
    final receivePort = ReceivePort();
    await Isolate.spawn(extractPdfText,
        (filePath: widget.book.filePath!, sendPort: receivePort.sendPort));
    // String text = extractPdfText(file.path!);
    receivePort.listen((text) async {
      //create scontent goal+prompt +filetext
      String prompt = Prompts.summaryPromptWithGoal + goal + Prompts.sPrompt;
      var scontent = [Content.text(prompt), Content.text(text)];
      var sResponse = await geminiGenerateContent(scontent);
      debugPrint(sResponse.text);

      var summaryJson = jsonDecode(sResponse.text!);

      List<SkipInclude> included = [];
      List<SkipInclude> skipped = [];
      if (summaryJson["summary"]["included"] != null) {
        for (var include in summaryJson["summary"]["included"]) {
          included.add(SkipInclude.fromJson(include));
        }
      }
      if (summaryJson["summary"]["skipped"] != null) {
        for (var skip in summaryJson["summary"]["skipped"]) {
          skipped.add(SkipInclude.fromJson(skip));
        }
      }
      setState(() {
        widget.book.includedskipIncludes = included;
        widget.book.skippedskipIncludes = skipped;
        goalchanging = false;
      });
      widget.book.updatedAt = Timestamp.now();
      final BooksDBService _booksDBService = BooksDBService();
      _booksDBService.updateBook(widget.book.id!, widget.book);
    });
  }
}
