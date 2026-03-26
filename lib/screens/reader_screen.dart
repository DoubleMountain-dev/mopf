// lib/screens/reader_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../models/reading_settings.dart';
import '../providers/library_provider.dart';
import '../utils/app_theme.dart';
import 'reading_settings_screen.dart';

class ReaderScreen extends StatefulWidget {
  final Book book;
  const ReaderScreen({super.key, required this.book});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool _showBars = true;
  int _currentChapterIndex = 0;
  late ScrollController _scrollController;
  String? _selectedText;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color get _bgColor {
    final settings = context.read<LibraryProvider>().settings;
    switch (settings.backgroundTheme) {
      case BackgroundTheme.dark:
        return const Color(0xFF1A1208);
      case BackgroundTheme.night:
        return const Color(0xFF0D1117);
      case BackgroundTheme.light:
        return Colors.white;
      case BackgroundTheme.sepia:
        return const Color(0xFFFAF6ED);
    }
  }

  Color get _textColor {
    final settings = context.read<LibraryProvider>().settings;
    switch (settings.backgroundTheme) {
      case BackgroundTheme.dark:
      case BackgroundTheme.night:
        return const Color(0xFFD4C9B0);
      case BackgroundTheme.light:
      case BackgroundTheme.sepia:
        return const Color(0xFF3D3020);
    }
  }

  String get _fontFamily {
    final settings = context.read<LibraryProvider>().settings;
    switch (settings.fontFamily) {
      case FontFamily.serif:
        return 'Playfair Display';
      case FontFamily.sansSerif:
        return 'DM Sans';
      case FontFamily.monospace:
        return 'Source Code Pro';
    }
  }

  void _toggleBars() {
    setState(() => _showBars = !_showBars);
  }

