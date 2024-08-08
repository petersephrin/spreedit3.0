import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:spreedit/models/books.dart';

class ReadPdf extends StatefulWidget {
  const ReadPdf({super.key, required this.book});

  final Book book;
  @override
  State<ReadPdf> createState() => _ReadPdfState();
}

class _ReadPdfState extends State<ReadPdf> {
  @override
  Widget build(Object context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title ?? ""),
      ),
      body: Hero(
        tag: widget.book.title!,
        child: PdfViewer.file(
          widget.book.filePath!,
          params: PdfViewerParams(
            enableTextSelection: true,
            viewerOverlayBuilder: (context, size, handleLinkTap) =>
                viewerOverlayBuilder(context, size, handleLinkTap),
            pageOverlaysBuilder: (context, pageRect, page) =>
                pageOverlayBuilder(context, pageRect, page),
          ),
        ),
      ),
    ));
  }

  viewerOverlayBuilder(
      BuildContext context, Size size, Function handleLinkTap) {
    return [
      SearchBar(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            debugPrint("Search");
          },
        ),
      ),
    ];
  }

  pageOverlayBuilder(BuildContext context, Rect pageRect, PdfPage page) {
    return [
      // SizedBox(
      //   height: 800,
      //   width: 800,
      //   child: BackdropFilter(
      //     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      //   ),
      // ),
      Align(
        alignment: Alignment.center,
        child: (page.pageNumber == 2)
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Text(page.pageNumber.toString(),
                    style: const TextStyle(color: Colors.red)),
              )
            : Text(page.pageNumber.toString(),
                style: const TextStyle(color: Colors.red)),
      )
    ];
  }
}
