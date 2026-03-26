// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/library_provider.dart';
import '../utils/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final totalBooks = library.books.length;
    final readingBooks = library.currentlyReading.length;
    final totalQuotes = library.allQuotes.length;
    final totalPagesRead = library.books
        .fold<int>(0, (sum, b) => sum + b.currentPage);

    return Scaffold(
      backgroundColor: AppColors.creamLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.woodBrown,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.woodBrown,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.accentRed,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.paperWarm.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Читатель',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.paperWarm,
                        ),
                      ),
                      Text(
                        'Любитель классической литературы',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: AppColors.paperWarm.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Статистика',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: '$totalBooks',
                          label: 'Всего книг',
                          icon: Icons.auto_stories,
                          color: AppColors.spineNavy,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          value: '$readingBooks',
                          label: 'Читаю',
                          icon: Icons.menu_book,
                          color: AppColors.spineForest,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: '$totalQuotes',
                          label: 'Цитат',
                          icon: Icons.format_quote,
                          color: AppColors.spineCrimson,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatCard(
                          value: '$totalPagesRead',
                          label: 'Страниц',
                          icon: Icons.layers_rounded,
                          color: AppColors.spineAmber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Reading streak
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.paperWarm,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: AppColors.goldAccent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Серия чтения',
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: AppColors.mutedBrown,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '7 дней подряд',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldAccent,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '🔥',
                      style: const TextStyle(fontSize: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Settings list
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'Настройки',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkDark,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.paperWarm,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _SettingsListItem(
                    icon: Icons.tune_rounded,
                    label: 'Настройки чтения',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 48, color: Color(0xFFE8E0D0)),
                  _SettingsListItem(
                    icon: Icons.notifications_outlined,
                    label: 'Уведомления',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 48, color: Color(0xFFE8E0D0)),
                  _SettingsListItem(
                    icon: Icons.cloud_upload_outlined,
                    label: 'Резервная копия',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 48, color: Color(0xFFE8E0D0)),
                  _SettingsListItem(
                    icon: Icons.info_outline,
                    label: 'О приложении',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paperWarm,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkDark,
                ),
              ),
              Text(
                label,
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

class _SettingsListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsListItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.mutedBrown),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.inkDark,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.mutedBrown,
            ),
          ],
        ),
      ),
    );
  }
}
