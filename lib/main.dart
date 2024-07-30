import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:spreedit/prompts/prompts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  //syncfusion
  //Ngo9BigBOggjHTQxAR8/V1NCaF1cWWhBYVZpR2Nbe05zflVEal9VVAciSV9jS3pTcUdqWXxecndRRmVeUg==
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpreedIt',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 7, 51, 145)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SpreedIt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GenerativeModel initGemini() {
    const apiKey = String.fromEnvironment("GEMINI_KEY",
        defaultValue: "AIzaSyCidDeDl41iW7A0i9l3hESfq5hfPHcdrLo");

    final model =
        GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
    return model;
  }

  void pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      String prompt = Prompts.filePickedPrompt;
      var content = [Content.text(prompt)];
      for (PlatformFile file in result.files) {
        print(file.name);
        if (file.extension == "pdf") {
          String text = extractPdfText(file.path!);
          content.add(Content.text(text));
        } else if (file.extension == "epub") {
          //extract text from epub
        } else if (file.extension == "png" ||
            file.extension == "jpg" ||
            file.extension == "jpeg") {
          Uint8List bytes = await File(file.path!).readAsBytes();
          content.add(Content.data(file.extension!, bytes));
        }
      }

      final gemini = initGemini();

      print(content.join("******"));
      gemini
          .generateContent(content,
              generationConfig:
                  GenerationConfig(responseMimeType: "application/json"))
          .then((value) => print(value.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Add files to start.',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'Hint: Open multiple files to study a topic.',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFiles,
        tooltip: 'Open files',
        child: const Icon(Icons.file_open_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

String extractPdfText(String filepath) {
  //TODO: Support password input if file requires password
  PdfDocument document =
      PdfDocument(inputBytes: File(filepath).readAsBytesSync());
  String text = PdfTextExtractor(document).extractText();
  return text;
}
