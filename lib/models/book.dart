// lib/models/book.dart

class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String genre;
  final double rating;
  final int totalPages;
  int currentPage;
  final List<String> chapters;
  final String spineColor;
  final String coverColor;
  final List<BookQuote> quotes;
  final List<Bookmark> bookmarks;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.genre,
    required this.rating,
    required this.totalPages,
    this.currentPage = 0,
    required this.chapters,
    required this.spineColor,
    required this.coverColor,
    List<BookQuote>? quotes,
    List<Bookmark>? bookmarks,
  })  : quotes = quotes ?? [],
        bookmarks = bookmarks ?? [];

  double get progress => totalPages > 0 ? currentPage / totalPages : 0.0;

  Book copyWith({int? currentPage, List<BookQuote>? quotes, List<Bookmark>? bookmarks}) {
    return Book(
      id: id,
      title: title,
      author: author,
      description: description,
      genre: genre,
      rating: rating,
      totalPages: totalPages,
      currentPage: currentPage ?? this.currentPage,
      chapters: chapters,
      spineColor: spineColor,
      coverColor: coverColor,
      quotes: quotes ?? this.quotes,
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }
}

class BookQuote {
  final String id;
  final String text;
  final String chapter;
  final int page;
  final DateTime savedAt;
  String? note;

  BookQuote({
    required this.id,
    required this.text,
    required this.chapter,
    required this.page,
    DateTime? savedAt,
    this.note,
  }) : savedAt = savedAt ?? DateTime.now();
}

class Bookmark {
  final String id;
  final String chapter;
  final int page;
  final String preview;
  final DateTime savedAt;

  Bookmark({
    required this.id,
    required this.chapter,
    required this.page,
    required this.preview,
    DateTime? savedAt,
  }) : savedAt = savedAt ?? DateTime.now();
}
