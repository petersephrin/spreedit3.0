class Books {
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
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
}

class SkipInclude {
  int? beginningPage;
  int? beginningWordIndex;
  int? endingPage;
  int? endingWordIndex;
  String? description;
}