  void _saveQuote(String text) {
    final book = widget.book;
    final quote = BookQuote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      chapter: book.chapters.isNotEmpty
          ? book.chapters[_currentChapterIndex]
          : 'Глава ${_currentChapterIndex + 1}',
      page: book.currentPage,
    );
    context.read<LibraryProvider>().addQuote(book.id, quote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.format_quote, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            const Text('Цитата сохранена'),
          ],
        ),
        backgroundColor: AppColors.accentRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addBookmark() {
    final book = widget.book;
    final bookmark = Bookmark(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chapter: book.chapters.isNotEmpty
          ? book.chapters[_currentChapterIndex]
          : 'Глава ${_currentChapterIndex + 1}',
      page: book.currentPage,
      preview: 'Закладка на странице ${book.currentPage}',
    );
    context.read<LibraryProvider>().addBookmark(book.id, bookmark);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.bookmark, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Закладка добавлена'),
          ],
        ),
        backgroundColor: AppColors.woodBrown,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<LibraryProvider>().settings;
    final book = widget.book;
    final chapterTitle = book.chapters.isNotEmpty
        ? book.chapters[_currentChapterIndex]
        : 'Глава ${_currentChapterIndex + 1}';
    final totalChapters = book.chapters.length;
    final progress = totalChapters > 0
        ? (_currentChapterIndex + 1) / totalChapters
        : book.progress;

    return Scaffold(
      backgroundColor: _bgColor,
      body: GestureDetector(
        onTap: _toggleBars,
        child: Stack(
          children: [
            // Reading content
            SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(
                24,
                _showBars ? 80 : 40,
                24,
                _showBars ? 80 : 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chapter number
                  Center(
                    child: Text(
                      'ГЛАВА ${_currentChapterIndex + 1}',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentRed,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      chapterTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Decorative divider
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 1,
                          color: AppColors.accentRed.withOpacity(0.4),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.accentRed.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 1,
                          color: AppColors.accentRed.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Reading text
                  _SelectableReadingText(
                    book: book,
                    chapterIndex: _currentChapterIndex,
                    textColor: _textColor,
                    fontSize: settings.fontSize,
                    lineHeight: settings.lineHeight,
                    fontFamily: _fontFamily,
                    onSaveQuote: _saveQuote,
                  ),
                  const SizedBox(height: 40),
                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentChapterIndex > 0)
                        TextButton.icon(
                          onPressed: () {
                            setState(() => _currentChapterIndex--);
                            _scrollController.jumpTo(0);
                          },
                          icon: Icon(Icons.arrow_back, size: 16, color: AppColors.accentRed),
                          label: Text(
                            'Назад',
                            style: GoogleFonts.dmSans(color: AppColors.accentRed),
                          ),
                        )
                      else
                        const SizedBox(),
                      if (_currentChapterIndex < totalChapters - 1)
                        TextButton.icon(
                          onPressed: () {
                            setState(() => _currentChapterIndex++);
                            _scrollController.jumpTo(0);
                          },
                          icon: Text(
                            'Далее',
                            style: GoogleFonts.dmSans(color: AppColors.accentRed),
                          ),
                          label: Icon(Icons.arrow_forward, size: 16, color: AppColors.accentRed),
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),

            // Top bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: _showBars ? 0 : -80,
              left: 0,
              right: 0,
              child: Container(
                color: _bgColor.withOpacity(0.96),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back,
                            color: _textColor,
                            size: 22,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Глава ${_currentChapterIndex + 1} · ${(progress * 100).round()}%',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  color: _textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _addBookmark,
                          icon: Icon(
                            Icons.bookmark_outline,
                            color: _textColor,
                            size: 22,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ReadingSettingsScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.tune_rounded,
                            color: _textColor,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom bar with progress
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              bottom: _showBars ? 0 : -80,
              left: 0,
              right: 0,
              child: Container(
                color: _bgColor.withOpacity(0.96),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${book.currentPage}',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: _textColor.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: _textColor.withOpacity(0.1),
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.accentRed,
                              ),
                              minHeight: 3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${book.totalPages}',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: _textColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableReadingText extends StatelessWidget {
  final Book book;
  final int chapterIndex;
  final Color textColor;
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final void Function(String) onSaveQuote;

  const _SelectableReadingText({
    required this.book,
    required this.chapterIndex,
    required this.textColor,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.onSaveQuote,
  });

  List<String> get _paragraphs {
    // Generate chapter text based on chapter index
    final baseTexts = [
      'В час жаркого весеннего заката на Патриарших прудах появилось двое граждан. Первый из них — приблизительно сорокалетний, одетый в серенький летний костюм, — был маленького роста, упитан, лыс, свою приличную шляпу пирожком нёс в руке, а аккуратно выбритое лицо его украшали сверхъестественных размеров очки в чёрной роговой оправе.',
      'Второй — плечистый, рыжеватый, вихрастый молодой человек в заломленной на затылок клетчатой кепке — был в ковбойке, жёваных белых брюках и в чёрных тапочках.',
      'Первый был не кто иной, как Михаил Александрович Берлиоз, председатель правления одной из крупнейших московских литературных ассоциаций, сокращённо именуемой МАССОЛИТ, и редактор толстого художественного журнала, а молодой спутник его — поэт Иван Николаевич Понырев, пишущий под псевдонимом Бездомный.',
      'Да, человек смертен, но это было бы ещё полбеды. Плохо то, что он иногда внезапно смертен, вот в чём фокус! И вообще не может сказать, что он будет делать в сегодняшний вечер.',
      '— Это совершенно справедливо, — согласился незнакомец с Берлиозом, — и это именно то, о чём я и хочу поговорить. Позвольте узнать, не иностранец ли вы?',
      'Берлиоз только что успел подумать: «Иностранец!» — как Прокофьевна влетела в кабинет с криком: «Михаил Александрович! Иностранный гость! Просит принять!»',
      'Трусость, несомненно, один из самых страшных пороков. Так говорил Иешуа Га-Ноцри. Нет, философ, я тебе возражаю: это самый страшный порок.',
      'Рукописи не горят. Это была не просто фраза — это была аксиома, в которую Воланд верил так же твёрдо, как в законы природы.',
      'Никогда и ничего не просите! Никогда и ничего, и в особенности у тех, кто сильнее вас. Сами предложат и сами всё дадут!',
      'Москва жила своей обычной ночной жизнью. Кто-то читал, кто-то спал, кто-то думал о вечном. Но над городом незримо парила тень чего-то необъяснимого и великого.',
    ];
    
    // Cycle through base texts for each chapter
    final start = (chapterIndex * 3) % baseTexts.length;
    final result = <String>[];
    for (int i = 0; i < 6; i++) {
      result.add(baseTexts[(start + i) % baseTexts.length]);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = fontFamily == 'Playfair Display'
        ? GoogleFonts.playfairDisplay(
            fontSize: fontSize,
            color: textColor,
            height: lineHeight,
          )
        : fontFamily == 'DM Sans'
        ? GoogleFonts.dmSans(
            fontSize: fontSize,
            color: textColor,
            height: lineHeight,
          )
        : TextStyle(
            fontFamily: 'monospace',
            fontSize: fontSize,
            color: textColor,
            height: lineHeight,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _paragraphs.map((paragraph) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SelectableText(
            paragraph,
            style: textStyle,
            onSelectionChanged: (selection, cause) {
              if (selection.isCollapsed) return;
              final selected = paragraph.substring(
                selection.start,
                selection.end,
              );
              if (selected.isNotEmpty && selected.length > 10) {
                // Show save quote action
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (context.mounted) {
                    _showSaveQuoteDialog(context, selected);
                  }
                });
              }
            },
          ),
        );
      }).toList(),
    );
  }

  void _showSaveQuoteDialog(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.paperWarm,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Сохранить цитату?',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.inkDark,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.creamLight,
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                  left: BorderSide(color: AppColors.accentRed, width: 3),
                ),
              ),
              child: Text(
                '"${text.length > 150 ? '${text.substring(0, 150)}...' : text}"',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF5A4E3A),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onSaveQuote(text);
                },
                icon: const Icon(Icons.format_quote),
                label: Text(
                  'Сохранить',
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
