// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/library_provider.dart';
import '../models/book.dart';
import '../utils/app_theme.dart';
import 'book_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final results = _query.isEmpty
        ? library.books
        : library.books
            .where(
              (b) =>
                  b.title.toLowerCase().contains(_query.toLowerCase()) ||
                  b.author.toLowerCase().contains(_query.toLowerCase()) ||
                  b.genre.toLowerCase().contains(_query.toLowerCase()),
            )
            .toList();

    return Scaffold(
      backgroundColor: AppColors.creamLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: AppColors.woodBrown,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Поиск',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.paperWarm,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.paperWarm.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.paperWarm.withOpacity(0.2),
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      onChanged: (v) => setState(() => _query = v),
                      style: GoogleFonts.dmSans(
                        color: AppColors.paperWarm,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Название, автор, жанр...',
                        hintStyle: GoogleFonts.dmSans(
                          color: AppColors.paperWarm.withOpacity(0.4),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.paperWarm.withOpacity(0.5),
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: AppColors.paperWarm.withOpacity(0.5),
                                  size: 18,
                                ),
                                onPressed: () {
                                  _controller.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Genres filter chips
            if (_query.isEmpty)
              Container(
                height: 44,
                color: AppColors.paperWarm,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    _GenreChip(label: 'Все', selected: true, onTap: () {}),
                    _GenreChip(label: 'Классика', selected: false, onTap: () {}),
                    _GenreChip(label: 'Роман', selected: false, onTap: () {}),
                    _GenreChip(label: 'Антиутопия', selected: false, onTap: () {}),
                    _GenreChip(label: 'Мистика', selected: false, onTap: () {}),
                  ],
                ),
              ),

            // Results
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text(
                        'Ничего не найдено',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          color: AppColors.mutedBrown,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) => _SearchResultCard(book: results[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenreChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentRed : AppColors.creamLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppColors.mutedBrown,
          ),
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final Book book;
  const _SearchResultCard({required this.book});

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
        decoration: BoxDecoration(
          color: AppColors.paperWarm,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Mini cover
            Container(
              width: 60,
              height: 86,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        book.title[0],
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      book.author,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.accentRed,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.creamLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            book.genre,
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              color: AppColors.mutedBrown,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '★ ${book.rating}',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: AppColors.goldAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (book.currentPage > 0) ...[
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: book.progress,
                          backgroundColor: AppColors.creamLight,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right,
                color: AppColors.mutedBrown,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
