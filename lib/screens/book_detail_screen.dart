// lib/screens/book_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/library_provider.dart';
import '../utils/app_theme.dart';
import 'reader_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(book.spineColor.replaceFirst('#', '0xFF')));
    final library = context.watch<LibraryProvider>();
    // Get latest book data
    final currentBook = library.books.firstWhere(
      (b) => b.id == book.id,
      orElse: () => book,
    );

    return Scaffold(
      backgroundColor: AppColors.paperWarm,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: color,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: color),
                  // Decorative lines
                  Positioned.fill(
                    child: CustomPaint(painter: _BookCoverPainter(color: color)),
                  ),
                  // Book cover card
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          width: 110,
                          height: 155,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(6, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  book.title,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              Text(
                                book.author,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmSans(
                                  fontSize: 9,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: AppColors.accentRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _Tag(text: book.genre),
                      _Tag(text: '${book.totalPages} стр.'),
                      _Tag(text: '★ ${book.rating}'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress section
                  if (currentBook.currentPage > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.creamLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Прогресс чтения',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mutedBrown,
                                ),
                              ),
                              Text(
                                '${(currentBook.progress * 100).round()}%',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: currentBook.progress,
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'стр. ${currentBook.currentPage} из ${book.totalPages}',
                            style: GoogleFonts.dmSans(
                              fontSize: 11,
                              color: AppColors.mutedBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Description
                  Text(
                    'О книге',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: const Color(0xFF5A4E3A),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Chapters
                  Text(
                    'Содержание',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...book.chapters.asMap().entries.map(
                    (entry) => _ChapterItem(
                      index: entry.key + 1,
                      title: entry.value,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<LibraryProvider>().setCurrentBook(book.id);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReaderScreen(book: currentBook),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.menu_book_rounded),
              label: Text(
                currentBook.currentPage > 0
                    ? 'Продолжить чтение'
                    : 'Начать читать',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.creamLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 12,
          color: AppColors.mutedBrown,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ChapterItem extends StatelessWidget {
  final int index;
  final String title;
  final Color color;
  const _ChapterItem({
    required this.index,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8E0D0), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$index',
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: AppColors.inkDark,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 16,
            color: AppColors.mutedBrown,
          ),
        ],
      ),
    );
  }
}

class _BookCoverPainter extends CustomPainter {
  final Color color;
  const _BookCoverPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      final y = size.height * 0.15 + i * 40.0;
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 30), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
