import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../widgets/settings_sheet.dart';

/// Home screen of the WASap application.
///
/// Contains:
/// - Phone input card with normalization preview
/// - Recent numbers section
/// - Open WhatsApp button
/// - How It Works info card
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SettingsSheet(),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      _phoneController.text = data.text!;
      ref.read(phoneControllerProvider.notifier).updateInput(data.text!);
    }
  }

  void _clearInput() {
    _phoneController.clear();
    ref.read(phoneControllerProvider.notifier).clearInput();
  }

  Future<void> _launchWhatsApp() async {
    final phoneState = ref.read(phoneControllerProvider);
    if (!phoneState.isValid) return;

    // Add to recent numbers
    await ref
        .read(recentNumbersControllerProvider.notifier)
        .addRecentNumber(phoneState.normalized!.value);

    // Launch WhatsApp
    await ref.read(phoneControllerProvider.notifier).launchWhatsApp();
  }

  void _selectRecentNumber(String phoneNumber) {
    _phoneController.text = phoneNumber;
    ref.read(phoneControllerProvider.notifier).updateInput(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final phoneState = ref.watch(phoneControllerProvider);
    final recentNumbersState = ref.watch(recentNumbersControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            tooltip: l10n.settings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle
              Center(
                child: Text(
                  l10n.appSubtitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Phone Input Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label
                      Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.phoneNumberLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Text Field
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          ref
                              .read(phoneControllerProvider.notifier)
                              .updateInput(value);
                        },
                        decoration: InputDecoration(
                          hintText: '0812 345 6789',
                          prefixIcon: const Icon(Icons.phone),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.paste),
                                onPressed: _pasteFromClipboard,
                                tooltip: l10n.pasteFromClipboard,
                              ),
                              if (_phoneController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: _clearInput,
                                  tooltip: l10n.clearInput,
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Normalized Preview
                      if (phoneState.normalized != null &&
                          phoneState.input.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: phoneState.isValid
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                phoneState.isValid
                                    ? Icons.check_circle
                                    : Icons.error,
                                size: 18,
                                color: phoneState.isValid
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '+${phoneState.normalized!.value}',
                                  style: TextStyle(
                                    color: phoneState.isValid
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Error Message
                      if (phoneState.error != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          phoneState.error!,
                          style: TextStyle(
                            color: colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Recent Numbers Section
              Text(
                l10n.recentNumbers,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (recentNumbersState.recentNumbers.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                            size: 48,
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.noRecentNumbers,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recentNumbersState.recentNumbers.map((recent) {
                        return ActionChip(
                          label: Text(recent.displayString),
                          onPressed: () =>
                              _selectRecentNumber(recent.phoneNumber),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          ref
                              .read(recentNumbersControllerProvider.notifier)
                              .clearRecentNumbers();
                        },
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: Text(l10n.clearAll),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),

              // Open WhatsApp Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: phoneState.isValid && !phoneState.isLoading
                      ? _launchWhatsApp
                      : null,
                  child: phoneState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.send),
                            const SizedBox(width: 8),
                            Text(l10n.openWhatsApp),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // How It Works Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.howItWorks,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            label: Text(l10n.exampleFormat1),
                            avatar: const Icon(Icons.arrow_forward, size: 16),
                          ),
                          Chip(
                            label: Text(l10n.exampleFormat2),
                            avatar: const Icon(Icons.arrow_forward, size: 16),
                          ),
                          Chip(
                            label: Text(l10n.exampleFormat3),
                            avatar: const Icon(Icons.arrow_forward, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Center(child: Text('→ 628123456789')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
