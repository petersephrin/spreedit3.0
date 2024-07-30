class Prompts {
  static const filePickedPrompt =
      '''Given these documents in text extracted from pdf or epub files ,
  separated by the words "New Document + FILE NAME", 
  list a topic that relates all the documents, if they actually have related topic,
   and for every document list the name (preferably as it appears in the document not just the file name),
    the authors, publisher, year of publishing, edition, type of document e.g. book, paper, article, magazine etc. 
    ,tags for the document and which page the cover page is in(usually on page 1 but in other documents the cover page is in other areas.The cover page probably has less text except maybe for the title of the book and author.). 
    Do this in JSON format like shown below :                                                                                       
    {   
    "topic": "Plasma Physics",
    "docs_have_related_topic": true,
    "books":[
    {
      "name": "Is a Plasma Diamagnetic?",
      "authors": [
        "W. Engelhardt"
      ],
      "publisher": null,
      "year": null,
      "edition": null,
      "type": "Article",
      "tags": [
        "Plasma Physics",
        "Diamagnetism",
        "Magnetohydrodynamics",
        "Lorentz Force",
        "Magnetic Confinement",
        "Theta Pinch"
      ],
      "cover_page": 1
    },
    {
      "name": "Electricity and Magnetism",
      "authors": [
        "Edward M. Purcell",
        "David J. Morin"
      ],
      "publisher": "Cambridge University Press",
      "year": 2013,
      "edition": "Third Edition",
      "type": "Book",
      "tags": [
        "Electricity",
        "Magnetism",
        "Physics",
        "Electromagnetism",
        "Electrostatics",
        "Magnetostatics",
        "Circuits",
        "Electromagnetic Waves",
        "SI Units",
        "Gaussian Units",
        "Relativity"
      ],
      "cover_page": 3 
    }
  ]
}
  ''';
}
