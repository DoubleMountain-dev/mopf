// lib/screens/reading_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/reading_settings.dart';
import '../providers/library_provider.dart';
import '../utils/app_theme.dart';

class ReadingSettingsScreen extends StatelessWidget {
  const ReadingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final settings = library.settings;

    return Scaffold(
      backgroundColor: AppColors.creamLight,
      appBar: AppBar(
        title: Text(
          'Настройки чтения',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.paperWarm,
          ),
        ),
        backgroundColor: AppColors.woodBrown,
        iconTheme: const IconThemeData(color: AppColors.paperWarm),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Font Family
          _SettingsCard(
            title: 'Гарнитура шрифта',
            child: Row(
              children: [
                _FontOption(
                  label: 'Serif',
                  sample: 'Aa',
                  fontFamily: GoogleFonts.playfairDisplay,
                  selected: settings.fontFamily == FontFamily.serif,
                  onTap: () => library.updateSettings(
                    settings.copyWith(fontFamily: FontFamily.serif),
                  ),
                ),
                const SizedBox(width: 8),
                _FontOption(
                  label: 'Sans',
                  sample: 'Aa',
                  fontFamily: GoogleFonts.dmSans,
                  selected: settings.fontFamily == FontFamily.sansSerif,
                  onTap: () => library.updateSettings(
                    settings.copyWith(fontFamily: FontFamily.sansSerif),
                  ),
                ),
                const SizedBox(width: 8),
                _FontOption(
                  label: 'Mono',
                  sample: 'Aa',
                  fontFamily: (style) => style.copyWith(fontFamily: 'monospace'),
                  selected: settings.fontFamily == FontFamily.monospace,
                  onTap: () => library.updateSettings(
                    settings.copyWith(fontFamily: FontFamily.monospace),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Font size
          _SettingsCard(
            title: 'Размер шрифта',
            child: Row(
              children: [
                Text(
                  'A',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    color: AppColors.mutedBrown,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: settings.fontSize,
                    min: 12,
                    max: 24,
                    divisions: 6,
                    activeColor: AppColors.accentRed,
                    inactiveColor: AppColors.mutedBrown.withOpacity(0.2),
                    onChanged: (v) => library.updateSettings(
                      settings.copyWith(fontSize: v),
                    ),
                  ),
                ),
                Text(
                  'A',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mutedBrown,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${settings.fontSize.round()}px',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.accentRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Line height
          _SettingsCard(
            title: 'Межстрочный интервал',
            child: Row(
              children: [
                Icon(Icons.format_line_spacing, color: AppColors.mutedBrown, size: 18),
                Expanded(
                  child: Slider(
                    value: settings.lineHeight,
                    min: 1.2,
                    max: 2.4,
                    divisions: 6,
                    activeColor: AppColors.accentRed,
                    inactiveColor: AppColors.mutedBrown.withOpacity(0.2),
                    onChanged: (v) => library.updateSettings(
                      settings.copyWith(lineHeight: v),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${settings.lineHeight.toStringAsFixed(1)}×',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.accentRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Theme
          _SettingsCard(
            title: 'Тема',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ThemeSwatch(
                  label: 'Сепия',
                  bgColor: const Color(0xFFFAF6ED),
                  textColor: AppColors.inkDark,
                  selected: settings.backgroundTheme == BackgroundTheme.sepia,
                  onTap: () => library.updateSettings(
                    settings.copyWith(backgroundTheme: BackgroundTheme.sepia),
                  ),
                ),
                _ThemeSwatch(
                  label: 'Белый',
                  bgColor: Colors.white,
                  textColor: AppColors.inkDark,
                  selected: settings.backgroundTheme == BackgroundTheme.light,
                  onTap: () => library.updateSettings(
                    settings.copyWith(backgroundTheme: BackgroundTheme.light),
                  ),
                ),
                _ThemeSwatch(
                  label: 'Тёмный',
                  bgColor: const Color(0xFF1A1208),
                  textColor: Colors.white,
                  selected: settings.backgroundTheme == BackgroundTheme.dark,
                  onTap: () => library.updateSettings(
                    settings.copyWith(backgroundTheme: BackgroundTheme.dark),
                  ),
                ),
                _ThemeSwatch(
                  label: 'Ночь',
                  bgColor: const Color(0xFF0D1117),
                  textColor: Colors.white,
                  selected: settings.backgroundTheme == BackgroundTheme.night,
                  onTap: () => library.updateSettings(
                    settings.copyWith(backgroundTheme: BackgroundTheme.night),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Toggles
          _SettingsCard(
            title: 'Дополнительно',
            child: Column(
              children: [
                _ToggleItem(
                  label: 'Ночной режим',
                  subtitle: 'Уменьшает яркость экрана',
                  icon: Icons.nights_stay_rounded,
                  value: settings.nightMode,
                  onChanged: (v) => library.updateSettings(
                    settings.copyWith(nightMode: v),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE8E0D0)),
                _ToggleItem(
                  label: 'Авто-прокрутка',
                  subtitle: 'Автоматически прокручивает текст',
                  icon: Icons.play_circle_outline,
                  value: settings.autoScroll,
                  onChanged: (v) => library.updateSettings(
                    settings.copyWith(autoScroll: v),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Preview
          _SettingsCard(
            title: 'Предпросмотр',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: settings.backgroundTheme == BackgroundTheme.dark ||
                        settings.backgroundTheme == BackgroundTheme.night
                    ? const Color(0xFF1A1208)
                    : settings.backgroundTheme == BackgroundTheme.light
                    ? Colors.white
                    : const Color(0xFFFAF6ED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Рукописи не горят. Это была не просто фраза — это была аксиома, в которую верили все читатели великих книг.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: settings.fontSize * 0.85,
                  height: settings.lineHeight,
                  color: settings.backgroundTheme == BackgroundTheme.dark ||
                          settings.backgroundTheme == BackgroundTheme.night
                      ? const Color(0xFFD4C9B0)
                      : const Color(0xFF3D3020),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SettingsCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.paperWarm,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedBrown,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FontOption extends StatelessWidget {
  final String label;
  final String sample;
  final TextStyle Function(TextStyle) fontFamily;
  final bool selected;
  final VoidCallback onTap;

  const _FontOption({
    required this.label,
    required this.sample,
    required this.fontFamily,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.woodBrown : AppColors.creamLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                sample,
                style: fontFamily(TextStyle(
                  fontSize: 20,
                  color: selected ? AppColors.paperWarm : AppColors.inkDark,
                )),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: selected ? AppColors.paperWarm : AppColors.mutedBrown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeSwatch({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.accentRed : Colors.transparent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: selected ? AppColors.accentRed : AppColors.mutedBrown,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleItem({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.creamLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.mutedBrown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: AppColors.mutedBrown,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accentRed,
          ),
        ],
      ),
    );
  }
}
