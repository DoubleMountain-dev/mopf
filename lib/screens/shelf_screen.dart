// lib/screens/shelf_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/library_provider.dart';
import '../models/book.dart';
import '../utils/app_theme.dart';
import 'book_detail_screen.dart';

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final reading = library.currentlyReading;
    final notStarted = library.notStarted;

    return Scaffold(
      backgroundColor: AppColors.creamLight,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 90,
            backgroundColor: AppColors.woodBrown,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Folio',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.paperWarm,
                    ),
                  ),
                  Icon(
                    Icons.add_circle_outline,
                    color: AppColors.accentRed,
                    size: 26,
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.paperWarm,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.creamLight),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: AppColors.mutedBrown, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Поиск по библиотеке...',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: AppColors.mutedBrown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Currently reading section
          if (reading.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Читаю сейчас',
                count: reading.length,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  itemCount: reading.length,
                  itemBuilder: (ctx, i) => _ReadingBookCard(book: reading[i]),
                ),
              ),
            ),
            SliverToBoxAdapter(child: _WoodShelf()),
          ],

          // Full library shelf
          SliverToBoxAdapter(
            child: _SectionHeader(
              title: 'Вся библиотека',
              count: library.books.length,
            ),
          ),
          SliverToBoxAdapter(
            child: _ShelfRow(books: library.books),
          ),
          SliverToBoxAdapter(child: _WoodShelf()),

          // Not started
          if (notStarted.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Хочу прочитать',
                count: notStarted.length,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.6,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _GridBookCard(book: notStarted[i]),
                  childCount: notStarted.length,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedBrown,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accentRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: AppColors.accentRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WoodShelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFC8B89A),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

class _ReadingBookCard extends StatelessWidget {
  final Book book;
  const _ReadingBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(book.spineColor.replaceFirst('#', '0xFF')));
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(4, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Spine shadow
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  // Title
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        book.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                  // Author at bottom
                  Positioned(
                    bottom: 10,
                    left: 8,
                    right: 8,
                    child: Text(
                      book.author,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 9,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Progress
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: book.progress,
                backgroundColor: AppColors.creamLight,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 3,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'стр. ${book.currentPage}',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    color: AppColors.mutedBrown,
                  ),
                ),
                Text(
                  '${(book.progress * 100).round()}%',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ShelfRow extends StatelessWidget {
  final List<Book> books;
  const _ShelfRow({required this.books});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        itemCount: books.length,
        itemBuilder: (ctx, i) {
          final book = books[i];
          final color =
              Color(int.parse(book.spineColor.replaceFirst('#', '0xFF')));
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
              );
            },
            child: Container(
              width: 52,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 6,
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                  if (book.progress > 0)
                    Positioned(
                      bottom: 0,
                      left: 6,
                      right: 0,
                      child: Container(
                        height: 130 * book.progress,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GridBookCard extends StatelessWidget {
  final Book book;
  const _GridBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(book.spineColor.replaceFirst('#', '0xFF')));
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 6,
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        book.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            book.author.split(' ').last,
            style: GoogleFonts.dmSans(
              fontSize: 9,
              color: AppColors.mutedBrown,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
