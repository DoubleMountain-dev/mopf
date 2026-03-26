// lib/screens/notes_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/library_provider.dart';
import '../models/book.dart';
import '../utils/app_theme.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final quotes = library.allQuotes;
    final bookmarks = library.allBookmarks;

    return Scaffold(
      backgroundColor: AppColors.paperWarm,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text(
              'Заметки и закладки',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.paperWarm,
              ),
            ),
            backgroundColor: AppColors.woodBrown,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.accentRed),
                onPressed: () {},
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.accentRed,
              indicatorWeight: 2,
              labelColor: AppColors.accentRed,
              unselectedLabelColor: AppColors.paperWarm.withOpacity(0.5),
              labelStyle: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 13),
              tabs: [
                Tab(text: 'Цитаты (${quotes.length})'),
                Tab(text: 'Закладки (${bookmarks.length})'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _QuotesList(quotes: quotes, books: library.books),
            _BookmarksList(bookmarks: bookmarks, books: library.books),
          ],
        ),
      ),
    );
  }
}

class _QuotesList extends StatelessWidget {
  final List<BookQuote> quotes;
  final List books;

  const _QuotesList({required this.quotes, required this.books});

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) {
      return _EmptyState(
        icon: Icons.format_quote_rounded,
        message: 'Нет сохранённых цитат',
        subtitle: 'Выделите текст при чтении,\nчтобы сохранить цитату',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: quotes.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Color(0xFFE8E0D0),
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (ctx, i) {
        final quote = quotes[i];
        return _QuoteCard(quote: quote);
      },
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final BookQuote quote;
  const _QuoteCard({required this.quote});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 6) return '${(diff.inDays / 7).round()} нед. назад';
    if (diff.inDays > 0) return '${diff.inDays} дн. назад';
    if (diff.inHours > 0) return '${diff.inHours} ч. назад';
    return 'только что';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote text
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              color: AppColors.creamLight,
              borderRadius: BorderRadius.circular(8),
              border: const Border(
                left: BorderSide(color: AppColors.accentRed, width: 3),
              ),
            ),
            child: Text(
              '"${quote.text}"',
              style: GoogleFonts.playfairDisplay(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF5A4E3A),
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.creamLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${quote.chapter} · стр. ${quote.page}',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: AppColors.mutedBrown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _timeAgo(quote.savedAt),
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: AppColors.mutedBrown,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BookmarksList extends StatelessWidget {
  final List<Bookmark> bookmarks;
  final List books;

  const _BookmarksList({required this.bookmarks, required this.books});

  @override
  Widget build(BuildContext context) {
    if (bookmarks.isEmpty) {
      return _EmptyState(
        icon: Icons.bookmark_border_rounded,
        message: 'Нет закладок',
        subtitle: 'Нажмите на иконку закладки\nвo время чтения',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: bookmarks.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        color: Color(0xFFE8E0D0),
        indent: 16,
        endIndent: 16,
      ),
      itemBuilder: (ctx, i) {
        final bm = bookmarks[i];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accentRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bookmark_rounded,
                  color: AppColors.accentRed,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bm.chapter,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Страница ${bm.page}',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.mutedBrown,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.mutedBrown,
                size: 18,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: AppColors.mutedBrown.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedBrown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: AppColors.mutedBrown.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
