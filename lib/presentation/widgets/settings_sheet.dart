import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';

import '../providers/providers.dart';
import '../theme/app_theme.dart';

/// Settings bottom sheet widget.
///
/// Provides language and theme selection options.
class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsState = ref.watch(settingsControllerProvider);
    final settings = settingsState.settings;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.settings,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Language Selector
          Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _LanguageOption(
                  label: l10n.english,
                  flag: '🇬🇧',
                  isSelected: settings.locale.languageCode == 'en',
                  onTap: () {
                    ref
                        .read(settingsControllerProvider.notifier)
                        .setLocale(const Locale('en'));
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LanguageOption(
                  label: l10n.indonesian,
                  flag: '🇮🇩',
                  isSelected: settings.locale.languageCode == 'id',
                  onTap: () {
                    ref
                        .read(settingsControllerProvider.notifier)
                        .setLocale(const Locale('id'));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Theme Selector
          Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ThemeOption(
                  label: l10n.lightTheme,
                  icon: Icons.light_mode,
                  isSelected: settings.themeMode == ThemeMode.light,
                  onTap: () {
                    ref
                        .read(settingsControllerProvider.notifier)
                        .setThemeMode(ThemeMode.light);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ThemeOption(
                  label: l10n.darkTheme,
                  icon: Icons.dark_mode,
                  isSelected: settings.themeMode == ThemeMode.dark,
                  onTap: () {
                    ref
                        .read(settingsControllerProvider.notifier)
                        .setThemeMode(ThemeMode.dark);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppTheme.primaryColor
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
