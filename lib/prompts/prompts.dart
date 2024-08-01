class Prompts {
  static const filePickedPrompt =
      '''Given this document, list the name (preferably as it appears in the document not just the file name),
    the authors, publisher, year of publishing, edition, type of document e.g. book, paper, article, magazine etc. 
    ,tags for the document.
    Do this in JSON format like shown below :                                                                                       
    {
      "name": "",
      "authors": [
        "",
        ""
      ],
      "publisher": "",
      "year": ,
      "edition": "",
      "type": "",
      "tags": [
        "",
        "",
        "",
      ]
    }
  ''';

  static const summaryPrompt = '''
  What is the main goal of reading this document? 
  Based on this goal summarize the document keeping only what is relevant to 
  achieve this goal as a reader and site parts that are skipped and parts that
  are included in the summary. 
  Include page numbers for the parts(beginningPage, endingPage, 
  beginningWordIndex(the index of the first word that is skipped in the beginningPage)
   and endingWordIndex(the index of the last word that is skipped in the endingPage), 
   title and description).Skipped parts should also be listed just like the included parts. Format this in JSON like so:
   {
  "goal": "",
  "summary": {
    "included": [
      {
        "beginningPage": ,
        "endingPage": ,
        "beginningWordIndex": ,
        "endingWordIndex": ,
        "title": "",
        "description": ""
      },
      {
        "beginningPage": ,
        "endingPage": ,
        "beginningWordIndex": ,
        "endingWordIndex": ,
        "title": "",
        "description": ""
      }
    ],
    "skipped": [
      {
        "beginningPage": ,
        "endingPage": ,
        "beginningWordIndex": ,
        "endingWordIndex": ,
        "title": "",
        "description": ""
      },
      {
        "beginningPage": ,
        "endingPage": ,
        "beginningWordIndex": ,
        "endingWordIndex": ,
        "title": "",
        "description": ""
      },
    ]
  }
}
   
   ''';
}
