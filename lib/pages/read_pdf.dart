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
    List<Widget> widgets = [];
    return widgets;
  }

  (bool isSkipped, SkipInclude skippedInclude) isPageSkipped(int pageNumber) {
    List<SkipInclude> skippedIncludes = widget.book.skippedskipIncludes ?? [];
    SkipInclude emptySkipInclude = SkipInclude.fromJson(<String, dynamic>{});
    if (skippedIncludes.isEmpty) {
      return (false, emptySkipInclude);
    }
    for (SkipInclude skipped in skippedIncludes) {
      int? lPointer = skipped.beginningPage;
      int? rPointer = skipped.endingPage;
      if (lPointer == null || rPointer == null) {
        continue;
      }
      if (pageNumber >= lPointer && pageNumber <= rPointer) {
        return (true, skipped);
      }
    }
    return (false, emptySkipInclude);
  }

  pageOverlayBuilder(BuildContext context, Rect pageRect, PdfPage page) {
    var (isSkipped, skipped) = isPageSkipped(page.pageNumber);
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
        child: isSkipped
            ? ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: IgnorePointer(
                    ignoring: true,
                    child: SizedBox(
                      height: page.height,
                      width: page.width,
                      child: Text(
                          "${skipped.description} Page :${skipped.beginningPage!}End Page:${skipped.endingPage!}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 0, 0, 0))),
                    ),
                  ),
                ),
              )
            : Text(page.pageNumber.toString(),
                style: const TextStyle(color: Colors.red)),
      )
    ];
  }
}
