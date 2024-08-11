import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String? title;
  List<String>? authors;
  List<String>? tags;
  String? publisher;
  String? isbn;
  String? edition;
  String? genre;
  String? description;
  String? language;
  String? publicationDate;
  String? coverImage;
  String? filePath;
  String? fileType;
  String? fileUrl;
  String? fileContent;
  String? fileContentSize;
  String? fileContentMimeType;
  String? fileContentEncoding;
  String? fileContentCompression;
  String? fileContentGoal;
  String? fileContentObjective;
  String? fileContentSummary;
  List<SkipInclude>? includedskipIncludes;
  List<SkipInclude>? skippedskipIncludes;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? deletedAt;

  Book.fromJson(Map<String, Object?> json) {
    title = json['title'] as String?;
    authors = (json['authors'] as List?)?.map((e) => e as String).toList();
    tags = (json['tags'] as List?)?.map((e) => e as String).toList();
    publisher = json['publisher'] as String?;
    isbn = json['isbn'] as String?;
    edition = json['edition'] as String?;
    genre = json['genre'] as String?;
    description = json['description'] as String?;
    language = json['language'] as String?;
    publicationDate = json['publicationDate'] as String?;
    coverImage = json['coverImage'] as String?;
    filePath = json['filePath'] as String?;
    fileType = json['fileType'] as String?;
    fileUrl = json['fileUrl'] as String?;
    fileContent = json['fileContent'] as String?;
    fileContentSize = json['fileContentSize'] as String?;
    fileContentMimeType = json['fileContentMimeType'] as String?;
    fileContentEncoding = json['fileContentEncoding'] as String?;
    fileContentCompression = json['fileContentCompression'] as String?;
    fileContentGoal = json['fileContentGoal'] as String?;
    fileContentObjective = json['fileContentObjective'] as String?;
    fileContentSummary = json['fileContentSummary'] as String?;
    includedskipIncludes = (json['includedskipIncludes'] as List?)
        ?.map((e) => SkipInclude.fromJson(e as Map<String, Object?>))
        .toList();
    skippedskipIncludes = (json['skippedskipIncludes'] as List?)
        ?.map((e) => SkipInclude.fromJson(e as Map<String, Object?>))
        .toList();
    createdAt = json['createdAt'] as Timestamp?;
    updatedAt = json['updatedAt'] as Timestamp?;
    deletedAt = json['deletedAt'] as Timestamp?;
  }
  Map<String, Object?> toJson() {
    return {
      'title': title,
      'authors': authors,
      'tags': tags,
      'publisher': publisher,
      'isbn': isbn,
      'edition': edition,
      'genre': genre,
      'description': description,
      'language': language,
      'publicationDate': publicationDate,
      'coverImage': coverImage,
      'filePath': filePath,
      'fileType': fileType,
      'fileUrl': fileUrl,
      'fileContent': fileContent,
      'fileContentSize': fileContentSize,
      'fileContentMimeType': fileContentMimeType,
      'fileContentEncoding': fileContentEncoding,
      'fileContentCompression': fileContentCompression,
      'fileContentGoal': fileContentGoal,
      'fileContentObjective': fileContentObjective,
      'fileContentSummary': fileContentSummary,
      'includedskipIncludes':
          includedskipIncludes?.map((e) => e.toJson()).toList(),
      'skippedskipIncludes':
          skippedskipIncludes?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}

class SkipInclude {
  int? beginningPage;
  int? beginningWordIndex;
  int? endingPage;
  int? endingWordIndex;
  String? title;
  String? description;

  SkipInclude.fromJson(Map<String, Object?> json) {
    beginningPage = json['beginningPage'] as int?;
    beginningWordIndex = json['beginningWordIndex'] as int?;
    endingPage = json['endingPage'] as int?;
    endingWordIndex = json['endingWordIndex'] as int?;
    title = json['title'] as String?;
    description = json['description'] as String?;
  }

  Map<String, Object?> toJson() {
    return {
      'beginningPage': beginningPage,
      'beginningWordIndex': beginningWordIndex,
      'endingPage': endingPage,
      'endingWordIndex': endingWordIndex,
      'title': title,
      'description': description,
    };
  }
}

class BooksDBService {
  final String booksCollection = "books";

  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _booksRef;

  BooksDBService() {
    _booksRef = _firestore.collection(booksCollection).withConverter<Book>(
        fromFirestore: (snapshot, _) => Book.fromJson(snapshot.data()!),
        toFirestore: (book, _) => book.toJson());
  }

  Stream<QuerySnapshot> getBooks() {
    return _booksRef.snapshots();
  }

  void addBook(Book book) {
    _booksRef.add(book);
  }
}
