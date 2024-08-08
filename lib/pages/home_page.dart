import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spreedit/gemini/gemini.dart';
import 'package:spreedit/models/books.dart';
import 'package:spreedit/pages/read_epub.dart';
import 'package:spreedit/pages/read_pdf.dart';
import 'package:spreedit/prompts/prompts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdfrx/pdfrx.dart' as pdfrx;
import 'package:image/image.dart' as image;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BooksDBService _booksDBService = BooksDBService();
  var startMessage = 'Open a pdf or epub file to start.';
  var startMessageDesc =
      'Let AI help you read faster and understand complex topics easily';

  Future<GenerateContentResponse> geminiGenerateContent(
      List<Content> content) async {
    final gemini = Gemini().init();
    var gResponse = await gemini.generateContent(content);
    return gResponse;
  }

  void pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      String fprompt = Prompts.filePickedPrompt;
      var fcontent = [Content.text(fprompt)];

      String sprompt = Prompts.summaryPrompt;
      var scontent = [Content.text(sprompt)];

      for (PlatformFile file in result.files) {
        debugPrint(file.name);
        String filename = file.name;
        setState(() {
          startMessage = "Opening $filename";
        });
        var filepath = file.path!;
        var fileextension = file.extension!;
        if (fileextension == "pdf") {
          final receivePort = ReceivePort();
          setState(() {
            startMessageDesc = "Extracting text from pdf";
          });
          await Isolate.spawn(extractPdfText,
              (filePath: file.path!, sendPort: receivePort.sendPort));
          // String text = extractPdfText(file.path!);
          receivePort.listen((text) async {
            //debugPrint(text);
            fcontent.add(Content.text(text));
            setState(() {
              startMessageDesc = "Extracting metadata from file";
            });
            var gResponse = await geminiGenerateContent(fcontent);
            debugPrint(gResponse.text);
            Book book = Book.fromJson(jsonDecode(gResponse.text!));
            debugPrint(book.title);
            scontent.add(Content.text(text));
            setState(() {
              startMessageDesc = "Creating a spreedit summary for you";
            });

            setState(() {
              startMessageDesc = "Adding file to database";
            });
            var sResponse = await geminiGenerateContent(scontent);
            debugPrint(sResponse.text);

            var summaryJson = jsonDecode(sResponse.text!);
            book.fileContentGoal = summaryJson["goal"];

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
            book.includedskipIncludes = included;
            book.skippedskipIncludes = skipped;
            book.fileContentMimeType = fileextension;
            book.filePath = filepath;
            book.createdAt = Timestamp.now();
            book.updatedAt = Timestamp.now();

            //get image of first page
            final docRendered = await pdfrx.PdfDocument.openFile(filepath);
            var page = docRendered.pages.first;
            var imgPDF = await page.render();
            String coverfilepath = "";
            debugPrint("Starting to create cover image");
            if (imgPDF != null) {
              var img = await imgPDF.createImage();
              var imgBytes = await img.toByteData(format: ImageByteFormat.png);
              var libImage = image.decodeImage(imgBytes!.buffer
                  .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));

              File file =
                  File(await getFilePath(result.files.first.name, "png"));
              file.writeAsBytes(image.encodePng(libImage!)).then((value) {
                coverfilepath = value.path;
                debugPrint(coverfilepath);
                book.coverImage = coverfilepath;
                _booksDBService.addBook(book);
              });
            } else {
              debugPrint("Cover file:$coverfilepath");
              book.coverImage = coverfilepath;
              _booksDBService.addBook(book);
            }
            docRendered.dispose();
            setState(() {
              startMessageDesc = "Done.";
            });
          });
        } else if (file.extension == "epub") {
          //extract text from epub
        } else if (file.extension == "png" ||
            file.extension == "jpg" ||
            file.extension == "jpeg") {
          Uint8List bytes = await File(file.path!).readAsBytes();
          fcontent.add(Content.data(file.extension!, bytes));
        }
      }
    }
  }

  Future<String> getFilePath(String filename, String ext) async {
    Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$filename.$ext'; // 3

    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: booksView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFiles,
        tooltip: 'Open files',
        child: const Icon(Icons.file_open_rounded),
      ),
    );
  }

  Widget booksView() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: StreamBuilder(
          stream: _booksDBService.getBooks(),
          builder: (context, snapshot) {
            List<Book> books =
                snapshot.data!.docs.map((doc) => doc.data() as Book).toList();
            if (books.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    startMessage,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    startMessageDesc,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              );
            } else {
              debugPrint(books.length.toString());
              return GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 27 / 35,
                children: [
                  for (Book book in books)
                    InkWell(
                      onTap: () {
                        if (book.fileType == "epub") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadEpub(book: book),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadPdf(book: book),
                              ));
                        }
                      },
                      child: Hero(
                        tag: book.title!,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: book.coverImage!.isEmpty
                                        ? const AssetImage(
                                                'images/blankbookcover.png')
                                            as ImageProvider
                                        : FileImage(File(book.coverImage!)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                height: 80.0,
                                child: book.coverImage!.isEmpty
                                    ? Text(
                                        book.title!,
                                        style:
                                            TextStyle(fontSize: 20, shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            offset: const Offset(0.4, 0.4),
                                            blurRadius: 0.5,
                                          ),
                                        ]),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ));
  }
}

void extractPdfText(({String filePath, SendPort sendPort}) data) {
  //TODO: Support password input if file requires password
  PdfDocument document =
      PdfDocument(inputBytes: File(data.filePath).readAsBytesSync());
  String text = PdfTextExtractor(document).extractText();
  document.dispose();
  return data.sendPort.send(text);
}
