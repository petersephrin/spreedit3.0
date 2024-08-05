class Prompts {
  static const filePickedPrompt = '''
    Extract the following metadata from the provided text:

* **title:** The title of the document as it appears in the text.
* **authors:** A list of authors as they appear in the text.
* **publisher:** The name of the publisher.
* **publicationDate:** The publication year.
* **language:** The language of the document.
* **isbn:** The ISBN number (if available).
* **edition:** The edition number or description (if available).
* **fileType:** The document type (e.g., book, article, report, thesis).
* **tags:** A list of relevant keywords or topics related to the document (maximum 12).

* **description:** Come up with a brief description of the document.
Output the metadata in JSON format:

{
  "title": "",
  "authors": [
    "",
    ""
  ],
  "publisher": "",
  "publicationDate": "",
  "language": "",
  "description": "",
  "isbn": "",
  "edition": "",
  "fileType": "",
  "tags": [
    "",
    "",
    ""
  ]
}
  ''';

  static const summaryPrompt = '''
  Identify the primary objective of reading this document(the goal). Based on this objective, generate a concise summary focusing on the most critical information to achieve the goal.

Structure your response in JSON format as follows:

{
  "goal": "",
  "summary": {
    "included": [
      {
        "beginningPage": 1,
        "endingPage": 3,
        "beginningWordIndex": 100,
        "endingWordIndex": 250,
        "title": "Document Introduction",
        "description": "Provides essential background information and problem statement."
      },
      ...
    ],
    "skipped": [
      {
        "beginningPage": 4,
        "endingPage": 6,
        "beginningWordIndex": 0,
        "endingWordIndex": 1500,
        "title": "Methodology Details",
        "description": "In-depth explanation of research methods, not crucial for understanding the main findings."
      },
      ...
    ]
  }
}

Include as many included and skipped sections as necessary to accurately represent the document and its summary.
   ''';
}
