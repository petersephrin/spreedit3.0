import 'package:google_generative_ai/google_generative_ai.dart';

class Gemini {
  GenerativeModel init() {
    const apiKey = String.fromEnvironment("GEMINI_KEY",
        defaultValue: "AIzaSyCidDeDl41iW7A0i9l3hESfq5hfPHcdrLo");

    final model =
        GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
    return model;
  }
}
