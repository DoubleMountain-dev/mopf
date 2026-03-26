// lib/providers/library_provider.dart

import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/reading_settings.dart';
import '../utils/sample_data.dart';

class LibraryProvider extends ChangeNotifier {
  List<Book> _books = getSampleBooks();
  ReadingSettings _settings = const ReadingSettings();
  String? _currentBookId;

  List<Book> get books => _books;
  ReadingSettings get settings => _settings;

  List<Book> get currentlyReading =>
      _books.where((b) => b.currentPage > 0 && b.progress < 1.0).toList();

  List<Book> get notStarted =>
      _books.where((b) => b.currentPage == 0).toList();

  List<Book> get finished =>
      _books.where((b) => b.progress >= 1.0).toList();

  Book? get currentBook =>
      _currentBookId != null
          ? _books.firstWhere((b) => b.id == _currentBookId, orElse: () => _books.first)
          : null;

  void setCurrentBook(String bookId) {
    _currentBookId = bookId;
    notifyListeners();
  }

  void updateProgress(String bookId, int page) {
    final idx = _books.indexWhere((b) => b.id == bookId);
    if (idx != -1) {
      _books[idx] = _books[idx].copyWith(currentPage: page);
      notifyListeners();
    }
  }

  void addQuote(String bookId, BookQuote quote) {
    final idx = _books.indexWhere((b) => b.id == bookId);
    if (idx != -1) {
      final updated = List<BookQuote>.from(_books[idx].quotes)..add(quote);
      _books[idx] = _books[idx].copyWith(quotes: updated);
      notifyListeners();
    }
  }

  void addBookmark(String bookId, Bookmark bookmark) {
    final idx = _books.indexWhere((b) => b.id == bookId);
    if (idx != -1) {
      final updated = List<Bookmark>.from(_books[idx].bookmarks)..add(bookmark);
      _books[idx] = _books[idx].copyWith(bookmarks: updated);
      notifyListeners();
    }
  }

  void removeQuote(String bookId, String quoteId) {
    final idx = _books.indexWhere((b) => b.id == bookId);
    if (idx != -1) {
      final updated = _books[idx].quotes.where((q) => q.id != quoteId).toList();
      _books[idx] = _books[idx].copyWith(quotes: updated);
      notifyListeners();
    }
  }

  void updateSettings(ReadingSettings settings) {
    _settings = settings;
    notifyListeners();
  }

  List<BookQuote> get allQuotes {
    final quotes = <BookQuote>[];
    for (final book in _books) {
      quotes.addAll(book.quotes);
    }
    quotes.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return quotes;
  }

  List<Bookmark> get allBookmarks {
    final bookmarks = <Bookmark>[];
    for (final book in _books) {
      bookmarks.addAll(book.bookmarks);
    }
    bookmarks.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return bookmarks;
  }
}
